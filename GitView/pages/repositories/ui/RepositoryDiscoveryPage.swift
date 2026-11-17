import GitHubAPI
import GitHubAuth
import ProjectStore
import SwiftUI

struct RepositoryDiscoveryPage: View {
    let sessionManager: GitHubSessionManager
    let accountID: Int64
    let account: String
    let library: ProjectLibrary?
    var preferredProjectID: UUID? = nil
    @State private var result: DiscoveryResult?
    @State private var isLoading = false
    @State private var errorMessage: String?
    @State private var query = ""
    @State private var selected: GitHubRepository?
    @State private var isFresh = false

    var body: some View {
        List {
            if let result {
                if !result.isComplete {
                    Label("Some repositories could not be loaded. Pull to retry.", systemImage: "exclamationmark.triangle")
                        .foregroundStyle(.secondary)
                }
                ForEach(result.repositories.filter { query.isEmpty || $0.fullName.localizedCaseInsensitiveContains(query) }) { repository in
                    Button {
                        selected = repository
                    } label: {
                        Label(repository.fullName, systemImage: repository.isPrivate ? "lock" : "book.closed")
                    }
                    .disabled(!isFresh || isLoading || library == nil)
                }
                if result.repositories.isEmpty && result.isComplete {
                    ContentUnavailableView("No accessible repositories", systemImage: "tray", description: Text("Install the GitHub App for repositories you want to view."))
                }
            } else if isLoading {
                ProgressView("Loading repositories")
            }
            if let errorMessage {
                Text(errorMessage).foregroundStyle(.secondary)
            }
        }
        .navigationTitle("Repositories")
        .searchable(text: $query)
        .task { await load() }
        .refreshable { await load() }
        .sheet(item: $selected) { repository in
            if let library {
                ProjectCreationSheet(repository: repository, library: library, canSave: isFresh && !isLoading, preferredProjectID: preferredProjectID)
            }
        }
    }

    @MainActor private func load() async {
        guard !isLoading else { return }
        isLoading = true
        isFresh = false
        defer { isLoading = false }
        do {
            let session = try await sessionManager.usableSession(for: accountID)
            let updated = try await GitHubDiscovery().load(token: session.accessToken)
            try Task.checkCancellation()
            var metadataProblem = false
            if let library {
                do {
                    try library.reconcile(observed: updated.repositories.map {
                        RepositoryReference(id: $0.id, fullName: $0.fullName, isPrivate: $0.isPrivate, nodeID: $0.nodeID)
                    })
                } catch { metadataProblem = true }
            }
            if !updated.isComplete, result != nil {
                errorMessage = metadataProblem ? "Refresh was incomplete and saved repository metadata could not be updated." : "Refresh was incomplete. Showing the previous results."
            } else {
                result = updated
                isFresh = true
                errorMessage = metadataProblem ? "Saved repository metadata could not be updated." : nil
            }
        } catch is CancellationError {
        } catch {
            errorMessage = "Could not refresh repositories for \(account)."
        }
    }
}
