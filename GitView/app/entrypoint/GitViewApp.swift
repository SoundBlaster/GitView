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
                let json = #"[{"id":"I1","number":1,"title":"Offline fixture","url":"https://github.com/fixture/one/issues/1","state":"OPEN","updatedAt":0,"isDraft":false,"kind":"issue","details":{"body":"Saved synthetic description","observedAt":0}}]"#
                try cache.save(accountID: 1, projectID: id, payload: Data(json.utf8), observedAt: .now, complete: false)
                self.library = library
            } catch { assertionFailure("Could not create UI test fixture: \(error)") }
        }
    }
}
#endif
