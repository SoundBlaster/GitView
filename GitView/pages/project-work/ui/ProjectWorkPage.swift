import GitHubAPI
import GitHubAuth
import Charts
import ProjectStore
import SwiftUI
import UIKit
import WorkDomain
import WorkCache

struct ProjectWorkPage: View {
    let project: StoredProject
    let sessionManager: GitHubSessionManager
    let library: ProjectLibrary
    let workClient: GitHubWorkClient
    let discovery: GitHubDiscovery
    @State private var items: [GitHubWorkItem] = []
    @State private var hasLoaded = false
    @State private var isLoading = false
    @State private var refreshPending = false
    @State private var warning: String?
    @State private var observedAt: Date?
    @State private var cache: WorkCache?
    @State private var archive: ProjectWorkArchive?
    @State private var columns = 8
    @State private var gridWidth: CGFloat = 0
    @State private var workPosition = ScrollPosition(idType: String.self)
    @State private var visibleWorkIDs = Set<String>()
    @State private var zoomRevision = 0
    @State private var selectedItem: GitHubWorkItem?
    @State private var accessiblePreview: GitHubWorkItem?
    @State private var previewToOpen: GitHubWorkItem?
    @State private var previewOriginID: String?
    @AccessibilityFocusState private var focusedWorkID: String?
    @State private var showProjectSettings = false
    @State private var showMetrics = false
    @State private var pendingAttention: ProjectAttentionOrigin?
    @State private var zoomHint = false
    @Environment(\.dynamicTypeSize) private var dynamicTypeSize
    @Environment(\.scenePhase) private var scenePhase
    @AppStorage private var showOpen: Bool
    @AppStorage private var showMerged: Bool
    @AppStorage private var showClosed: Bool
    @AppStorage private var showIssues: Bool
    @AppStorage private var showPullRequests: Bool

    init(project: StoredProject, sessionManager: GitHubSessionManager, library: ProjectLibrary, initialAttention: ProjectAttentionOrigin? = nil,
         workClient: GitHubWorkClient = GitHubWorkClient(), discovery: GitHubDiscovery = GitHubDiscovery()) {
        self.project = project
        self.sessionManager = sessionManager
        self.library = library
        self.workClient = workClient
        self.discovery = discovery
        _pendingAttention = State(initialValue: initialAttention)
        _showMetrics = State(initialValue: initialAttention != nil)
        let prefix = "project.\(project.id.uuidString).filters."
        _showOpen = AppStorage(wrappedValue: true, prefix + "open")
        _showMerged = AppStorage(wrappedValue: true, prefix + "merged")
        _showClosed = AppStorage(wrappedValue: true, prefix + "closed")
        _showIssues = AppStorage(wrappedValue: true, prefix + "issues")
        _showPullRequests = AppStorage(wrappedValue: true, prefix + "pullRequests")
    }

