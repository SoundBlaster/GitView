import GitHubAPI
import GitHubAuth
import ProjectStore
import SwiftUI
import WorkDomain
import WorkCache

struct ProjectWorkPage: View {
    let project: StoredProject
    let sessionManager: GitHubSessionManager
    let library: ProjectLibrary
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
    @State private var selectedItem: GitHubWorkItem?
    @State private var showProjectSettings = false
    @State private var zoomHint = false
    @Environment(\.dynamicTypeSize) private var dynamicTypeSize
    @AppStorage private var showOpen: Bool
    @AppStorage private var showMerged: Bool
    @AppStorage private var showClosed: Bool
    @AppStorage private var showIssues: Bool
    @AppStorage private var showPullRequests: Bool

    init(project: StoredProject, sessionManager: GitHubSessionManager, library: ProjectLibrary) {
        self.project = project
        self.sessionManager = sessionManager
        self.library = library
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
                if let archive {
                    if !archive.legacyItems.isEmpty && archive.hasRefreshProblems {
                        Text("Some older saved work could not yet be attributed to a repository.")
                            .font(.footnote).foregroundStyle(.secondary)
                    }
                    ForEach(archive.repositories.filter { $0.refreshProblem != nil }, id: \.id) { repository in
                        VStack(alignment: .leading) {
                            Text("\(repository.name): \(repository.refreshProblem ?? "")")
                            if let date = repository.observedAt {
                                Text("Last observed \(date.formatted(date: .abbreviated, time: .shortened))")
                            } else { Text("No saved observation") }
                        }.font(.footnote).foregroundStyle(.secondary)
                    }
                }
                if isLoading && !hasLoaded { ProgressView("Loading work") }
                if hasLoaded && items.isEmpty && warning == nil {
                    ContentUnavailableView("No work in Today", systemImage: "checkmark.circle")
                }
                if hasLoaded && !items.isEmpty && visibleItems.isEmpty {
                    ContentUnavailableView("No work matches filters", systemImage: "line.3.horizontal.decrease.circle")
                }
                if zoomHint {
                    Text("Choose an item to open it.").font(.footnote).foregroundStyle(.secondary)
                }
                LazyVGrid(columns: gridColumns, spacing: 4) {
                    ForEach(visibleItems) { item in
                        WorkGridCell(item: item, showDetails: effectiveColumns <= 2) { selectedItem = item }
                    }
                }
                .onGeometryChange(for: CGFloat.self) { $0.size.width } action: { gridWidth = $0 }
                .simultaneousGesture(MagnifyGesture().onEnded { value in
                    if value.magnification > 1.15 { changeZoom(.larger) }
                    else if value.magnification < 0.85 { changeZoom(.smaller) }
                })
            }
            .padding()
        }
        .navigationTitle(project.name)
        .toolbar {
            Button("Project settings", systemImage: "gearshape") { showProjectSettings = true }
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
        }
        .sheet(item: $selectedItem) { item in
            WorkDetailSheet(item: item, sessionManager: sessionManager, accountID: project.accountID, onThreads: persistThreads)
        }
        .sheet(isPresented: $showProjectSettings) {
            ProjectSettingsSheet(project: project, library: library, sessionManager: sessionManager)
        }
        .task { restore(); await load() }
        .refreshable { await load() }
        .onChange(of: project.repositories) {
            warning = "Project membership changed; updating its overview."
            observedAt = nil
            if isLoading { refreshPending = true } else { Task { await load() } }
        }
        .onChange(of: isLoading) {
            if !isLoading && refreshPending { refreshPending = false; Task { await load() } }
        }
    }

    @MainActor private func changeZoom(_ direction: GridZoomDirection) {
        let next = GridDensity.next(current: effectiveColumns, direction: direction, width: Double(gridWidth), maxCellWidth: 320)
        withAnimation(.easeInOut(duration: 0.2)) { columns = next }
        guard direction == .larger, GridDensity.isAtMaximum(columns: next, width: Double(gridWidth), maxCellWidth: 320) else {
            zoomHint = false
            return
        }
        if visibleItems.count == 1 { selectedItem = visibleItems.first; zoomHint = false }
        else if !visibleItems.isEmpty { zoomHint = true }
    }

    @MainActor private func load() async {
        guard !isLoading else { return }
        let requestedRepositories = project.repositories
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
        var results: [RepositoryWorkRefresh] = []
        for repository in requestedRepositories {
            do {
                let page = try await GitHubWorkClient().load(token: accessToken, repositoryID: repository.id, fullName: repository.fullName)
                results.append(.init(id: repository.id, name: repository.fullName, outcome: .received(page.items, complete: !page.isIncomplete)))
            } catch is CancellationError { return }
            catch let WorkFetchError.httpStatus(code) {
                results.append(.init(id: repository.id, name: repository.fullName, outcome: .failed("GitHub HTTP \(code)")))
            } catch {
                results.append(.init(id: repository.id, name: repository.fullName, outcome: .failed("Could not update from GitHub")))
            }
        }
        guard !Task.isCancelled else { return }
        guard library.projects.first(where: { $0.id == project.id })?.repositories == requestedRepositories else { return }
        let now = Date()
        let snapshot: WorkSnapshot?
        do {
            snapshot = try cache?.load(accountID: project.accountID, projectID: project.id)
        } catch {
            warning = "Saved work could not be read; the refresh was not saved."
            return
        }
        let previous: ProjectWorkArchive
        do { previous = try snapshot.map { try ProjectWorkArchive.decode($0.payload) } ?? archive ?? ProjectWorkArchive() }
        catch { warning = "Saved work could not be read; the refresh was not saved."; return }
        let updated = previous.applying(results, at: now)
        let complete = !updated.hasRefreshProblems
        var saved = false
        if let cache {
            do {
                let data = try JSONEncoder().encode(updated)
                if let snapshot, snapshot.observedAt > now {
                    saved = false
                } else if complete || snapshot == nil {
                    try cache.save(accountID: project.accountID, projectID: project.id, payload: data, observedAt: now, complete: complete)
                    saved = true
                } else if let snapshot {
                    saved = try cache.replacePayload(accountID: project.accountID, projectID: project.id, expected: snapshot, payload: data)
                }
            } catch { saved = false }
        }
        archive = updated
        present(updated.items, now: now)
        if saved && complete { observedAt = now }
        hasLoaded = true
        warning = !saved ? "Updated data could not be saved locally." : (complete ? nil : "Some repositories could not be fully refreshed.")
    }

    @MainActor private func restore() {
        do {
            let base = try FileManager.default.url(for: .applicationSupportDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
            let directory = base.appendingPathComponent("GitGrid", isDirectory: true)
            try FileManager.default.createDirectory(at: directory, withIntermediateDirectories: true)
            let store = try WorkCache(url: directory.appendingPathComponent("WorkCache.sqlite"))
            cache = store
            if let snapshot = try store.load(accountID: project.accountID, projectID: project.id) {
                let saved = try ProjectWorkArchive.decode(snapshot.payload)
                archive = saved
                present(saved.items, now: .now)
                let coversProject = saved.coversRepositories(Set(project.repositories.map(\.id)))
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

private struct ProjectSettingsSheet: View {
    let project: StoredProject
    let library: ProjectLibrary
    let sessionManager: GitHubSessionManager
    @Environment(\.dismiss) private var dismiss
    private var currentProject: StoredProject { library.projects.first(where: { $0.id == project.id }) ?? project }

    var body: some View {
        NavigationStack {
            List {
                Section("Repositories") {
                    ForEach(currentProject.repositories, id: \.id) { repository in
                        Label(repository.fullName, systemImage: repository.isPrivate ? "lock" : "book.closed")
                    }
                    NavigationLink {
                        RepositoryDiscoveryPage(sessionManager: sessionManager, accountID: library.accountID,
                            account: "connected account", library: library, preferredProjectID: project.id)
                    } label: {
                        Label("Add Repository", systemImage: "plus")
                    }
                }
            }
            .navigationTitle(project.name)
            .toolbar { ToolbarItem(placement: .confirmationAction) { Button("Done") { dismiss() } } }
        }
    }
}

private struct WorkGridCell: View {
    let item: GitHubWorkItem
    let showDetails: Bool
    let open: () -> Void
    @Environment(\.openURL) private var openURL

    private var tint: Color {
        switch item.checkStatus {
        case "ERROR", "FAILURE": .red
        case "PENDING", "EXPECTED": .yellow
        case "SUCCESS": .green
        default: .secondary
        }
    }

    var body: some View {
        Button(action: open) {
            RoundedRectangle(cornerRadius: 6)
                .fill(tint.opacity(0.25))
                .aspectRatio(1, contentMode: .fit)
                .frame(maxWidth: 320)
                .overlay {
                    VStack(alignment: .leading, spacing: 8) {
                        Image(systemName: item.kind == .pullRequest ? "arrow.triangle.pull" : "circle.dotted")
                        if showDetails {
                            Text("#\(item.number) · \(item.state)").font(.caption)
                            Text(item.title).font(.caption).lineLimit(3)
                        }
                    }.padding(6).foregroundStyle(tint)
                }
        }
        .buttonStyle(.plain)
        .accessibilityLabel(item.kind == .pullRequest
            ? "Pull request \(item.number), \(item.title), \(item.state), CI \(item.checkStatus ?? "unavailable")"
            : "Issue \(item.number), \(item.title), \(item.state)")
        .contextMenu {
            Button("Open on GitHub", systemImage: "arrow.up.right.square") { openURL(item.url) }
            ShareLink(item: item.url)
        } preview: {
            VStack(alignment: .leading, spacing: 10) {
                Text(item.title).font(.headline)
                Text("#\(item.number) · \(item.state)").foregroundStyle(.secondary)
                if item.kind == .pullRequest {
                    WorkSignalDetails(item: item)
                }
            }.padding()
        }
    }

}

private struct WorkDetailSheet: View {
    let item: GitHubWorkItem
    let sessionManager: GitHubSessionManager
    let accountID: Int64
    let onThreads: @MainActor (GitHubWorkItem, GitHubReviewThreads, Date) -> Bool
    @Environment(\.dismiss) private var dismiss
    @Environment(\.openURL) private var openURL
    @State private var expandedThreads: GitHubReviewThreads?
    @State private var threadError = false
    @State private var loadingThreads = false
    @State private var threadObservedAt: Date?
    @State private var storageError = false

    var body: some View {
        NavigationStack {
            List {
                Section {
                    Text(item.title).font(.headline)
                    LabeledContent("Number", value: "#\(item.number)")
                    LabeledContent("State", value: item.state)
                    if item.kind == .pullRequest {
                        WorkSignalDetails(item: item, threadsOverride: expandedThreads, observedAtOverride: threadObservedAt)
                        if loadingThreads { ProgressView("Loading review threads") }
                        if threadError { Text("Could not complete the thread count. Refresh the project and try again.").foregroundStyle(.secondary) }
                        if storageError { Text("Updated thread count could not be saved locally.").foregroundStyle(.secondary) }
                    }
                }
                Button("Open on GitHub", systemImage: "arrow.up.right.square") { openURL(item.url) }
                ShareLink(item: item.url)
            }
            .navigationTitle(item.kind == .pullRequest ? "Pull Request" : "Issue")
            .toolbar { ToolbarItem(placement: .confirmationAction) { Button("Done") { dismiss() } } }
            .task { await loadThreadsIfNeeded() }
        }
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
            let now = Date()
            expandedThreads = result
            threadObservedAt = now
            storageError = !onThreads(item, result, now)
        } catch is CancellationError {
        } catch {
            threadError = true
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
