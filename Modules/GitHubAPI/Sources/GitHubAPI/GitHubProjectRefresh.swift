import Foundation

public struct RefreshRepository: Sendable {
    public let id: Int64
    public let fullName: String
    public let nodeID: String?

    public init(id: Int64, fullName: String, nodeID: String?) {
        self.id = id
        self.fullName = fullName
        self.nodeID = nodeID
    }
}

public struct ProjectRefreshResults: Sendable {
    public let observations: [RepositoryWorkRefresh]
    public let observedRepositories: [GitHubRepository]
}

/// Collects independent repository outcomes without committing any partial result on cancellation.
public struct GitHubProjectRefresh: Sendable {
    public typealias Load = @Sendable (String, RefreshRepository) async throws -> GitHubWorkPage
    private let load: Load
    private let tracksOpenContinuation: Bool
    private let continuations: [Int64: GitHubOpenContinuation]

    public init(tracksOpenContinuation: Bool = false, continuations: [Int64: GitHubOpenContinuation] = [:], load: @escaping Load = { token, repository in
        try await GitHubWorkClient().load(token: token, repositoryID: repository.id, fullName: repository.fullName, nodeID: repository.nodeID)
    }) {
        self.load = load
        self.tracksOpenContinuation = tracksOpenContinuation
        self.continuations = continuations
    }

    public func fetch(token: String, repositories: [RefreshRepository]) async throws -> ProjectRefreshResults {
        var observations: [RepositoryWorkRefresh] = []
        var observedRepositories: [GitHubRepository] = []
        for repository in repositories {
            try Task.checkCancellation()
            let expected = continuations[repository.id]
            do {
                let page = try await load(token, repository)
                if let observed = page.observedRepository { observedRepositories.append(observed) }
                observations.append(.init(id: repository.id, name: page.observedRepository?.fullName ?? repository.fullName,
                                          outcome: .received(page.items, complete: !page.isIncomplete), observedAt: .now,
                                          refreshProblem: page.refreshProblem,
                                          continuationUpdate: tracksOpenContinuation ? .advance(from: expected, to: page.openContinuation) : .unchanged))
            } catch is CancellationError { throw CancellationError() }
            catch let GitHubRateLimitError.deferred(until) {
                observations.append(.init(id: repository.id, name: repository.fullName, outcome: .failed("GitHub rate limit; retry after \(until.formatted())")))
            }
            catch let WorkFetchError.httpStatus(code) {
                observations.append(.init(id: repository.id, name: repository.fullName, outcome: .failed("GitHub HTTP \(code)"), continuationUpdate: tracksOpenContinuation ? .advance(from: expected, to: nil) : .unchanged))
            } catch {
                observations.append(.init(id: repository.id, name: repository.fullName, outcome: .failed("Could not update from GitHub"), continuationUpdate: tracksOpenContinuation ? .advance(from: expected, to: nil) : .unchanged))
            }
        }
        try Task.checkCancellation()
        return ProjectRefreshResults(observations: observations, observedRepositories: observedRepositories)
    }
}