    private var visibleItems: [GitHubWorkItem] {
        let rule = WorkVisibilitySpecification(filters: WorkFilters(showOpen: showOpen, showMerged: showMerged, showClosed: showClosed, showIssues: showIssues, showPullRequests: showPullRequests))
        return items.filter { item in
            let kind: WorkKind = item.kind == .issue ? .issue : .pullRequest
            let state: WorkState = switch item.state {
            case "OPEN": .open
            case "MERGED": .merged
            case "CLOSED": .closed
            default: .unknown
            }
            return rule.isSatisfiedBy(WorkVisibilityContext(kind: kind, state: state))
        }
    }
    private var effectiveColumns: Int { dynamicTypeSize.isAccessibilitySize ? min(columns, 2) : columns }
    private var gridColumns: [GridItem] { Array(repeating: GridItem(.flexible(), spacing: 4), count: effectiveColumns) }
    private var repositoryNames: [String: String] { archive?.repositoryNamesByWorkID ?? [:] }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 12) {
                if let observedAt {
                    Text("Last complete update \(observedAt.formatted(date: .abbreviated, time: .shortened))")
                        .font(.footnote).foregroundStyle(.secondary)
                }
                if let warning {
                    Label(warning, systemImage: "exclamationmark.triangle")
                        .font(.footnote).foregroundStyle(.secondary)
                }
                ForEach(project.repositories.filter(\.syncPaused), id: \.id) { repository in
                    Label("\(repository.fullName): synchronization paused", systemImage: "pause.circle")
                        .font(.footnote).foregroundStyle(.secondary)
                }
                if let archive {
                    if !archive.legacyItems.isEmpty {
                        Text("Some older saved work could not yet be attributed to a repository.")
                            .font(.footnote).foregroundStyle(.secondary)
                    }
                    ForEach(archive.repositories.filter { $0.refreshProblem != nil }, id: \.id) { repository in
                        VStack(alignment: .leading) {
                            Text("\(repository.name): \(repository.refreshProblem ?? "")")
                            if let date = repository.observedAt {
                                if repository.complete {
                                    Text("Last complete observation \(date.formatted(date: .abbreviated, time: .shortened))")
                                } else {
                                    Text("Partial observation \(date.formatted(date: .abbreviated, time: .shortened))")
                                }
                            } else { Text("No saved observation") }
                        }.font(.footnote).foregroundStyle(.secondary)
                    }
                }
                if isLoading && !hasLoaded { ProgressView("Loading work") }
                if hasLoaded && items.isEmpty && warning == nil {
                    if project.repositories.contains(where: \.syncPaused) {
                        ContentUnavailableView("Some saved work is unavailable", systemImage: "pause.circle",
                            description: Text("Synchronization is paused for at least one repository."))
                    } else {
                        ContentUnavailableView("No work in Today", systemImage: "checkmark.circle")
                    }
                }
                if hasLoaded && !items.isEmpty && visibleItems.isEmpty {
                    ContentUnavailableView("No work matches filters", systemImage: "line.3.horizontal.decrease.circle")
                }
                if zoomHint {
                    Text("Choose an item to open it.").font(.footnote).foregroundStyle(.secondary)
                }
                let sources = repositoryNames
                let observations = archive?.repositoryObservationsByWorkID ?? [:]
                LazyVGrid(columns: gridColumns, spacing: 4) {
                    ForEach(visibleItems) { item in
                        WorkGridCell(item: item, repositoryName: sources[item.id], showDetails: effectiveColumns <= 2,
                            source: observations[item.id],
                            open: { selectedItem = item }, preview: { previewOriginID = item.id; accessiblePreview = item })
                            .accessibilityFocused($focusedWorkID, equals: item.id)
                    }
                }
                .scrollTargetLayout()
                .onGeometryChange(for: CGFloat.self) { $0.size.width } action: { gridWidth = $0 }
            }
            .padding()
        }
        .scrollPosition($workPosition, anchor: .center)
        .onScrollTargetVisibilityChange(idType: String.self, threshold: 0.5) { visibleWorkIDs = Set($0) }
        .highPriorityGesture(MagnifyGesture().onEnded { value in
            if value.magnification > 1.15 { changeZoom(.larger) }
            else if value.magnification < 0.85 { changeZoom(.smaller) }
        })
        .navigationTitle(project.name)
        .toolbar {
            Button("Project settings", systemImage: "gearshape") { showProjectSettings = true }
                .accessibilityIdentifier("project.settings")
            Button("Metrics", systemImage: "chart.bar") { showMetrics = true }
                .disabled(archive == nil)
                .accessibilityIdentifier("project.metrics")
            Menu("Zoom", systemImage: "plus.magnifyingglass") {
                Button("Larger", systemImage: "plus.magnifyingglass") { changeZoom(.larger) }
                Button("Smaller", systemImage: "minus.magnifyingglass") { changeZoom(.smaller) }
            }
            Menu("Filters", systemImage: "line.3.horizontal.decrease.circle") {
                Toggle("Open", isOn: $showOpen)
                Toggle("Merged", isOn: $showMerged)
                Toggle("Closed", isOn: $showClosed)
                Divider()
                Toggle("Issues", isOn: $showIssues)
                Toggle("Pull requests", isOn: $showPullRequests)
            }
            .accessibilityIdentifier("project.filters")
        }
        .sheet(item: $selectedItem) { item in
            WorkDetailSheet(item: item, repositoryName: repositoryNames[item.id], source: archive?.repositoryObservationsByWorkID[item.id],
                sessionManager: sessionManager, accountID: project.accountID, onThreads: persistThreads, onDetails: persistDetails)
        }
        .sheet(item: $accessiblePreview, onDismiss: {
            if let item = previewToOpen {
                previewToOpen = nil
                selectedItem = item
            } else if let id = previewOriginID, visibleItems.contains(where: { $0.id == id }) {
                focusedWorkID = id
            }
            previewOriginID = nil
        }) { item in
            NavigationStack {
                ScrollView {
                    WorkPreviewContent(item: item, repositoryName: repositoryNames[item.id],
                        source: archive?.repositoryObservationsByWorkID[item.id]).padding()
                    Button("Open in GitGrid", systemImage: "doc.text") { previewToOpen = item; accessiblePreview = nil }
                        .buttonStyle(.borderedProminent)
                    if let url = GitHubSourceLink.eligible(item.url, repository: repositoryNames[item.id], kind: item.kind, number: item.number) {
                        Link("Open on GitHub", destination: url).padding()
                        ShareLink(item: url).accessibilityIdentifier("source.share").padding()
                    } else {
                        Text("Source link unavailable").foregroundStyle(.secondary)
                    }
                }
                .navigationTitle("Preview")
                .toolbar { ToolbarItem(placement: .confirmationAction) { Button("Done") { accessiblePreview = nil } } }
            }
        }
        .sheet(isPresented: $showProjectSettings) {
            ProjectSettingsSheet(project: project, library: library, sessionManager: sessionManager, cache: cache,
                                 discovery: discovery, workClient: workClient)
        }
        .sheet(isPresented: $showMetrics) {
            if let archive {
                ProjectMetricsSheet(project: project, archive: archive, sessionManager: sessionManager, refreshWarning: warning,
                    onThreads: persistThreads, onDetails: persistDetails, initialAttention: pendingAttention)
            }
        }
        .task {
            restore()
            if pendingAttention != nil && archive == nil {
                showMetrics = false
                warning = "The saved signal is unavailable. Refresh the project to inspect it."
                pendingAttention = nil
            }
            await load()
        }
        .onChange(of: showMetrics) { if !showMetrics { pendingAttention = nil } }
        .refreshable { await load() }
        .onReceive(NotificationCenter.default.publisher(for: .NSCalendarDayChanged)) { _ in updateToday() }
        .onReceive(NotificationCenter.default.publisher(for: UIApplication.significantTimeChangeNotification)) { _ in updateToday() }
        .onReceive(NotificationCenter.default.publisher(for: .NSSystemTimeZoneDidChange)) { _ in updateToday() }
        .onChange(of: scenePhase) {
            guard scenePhase == .active else { return }
            restore()
            if ForegroundRefreshSpecification(now: .now, maximumAge: 15 * 60).isSatisfiedBy(observedAt) {
                Task { await load() }
            }
        }
        .onChange(of: project.repositories) {
            warning = "Project membership changed; updating its overview."
            observedAt = nil
            if let archive {
                let scoped = archive.restricting(to: Set(project.repositories.map(\.id)))
                self.archive = scoped
                present(scoped.items, now: .now)
            }
            restore()
            if isLoading { refreshPending = true } else { Task { await load() } }
        }
        .onChange(of: isLoading) {
            if !isLoading && refreshPending { refreshPending = false; Task { await load() } }
        }
    }

    @MainActor private func changeZoom(_ direction: GridZoomDirection) {
        let next = GridDensity.next(current: effectiveColumns, direction: direction, width: Double(gridWidth), maxCellWidth: 320)
        let densityChanged = next != effectiveColumns
        zoomRevision += 1
        let revision = zoomRevision
        let visible = visibleItems.filter { visibleWorkIDs.contains($0.id) }
        let anchor = visible.isEmpty ? workPosition.viewID(type: String.self) : visible[visible.count / 2].id
        withAnimation(.easeInOut(duration: 0.2), completionCriteria: .logicallyComplete) {
            columns = next
        } completion: {
            if densityChanged, revision == zoomRevision, let anchor, visibleItems.contains(where: { $0.id == anchor }) {
                workPosition.scrollTo(id: anchor, anchor: .center)
            }
        }
        guard direction == .larger, GridDensity.isAtMaximum(columns: next, width: Double(gridWidth), maxCellWidth: 320) else {
            zoomHint = false
            return
        }
        if visibleItems.count == 1 { selectedItem = visibleItems.first; zoomHint = false }
        else if !visibleItems.isEmpty { zoomHint = true }
    }

    @MainActor private func updateToday() {
        if let archive { present(archive.items, now: .now) }
    }

    @MainActor private func load() async {
        guard !isLoading else { return }
        let requestedRepositories = project.repositories
        let activeRepositories = requestedRepositories.filter { !$0.syncPaused }
        guard !activeRepositories.isEmpty else { hasLoaded = true; warning = nil; return }
        isLoading = true
        defer { isLoading = false }
        let accessToken: String
        do {
            accessToken = try await sessionManager.usableSession(for: project.accountID).accessToken
        } catch is CancellationError { return }
        catch {
            warning = "Could not refresh the GitHub session. Showing saved work."
            return
        }
        let batch: ProjectRefreshResults
        let continuations = Dictionary((archive?.repositories ?? []).compactMap { observation in
            observation.openContinuation.map { (observation.id, $0) }
        }, uniquingKeysWith: { first, _ in first })
        do {
            let client = workClient
            let service = GitHubProjectRefresh(tracksOpenContinuation: true, continuations: continuations) { token, repository in
                try await client.load(token: token, repositoryID: repository.id, fullName: repository.fullName,
                    nodeID: repository.nodeID, openContinuation: continuations[repository.id])
            }
            batch = try await service.fetch(token: accessToken, repositories: activeRepositories.map {
                RefreshRepository(id: $0.id, fullName: $0.fullName, nodeID: $0.nodeID)
            })
        } catch { return }
        let results = batch.observations
        let observedRepositories = batch.observedRepositories.map {
            RepositoryReference(id: $0.id, fullName: $0.fullName, isPrivate: $0.isPrivate, nodeID: $0.nodeID)
        }
        guard !Task.isCancelled else { return }
        do {
            guard try await sessionManager.isCurrent(accountID: project.accountID, accessToken: accessToken) else { return }
        } catch { warning = "Could not verify the current GitHub session. Showing saved work."; return }
        guard !Task.isCancelled else { return }
        guard library.projects.first(where: { $0.id == project.id })?.repositories == requestedRepositories else { return }
        var metadataProblem = false
        if !observedRepositories.isEmpty {
            do { try library.reconcile(observed: observedRepositories) }
            catch { metadataProblem = true }
        }
        let now = Date()
        let result: ProjectRefreshPersistence.Result
        do {
            result = try ProjectRefreshPersistence.commit(cache: cache, accountID: project.accountID, projectID: project.id,
                observations: results, fallback: archive, at: now, scope: Set(requestedRepositories.map(\.id)))
        } catch {
            warning = "Saved work could not be read; the refresh was not saved."
            return
        }
        let updated = result.archive
        let complete = result.complete
        let saved = result.saved
        archive = updated
        present(updated.items, now: now)
        if saved && complete { observedAt = now }
        hasLoaded = true
        if !saved { warning = "Updated data could not be saved locally." }
        else if !complete { warning = "Some repositories could not be fully refreshed." }
        else if metadataProblem { warning = "Work updated, but repository metadata could not be saved." }
        else { warning = nil }
    }

    @MainActor private func restore() {
        do {
            let base = try FileManager.default.url(for: .applicationSupportDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
            let directory = base.appendingPathComponent("GitGrid", isDirectory: true)
            try FileManager.default.createDirectory(at: directory, withIntermediateDirectories: true)
            let store = try WorkCache(url: directory.appendingPathComponent("WorkCache.sqlite"))
            cache = store
            if let snapshot = try store.load(accountID: project.accountID, projectID: project.id) {
                let saved = try ProjectWorkArchive.decode(snapshot.payload).restricting(to: Set(project.repositories.map(\.id)))
                archive = saved
                present(saved.items, now: .now)
                let coversProject = saved.hasCompleteObservation(for: Set(project.repositories.map(\.id)))
                if snapshot.complete && coversProject { observedAt = snapshot.observedAt }
                hasLoaded = true
                if !snapshot.complete || saved.hasRefreshProblems || !coversProject { warning = "Saved work includes incomplete or unsuccessful updates." }
            }
        } catch {
            warning = "Saved work could not be read."
        }
    }

    @MainActor private func persistThreads(_ item: GitHubWorkItem, _ threads: GitHubReviewThreads, _ observedAt: Date) -> Bool {
        guard let cache, let head = item.headRevision else { return false }
        do {
            guard let snapshot = try cache.load(accountID: project.accountID, projectID: project.id) else { return false }
            var stored = try ProjectWorkArchive.decode(snapshot.payload)
            guard stored.updateThreadObservation(itemID: item.id, head: head, threads: threads, at: observedAt) else { return false }
            let payload = try JSONEncoder().encode(stored)
            guard try cache.replacePayload(accountID: project.accountID, projectID: project.id, expected: snapshot, payload: payload) else { return false }
            archive = stored
            if let visible = items.firstIndex(where: { $0.id == item.id && $0.headRevision == head }),
               let updated = items[visible].withReviewThreads(threads, forHead: head, observedAt: observedAt) {
                items[visible] = updated
            }
            return true
        } catch { return false }
    }

    @MainActor private func persistDetails(_ item: GitHubWorkItem, _ details: GitHubWorkDetails) -> Bool {
        guard let cache else { return false }
        do {
            guard let snapshot = try cache.load(accountID: project.accountID, projectID: project.id) else { return false }
            var stored = try ProjectWorkArchive.decode(snapshot.payload)
            guard stored.updateDetails(itemID: item.id, head: item.headRevision, details: details) else { return false }
            let payload = try JSONEncoder().encode(stored)
            guard try cache.replacePayload(accountID: project.accountID, projectID: project.id, expected: snapshot, payload: payload) else { return false }
            archive = stored
            if let index = items.firstIndex(where: { $0.id == item.id }),
               let updated = items[index].withDetails(details, forHead: item.headRevision) { items[index] = updated }
            return true
        } catch { return false }
    }

    @MainActor private func present(_ collected: [GitHubWorkItem], now: Date) {
        let calendar = Calendar.current
        let policy = TodayEligibility(now: now, calendar: calendar)
        var seen = Set<String>()
        items = collected.filter { item in
            guard seen.insert(item.id).inserted else { return false }
            if item.state == "OPEN" { return policy.evaluate(.unfinished) == .eligible }
            if item.state == "MERGED", let merged = item.mergedAt { return policy.evaluate(.completed(at: merged)) == .eligible }
            if item.state == "CLOSED", let closed = item.closedAt { return calendar.isDate(closed, inSameDayAs: now) && closed <= now }
            return true
        }.sorted { $0.updatedAt > $1.updatedAt }
    }
}

