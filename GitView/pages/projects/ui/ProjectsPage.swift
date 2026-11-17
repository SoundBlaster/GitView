import GitHubAPI
import GitHubAuth
import ProjectStore
import SwiftUI
import WorkCache
import WorkDomain

struct ProjectsPage: View {
    let library: ProjectLibrary
    let sessionManager: GitHubSessionManager
    var discovery: GitHubDiscovery = GitHubDiscovery()
    var workClient: GitHubWorkClient = GitHubWorkClient()
    @Environment(\.dynamicTypeSize) private var dynamicTypeSize
    @Environment(\.scenePhase) private var scenePhase
    @State private var columns = 4
    @State private var width: CGFloat = 0
    @State private var projectPosition = ScrollPosition(idType: UUID.self)
    @State private var visibleProjectIDs = Set<UUID>()
    @State private var zoomRevision = 0
    @State private var selectedRoute: ProjectRoute?
    @State private var zoomHint = false
    @State private var overviews: [UUID: ProjectOverview] = [:]
    @State private var cacheError = false
    @State private var isRefreshing = false
    @State private var refreshError: String?
    private var effectiveColumns: Int { dynamicTypeSize.isAccessibilitySize ? min(columns, 2) : columns }
    private var gridColumns: [GridItem] { Array(repeating: GridItem(.flexible(), spacing: 6), count: effectiveColumns) }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 12) {
                if library.projects.isEmpty {
                    ContentUnavailableView {
                        Label("No projects yet", systemImage: "square.grid.2x2")
                    } description: {
                        Text("Choose a repository to create a project.")
                    } actions: {
                        NavigationLink("Choose Repository") { repositoryDiscovery }
                            .buttonStyle(.borderedProminent)
                            .accessibilityIdentifier("projects.chooseRepository")
                    }
                }
                if cacheError {
                    Label("Some saved summaries could not be read.", systemImage: "exclamationmark.triangle")
                        .font(.footnote).foregroundStyle(.secondary)
                }
                if let refreshError {
                    Label(refreshError, systemImage: "exclamationmark.triangle")
                        .font(.footnote).foregroundStyle(.secondary)
                }
                if isRefreshing { ProgressView("Updating projects").font(.footnote) }
                if zoomHint { Text("Choose a project to open it.").font(.footnote).foregroundStyle(.secondary) }
                LazyVGrid(columns: gridColumns, spacing: 6) {
                    ForEach(library.projects) { project in
                        Button { selectedRoute = ProjectRoute(project: project, attention: nil) } label: {
                            ProjectCell(project: project, overview: overviews[project.id], expanded: effectiveColumns <= 2)
                        }
                        .buttonStyle(.plain)
                        .accessibilityIdentifier("project.\(project.id.uuidString)")
                        .contextMenu {
                            Button("Open Project", systemImage: "arrow.up.right.square") { selectedRoute = ProjectRoute(project: project, attention: nil) }
                            if let overview = overviews[project.id] {
                                if overview.summary.failedCI.count > 0 {
                                    Button("Show failed CI", systemImage: "xmark.circle.fill") {
                                        open(project, signal: .failedCI, metric: overview.summary.failedCI, overview: overview)
                                    }
                                }
                                if overview.summary.affectedByThreads.count > 0 {
                                    Button("Show unresolved review threads", systemImage: "text.bubble.fill") {
                                        open(project, signal: .unresolvedThreads, metric: overview.summary.affectedByThreads, overview: overview)
                                    }
                                }
                            }
                        } preview: {
                            ProjectCell(project: project, overview: overviews[project.id], expanded: true).padding()
                        }
                    }
                }
                .scrollTargetLayout()
                .onGeometryChange(for: CGFloat.self) { $0.size.width } action: { width = $0 }
            }.padding()
        }
        .scrollPosition($projectPosition, anchor: .center)
        .onScrollTargetVisibilityChange(idType: UUID.self, threshold: 0.5) { visibleProjectIDs = Set($0) }
        .highPriorityGesture(MagnifyGesture().onEnded { value in
            if value.magnification > 1.15 { changeZoom(.larger) }
            else if value.magnification < 0.85 { changeZoom(.smaller) }
        })
        .navigationTitle("Projects")
        .toolbar {
            NavigationLink { repositoryDiscovery } label: { Label("Add Repository", systemImage: "plus") }
                .accessibilityIdentifier("projects.addRepository")
            Menu("Zoom", systemImage: "plus.magnifyingglass") {
                Button("Larger", systemImage: "plus.magnifyingglass") { changeZoom(.larger) }
                Button("Smaller", systemImage: "minus.magnifyingglass") { changeZoom(.smaller) }
            }
        }
        .navigationDestination(item: $selectedRoute) { route in
            ProjectWorkPage(project: library.projects.first(where: { $0.id == route.project.id }) ?? route.project,
                sessionManager: sessionManager, library: library, initialAttention: route.attention, workClient: workClient, discovery: discovery)
        }
        .task { loadOverviews(); await refreshOverviews(force: false) }
        .refreshable { await refreshOverviews(force: true) }
        .onChange(of: scenePhase) {
            if scenePhase == .active { loadOverviews(); Task { await refreshOverviews(force: false) } }
        }
        .onChange(of: library.projects) { loadOverviews() }
    }

    private var repositoryDiscovery: some View {
        RepositoryDiscoveryPage(sessionManager: sessionManager, accountID: library.accountID,
                                account: "connected account", library: library, discovery: discovery, workClient: workClient)
    }

    @MainActor private func changeZoom(_ direction: GridZoomDirection) {
        let next = GridDensity.next(current: effectiveColumns, direction: direction, width: Double(width), maxCellWidth: 320)
        let densityChanged = next != effectiveColumns
        zoomRevision += 1
        let revision = zoomRevision
        let visible = library.projects.filter { visibleProjectIDs.contains($0.id) }
        let anchor = visible.isEmpty ? projectPosition.viewID(type: UUID.self) : visible[visible.count / 2].id
        withAnimation(.easeInOut(duration: 0.2), completionCriteria: .logicallyComplete) {
            columns = next
        } completion: {
            if densityChanged, revision == zoomRevision, let anchor, library.projects.contains(where: { $0.id == anchor }) {
                projectPosition.scrollTo(id: anchor, anchor: .center)
            }
        }
        guard direction == .larger, GridDensity.isAtMaximum(columns: next, width: Double(width), maxCellWidth: 320) else { zoomHint = false; return }
        if let project = library.projects.first, library.projects.count == 1 { selectedRoute = ProjectRoute(project: project, attention: nil); zoomHint = false }
        else if !library.projects.isEmpty { zoomHint = true }
    }

    @MainActor private func open(_ project: StoredProject, signal: AttentionSignal, metric: ObservedMetric, overview: ProjectOverview) {
        let threadPartial: Bool
        if case .unresolvedThreads = signal { threadPartial = overview.summary.unresolvedThreads.unavailable > 0 }
        else { threadPartial = false }
        let partial = !overview.summary.coverageComplete || overview.hasPausedRepositories || metric.unavailable > 0 || threadPartial
        let attention = ProjectAttentionOrigin(signal: signal, metric: metric, snapshotAt: overview.date,
            repositoryIDs: Set(project.repositories.map(\.id)), partial: partial)
        selectedRoute = ProjectRoute(project: project, attention: attention)
    }

    @MainActor private func loadOverviews() {
        do {
            let base = try FileManager.default.url(for: .applicationSupportDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
            let directory = base.appendingPathComponent("GitGrid", isDirectory: true)
            try FileManager.default.createDirectory(at: directory, withIntermediateDirectories: true)
            let cache = try WorkCache(url: directory.appendingPathComponent("WorkCache.sqlite"))
            var results: [UUID: ProjectOverview] = [:]
            var failures = false
            for project in library.projects {
                do {
                    if let snapshot = try cache.load(accountID: library.accountID, projectID: project.id) {
                        let archive = try ProjectWorkArchive.decode(snapshot.payload).restricting(to: Set(project.repositories.map(\.id)))
                        let coversProject = archive.hasCompleteObservation(for: Set(project.repositories.map(\.id)))
                        let summary = ProjectWorkSummary(records: archive.items.map(\.metricRecord),
                            coverageComplete: snapshot.complete && !archive.hasRefreshProblems && coversProject,
                            now: .now, calendar: .current)
                        results[project.id] = ProjectOverview(summary: summary, date: snapshot.observedAt,
                            hasPausedRepositories: project.repositories.contains(where: \.syncPaused))
                    }
                } catch { failures = true }
            }
            overviews = results
            cacheError = failures
        } catch { cacheError = true }
    }

    @MainActor private func refreshOverviews(force: Bool) async {
        guard !isRefreshing, !library.projects.isEmpty else { return }
        isRefreshing = true
        refreshError = nil
        defer { isRefreshing = false }
        do {
            let credential = try await sessionManager.usableSession(for: library.accountID)
            let base = try FileManager.default.url(for: .applicationSupportDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
            let directory = base.appendingPathComponent("GitGrid", isDirectory: true)
            try FileManager.default.createDirectory(at: directory, withIntermediateDirectories: true)
            let cache = try WorkCache(url: directory.appendingPathComponent("WorkCache.sqlite"))
            let client = workClient
            let service = GitHubProjectRefresh { token, repository in
                try await client.load(token: token, repositoryID: repository.id, fullName: repository.fullName,
                                                  nodeID: repository.nodeID, maxRequests: 2)
            }
            let coordinator = ForegroundOverviewRefreshCoordinator(projects: { library.projects },
                isCurrent: { try await sessionManager.isCurrent(accountID: library.accountID, accessToken: credential.accessToken) },
                needsRefresh: { project in
                    guard !force, let snapshot = try cache.load(accountID: library.accountID, projectID: project.id),
                          snapshot.complete, snapshot.observedAt <= .now,
                          Date.now.timeIntervalSince(snapshot.observedAt) < 15 * 60 else { return true }
                    let archive = try ProjectWorkArchive.decode(snapshot.payload)
                    return archive.hasRefreshProblems || !archive.hasCompleteObservation(for: Set(project.repositories.map(\.id)))
                }, fetch: { repository in
                    let batch = try await service.fetch(token: credential.accessToken, repositories: [
                        RefreshRepository(id: repository.id, fullName: repository.fullName, nodeID: repository.nodeID)
                    ])
                    guard let observation = batch.observations.first else { throw OverviewRefreshError.invalidResponse }
                    return observation
                }, save: { project, observations in
                    let result = try ProjectRefreshPersistence.commit(cache: cache, accountID: library.accountID, projectID: project.id,
                        observations: observations, fallback: nil, at: .now, scope: Set(project.repositories.map(\.id)))
                    guard result.saved else { throw OverviewRefreshError.couldNotSave }
                    if !result.complete { refreshError = "Some project summaries are incomplete. Open a project for details." }
                    loadOverviews()
                })
            try await coordinator.run()
        } catch is CancellationError {
        } catch {
            refreshError = "Could not update all projects. Showing saved summaries."
        }
    }
}

private enum OverviewRefreshError: Error { case invalidResponse, couldNotSave }

private struct ProjectOverview {
    let summary: ProjectWorkSummary
    let date: Date
    let hasPausedRepositories: Bool
}

private struct ProjectRoute: Identifiable, Hashable {
    let project: StoredProject
    let attention: ProjectAttentionOrigin?
    var id: UUID { project.id }
    static func == (lhs: ProjectRoute, rhs: ProjectRoute) -> Bool { lhs.id == rhs.id }
    func hash(into hasher: inout Hasher) { hasher.combine(id) }
}

private struct ProjectCell: View {
    let project: StoredProject
    let overview: ProjectOverview?
    let expanded: Bool

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Image(systemName: "folder")
            Text(project.name).font(.caption.weight(.semibold)).lineLimit(expanded ? 3 : 1)
            if let overview {
                HStack(spacing: 6) {
                    if overview.summary.failedCI.count > 0 {
                        Label("\(overview.summary.failedCI.count)", systemImage: "xmark.circle.fill").foregroundStyle(.red)
                    }
                    if overview.summary.affectedByThreads.count > 0 {
                        Label("\(overview.summary.affectedByThreads.count)", systemImage: "text.bubble.fill").foregroundStyle(.orange)
                    }
                    if !overview.summary.coverageComplete || overview.hasPausedRepositories || overview.summary.failedCI.unavailable > 0 || overview.summary.unresolvedThreads.unavailable > 0 {
                        Text("?").foregroundStyle(.secondary)
                    }
                }.font(.caption2)
            } else if project.repositories.contains(where: \.syncPaused) {
                Image(systemName: "pause.circle").foregroundStyle(.secondary)
            }
            if expanded {
                Text("\(project.repositories.count) repositories").font(.caption2).foregroundStyle(.secondary)
                if let overview {
                    Text("Observed: \(overview.summary.openPullRequests) open PR · \(overview.summary.openIssues) open issues")
                        .font(.caption2).foregroundStyle(.secondary)
                    Text(overview.summary.coverageComplete ? "Snapshot \(overview.date.formatted(date: .abbreviated, time: .shortened))" : "Partial · \(overview.date.formatted(date: .abbreviated, time: .shortened))")
                        .font(.caption2).foregroundStyle(.secondary)
                    if overview.hasPausedRepositories { Text("Sync paused").font(.caption2).foregroundStyle(.secondary) }
                } else {
                    Text("No cached work").font(.caption2).foregroundStyle(.secondary)
                    if project.repositories.contains(where: \.syncPaused) { Text("Sync paused").font(.caption2).foregroundStyle(.secondary) }
                }
            }
        }
        .frame(maxWidth: 320, maxHeight: .infinity, alignment: .topLeading)
        .padding(8)
        .frame(maxWidth: .infinity)
        .aspectRatio(1, contentMode: .fit)
        .background(.quaternary, in: RoundedRectangle(cornerRadius: 10))
        .accessibilityElement(children: .combine)
        .accessibilityLabel(accessibilitySummary)
    }

    private var accessibilitySummary: String {
        guard let overview else {
            return "\(project.name), no cached work" + (project.repositories.contains(where: \.syncPaused) ? ", synchronization paused" : "")
        }
        let summary = overview.summary
        let uncertain = !summary.coverageComplete || overview.hasPausedRepositories || summary.failedCI.unavailable > 0 || summary.unresolvedThreads.unavailable > 0
        return "\(project.name), \(summary.openPullRequests) open pull requests, \(summary.openIssues) open issues, \(summary.failedCI.count) pull requests with failed CI, \(summary.affectedByThreads.count) pull requests with unresolved threads" + (uncertain ? ", some data unavailable or partial" : "") + (overview.hasPausedRepositories ? ", synchronization paused" : "") + ", snapshot saved \(overview.date.formatted(date: .abbreviated, time: .shortened))"
    }
}
