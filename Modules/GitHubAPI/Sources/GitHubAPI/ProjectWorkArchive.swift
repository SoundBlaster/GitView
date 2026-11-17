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
    public let observedAt: Date?
    public init(id: Int64, name: String, outcome: Outcome, observedAt: Date? = nil) {
        self.id = id; self.name = name; self.outcome = outcome; self.observedAt = observedAt
    }
}

/// Durable per-repository observations; legacy unscoped entries remain until a complete refresh.
public struct ProjectWorkArchive: Codable, Sendable {
    public enum RemovalError: Error, Equatable { case unattributedData }
    public var repositories: [RepositoryWorkObservation]
    public var legacyItems: [GitHubWorkItem]
    public var lastAttemptAt: Date?
    public var detachedRepositories: [RepositoryWorkObservation]?
    public var retainedLegacyItems: [GitHubWorkItem]?
    public var completeScopeIDs: [Int64]?
    public init(repositories: [RepositoryWorkObservation] = [], legacyItems: [GitHubWorkItem] = [], lastAttemptAt: Date? = nil,
                detachedRepositories: [RepositoryWorkObservation]? = nil, retainedLegacyItems: [GitHubWorkItem]? = nil,
                completeScopeIDs: [Int64]? = nil) {
        self.repositories = repositories; self.legacyItems = legacyItems; self.lastAttemptAt = lastAttemptAt
        self.detachedRepositories = detachedRepositories; self.retainedLegacyItems = retainedLegacyItems
        self.completeScopeIDs = completeScopeIDs
    }
    public var items: [GitHubWorkItem] { repositories.flatMap(\.items) + legacyItems }
    /// Unambiguous source names for observed objects; conflicting ownership remains unavailable.
    public var repositoryNamesByWorkID: [String: String] {
        repositoryObservationsByWorkID.mapValues(\.name)
    }
    /// Associates an object with source status only when exactly one repository owns it.
    public var repositoryObservationsByWorkID: [String: RepositoryWorkObservation] {
        var owners: [String: RepositoryWorkObservation] = [:]
        var ambiguous = Set<String>()
        for repository in repositories {
            for item in repository.items {
                if let owner = owners[item.id], owner.id != repository.id { ambiguous.insert(item.id) }
                else { owners[item.id] = repository }
            }
        }
        for id in ambiguous { owners.removeValue(forKey: id) }
        return owners
    }
    public var hasRefreshProblems: Bool { repositories.contains { $0.refreshProblem != nil } }
    public func coversRepositories(_ ids: Set<Int64>) -> Bool {
        legacyItems.isEmpty && Set(repositories.map(\.id)) == ids
    }
    public func hasCompleteObservation(for ids: Set<Int64>) -> Bool {
        coversRepositories(ids) && completeScopeIDs.map { Set($0) == ids } == true
    }

    /// Removes only observations attributable to this repository, including detached ones.
    public func forgetting(repositoryID: Int64) throws -> ProjectWorkArchive {
        guard legacyItems.isEmpty, retainedLegacyItems?.isEmpty ?? true else { throw RemovalError.unattributedData }
        return ProjectWorkArchive(repositories: repositories.filter { $0.id != repositoryID }, legacyItems: [],
            lastAttemptAt: lastAttemptAt, detachedRepositories: detachedRepositories?.filter { $0.id != repositoryID },
            retainedLegacyItems: retainedLegacyItems, completeScopeIDs: nil)
    }