private struct ProjectHistoryContext {
    let summary: ProjectWorkSummary
    let items: [GitHubWorkItem]
    let repositories: [RepositoryWorkObservation]
    let observedThrough: Date
    let isSaved: Bool
}

private struct MetricSelection: Identifiable {
    let item: GitHubWorkItem
    let historicalRepositories: [RepositoryWorkObservation]?
    let historicalTime: Date?
    var id: String { item.id }
}

private struct ProjectMetricsSheet: View {
    let project: StoredProject
    let archive: ProjectWorkArchive
    let sessionManager: GitHubSessionManager
    let refreshWarning: String?
    let onThreads: @MainActor (GitHubWorkItem, GitHubReviewThreads, Date) -> Bool
    let onDetails: @MainActor (GitHubWorkItem, GitHubWorkDetails) -> Bool
    let initialAttention: ProjectAttentionOrigin?
    @Environment(\.dismiss) private var dismiss
    @State private var now = Date()
    @State private var selectedMetricItem: MetricSelection?
    @State private var showInitialSelection = false
    @State private var initialSelectionOpened = false

    private var summary: ProjectWorkSummary {
        let records = archive.items.map(\.metricRecord)
        let complete = archive.hasCompleteObservation(for: Set(project.repositories.map(\.id))) && !archive.hasRefreshProblems
        return ProjectWorkSummary(records: records, coverageComplete: complete, now: now, calendar: .current)
    }

    private var history: ProjectHistoryContext? {
        let scope = Set(project.repositories.map(\.id))
        if summary.coverageComplete && refreshWarning == nil && !project.repositories.contains(where: \.syncPaused),
           let through = archive.repositories.compactMap(\.observedAt).min(), archive.repositories.count == scope.count {
            return ProjectHistoryContext(summary: ProjectWorkSummary(records: archive.items.map(\.metricRecord), coverageComplete: true,
                now: through, calendar: .current), items: archive.items, repositories: archive.repositories, observedThrough: through, isSaved: false)
        }
        guard let saved = archive.lastCompleteHistory(for: scope), let through = saved.observedThrough else { return nil }
        return ProjectHistoryContext(summary: ProjectWorkSummary(records: saved.items.map(\.metricRecord), coverageComplete: true,
            now: through, calendar: .current), items: saved.items, repositories: saved.repositories, observedThrough: through, isSaved: true)
    }

    private func metricValue(_ metric: ObservedMetric) -> String {
        metric.unavailable == 0 ? "\(metric.count)" : "\(metric.count) · \(metric.unavailable) PRs unknown or partial"
    }

