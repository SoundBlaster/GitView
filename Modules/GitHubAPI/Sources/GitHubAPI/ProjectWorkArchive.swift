import Foundation

public struct RepositoryWorkObservation: Codable, Sendable {
    public let id: Int64
    public let name: String
    public let items: [GitHubWorkItem]
    public let observedAt: Date?
    public let complete: Bool
    public let refreshProblem: String?
}

public struct RepositoryWorkRefresh: Sendable {
    public enum Outcome: Sendable {
        case received([GitHubWorkItem], complete: Bool)
        case failed(String)
    }
    public let id: Int64
    public let name: String
    public let outcome: Outcome
    public init(id: Int64, name: String, outcome: Outcome) { self.id = id; self.name = name; self.outcome = outcome }
}

/// Durable per-repository observations; legacy unscoped entries remain until a complete refresh.
public struct ProjectWorkArchive: Codable, Sendable {
    public var repositories: [RepositoryWorkObservation]
    public var legacyItems: [GitHubWorkItem]
    public var lastAttemptAt: Date?
    public init(repositories: [RepositoryWorkObservation] = [], legacyItems: [GitHubWorkItem] = [], lastAttemptAt: Date? = nil) {
        self.repositories = repositories; self.legacyItems = legacyItems; self.lastAttemptAt = lastAttemptAt
    }
    public var items: [GitHubWorkItem] { repositories.flatMap(\.items) + legacyItems }
    public var hasRefreshProblems: Bool { repositories.contains { $0.refreshProblem != nil } }
    public func coversRepositories(_ ids: Set<Int64>) -> Bool {
        legacyItems.isEmpty && Set(repositories.map(\.id)) == ids
    }

    public func applying(_ results: [RepositoryWorkRefresh], at date: Date) -> ProjectWorkArchive {
        let previous = Dictionary(repositories.map { ($0.id, $0) }, uniquingKeysWith: { first, _ in first })
        let updated = results.map { result -> RepositoryWorkObservation in
            let old = previous[result.id]
            switch result.outcome {
            case let .received(items, complete: true):
                return RepositoryWorkObservation(id: result.id, name: result.name, items: items, observedAt: date, complete: true, refreshProblem: nil)
            case let .received(items, complete: false):
                return RepositoryWorkObservation(id: result.id, name: result.name, items: old?.items ?? items,
                    observedAt: old?.observedAt ?? date, complete: old?.complete ?? false, refreshProblem: "Incomplete GitHub response")
            case let .failed(problem):
                return RepositoryWorkObservation(id: result.id, name: result.name, items: old?.items ?? [],
                    observedAt: old?.observedAt, complete: old?.complete ?? false, refreshProblem: problem)
            }
        }
        let allComplete = results.allSatisfy { result in
            if case .received(_, complete: true) = result.outcome { return true }
            return false
        }
        return ProjectWorkArchive(repositories: updated, legacyItems: allComplete ? [] : legacyItems, lastAttemptAt: date)
    }

    public static func decode(_ data: Data) throws -> ProjectWorkArchive {
        let decoder = JSONDecoder()
        if let archive = try? decoder.decode(ProjectWorkArchive.self, from: data) { return archive }
        return ProjectWorkArchive(legacyItems: try decoder.decode([GitHubWorkItem].self, from: data))
    }

    public mutating func updateThreadObservation(itemID: String, head: String, threads: GitHubReviewThreads, at date: Date) -> Bool {
        for index in repositories.indices {
            guard let itemIndex = repositories[index].items.firstIndex(where: { $0.id == itemID }),
                  let item = repositories[index].items[itemIndex].withReviewThreads(threads, forHead: head, observedAt: date) else { continue }
            let old = repositories[index]
            var items = old.items
            items[itemIndex] = item
            repositories[index] = RepositoryWorkObservation(id: old.id, name: old.name, items: items, observedAt: old.observedAt, complete: old.complete, refreshProblem: old.refreshProblem)
            return true
        }
        guard let index = legacyItems.firstIndex(where: { $0.id == itemID }),
              let item = legacyItems[index].withReviewThreads(threads, forHead: head, observedAt: date) else { return false }
        legacyItems[index] = item
        return true
    }
}
