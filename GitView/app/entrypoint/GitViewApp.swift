import SwiftUI
#if DEBUG
import GitHubAuth
import GitHubAPI
import ProjectStore
import WorkCache
#endif

@main
struct GitViewApp: App {
    @Environment(\.scenePhase) private var scenePhase

    var body: some Scene {
        WindowGroup {
            Group {
            #if DEBUG
            if ProcessInfo.processInfo.arguments.contains("--gitgrid-ui-test-project") || ProcessInfo.processInfo.arguments.contains("--gitgrid-ui-test-dense") || ProcessInfo.processInfo.arguments.contains("--gitgrid-ui-test-project-grid") {
                ProjectTestFixture()
            } else {
                ConnectionPage()
            }
            #else
            ConnectionPage()
            #endif
            }
            .onChange(of: scenePhase) {
                if scenePhase == .background { BackgroundRefreshRuntime.schedule() }
            }
        }
        .backgroundTask(.appRefresh(BackgroundRefreshRuntime.identifier)) { await BackgroundRefreshRuntime.run() }
    }
}

#if DEBUG
private struct ProjectTestFixture: View {
    @State private var library: ProjectLibrary?
    @Environment(\.scenePhase) private var scenePhase

    var body: some View {
        NavigationStack {
            if let library {
                ProjectsPage(library: library, sessionManager: GitHubSessionManager(load: { nil }, save: { _, _, _ in }, refresh: { _ in throw SessionRefreshError.missingSession }))
            } else { ProgressView() }
        }
        .task {
            do {
                let library = try ProjectLibrary(accountID: 1, store: ProjectStore(inMemory: true))
                try library.create(name: "Fixture Project", repository: RepositoryReference(id: 101, fullName: "fixture/one", isPrivate: false))
                guard let id = library.projects.first?.id else { return }
                try library.add(repository: RepositoryReference(id: 102, fullName: "fixture/two", isPrivate: true), to: id)
                if ProcessInfo.processInfo.arguments.contains("--gitgrid-ui-test-paused-repository") {
                    try library.setSyncPaused(true, repositoryID: 101, projectID: id)
                }
                if ProcessInfo.processInfo.arguments.contains("--gitgrid-ui-test-project-grid") {
                    for index in 1...11 {
                        try library.create(name: "Fixture Project \(index)", repository: RepositoryReference(id: Int64(200 + index), fullName: "fixture/\(index)", isPrivate: false))
                    }
                }
                let base = try FileManager.default.url(for: .applicationSupportDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
                let directory = base.appendingPathComponent("GitGrid", isDirectory: true)
                try FileManager.default.createDirectory(at: directory, withIntermediateDirectories: true)
                let cache = try WorkCache(url: directory.appendingPathComponent("WorkCache.sqlite"))
                let now = Date()
                let stamp = now.timeIntervalSinceReferenceDate
                let json = #"[{"id":"I1","number":1,"title":"Offline fixture","url":"https://github.com/fixture/one/issues/1","state":"OPEN","updatedAt":0,"isDraft":false,"kind":"issue","details":{"body":"Saved synthetic description","issueContext":{"repository":"fixture/one","type":"Bug","assignees":["alice"],"assigneesTotal":2,"assigneesComplete":false,"milestone":"First release","participantCount":7,"commentCount":4},"issueRelationships":{"parent":{"id":"IP","number":8,"title":"Parent fixture","url":"https://github.com/fixture/one/issues/8","state":"OPEN","repository":"fixture/one"},"parentObserved":true,"blockedBy":{"items":[{"id":"IB","number":9,"title":"Blocker fixture","url":"https://github.com/fixture/one/issues/9","state":"OPEN","repository":"fixture/one"}],"total":2,"isComplete":false},"blocking":{"items":[],"total":0,"isComplete":true},"subIssues":{"items":[],"total":0,"isComplete":true},"pullRequests":{"items":[{"id":"PRLINK","number":12,"title":"Linked PR fixture","url":"https://github.com/fixture/one/pull/12","state":"OPEN","repository":"fixture/one","willCloseTarget":true,"crossReferenced":true,"manuallyLinked":true}],"isComplete":false,"manualLinksComplete":true}},"observedAt":0}},{"id":"I2","number":4,"title":"Completed fixture","url":"https://github.com/fixture/one/issues/4","state":"CLOSED","updatedAt":\#(stamp),"closedAt":\#(stamp),"closureReason":"COMPLETED","isDraft":false,"kind":"issue"},{"id":"I3","number":5,"title":"Not planned fixture","url":"https://github.com/fixture/one/issues/5","state":"CLOSED","updatedAt":\#(stamp),"closedAt":\#(stamp),"closureReason":"NOT_PLANNED","isDraft":false,"kind":"issue"},{"id":"P1","number":2,"title":"Merged fixture","url":"https://github.com/fixture/one/pull/2","state":"MERGED","updatedAt":\#(stamp),"mergedAt":\#(stamp),"isDraft":false,"kind":"pullRequest"},{"id":"P2","number":3,"title":"Failed fixture","url":"https://github.com/fixture/one/pull/3","state":"OPEN","updatedAt":\#(stamp),"isDraft":true,"kind":"pullRequest","checkStatus":"FAILURE","reviewDecision":"CHANGES_REQUESTED","reviewRequestCount":1,"reviewThreads":{"total":3,"observedUnresolved":2,"isComplete":false}}]"#
                let items: [GitHubWorkItem]
                if ProcessInfo.processInfo.arguments.contains("--gitgrid-ui-test-dense") {
                    items = try denseItems(stamp: stamp)
                } else {
                    items = try JSONDecoder().decode([GitHubWorkItem].self, from: Data(json.utf8))
                }
                var archive = ProjectWorkArchive().applying([
                    .init(id: 101, name: "fixture/one", outcome: .received(items, complete: true)),
                    .init(id: 102, name: "fixture/two", outcome: .received([], complete: true))
                ], at: now)
                if ProcessInfo.processInfo.arguments.contains("--gitgrid-ui-test-preview-failure") {
                    archive = archive.applyingPartial([
                        .init(id: 101, name: "fixture/one", outcome: .failed("GitHub HTTP 403"))
                    ], in: [101, 102], at: now)
                }
                try cache.save(accountID: 1, projectID: id, payload: JSONEncoder().encode(archive), observedAt: now, complete: true)
                self.library = library
            } catch { assertionFailure("Could not create UI test fixture: \(error)") }
        }
        .onChange(of: scenePhase) {
            guard scenePhase == .background, ProcessInfo.processInfo.arguments.contains("--gitgrid-ui-test-overview-refresh"),
                  let project = library?.projects.first else { return }
            do {
                let base = try FileManager.default.url(for: .applicationSupportDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
                let cache = try WorkCache(url: base.appendingPathComponent("GitGrid/WorkCache.sqlite"))
                let now = Date()
                let archive = ProjectWorkArchive().applying(project.repositories.map {
                    .init(id: $0.id, name: $0.fullName, outcome: .received([], complete: true), observedAt: now)
                }, at: now)
                try cache.save(accountID: project.accountID, projectID: project.id, payload: JSONEncoder().encode(archive), observedAt: now, complete: true)
            } catch { assertionFailure("Could not update UI test overview: \(error)") }
        }
    }

    private func denseItems(stamp: TimeInterval) throws -> [GitHubWorkItem] {
        let values: [[String: Any]] = (1...100).map { index in
            let issue = index.isMultiple(of: 3)
            let state = issue ? (index.isMultiple(of: 2) ? "CLOSED" : "OPEN") :
                (index % 4 == 2 ? "MERGED" : (index % 4 == 0 ? "CLOSED" : "OPEN"))
            let updated = stamp - Double(index)
            var item: [String: Any] = ["id": "D\(index)", "number": index, "title": "Synthetic work \(index)",
                "url": "https://github.com/fixture/one/\(issue ? "issues" : "pull")/\(index)", "state": state,
                "updatedAt": updated, "isDraft": !issue && state == "OPEN" && index.isMultiple(of: 5),
                "kind": issue ? "issue" : "pullRequest"]
            if state == "CLOSED" || state == "MERGED" { item["closedAt"] = stamp }
            if state == "MERGED" { item["mergedAt"] = stamp }
            if !issue && state == "OPEN" { item["checkStatus"] = ["FAILURE", "PENDING", "SUCCESS"][index % 5 % 3] }
            return item
        }
        return try JSONDecoder().decode([GitHubWorkItem].self, from: JSONSerialization.data(withJSONObject: values))
    }
}
#endif