    var body: some View {
        NavigationStack {
            List {
                Section {
                    Text("Current Project membership · saved grid filters do not apply")
                        .font(.footnote).foregroundStyle(.secondary)
                    if let refreshWarning {
                        Label(refreshWarning, systemImage: "exclamationmark.triangle").foregroundStyle(.secondary)
                    }
                    if !summary.coverageComplete {
                        Label("Incomplete repository coverage; counts are observed values.", systemImage: "exclamationmark.triangle")
                            .foregroundStyle(.secondary)
                    }
                    if project.repositories.contains(where: \.syncPaused) {
                        Label("Some repositories are not synchronizing; counts use saved observations.", systemImage: "pause.circle")
                            .foregroundStyle(.secondary)
                    }
                    ForEach(project.repositories, id: \.id) { repository in
                        VStack(alignment: .leading, spacing: 4) {
                            Text(repository.fullName).font(.footnote.weight(.semibold))
                            if repository.syncPaused { Text("Synchronization paused").font(.footnote).foregroundStyle(.secondary) }
                            if let source = archive.repositories.first(where: { $0.id == repository.id }) {
                                WorkSourceStatus(source: source, identifierPrefix: "metrics.repository.\(repository.id)")
                                if source.observedAt == nil { Text("No saved observation").font(.footnote).foregroundStyle(.secondary) }
                            } else {
                                Text("No saved observation").font(.footnote).foregroundStyle(.secondary)
                            }
                        }
                    }
                }
                Section("Current work") {
                    LabeledContent("Open pull requests", value: "\(summary.openPullRequests)")
                    LabeledContent("Draft pull requests", value: "\(summary.draftPullRequests)")
                    LabeledContent("Open issues", value: "\(summary.openIssues)")
                }
                Section("Attention · open PRs") {
                    attentionLink("Failed CI · PRs", metric: summary.failedCI, signal: .failedCI, unit: "pull requests")
                        .accessibilityIdentifier("metrics.failedCI")
                    attentionLink("Changes requested · PRs", metric: summary.changesRequested, signal: .changesRequested, unit: "pull requests")
                    attentionLink("Review requested · PRs", metric: summary.waitingForReview, signal: .reviewRequested, unit: "pull requests")
                    attentionLink("Unresolved threads", metric: summary.unresolvedThreads, signal: .unresolvedThreads, unit: "threads")
                        .accessibilityIdentifier("metrics.unresolvedThreads")
                    attentionLink("PRs with unresolved threads", metric: summary.affectedByThreads, signal: .unresolvedThreads, unit: "pull requests")
                }
                Section("Merged pull requests · 7 local days") {
                    if let history, let days = history.summary.mergedByDay {
                        Text("\(history.isSaved ? "Saved snapshot" : "Observed") through \(history.observedThrough.formatted(date: .abbreviated, time: .shortened))")
                            .font(.footnote).foregroundStyle(.secondary).accessibilityIdentifier("metrics.history.observedThrough")
                        Chart(days) { day in
                            BarMark(x: .value("Day", day.day, unit: .day), y: .value("Merged PRs", day.count))
                                .accessibilityLabel(day.day.formatted(date: .abbreviated, time: .omitted))
                                .accessibilityValue("\(day.count) merged pull requests")
                        }
                        .chartYScale(domain: 0...max(1, days.map(\.count).max() ?? 0))
                        .frame(height: 160)
                        NavigationLink {
                            mergedSelection(days: days, history: history)
                        } label: {
                            LabeledContent("View merged PRs", value: "\(days.reduce(0) { $0 + $1.count })")
                        }
                        .accessibilityIdentifier("metrics.merged.selection")
                        Text("Based on current Project membership and available GitHub observations.")
                            .font(.footnote).foregroundStyle(.secondary)
                    } else {
                        Text("History is unavailable or incomplete; no zero values are assumed.")
                            .foregroundStyle(.secondary)
                    }
                }
                Section("Last observed closed issues · 7 local days") {
                    if let history, let closures = history.summary.issueClosures {
                        if history.isSaved {
                            Text("Saved snapshot through \(history.observedThrough.formatted(date: .abbreviated, time: .shortened))")
                                .font(.footnote).foregroundStyle(.secondary)
                        }
                        issueClosureLink("All currently closed", count: closures.total, reason: nil, history: history)
                        issueClosureLink("Completed", count: closures.completed, reason: .completed, history: history)
                            .accessibilityIdentifier("metrics.issues.completed")
                        issueClosureLink("Not planned", count: closures.notPlanned, reason: .notPlanned, history: history)
                        issueClosureLink("Duplicate", count: closures.duplicate, reason: .duplicate, history: history)
                        issueClosureLink("Other reason", count: closures.other, reason: .other, history: history)
                        issueClosureLink("Reason unavailable", count: closures.unknown, reason: .unknown, history: history)
                        Text("Issues last observed closed, by latest closure in this period; reopened issues and earlier closure events are not included.")
                            .font(.footnote).foregroundStyle(.secondary)
                    } else {
                        Text("History is unavailable or incomplete; no zero values are assumed.")
                            .foregroundStyle(.secondary)
                    }
                }
            }
            .navigationTitle("Project metrics")
            .navigationDestination(isPresented: $showInitialSelection) {
                if let initialAttention {
                    attentionSelection(title: initialAttentionTitle(initialAttention.signal), signal: initialAttention.signal,
                        origin: initialAttention.metric, unit: "pull requests", source: initialAttention)
                }
            }
            .task {
                if initialAttention != nil && !initialSelectionOpened {
                    initialSelectionOpened = true
                    showInitialSelection = true
                }
            }
            .toolbar { ToolbarItem(placement: .confirmationAction) { Button("Done") { dismiss() } } }
            .sheet(item: $selectedMetricItem) { selection in
                let item = selection.item
                let sourceArchive = selection.historicalRepositories.map { ProjectWorkArchive(repositories: $0) } ?? archive
                let historicalSource = sourceArchive.repositoryObservationsByWorkID[item.id]
                let currentSource = historicalSource.flatMap { old in archive.repositories.first { $0.id == old.id } }
                WorkDetailSheet(item: item, repositoryName: sourceArchive.repositoryNamesByWorkID[item.id], source: currentSource ?? historicalSource,
                    sessionManager: sessionManager, accountID: project.accountID,
                    onThreads: onThreads, onDetails: onDetails, historicalSnapshotAt: selection.historicalTime)
            }
        }
    }

    @MainActor private func select(_ item: GitHubWorkItem, history: ProjectHistoryContext?) {
        let source = history.flatMap { ProjectWorkArchive(repositories: $0.repositories).repositoryObservationsByWorkID[item.id] }
        selectedMetricItem = MetricSelection(item: item, historicalRepositories: history?.repositories,
            historicalTime: history.map { source?.observedAt ?? $0.observedThrough })
    }

    private func attentionLink(_ title: String, metric: ObservedMetric, signal: AttentionSignal, unit: String) -> some View {
        NavigationLink {
            attentionSelection(title: title, signal: signal, origin: metric, unit: unit)
        } label: {
            LabeledContent(title, value: metricValue(metric))
        }
    }

    private func issueClosureLink(_ title: String, count: Int, reason: IssueClosureReason?, history: ProjectHistoryContext) -> some View {
        NavigationLink {
            issueClosureSelection(title: title, reason: reason, history: history)
        } label: {
            LabeledContent(title, value: "\(count)")
        }
    }

    private func issueClosureSelection(title: String, reason: IssueClosureReason?, history: ProjectHistoryContext) -> some View {
        let rule = ClosedIssueInPeriodSpecification(reason: reason, now: history.observedThrough, calendar: .current)
        var seen = Set<String>()
        let selected = history.items.filter { seen.insert($0.id).inserted && rule.isSatisfiedBy($0.metricRecord) }
            .sorted { ($0.closedAt ?? .distantPast) > ($1.closedAt ?? .distantPast) }
        let repositoryNames = ProjectWorkArchive(repositories: history.repositories).repositoryNamesByWorkID
        return List {
            Section {
                Text("\(project.name) · current membership · 7 local days through \(history.observedThrough.formatted(date: .abbreviated, time: .shortened))")
                Text("Issues last observed closed, by their latest closure in this period. Saved grid filters do not apply.")
                if let refreshWarning { Text(refreshWarning) }
                ForEach(history.repositories.filter { $0.observedAt != nil }, id: \.id) { repository in
                    if let date = repository.observedAt {
                        Text("\(repository.name): observed \(date.formatted(date: .abbreviated, time: .shortened))")
                    }
                }
            }.font(.footnote).foregroundStyle(.secondary)
            if selected.isEmpty { Text("No matching issues.").foregroundStyle(.secondary) }
            ForEach(selected) { item in
                Button { select(item, history: history) } label: {
                    VStack(alignment: .leading) {
                        Text(item.title)
                        if let repository = repositoryNames[item.id] {
                            Text("\(repository) · #\(String(item.number))").font(.caption).foregroundStyle(.secondary)
                        }
                    }
                }
            }
        }
        .navigationTitle(title)
    }

    private func initialAttentionTitle(_ signal: AttentionSignal) -> String {
        switch signal {
        case .failedCI: "Failed CI"
        case .unresolvedThreads: "PRs with unresolved threads"
        case .changesRequested: "Changes requested"
        case .reviewRequested: "Review requested"
        }
    }

