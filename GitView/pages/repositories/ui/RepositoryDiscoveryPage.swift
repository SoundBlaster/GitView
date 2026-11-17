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
    var discovery: GitHubDiscovery = GitHubDiscovery()
    @State private var result: DiscoveryResult?
    @State private var repositories: [GitHubRepository] = []
    @State private var freshRepositoryIDs = Set<Int64>()
    @State private var isLoading = false
    @State private var errorMessage: String?
    @State private var query = ""
    @State private var selected: GitHubRepository?

    var body: some View {
        List {
            if let result {
                if !result.isComplete {
                    Label("Some repositories could not be loaded. Pull to retry.", systemImage: "exclamationmark.triangle")
                        .foregroundStyle(.secondary)
                }
                ForEach(repositories.filter { query.isEmpty || $0.fullName.localizedCaseInsensitiveContains(query) }) { repository in
                    Button {
                        selected = repository
                    } label: {
                        VStack(alignment: .leading) {
                            Label(repository.fullName, systemImage: repository.isPrivate ? "lock" : "book.closed")
                            if !freshRepositoryIDs.contains(repository.id) {
                                Text("Not refreshed").font(.caption).foregroundStyle(.secondary)
                            }
                        }
                    }
                    .disabled(!freshRepositoryIDs.contains(repository.id) || isLoading || library == nil)
                    .accessibilityIdentifier("discovery.repository.\(repository.id)")
                }
                if repositories.isEmpty && result.isComplete {
                    ContentUnavailableView("No accessible repositories", systemImage: "tray", description: Text("Install the GitHub App for repositories you want to view."))
                }
            } else if isLoading {
                ProgressView("Loading repositories")
            }
            if let errorMessage {
                Text(errorMessage).foregroundStyle(.secondary)
            }
            if errorMessage != nil || result?.isComplete == false {
                Button("Retry") { Task { await load() } }
                    .disabled(isLoading)
                    .accessibilityIdentifier("discovery.retry")
            } else if result?.isComplete == true && repositories.isEmpty {
                Button("Refresh") { Task { await load() } }
                    .disabled(isLoading)
                    .accessibilityIdentifier("discovery.refresh")
            }
            Section {
                Link("Install GitGrid on GitHub", destination: URL(string: "https://github.com/apps/gitgrid-ios/installations/new")!)
                    .accessibilityIdentifier("discovery.installApp")
                Link("Manage installed GitHub Apps", destination: URL(string: "https://github.com/settings/installations")!)
                    .accessibilityIdentifier("discovery.manageAccess")
            } footer: {
                Text("Install GitGrid or change which repositories it can access on GitHub, then refresh this list.")
            }
        }
        .navigationTitle("Repositories")
        .toolbar {
            Button("Refresh", systemImage: "arrow.clockwise") { Task { await load() } }
                .disabled(isLoading)
                .accessibilityIdentifier("discovery.toolbarRefresh")
        }
        .searchable(text: $query)
        .task { await load() }
        .refreshable { await load() }
        .sheet(item: $selected) { repository in
            if let library {
                ProjectCreationSheet(repository: repository, library: library, canSave: freshRepositoryIDs.contains(repository.id) && !isLoading, preferredProjectID: preferredProjectID)
            }
        }
    }

    @MainActor private func load() async {
        guard !isLoading else { return }
        isLoading = true
        freshRepositoryIDs = []
        defer { isLoading = false }
        do {
            let session = try await sessionManager.usableSession(for: accountID)
            let updated = try await discovery.load(token: session.accessToken)
            try Task.checkCancellation()
            guard try await sessionManager.isCurrent(accountID: accountID, accessToken: session.accessToken) else {
                errorMessage = "The GitHub session changed. Refresh repositories for the active account."
                return
            }
            try Task.checkCancellation()
            var metadataProblem = false
            if let library {
                do {
                    try library.reconcile(observed: updated.repositories.map {
                        RepositoryReference(id: $0.id, fullName: $0.fullName, isPrivate: $0.isPrivate, nodeID: $0.nodeID)
                    })
                } catch { metadataProblem = true }
            }
            if updated.isComplete {
                repositories = updated.repositories
            } else {
                var merged = repositories
                var indices = Dictionary(merged.enumerated().map { ($0.element.id, $0.offset) }, uniquingKeysWith: { first, _ in first })
                for repository in updated.repositories {
                    if let index = indices[repository.id] { merged[index] = repository }
                    else { indices[repository.id] = merged.count; merged.append(repository) }
                }
                repositories = merged
            }
            result = updated
            freshRepositoryIDs = Set(updated.repositories.map(\.id))
            errorMessage = metadataProblem ? "Saved repository metadata could not be updated." : nil
            if let until = updated.rateLimitUntil {
                let limitMessage = "GitHub rate limit. Retry after \(until.formatted(date: .abbreviated, time: .shortened))."
                errorMessage = [errorMessage, limitMessage].compactMap { $0 }.joined(separator: " ")
            }
            let statuses = Set(updated.httpStatuses).sorted().map(String.init).joined(separator: ", ")
            if !statuses.isEmpty {
                errorMessage = [errorMessage, "GitHub HTTP \(statuses)"].compactMap { $0 }.joined(separator: " ")
            }
        } catch is CancellationError {
        } catch {
            errorMessage = "Could not refresh repositories for \(account)."
        }
    }
}
