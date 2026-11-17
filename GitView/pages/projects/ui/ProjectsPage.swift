import GitHubAPI
import GitHubAuth
import ProjectStore
import SwiftUI
import WorkCache
import WorkDomain

struct ProjectsPage: View {
    let library: ProjectLibrary
    let sessionManager: GitHubSessionManager
    @Environment(\.dynamicTypeSize) private var dynamicTypeSize
    @State private var columns = 4
    @State private var width: CGFloat = 0
    @State private var selectedProject: StoredProject?
    @State private var zoomHint = false
    @State private var overviews: [UUID: ProjectOverview] = [:]
    @State private var cacheError = false
    private var effectiveColumns: Int { dynamicTypeSize.isAccessibilitySize ? min(columns, 2) : columns }
    private var gridColumns: [GridItem] { Array(repeating: GridItem(.flexible(), spacing: 6), count: effectiveColumns) }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 12) {
                if library.projects.isEmpty {
                    ContentUnavailableView("No projects yet", systemImage: "square.grid.2x2", description: Text("Choose a repository to create a project."))
                }
                if cacheError {
                    Label("Some saved summaries could not be read.", systemImage: "exclamationmark.triangle")
                        .font(.footnote).foregroundStyle(.secondary)
                }
                if zoomHint { Text("Choose a project to open it.").font(.footnote).foregroundStyle(.secondary) }
                LazyVGrid(columns: gridColumns, spacing: 6) {
                    ForEach(library.projects) { project in
                        Button { selectedProject = project } label: {
                            ProjectCell(project: project, overview: overviews[project.id], expanded: effectiveColumns <= 2)
                        }
                        .buttonStyle(.plain)
                        .accessibilityIdentifier("project.\(project.id.uuidString)")
                        .contextMenu {
                            Button("Open Project", systemImage: "arrow.up.right.square") { selectedProject = project }
                        } preview: {
                            ProjectCell(project: project, overview: overviews[project.id], expanded: true).padding()
                        }
                    }
                }
                .onGeometryChange(for: CGFloat.self) { $0.size.width } action: { width = $0 }
                .simultaneousGesture(MagnifyGesture().onEnded { value in
                    if value.magnification > 1.15 { changeZoom(.larger) }
                    else if value.magnification < 0.85 { changeZoom(.smaller) }
                })
            }.padding()
        }
        .navigationTitle("Projects")
        .toolbar {
            Menu("Zoom", systemImage: "plus.magnifyingglass") {
                Button("Larger", systemImage: "plus.magnifyingglass") { changeZoom(.larger) }
                Button("Smaller", systemImage: "minus.magnifyingglass") { changeZoom(.smaller) }
            }
        }
        .navigationDestination(item: $selectedProject) { project in
            ProjectWorkPage(project: library.projects.first(where: { $0.id == project.id }) ?? project, sessionManager: sessionManager, library: library)
        }
        .onAppear { loadOverviews() }
        .onChange(of: library.projects) { loadOverviews() }
    }

    @MainActor private func changeZoom(_ direction: GridZoomDirection) {
        let next = GridDensity.next(current: effectiveColumns, direction: direction, width: Double(width), maxCellWidth: 320)
        withAnimation(.easeInOut(duration: 0.2)) { columns = next }
        guard direction == .larger, GridDensity.isAtMaximum(columns: next, width: Double(width), maxCellWidth: 320) else { zoomHint = false; return }
        if library.projects.count == 1 { selectedProject = library.projects.first; zoomHint = false }
        else if !library.projects.isEmpty { zoomHint = true }
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
                        results[project.id] = ProjectOverview(summary: summary, date: snapshot.observedAt)
                    }
                } catch { failures = true }
            }
            overviews = results
            cacheError = failures
        } catch { cacheError = true }
    }
}

private struct ProjectOverview {
    let summary: ProjectWorkSummary
    let date: Date
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
                    if !overview.summary.coverageComplete || overview.summary.failedCI.unavailable > 0 || overview.summary.unresolvedThreads.unavailable > 0 {
                        Text("?").foregroundStyle(.secondary)
                    }
                }.font(.caption2)
            }
            if expanded {
                Text("\(project.repositories.count) repositories").font(.caption2).foregroundStyle(.secondary)
                if let overview {
                    Text("Observed: \(overview.summary.openPullRequests) open PR · \(overview.summary.openIssues) open issues")
                        .font(.caption2).foregroundStyle(.secondary)
                    Text(overview.summary.coverageComplete ? "Snapshot \(overview.date.formatted(date: .abbreviated, time: .shortened))" : "Partial · \(overview.date.formatted(date: .abbreviated, time: .shortened))")
                        .font(.caption2).foregroundStyle(.secondary)
                } else {
                    Text("No cached work").font(.caption2).foregroundStyle(.secondary)
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
        guard let overview else { return "\(project.name), no cached work" }
        let summary = overview.summary
        let uncertain = !summary.coverageComplete || summary.failedCI.unavailable > 0 || summary.unresolvedThreads.unavailable > 0
        return "\(project.name), \(summary.openPullRequests) open pull requests, \(summary.openIssues) open issues, \(summary.failedCI.count) pull requests with failed CI, \(summary.affectedByThreads.count) pull requests with unresolved threads" + (uncertain ? ", some data unavailable or partial" : "") + ", snapshot saved \(overview.date.formatted(date: .abbreviated, time: .shortened))"
    }
}