    private func attentionSelection(title: String, signal: AttentionSignal, origin: ObservedMetric, unit: String,
                                    source: ProjectAttentionOrigin? = nil) -> some View {
        let rule = AttentionSignalSpecification(signal: signal)
        var seen = Set<String>()
        let unique = archive.items.filter { seen.insert($0.id).inserted }
        let selected = unique.filter { rule.isSatisfiedBy($0.metricRecord) }
        let unknown = unique.filter { rule.evaluate($0.metricRecord) == .unknown }.count
        let repositoryNames = archive.repositoryNamesByWorkID
        return List {
            Section {
                Text("\(project.name) · current membership · open pull requests")
                Text("Origin: \(origin.count) \(unit). Selection contains distinct pull requests; saved grid filters do not apply.")
                if let source {
                    Text("Origin snapshot saved \(source.snapshotAt.formatted(date: .abbreviated, time: .shortened)).")
                    if source.partial { Text("The origin observation was partial or had unavailable data.") }
                    if source.repositoryIDs != Set(project.repositories.map(\.id)) {
                        Text("Project membership changed since the origin snapshot; this selection uses current membership.")
                    }
                }
                if let refreshWarning { Text(refreshWarning) }
                if !summary.coverageComplete || unknown > 0 || origin.unavailable > 0 {
                    Label("Evidence is incomplete: \(unknown) PRs cannot be classified; \(origin.unavailable) PRs have unavailable or partial source data, or repository coverage is incomplete.", systemImage: "exclamationmark.triangle")
                }
                ForEach(archive.repositories.filter { $0.observedAt != nil }, id: \.id) { repository in
                    if let date = repository.observedAt {
                        Text("\(repository.name): observed \(date.formatted(date: .abbreviated, time: .shortened))")
                    }
                }
            }.font(.footnote).foregroundStyle(.secondary)
            if selected.isEmpty {
                Text(unknown > 0 || origin.unavailable > 0 || !summary.coverageComplete ? "No confirmed matches in the observed data." : "No matching pull requests.")
                    .foregroundStyle(.secondary)
            }
            ForEach(selected) { item in
                Button { select(item, history: nil) } label: {
                    VStack(alignment: .leading) {
                        Text(item.title)
                        if let repository = repositoryNames[item.id] {
                            Text("\(repository) · #\(String(item.number))").font(.caption).foregroundStyle(.secondary)
                        } else { Text("#\(String(item.number))").font(.caption).foregroundStyle(.secondary) }
                    }
                }
            }
        }
        .navigationTitle(title)
    }

    private func mergedSelection(days: [MergedDay], history: ProjectHistoryContext) -> some View {
        let firstDay = days.first?.day ?? history.observedThrough
        var seen = Set<String>()
        let selected = history.items.filter { item in
            guard seen.insert(item.id).inserted, item.kind == .pullRequest, item.state == "MERGED", let date = item.mergedAt else { return false }
            return date >= firstDay && date <= history.observedThrough
        }.sorted { ($0.mergedAt ?? .distantPast) > ($1.mergedAt ?? .distantPast) }
        let repositoryNames = ProjectWorkArchive(repositories: history.repositories).repositoryNamesByWorkID
        return List {
            Section {
                Text("\(project.name) · current membership · \(firstDay.formatted(date: .abbreviated, time: .omitted))–\(history.observedThrough.formatted(date: .abbreviated, time: .omitted))")
                Text("Observed through \(history.observedThrough.formatted(date: .abbreviated, time: .shortened)).")
                Text("Saved grid filters do not apply to this historical selection.")
                if let refreshWarning { Text(refreshWarning) }
                ForEach(history.repositories.filter { $0.observedAt != nil }, id: \.id) { repository in
                    if let date = repository.observedAt {
                        Text("\(repository.name): observed \(date.formatted(date: .abbreviated, time: .shortened))")
                    }
                }
            }.font(.footnote).foregroundStyle(.secondary)
            ForEach(selected) { item in
                Button { select(item, history: history) } label: {
                    VStack(alignment: .leading) {
                        Text(item.title)
                        if let repository = repositoryNames[item.id] {
                            Text("\(repository) · #\(String(item.number))").font(.caption).foregroundStyle(.secondary)
                        } else {
                            Text("#\(String(item.number))").font(.caption).foregroundStyle(.secondary)
                        }
                    }
                }
            }
        }
        .navigationTitle("Merged PRs")
    }
}

private struct ProjectSettingsSheet: View {
    let project: StoredProject
    let library: ProjectLibrary
    let sessionManager: GitHubSessionManager
    let cache: WorkCache?
    let discovery: GitHubDiscovery
    let workClient: GitHubWorkClient
    @Environment(\.dismiss) private var dismiss
    @State private var pendingRemoval: RepositoryReference?
    @State private var showRemovalConfirmation = false
    @State private var removalError = false
    @State private var pendingErase: RepositoryReference?
    @State private var showEraseConfirmation = false
    @State private var savedWorkError: String?
    private var currentProject: StoredProject { library.projects.first(where: { $0.id == project.id }) ?? project }

    var body: some View {
        NavigationStack {
            List {
                Section {
                    ForEach(currentProject.repositories, id: \.id) { repository in
                        VStack(alignment: .leading) {
                            HStack {
                                Label(repository.fullName, systemImage: repository.isPrivate ? "lock" : "book.closed")
                                Spacer()
                                if repository.syncPaused {
                                    Button("Resume sync") {
                                        do { try library.setSyncPaused(false, repositoryID: repository.id, projectID: project.id); savedWorkError = nil }
                                        catch { savedWorkError = "Could not resume synchronization." }
                                    }
                                    .buttonStyle(.borderless)
                                }
                            }
                            if repository.syncPaused { Text("Synchronization paused").font(.caption).foregroundStyle(.secondary) }
                        }
                            .accessibilityIdentifier("repository.\(repository.id)")
                            .swipeActions {
                                Button("Remove", role: .destructive) { pendingRemoval = repository; showRemovalConfirmation = true }
                                    .disabled(currentProject.repositories.count <= 1)
                                Button("Erase saved work", role: .destructive) { pendingErase = repository; showEraseConfirmation = true }
                                    .disabled(cache == nil)
                            }
                    }
                    NavigationLink {
                        RepositoryDiscoveryPage(sessionManager: sessionManager, accountID: library.accountID,
                            account: "connected account", library: library, preferredProjectID: project.id,
                            discovery: discovery, workClient: workClient)
                    } label: {
                        Label("Add Repository", systemImage: "plus")
                    }
                } header: {
                    Text("Repositories")
                } footer: {
                    Text("A Project must contain at least one Repository.")
                }
                if removalError { Text("Could not update the Project.").foregroundStyle(.secondary) }
                if let savedWorkError { Text(savedWorkError).foregroundStyle(.secondary) }
            }
            .navigationTitle(project.name)
            .toolbar { ToolbarItem(placement: .confirmationAction) { Button("Done") { dismiss() } } }
            .confirmationDialog("Remove Repository from this Project?", isPresented: $showRemovalConfirmation, titleVisibility: .visible) {
                Button("Remove from Project", role: .destructive) {
                    guard let repository = pendingRemoval else { return }
                    do { try library.remove(repositoryID: repository.id, from: project.id); removalError = false }
                    catch { removalError = true }
                    pendingRemoval = nil
                }
            } message: {
                Text("The Repository stays on GitHub and in any other Projects.")
            }
            .confirmationDialog("Erase saved work from this Project?", isPresented: $showEraseConfirmation, titleVisibility: .visible) {
                Button("Erase saved work", role: .destructive) {
                    guard let repository = pendingErase, let cache else { return }
                    do { try library.eraseSavedWork(repositoryID: repository.id, from: project.id, cache: cache); savedWorkError = nil }
                    catch ProjectWorkArchive.RemovalError.unattributedData {
                        savedWorkError = "Some older saved work has no known repository. It was not removed."
                    } catch { savedWorkError = "Could not erase saved work. Check whether synchronization is paused before retrying." }
                    pendingErase = nil
                }
            } message: {
                Text("This removes saved work for this Repository in this Project and pauses synchronization here. GitHub and other Projects are not changed. You can resume synchronization later.")
            }
        }
    }
}

private struct WorkGridCell: View {
    let item: GitHubWorkItem
    let repositoryName: String?
    let showDetails: Bool
    let source: RepositoryWorkObservation?
    let open: () -> Void
    let preview: () -> Void
    @Environment(\.openURL) private var openURL

    private var tint: Color {
        switch item.checkStatus {
        case "ERROR", "FAILURE": .red
        case "PENDING", "EXPECTED": .yellow
        case "SUCCESS": .green
        default: .secondary
        }
    }

    private var reviewIndicator: ReviewIndicator? { ReviewIndicatorDecision().decide(item.metricRecord) }

