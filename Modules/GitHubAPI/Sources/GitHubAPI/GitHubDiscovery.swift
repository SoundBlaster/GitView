import Foundation

public enum DiscoveryFailure: Equatable, Sendable {
    case installationPage(Int)
    case repositoryPage(installationID: Int64, page: Int)
    case incompleteInstallations
    case incompleteRepositories(installationID: Int64)
    case rateLimited(until: Date)
}

public struct DiscoveryResult: Sendable {
    public let repositories: [GitHubRepository]
    public let failures: [DiscoveryFailure]
    public var isComplete: Bool { failures.isEmpty }
    public var rateLimitUntil: Date? {
        failures.compactMap { failure in
            if case .rateLimited(let date) = failure { return date }
            return nil
        }.max()
    }
}

/// Sequential requests reduce rate pressure and retain successful independent results.
public struct GitHubDiscovery: Sendable {
    private let client: GitHubDiscoveryClient
    public init(client: GitHubDiscoveryClient = GitHubDiscoveryClient()) { self.client = client }

    public func load(token: String) async throws -> DiscoveryResult {
        var installationIDs: [Int64] = []
        var seenInstallations: Set<Int64> = []
        var failures: [DiscoveryFailure] = []
        var page: Int? = 1
        var expectedInstallations = 0
        while let current = page {
            try Task.checkCancellation()
            do {
                let result = try await client.installations(token: token, page: current)
                expectedInstallations = max(expectedInstallations, result.totalCount)
                for item in result.items where seenInstallations.insert(item.id).inserted { installationIDs.append(item.id) }
                page = result.nextPage
            } catch is CancellationError { throw CancellationError() }
            catch let GitHubRateLimitError.deferred(until) { failures.append(.rateLimited(until: until)); break }
            catch { failures.append(.installationPage(current)); break }
        }
        if failures.isEmpty && seenInstallations.count < expectedInstallations { failures.append(.incompleteInstallations) }
        var repositories: [GitHubRepository] = []
        var seenRepositories: Set<Int64> = []
        if failures.contains(where: { if case .rateLimited = $0 { return true }; return false }) {
            return DiscoveryResult(repositories: repositories, failures: failures)
        }
        installations: for installation in installationIDs {
            var next: Int? = 1
            var expected = 0
            var seenInInstallation: Set<Int64> = []
            var failed = false
            while let current = next {
                try Task.checkCancellation()
                do {
                    let result = try await client.repositories(token: token, installationID: installation, page: current)
                    expected = max(expected, result.totalCount)
                    for item in result.items {
                        seenInInstallation.insert(item.id)
                        if seenRepositories.insert(item.id).inserted { repositories.append(item) }
                    }
                    next = result.nextPage
                } catch is CancellationError { throw CancellationError() }
                catch let GitHubRateLimitError.deferred(until) { failures.append(.rateLimited(until: until)); break installations }
                catch { failures.append(.repositoryPage(installationID: installation, page: current)); failed = true; break }
            }
            if !failed && seenInInstallation.count < expected { failures.append(.incompleteRepositories(installationID: installation)) }
        }
        return DiscoveryResult(repositories: repositories, failures: failures)
    }
}