    public func applying(_ results: [RepositoryWorkRefresh], at date: Date) -> ProjectWorkArchive {
        let previous = Dictionary((repositories + (detachedRepositories ?? [])).map { ($0.id, $0) }, uniquingKeysWith: { first, _ in first })
        let updated = results.map { result -> RepositoryWorkObservation in
            let old = previous[result.id]
            switch result.outcome {
            case let .received(items, complete: true):
                let oldItems = Dictionary(((old?.items ?? []) + legacyItems).map { ($0.id, $0) }, uniquingKeysWith: { first, _ in first })
                let enriched = items.map { item -> GitHubWorkItem in
                    guard let oldItem = oldItems[item.id], let details = oldItem.details else { return item }
                    return item.withDetails(details, forHead: oldItem.headRevision) ?? item
                }
                return RepositoryWorkObservation(id: result.id, name: result.name, items: enriched, observedAt: result.observedAt ?? date, complete: true, refreshProblem: nil)
            case let .received(items, complete: false):
                var merged = old?.items ?? []
                var indices = Dictionary(merged.enumerated().map { ($0.element.id, $0.offset) }, uniquingKeysWith: { first, _ in first })
                for item in items {
                    if let index = indices[item.id] {
                        let previous = merged[index]
                        guard item.updatedAt >= previous.updatedAt else { continue }
                        if let details = previous.details {
                            merged[index] = item.withDetails(details, forHead: previous.headRevision) ?? item
                        } else { merged[index] = item }
                    } else {
                        indices[item.id] = merged.count
                        merged.append(item)
                    }
                }
                return RepositoryWorkObservation(id: result.id, name: result.name, items: merged,
                    observedAt: old?.observedAt ?? result.observedAt ?? date, complete: old?.complete ?? false, refreshProblem: "Incomplete GitHub response")
            case let .failed(problem):
                return RepositoryWorkObservation(id: result.id, name: result.name, items: old?.items ?? [],
                    observedAt: old?.observedAt, complete: old?.complete ?? false, refreshProblem: problem)
            }
        }
        let allComplete = results.allSatisfy { result in
            if case .received(_, complete: true) = result.outcome { return true }
            return false
        }
        let selected = Set(results.map(\.id))
        let detached = previous.values.filter { !selected.contains($0.id) }.sorted { $0.id < $1.id }
        let retainedLegacy = (retainedLegacyItems ?? []) + (allComplete ? legacyItems : [])
        return ProjectWorkArchive(repositories: updated, legacyItems: allComplete ? [] : legacyItems, lastAttemptAt: date,
            detachedRepositories: detached, retainedLegacyItems: retainedLegacy,
            completeScopeIDs: allComplete ? selected.sorted() : completeScopeIDs)
    }

    /// Updates only the supplied repositories without discarding unvisited observations.
    public func applyingPartial(_ results: [RepositoryWorkRefresh], in scope: Set<Int64>, at date: Date) -> ProjectWorkArchive {
        let scoped = restricting(to: scope)
        let refreshed = scoped.applying(results.filter { scope.contains($0.id) }, at: date)
        let detached = refreshed.detachedRepositories ?? []
        let preserved = detached.filter { scope.contains($0.id) }
        return ProjectWorkArchive(repositories: (refreshed.repositories + preserved).sorted { $0.id < $1.id },
            legacyItems: scoped.legacyItems, lastAttemptAt: date,
            detachedRepositories: detached.filter { !scope.contains($0.id) },
            retainedLegacyItems: scoped.retainedLegacyItems, completeScopeIDs: scoped.completeScopeIDs)
    }

    public func restricting(to ids: Set<Int64>) -> ProjectWorkArchive {
        let all = Dictionary((repositories + (detachedRepositories ?? [])).map { ($0.id, $0) }, uniquingKeysWith: { first, _ in first })
        let selected = all.values.filter { ids.contains($0.id) }.sorted { $0.id < $1.id }
        let retained = all.values.filter { !ids.contains($0.id) }.sorted { $0.id < $1.id }
        return ProjectWorkArchive(repositories: selected, legacyItems: legacyItems, lastAttemptAt: lastAttemptAt,
            detachedRepositories: retained, retainedLegacyItems: retainedLegacyItems, completeScopeIDs: completeScopeIDs)
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

    public mutating func updateDetails(itemID: String, head: String?, details: GitHubWorkDetails) -> Bool {
        for index in repositories.indices {
            guard let itemIndex = repositories[index].items.firstIndex(where: { $0.id == itemID }),
                  let item = repositories[index].items[itemIndex].withDetails(details, forHead: head) else { continue }
            let old = repositories[index]
            var items = old.items
            items[itemIndex] = item
            repositories[index] = RepositoryWorkObservation(id: old.id, name: old.name, items: items, observedAt: old.observedAt, complete: old.complete, refreshProblem: old.refreshProblem)
            return true
        }
        guard let index = legacyItems.firstIndex(where: { $0.id == itemID }),
              let item = legacyItems[index].withDetails(details, forHead: head) else { return false }
        legacyItems[index] = item
        return true
    }
}
