import Foundation

enum GitHubWorkFailureDescription {
    static func describe(_ error: Error) -> String {
        if case GitHubRateLimitError.deferred(let until) = error {
            return "GitHub rate limit; retry after \(until.formatted())"
        }
        if case WorkFetchError.httpStatus(let code) = error {
            switch code {
            case 401: return "GitHub HTTP 401: authentication was rejected."
            case 403: return "GitHub HTTP 403: request was forbidden. Check access and rate limits."
            case 404: return "GitHub HTTP 404: repository or requested resource was not found or is inaccessible."
            default: return "GitHub HTTP \(code)"
            }
        }
        if let error = error as? URLError {
            switch error.code {
            case .notConnectedToInternet, .networkConnectionLost: return "Network unavailable. Could not update from GitHub."
            case .timedOut: return "GitHub request timed out."
            default: break
            }
        }
        return "Could not update from GitHub"
    }
}

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
                observations.append(.init(id: repository.id, name: repository.fullName, outcome: .failed(GitHubWorkFailureDescription.describe(GitHubRateLimitError.deferred(until: until)))))
            }
            catch let WorkFetchError.httpStatus(code) {
                observations.append(.init(id: repository.id, name: repository.fullName, outcome: .failed(GitHubWorkFailureDescription.describe(WorkFetchError.httpStatus(code))), continuationUpdate: tracksOpenContinuation ? .advance(from: expected, to: nil) : .unchanged))
            } catch {
                observations.append(.init(id: repository.id, name: repository.fullName, outcome: .failed(GitHubWorkFailureDescription.describe(error)), continuationUpdate: tracksOpenContinuation ? .advance(from: expected, to: nil) : .unchanged))
            }
        }
        try Task.checkCancellation()
        return ProjectRefreshResults(observations: observations, observedRepositories: observedRepositories)
    }
}