    private var reviewSymbol: String? {
        switch reviewIndicator {
        case .attention: "exclamationmark.triangle.fill"
        case .requested: "eye"
        case .approved: "checkmark.circle.fill"
        case nil: nil
        }
    }

    private var reviewAccessibility: String {
        switch reviewIndicator {
        case .attention: ", review needs attention"
        case .requested: ", review requested or required"
        case .approved: ", approved with no unresolved review threads"
        case nil: ""
        }
    }

    private var reviewColor: Color {
        switch reviewIndicator {
        case .attention: .orange
        case .approved: .green
        case .requested, nil: .primary
        }
    }

    var body: some View {
        Button(action: open) {
            RoundedRectangle(cornerRadius: 6)
                .fill(tint.opacity(0.25))
                .aspectRatio(1, contentMode: .fit)
                .frame(maxWidth: 320)
                .overlay {
                    VStack(alignment: .leading, spacing: 3) {
                        HStack(alignment: .top, spacing: 2) {
                            Image(systemName: item.kind == .pullRequest ? "arrow.trianglehead.pull" : "circle.dotted")
                                .foregroundStyle(tint)
                            Spacer(minLength: 0)
                            if item.state == "MERGED" { Image(systemName: "arrow.trianglehead.merge") }
                            else if item.state == "CLOSED" { Image(systemName: "xmark.circle") }
                            else if item.state != "OPEN" { Text("?") }
                            if !showDetails, let reviewSymbol {
                                Image(systemName: reviewSymbol)
                                    .foregroundStyle(reviewColor)
                                    .accessibilityHidden(true)
                            }
                        }
                        .font(.caption2)
                        Spacer(minLength: 0)
                        if showDetails {
                            Text("#\(String(item.number)) · \(item.state)").font(.caption)
                            Text(item.title).font(.caption).lineLimit(3)
                        }
                        HStack(spacing: 2) {
                            if showDetails, let reviewSymbol {
                                Image(systemName: reviewSymbol)
                                    .foregroundStyle(reviewColor)
                                    .accessibilityHidden(true)
                            }
                            Spacer(minLength: 0)
                            if !showDetails {
                                Text(verbatim: String(item.number)).font(.caption2.monospacedDigit())
                                    .lineLimit(1).minimumScaleFactor(0.55).allowsTightening(true)
                            }
                        }.font(.caption2)
                    }.padding(6).foregroundStyle(.primary)
                }
        }
        .buttonStyle(.plain)
        .accessibilityIdentifier("work.\(item.id)")
        .accessibilityLabel((repositoryName.map { "\($0), " } ?? "Repository unavailable, ") + (item.kind == .pullRequest
            ? "Pull request \(item.number), \(item.title), \(item.state)\(item.isDraft ? ", draft" : ""), CI \(item.checkStatus ?? "unavailable")\(reviewAccessibility)"
            : "Issue \(item.number), \(item.title), \(item.state)"))
        .accessibilityAction(named: Text("Preview"), preview)
        .contextMenu {
            Button("Preview", systemImage: "eye", action: preview)
            Button("Open in GitGrid", systemImage: "doc.text") { open() }
            if let url = GitHubSourceLink.eligible(item.url, repository: repositoryName, kind: item.kind, number: item.number) {
                Button("Open on GitHub", systemImage: "arrow.up.right.square") { openURL(url) }
                ShareLink(item: url).accessibilityIdentifier("source.share")
            } else {
                Text("Source link unavailable")
            }
        } preview: {
            WorkPreviewContent(item: item, repositoryName: repositoryName, source: source).padding()
        }
    }

}

private struct WorkPreviewContent: View {
    let item: GitHubWorkItem
    let repositoryName: String?
    let source: RepositoryWorkObservation?
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(item.title).font(.headline)
            Text("\(item.kind == .issue ? "Issue" : "Pull request") #\(String(item.number)) · \(item.state)").foregroundStyle(.secondary)
            Text(repositoryName ?? "Repository unavailable").font(.subheadline).foregroundStyle(.secondary)
            if item.kind == .pullRequest { WorkSignalDetails(item: item) }
            if let details = item.details {
                if let type = details.issueContext?.type { LabeledContent("Issue type", value: type) }
                if let count = details.issueContext?.commentCount { LabeledContent("Comments", value: "\(count)") }
                if let body = details.body, !body.isEmpty {
                    Text(verbatim: body).lineLimit(5).accessibilityIdentifier("preview.description")
                }
                Text("Details observed \(details.observedAt.formatted(date: .abbreviated, time: .shortened))")
                    .font(.footnote).foregroundStyle(.secondary)
            }
            WorkSourceStatus(source: source, identifierPrefix: "preview")
        }
    }
}

private struct WorkSourceStatus: View {
    let source: RepositoryWorkObservation?
    let identifierPrefix: String
    var body: some View {
        if let source {
            if let problem = source.refreshProblem {
                Label(problem, systemImage: "exclamationmark.triangle").foregroundStyle(.secondary)
                    .accessibilityIdentifier("\(identifierPrefix).sourceProblem")
            }
            if let date = source.observedAt {
                if source.complete {
                    Text("Last complete observation \(date.formatted(date: .abbreviated, time: .shortened))")
                        .font(.footnote).foregroundStyle(.secondary).accessibilityIdentifier("\(identifierPrefix).sourceObservedAt")
                } else {
                    Text("Partial observation \(date.formatted(date: .abbreviated, time: .shortened))")
                        .font(.footnote).foregroundStyle(.secondary).accessibilityIdentifier("\(identifierPrefix).sourceObservedAt")
                }
            }
        }
    }
}

private struct WorkDetailSheet: View {
    let item: GitHubWorkItem
    let repositoryName: String?
    let source: RepositoryWorkObservation?
    let sessionManager: GitHubSessionManager
    let accountID: Int64
    let onThreads: @MainActor (GitHubWorkItem, GitHubReviewThreads, Date) -> Bool
    let onDetails: @MainActor (GitHubWorkItem, GitHubWorkDetails) -> Bool
    var historicalSnapshotAt: Date? = nil
    @Environment(\.dismiss) private var dismiss
    @Environment(\.openURL) private var openURL
    @State private var expandedThreads: GitHubReviewThreads?
    @State private var threadError = false
    @State private var loadingThreads = false
    @State private var threadObservedAt: Date?
    @State private var storageError = false
    @State private var details: GitHubWorkDetails?
    @State private var detailError = false
    @State private var loadingDetails = false
    @State private var loadingLinks = false
    @State private var linkError = false
    @State private var linkPageLimit = 10
    @State private var loadingRelation: GitHubIssueRelationKind?
    @State private var relationError: GitHubIssueRelationKind?
    @State private var relationPageLimits: [GitHubIssueRelationKind: Int] = [:]

