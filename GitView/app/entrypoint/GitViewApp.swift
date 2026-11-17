import SwiftUI
#if DEBUG
import GitHubAuth
import GitHubAPI
import ProjectStore
import WorkCache
#endif

@main
struct GitViewApp: App {
    var body: some Scene {
        WindowGroup {
            #if DEBUG
            if ProcessInfo.processInfo.arguments.contains("--gitgrid-ui-test-project") {
                ProjectTestFixture()
            } else {
                ConnectionPage()
            }
            #else
            ConnectionPage()
            #endif
        }
    }
}

#if DEBUG
private struct ProjectTestFixture: View {
    @State private var library: ProjectLibrary?

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
                let base = try FileManager.default.url(for: .applicationSupportDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
                let directory = base.appendingPathComponent("GitGrid", isDirectory: true)
                try FileManager.default.createDirectory(at: directory, withIntermediateDirectories: true)
                let cache = try WorkCache(url: directory.appendingPathComponent("WorkCache.sqlite"))
                let now = Date()
                let stamp = now.timeIntervalSinceReferenceDate
                let json = #"[{"id":"I1","number":1,"title":"Offline fixture","url":"https://github.com/fixture/one/issues/1","state":"OPEN","updatedAt":0,"isDraft":false,"kind":"issue","details":{"body":"Saved synthetic description","observedAt":0}},{"id":"I2","number":4,"title":"Completed fixture","url":"https://github.com/fixture/one/issues/4","state":"CLOSED","updatedAt":\#(stamp),"closedAt":\#(stamp),"closureReason":"COMPLETED","isDraft":false,"kind":"issue"},{"id":"I3","number":5,"title":"Not planned fixture","url":"https://github.com/fixture/one/issues/5","state":"CLOSED","updatedAt":\#(stamp),"closedAt":\#(stamp),"closureReason":"NOT_PLANNED","isDraft":false,"kind":"issue"},{"id":"P1","number":2,"title":"Merged fixture","url":"https://github.com/fixture/one/pull/2","state":"MERGED","updatedAt":\#(stamp),"mergedAt":\#(stamp),"isDraft":false,"kind":"pullRequest"},{"id":"P2","number":3,"title":"Failed fixture","url":"https://github.com/fixture/one/pull/3","state":"OPEN","updatedAt":\#(stamp),"isDraft":true,"kind":"pullRequest","checkStatus":"FAILURE","reviewDecision":"CHANGES_REQUESTED","reviewRequestCount":1,"reviewThreads":{"total":3,"observedUnresolved":2,"isComplete":false}}]"#
                let items = try JSONDecoder().decode([GitHubWorkItem].self, from: Data(json.utf8))
                let archive = ProjectWorkArchive().applying([
                    .init(id: 101, name: "fixture/one", outcome: .received(items, complete: true)),
                    .init(id: 102, name: "fixture/two", outcome: .received([], complete: true))
                ], at: now)
                try cache.save(accountID: 1, projectID: id, payload: JSONEncoder().encode(archive), observedAt: now, complete: true)
                self.library = library
            } catch { assertionFailure("Could not create UI test fixture: \(error)") }
        }
    }
}
#endif
