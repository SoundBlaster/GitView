import SwiftUI
#if DEBUG
import GitHubAuth
import ProjectStore
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
                self.library = library
            } catch { assertionFailure("Could not create UI test fixture: \(error)") }
        }
    }
}
#endif