    var body: some View {
        NavigationStack {
            List {
                Section {
                    if let historicalSnapshotAt {
                        Text("Saved observation through \(historicalSnapshotAt.formatted(date: .abbreviated, time: .shortened))")
                            .font(.footnote).foregroundStyle(.secondary)
                    }
                    Text(item.title).font(.headline)
                    LabeledContent("Number", value: "#\(item.number)")
                    LabeledContent("Repository", value: repositoryName ?? "Unavailable")
                        .accessibilityElement(children: .ignore)
                        .accessibilityLabel("Repository, \(repositoryName ?? "Unavailable")")
                        .accessibilityIdentifier("work.repository")
                    LabeledContent(historicalSnapshotAt == nil ? "State" : "State at observation", value: item.state)
                    LabeledContent("Updated", value: item.updatedAt.formatted(date: .abbreviated, time: .shortened))
                    WorkSourceStatus(source: source, identifierPrefix: "detail")
                    if source?.refreshProblem != nil {
                        Link("Manage GitHub access", destination: URL(string: "https://github.com/settings/installations")!)
                            .accessibilityIdentifier("detail.manageAccess")
                    }
                    if item.state != "OPEN", let closedAt = item.closedAt { LabeledContent("Closed", value: closedAt.formatted(date: .abbreviated, time: .shortened)) }
                    if item.kind == .issue && item.state == "CLOSED" {
                        LabeledContent("Closure reason", value: issueClosureLabel(item.closureReason))
                    }
                    if item.kind == .pullRequest && item.isDraft { Text("Draft").foregroundStyle(.secondary) }
                    if item.kind == .pullRequest {
                        WorkSignalDetails(item: item, threadsOverride: expandedThreads, observedAtOverride: threadObservedAt)
                        if loadingThreads { ProgressView("Loading review threads") }
                        if threadError { Text("Could not complete the thread count. Refresh the project and try again.").foregroundStyle(.secondary) }
                    }
                    if storageError { Text("Updated details could not be saved locally.").foregroundStyle(.secondary) }
                }
                if let details = details ?? item.details {
                    WorkDescriptionDetails(details: details)
                    if item.kind == .issue {
                        IssueRelationshipDetails(relationships: details.issueRelationships, loading: loadingLinks,
                            canLoad: historicalSnapshotAt == nil && !loadingDetails && loadingRelation == nil, loadError: linkError,
                            loadingRelation: loadingRelation, relationError: relationError,
                            onLoadMore: { Task { await loadMoreLinks() } },
                            onLoadRelation: { kind in Task { await loadMoreRelation(kind) } })
                    }
                }
                if loadingDetails { ProgressView("Loading details") }
                if detailError {
                    Text((details ?? item.details) == nil ? "Details could not be loaded." : "Could not update details. Showing saved details.")
                        .foregroundStyle(.secondary)
                    Button("Retry details", systemImage: "arrow.clockwise") { Task { await loadDetails() } }
                        .disabled(loadingDetails)
                        .accessibilityIdentifier("detail.retry")
                }
                if let url = GitHubSourceLink.eligible(item.url, repository: repositoryName, kind: item.kind, number: item.number) {
                    Button("Open on GitHub", systemImage: "arrow.up.right.square") { openURL(url) }
                    ShareLink(item: url).accessibilityIdentifier("source.share")
                } else {
                    Text("Source link unavailable").foregroundStyle(.secondary)
                }
            }
            .navigationTitle(item.kind == .pullRequest ? "Pull Request" : "Issue")
            .toolbar { ToolbarItem(placement: .confirmationAction) { Button("Done") { dismiss() } } }
            .task {
                guard historicalSnapshotAt == nil else { return }
                async let detail: Void = loadDetails()
                async let threads: Void = loadThreadsIfNeeded()
                _ = await (detail, threads)
            }
        }
    }

    private func issueClosureLabel(_ reason: String?) -> String {
        switch reason {
        case "COMPLETED": "Completed"
        case "NOT_PLANNED": "Not planned"
        case "DUPLICATE": "Duplicate"
        case nil, "": "Unavailable"
        default: reason ?? "Unavailable"
        }
    }

    @MainActor private func loadDetails() async {
        guard !loadingDetails else { return }
        loadingDetails = true
        detailError = false
        defer { loadingDetails = false }
        do {
            let credential = try await sessionManager.usableSession(for: accountID)
            let result = try await GitHubWorkDetailClient().load(token: credential.accessToken, id: item.id, kind: item.kind, expectedHead: item.headRevision)
            try Task.checkCancellation()
            guard try await sessionManager.isCurrent(accountID: accountID, accessToken: credential.accessToken) else { throw SessionRefreshError.sessionChanged }
            try Task.checkCancellation()
            details = result
            if !onDetails(item, result) { storageError = true }
        } catch is CancellationError {
        } catch { detailError = true }
    }

    @MainActor private func loadThreadsIfNeeded() async {
        guard item.kind == .pullRequest, item.reviewThreads?.isComplete == false,
              let head = item.headRevision else { return }
        loadingThreads = true
        defer { loadingThreads = false }
        do {
            let credential = try await sessionManager.usableSession(for: accountID)
            let result = try await GitHubReviewThreadsClient().load(token: credential.accessToken, pullRequestID: item.id, expectedHead: head)
            try Task.checkCancellation()
            guard try await sessionManager.isCurrent(accountID: accountID, accessToken: credential.accessToken) else { throw SessionRefreshError.sessionChanged }
            try Task.checkCancellation()
            let now = Date()
            expandedThreads = result
            threadObservedAt = now
            if !onThreads(item, result, now) { storageError = true }
        } catch is CancellationError {
        } catch {
            threadError = true
        }
    }

    @MainActor private func loadMoreLinks() async {
        guard !loadingLinks, !loadingDetails, loadingRelation == nil else { return }
        loadingLinks = true
        linkError = false
        defer { loadingLinks = false }
        do {
            let credential = try await sessionManager.usableSession(for: accountID)
            let links = try await GitHubWorkDetailClient().loadIssuePullRequestReferences(token: credential.accessToken, id: item.id, maxPages: linkPageLimit)
            try Task.checkCancellation()
            guard try await sessionManager.isCurrent(accountID: accountID, accessToken: credential.accessToken) else { throw SessionRefreshError.sessionChanged }
            try Task.checkCancellation()
            guard let updated = (details ?? item.details)?.replacingPullRequestReferences(links) else { linkError = true; return }
            details = updated
            if !links.isComplete || links.manualLinksComplete == false { linkPageLimit += 10 }
            if !onDetails(item, updated) { storageError = true }
        } catch is CancellationError {
        } catch { linkError = true }
    }

    @MainActor private func loadMoreRelation(_ kind: GitHubIssueRelationKind) async {
        guard loadingRelation == nil, !loadingLinks, !loadingDetails else { return }
        loadingRelation = kind
        relationError = nil
        defer { loadingRelation = nil }
        do {
            let credential = try await sessionManager.usableSession(for: accountID)
            let limit = relationPageLimits[kind] ?? 10
            let page = try await GitHubWorkDetailClient().loadIssueRelation(token: credential.accessToken, id: item.id, kind: kind, maxPages: limit)
            try Task.checkCancellation()
            guard try await sessionManager.isCurrent(accountID: accountID, accessToken: credential.accessToken) else { throw SessionRefreshError.sessionChanged }
            try Task.checkCancellation()
            guard let updated = (details ?? item.details)?.replacingIssueRelation(page, kind: kind) else { relationError = kind; return }
            details = updated
            if !page.isComplete { relationPageLimits[kind] = limit + 10 }
            if !onDetails(item, updated) { storageError = true }
        } catch is CancellationError {
        } catch { relationError = kind }
    }
}

private struct IssueRelationshipDetails: View {
    let relationships: GitHubIssueRelationships?
    let loading: Bool
    let canLoad: Bool
    let loadError: Bool
    let loadingRelation: GitHubIssueRelationKind?
    let relationError: GitHubIssueRelationKind?
    let onLoadMore: () -> Void
    let onLoadRelation: (GitHubIssueRelationKind) -> Void

    var body: some View {
        Section("Parent issue") {
            if let parent = relationships?.parent {
                issueLink(parent)
            } else if relationships?.parentObserved == true {
                Text("No parent issue").foregroundStyle(.secondary)
            } else {
                Text("Parent issue unavailable").foregroundStyle(.secondary)
            }
        }
        relationSection("Blocked by", page: relationships?.blockedBy, kind: .blockedBy)
        relationSection("Blocking", page: relationships?.blocking, kind: .blocking)
        relationSection("Direct sub-issues", page: relationships?.subIssues, kind: .subIssues)
        Section("Linked pull requests") {
            if let page = relationships?.pullRequests {
                ForEach(page.items) { pull in
                    if let url = GitHubSourceLink.eligible(pull.url, repository: pull.repository, kind: .pullRequest, number: pull.number) {
                        Link(destination: url) { pullDescription(pull) }
                    } else {
                        VStack(alignment: .leading) {
                            pullDescription(pull)
                            Text("Source link unavailable").font(.caption).foregroundStyle(.secondary)
                        }
                    }
                }
                if !page.isComplete { Text("Some cross-references are not shown.").foregroundStyle(.secondary) }
                if page.manualLinksComplete == false { Text("Some manually linked pull requests are not shown.").foregroundStyle(.secondary) }
                if page.manualLinksComplete == nil { Text("Manual links unavailable.").foregroundStyle(.secondary) }
                if !page.isComplete || page.manualLinksComplete != true {
                    Button("Load more pull request links", action: onLoadMore)
                        .disabled(loading || !canLoad)
                        .accessibilityIdentifier("issue.loadMoreLinks")
                }
                if loading { ProgressView("Loading links") }
                if loadError { Text("Could not load more links. Showing saved results.").foregroundStyle(.secondary) }
                if let observedAt = page.observedAt {
                    Text("Links observed \(observedAt.formatted(date: .abbreviated, time: .shortened))")
                        .font(.footnote).foregroundStyle(.secondary)
                }
                if page.isComplete && page.manualLinksComplete == true && page.items.isEmpty {
                    Text("No linked pull requests observed.").foregroundStyle(.secondary)
                }
            } else { Text("Pull request links unavailable.").foregroundStyle(.secondary) }
        }
    }

    private func relationSection(_ title: String, page: GitHubIssueRelationPage?, kind: GitHubIssueRelationKind) -> some View {
        Section(title) {
            if let page {
                LabeledContent("Reported total", value: "\(page.total)")
                if kind == .subIssues {
                    if let closed = page.closedCount { LabeledContent("Closed sub-issues", value: "\(closed)").accessibilityIdentifier("issue.closedSubIssues") }
                    else { Text("Closed sub-issue count unavailable.").foregroundStyle(.secondary) }
                }
                ForEach(page.items) { issue in issueLink(issue) }
                if !page.isComplete {
                    Text("Some related issues are not shown.").foregroundStyle(.secondary)
                    Button("Load more \(title)") { onLoadRelation(kind) }
                        .disabled(!canLoad || loading || loadingRelation != nil)
                        .accessibilityIdentifier("issue.loadRelation.\(kind.rawValue)")
                }
                if loadingRelation == kind { ProgressView("Loading related issues") }
                if relationError == kind { Text("Could not load more related issues. Showing saved results.").foregroundStyle(.secondary) }
                if let observedAt = page.observedAt {
                    Text("Relations observed \(observedAt.formatted(date: .abbreviated, time: .shortened))")
                        .font(.footnote).foregroundStyle(.secondary)
                }
            } else {
                Text("Relationships unavailable").foregroundStyle(.secondary)
            }
        }
    }

    private func issueLink(_ issue: GitHubIssueReference) -> some View {
        Group {
            if let url = GitHubSourceLink.eligible(issue.url, repository: issue.repository, kind: .issue, number: issue.number) {
                Link(destination: url) { issueDescription(issue) }
            } else {
                VStack(alignment: .leading) {
                    issueDescription(issue)
                    Text("Source link unavailable").font(.caption).foregroundStyle(.secondary)
                }
            }
        }
    }

    private func issueDescription(_ issue: GitHubIssueReference) -> some View {
        VStack(alignment: .leading) {
            Text(issue.title)
            Text("\(issue.repository) · #\(String(issue.number)) · \(issue.state)").font(.caption).foregroundStyle(.secondary)
        }
    }

    private func pullDescription(_ pull: GitHubPullRequestReference) -> some View {
        VStack(alignment: .leading) {
            Text(pull.title)
            Text("\(pull.repository) · #\(String(pull.number)) · \(pull.state)").font(.caption).foregroundStyle(.secondary)
            if pull.crossReferenced ?? true {
                Text(pull.willCloseTarget ? "Cross-reference · closes this issue on merge" : "Cross-reference")
                    .font(.caption).foregroundStyle(.secondary)
            }
            if pull.manuallyLinked == true { Text("Manually linked on GitHub").font(.caption).foregroundStyle(.secondary) }
        }
    }
}

private struct WorkDescriptionDetails: View {
    let details: GitHubWorkDetails
    var body: some View {
        Section("Context") {
            if let author = details.author { LabeledContent("Author", value: author) }
            if let created = details.createdAt { LabeledContent("Created", value: created.formatted(date: .abbreviated, time: .shortened)) }
            if let issue = details.issueContext {
                if let repository = issue.repository { LabeledContent("Repository", value: repository) }
                if let type = issue.type { LabeledContent("Issue type", value: type) }
                if let names = issue.assignees {
                    if names.isEmpty && issue.assigneesComplete == true { LabeledContent("Assignees", value: "None") }
                    else if !names.isEmpty { LabeledContent("Assignees", value: names.joined(separator: ", ")).accessibilityIdentifier("issue.assignees") }
                }
                if issue.assigneesComplete == false { Text("Some assignees are not shown.").foregroundStyle(.secondary) }
                if let milestone = issue.milestone { LabeledContent("Milestone", value: milestone).accessibilityIdentifier("issue.milestone") }
                if let count = issue.commentCount { LabeledContent("Comments", value: "\(count)") }
                if let count = issue.participantCount { LabeledContent("Participants", value: "\(count)") }
                if let date = issue.lastCommentAt { LabeledContent("Last comment", value: date.formatted(date: .abbreviated, time: .shortened)) }
            }
            if let base = details.baseRepository { LabeledContent("Target repository", value: base) }
            if let head = details.headRepository { LabeledContent("Source repository", value: head) }
            if let base = details.baseBranch { LabeledContent("Target branch", value: base) }
            if let head = details.headBranch { LabeledContent("Source branch", value: head) }
            if let labels = details.labels, !labels.isEmpty { LabeledContent("Labels", value: labels.joined(separator: ", ")) }
            if details.labelsComplete == false { Text("Some labels are not shown.").foregroundStyle(.secondary) }
            if let count = details.additions { LabeledContent("Added lines", value: "\(count)") }
            if let count = details.deletions { LabeledContent("Deleted lines", value: "\(count)") }
            if let count = details.changedFiles { LabeledContent("Changed files", value: "\(count)") }
            if let count = details.commits { LabeledContent("Commits", value: "\(count)") }
            Text("Details observed \(details.observedAt.formatted(date: .abbreviated, time: .shortened))").font(.footnote).foregroundStyle(.secondary)
        }
        if let body = details.body, !body.isEmpty {
            Section("Description") { Text(verbatim: body).textSelection(.enabled) }
        }
    }
}

private struct WorkSignalDetails: View {
    let item: GitHubWorkItem
    let threadsOverride: GitHubReviewThreads?
    let observedAtOverride: Date?

    init(item: GitHubWorkItem, threadsOverride: GitHubReviewThreads? = nil, observedAtOverride: Date? = nil) {
        self.item = item
        self.threadsOverride = threadsOverride
        self.observedAtOverride = observedAtOverride
    }

    var body: some View {
        LabeledContent("CI", value: item.checkStatus ?? "Unavailable")
        if let counts = item.checkCounts {
            LabeledContent("Checks (GitHub rollup)", value: "\(counts.red) failed · \(counts.yellow) pending · \(counts.green) passed · \(counts.total) total")
            if counts.other > 0 { LabeledContent("Other check results", value: "\(counts.other)") }
            if !counts.isComplete { Text("Check counts may be incomplete.").foregroundStyle(.secondary) }
        } else {
            Text("Check counts unavailable.").foregroundStyle(.secondary)
        }
        LabeledContent("Review", value: item.reviewDecision ?? "Unavailable")
        if let count = item.reviewRequestCount { LabeledContent("Review requests", value: "\(count)") }
        if let threads = threadsOverride ?? item.reviewThreads {
            LabeledContent("Review threads", value: "\(threads.total)")
            LabeledContent(threads.isComplete ? "Unresolved" : "Unresolved observed (partial)", value: "\(threads.observedUnresolved)")
            if let date = observedAtOverride ?? item.reviewThreadObservedAt {
                Text("Threads observed \(date.formatted(date: .abbreviated, time: .shortened))").font(.footnote).foregroundStyle(.secondary)
            }
        } else {
            Text("Review thread counts unavailable.").foregroundStyle(.secondary)
        }
    }
}
