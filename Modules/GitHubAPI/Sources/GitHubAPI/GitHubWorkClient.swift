import Foundation

public enum GitHubWorkKind: String, Codable, Sendable { case issue, pullRequest }

public struct GitHubCheckCounts: Codable, Sendable {
    public let total: Int
    public let red: Int
    public let yellow: Int
    public let green: Int
    public let other: Int
    public let isComplete: Bool
}

public struct GitHubReviewThreads: Codable, Sendable {
    public let total: Int
    public let observedUnresolved: Int
    public let isComplete: Bool
}

public struct GitHubWorkItem: Codable, Identifiable, Sendable {
    public let id: String
    public let number: Int
    public let title: String
    public let url: URL
    public let state: String
    public let updatedAt: Date
    public let closedAt: Date?
    public let closureReason: String?
    public let mergedAt: Date?
    public let isDraft: Bool
    public let kind: GitHubWorkKind
    public let headRevision: String?
    public let checkStatus: String?
    public let reviewDecision: String?
    public let checkCounts: GitHubCheckCounts?
    public let reviewThreads: GitHubReviewThreads?
    public let reviewRequestCount: Int?
    public let reviewThreadObservedAt: Date?
    public let details: GitHubWorkDetails?

    public func withReviewThreads(_ threads: GitHubReviewThreads, forHead head: String, observedAt: Date) -> GitHubWorkItem? {
        guard kind == .pullRequest, headRevision == head,
              reviewThreadObservedAt.map({ $0 <= observedAt }) ?? true else { return nil }
        return GitHubWorkItem(id: id, number: number, title: title, url: url, state: state, updatedAt: updatedAt,
            closedAt: closedAt, closureReason: closureReason, mergedAt: mergedAt, isDraft: isDraft, kind: kind, headRevision: headRevision,
            checkStatus: checkStatus, reviewDecision: reviewDecision, checkCounts: checkCounts,
            reviewThreads: threads, reviewRequestCount: reviewRequestCount, reviewThreadObservedAt: observedAt, details: details)
    }

    public func withDetails(_ details: GitHubWorkDetails, forHead head: String?) -> GitHubWorkItem? {
        guard kind != .pullRequest || (head != nil && headRevision == head),
              self.details.map({ $0.observedAt <= details.observedAt }) ?? true else { return nil }
        return GitHubWorkItem(id: id, number: number, title: title, url: url, state: state, updatedAt: updatedAt,
            closedAt: closedAt, closureReason: closureReason, mergedAt: mergedAt, isDraft: isDraft, kind: kind, headRevision: headRevision,
            checkStatus: checkStatus, reviewDecision: reviewDecision, checkCounts: checkCounts,
            reviewThreads: reviewThreads, reviewRequestCount: reviewRequestCount, reviewThreadObservedAt: reviewThreadObservedAt, details: details)
    }
}

public struct GitHubWorkPage: Sendable {
    public let items: [GitHubWorkItem]
    public let isIncomplete: Bool
    public let observedRepository: GitHubRepository?
    public let refreshProblem: String?
    let issueCursor: String?
    let pullCursor: String?

    init(items: [GitHubWorkItem], isIncomplete: Bool, observedRepository: GitHubRepository?,
         issueCursor: String?, pullCursor: String?, refreshProblem: String? = nil) {
        self.items = items; self.isIncomplete = isIncomplete; self.observedRepository = observedRepository
        self.issueCursor = issueCursor; self.pullCursor = pullCursor; self.refreshProblem = refreshProblem
    }
}

public enum WorkFetchError: Error, Equatable {
    case invalidRequest
    case httpStatus(Int)
    case graphQLFailure
    case invalidResponse
    case repositoryIdentityMismatch
}

/// Fetches a bounded initial view; `isIncomplete` must remain visible to callers.
public struct GitHubWorkClient: Sendable {
    private let transport: GitHubDiscoveryClient.Transport
    public init(transport: @escaping GitHubDiscoveryClient.Transport = GitHubDiscoveryClient.send) { self.transport = transport }

    public func firstPage(token: String, repositoryID: Int64, fullName: String, nodeID: String? = nil) async throws -> GitHubWorkPage {
        try await page(token: token, repositoryID: repositoryID, fullName: fullName, nodeID: nodeID, issueAfter: nil, pullAfter: nil, loadIssues: true, loadPulls: true)
    }

    /// Limits requests per repository; truncated results are explicitly incomplete.
    public func load(token: String, repositoryID: Int64, fullName: String, nodeID: String? = nil, maxRequests: Int = 20) async throws -> GitHubWorkPage {
        guard maxRequests > 0 else { throw WorkFetchError.invalidRequest }
        var issueAfter: String?, pullAfter: String?
        var loadIssues = true, loadPulls = true
        var items: [GitHubWorkItem] = []
        var seen: Set<String> = []
        var issueCursors: Set<String> = [], pullCursors: Set<String> = []
        var observedRepository: GitHubRepository?
        var pagesLoaded = 0
        var priorityItems: [GitHubWorkItem] = []
        if maxRequests > 1 {
            let priority = try await page(token: token, repositoryID: repositoryID, fullName: fullName, nodeID: nodeID,
                                          issueAfter: nil, pullAfter: nil, loadIssues: true, loadPulls: true, openOnly: true)
            priorityItems = priority.items
            observedRepository = priority.observedRepository
            pagesLoaded = 1
        }
        for _ in pagesLoaded..<maxRequests {
            try Task.checkCancellation()
            let result: GitHubWorkPage
            do {
                result = try await page(token: token, repositoryID: repositoryID, fullName: fullName, nodeID: nodeID, issueAfter: issueAfter, pullAfter: pullAfter, loadIssues: loadIssues, loadPulls: loadPulls)
            } catch is CancellationError { throw CancellationError() }
            catch WorkFetchError.repositoryIdentityMismatch { throw WorkFetchError.repositoryIdentityMismatch }
            catch {
                try Task.checkCancellation()
                guard pagesLoaded > 0 else { throw error }
                let problem: String
                if case GitHubRateLimitError.deferred(let until) = error {
                    problem = "GitHub rate limit; retry after \(until.formatted())"
                } else if case WorkFetchError.httpStatus(let code) = error {
                    problem = "GitHub HTTP \(code)"
                } else { problem = "Could not load all GitHub pages" }
                return GitHubWorkPage(items: merging(priorityItems, with: items), isIncomplete: true, observedRepository: observedRepository,
                                      issueCursor: issueAfter, pullCursor: pullAfter, refreshProblem: problem)
            }
            pagesLoaded += 1
            observedRepository = result.observedRepository ?? observedRepository
            for item in result.items where seen.insert(item.id).inserted { items.append(item) }
            issueAfter = result.issueCursor
            pullAfter = result.pullCursor
            if let issueAfter, !issueCursors.insert(issueAfter).inserted { throw WorkFetchError.invalidResponse }
            if let pullAfter, !pullCursors.insert(pullAfter).inserted { throw WorkFetchError.invalidResponse }
            loadIssues = issueAfter != nil
            loadPulls = pullAfter != nil
            if !loadIssues && !loadPulls { return GitHubWorkPage(items: items, isIncomplete: false, observedRepository: observedRepository, issueCursor: nil, pullCursor: nil) }
        }
        return GitHubWorkPage(items: merging(priorityItems, with: items), isIncomplete: true, observedRepository: observedRepository, issueCursor: issueAfter, pullCursor: pullAfter)
    }

    private func merging(_ priority: [GitHubWorkItem], with later: [GitHubWorkItem]) -> [GitHubWorkItem] {
        var result: [GitHubWorkItem] = []
        var indices: [String: Int] = [:]
        for item in priority + later {
            if let index = indices[item.id] {
                if item.updatedAt >= result[index].updatedAt { result[index] = item }
            } else { indices[item.id] = result.count; result.append(item) }
        }
        return result
    }

    private func page(token: String, repositoryID: Int64, fullName: String, nodeID: String?, issueAfter: String?, pullAfter: String?, loadIssues: Bool, loadPulls: Bool, openOnly: Bool = false) async throws -> GitHubWorkPage {
        let names = fullName.split(separator: "/", omittingEmptySubsequences: false)
        guard names.count == 2, names.allSatisfy({ !$0.isEmpty }), repositoryID > 0,
              !token.isEmpty, !token.contains("\n"), !token.contains("\r") else { throw WorkFetchError.invalidRequest }
        guard nodeID.map({ !$0.isEmpty }) ?? true else { throw WorkFetchError.invalidRequest }
        let locationArguments = nodeID == nil ? "$owner:String!, $name:String!" : "$nodeID:ID!"
        let selector = nodeID == nil ? "repository(owner:$owner, name:$name)" : "node(id:$nodeID) { ... on Repository"
        let selectorClose = nodeID == nil ? "}" : "} }"
        let issueStates = openOnly ? "[OPEN]" : "[OPEN,CLOSED]"
        let pullStates = openOnly ? "[OPEN]" : "[OPEN,CLOSED,MERGED]"
        let query = """
        query Work(\(locationArguments), $issueAfter:String, $pullAfter:String, $loadIssues:Boolean!, $loadPulls:Boolean!) {
          \(selector) {
            id fullDatabaseId nameWithOwner isPrivate
            issues(first:100, after:$issueAfter, states:\(issueStates), orderBy:{field:UPDATED_AT,direction:DESC}) @include(if:$loadIssues) {
              nodes { id number title url state updatedAt closedAt stateReason }
              pageInfo { hasNextPage endCursor }
            }
            pullRequests(first:100, after:$pullAfter, states:\(pullStates), orderBy:{field:UPDATED_AT,direction:DESC}) @include(if:$loadPulls) {
              nodes {
                id number title url state updatedAt closedAt mergedAt isDraft headRefOid reviewDecision
                statusCheckRollup { state contexts(first:1) { totalCount checkRunCountsByState { state count } statusContextCountsByState { state count } } }
                reviewRequests(first:1) { totalCount }
                reviewThreads(first:20) { totalCount nodes { isResolved } pageInfo { hasNextPage } }
              }
              pageInfo { hasNextPage endCursor }
            }
          \(selectorClose)
        }
        """
        var request = URLRequest(url: URL(string: "https://api.github.com/graphql")!)
        request.httpMethod = "POST"
        request.setValue("Bearer " + token, forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("application/vnd.github+json", forHTTPHeaderField: "Accept")
        request.httpBody = try JSONEncoder().encode(Query(query: query, variables: Variables(owner: nodeID == nil ? String(names[0]) : nil, name: nodeID == nil ? String(names[1]) : nil, nodeID: nodeID, issueAfter: issueAfter, pullAfter: pullAfter, loadIssues: loadIssues, loadPulls: loadPulls)))
        let (data, response) = try await transport(request)
        guard (200..<300).contains(response.statusCode) else { throw WorkFetchError.httpStatus(response.statusCode) }
        let decoder = JSONDecoder(); decoder.dateDecodingStrategy = .iso8601
        guard let envelope = try? decoder.decode(Envelope.self, from: data) else { throw WorkFetchError.invalidResponse }
        guard envelope.errors?.isEmpty != false else { throw WorkFetchError.graphQLFailure }
        guard let repository = nodeID == nil ? envelope.data?.repository : envelope.data?.node else { throw WorkFetchError.invalidResponse }
        let numericID = repository.fullDatabaseId.flatMap(Int64.init) ?? repository.databaseId
        guard numericID == repositoryID else { throw WorkFetchError.repositoryIdentityMismatch }
        guard (!loadIssues || repository.issues != nil), (!loadPulls || repository.pullRequests != nil) else { throw WorkFetchError.invalidResponse }
        let issues = repository.issues?.nodes.map { $0.item(kind: .issue) } ?? []
        let pulls = repository.pullRequests?.nodes.map { $0.item(kind: .pullRequest) } ?? []
        let issueCursor = try cursor(repository.issues?.pageInfo)
        let pullCursor = try cursor(repository.pullRequests?.pageInfo)
        let observed: GitHubRepository?
        if let name = repository.nameWithOwner, let isPrivate = repository.isPrivate, let sourceNodeID = repository.id {
            observed = GitHubRepository(id: repositoryID, fullName: name, isPrivate: isPrivate, nodeID: sourceNodeID)
        } else { observed = nil }
        return GitHubWorkPage(items: issues + pulls, isIncomplete: issueCursor != nil || pullCursor != nil, observedRepository: observed, issueCursor: issueCursor, pullCursor: pullCursor)
    }

    private func cursor(_ info: PageInfo?) throws -> String? {
        guard let info, info.hasNextPage else { return nil }
        guard let cursor = info.endCursor, !cursor.isEmpty else { throw WorkFetchError.invalidResponse }
        return cursor
    }

    private struct Query: Encodable { let query: String; let variables: Variables }
    private struct Variables: Encodable { let owner: String?; let name: String?; let nodeID: String?; let issueAfter: String?; let pullAfter: String?; let loadIssues: Bool; let loadPulls: Bool }
    private struct Envelope: Decodable { let data: DataValue?; let errors: [GraphError]? }
    private struct GraphError: Decodable { let message: String }
    private struct DataValue: Decodable { let repository: Repository?; let node: Repository? }
    private struct Repository: Decodable { let id: String?; let databaseId: Int64?; let fullDatabaseId: String?; let nameWithOwner: String?; let isPrivate: Bool?; let issues: Connection?; let pullRequests: Connection? }
    private struct Connection: Decodable { let nodes: [Node]; let pageInfo: PageInfo }
    private struct PageInfo: Decodable { let hasNextPage: Bool; let endCursor: String? }
    private struct Node: Decodable {
        let id: String; let number: Int; let title: String; let url: URL; let state: String
        let updatedAt: Date; let closedAt: Date?; let stateReason: String?; let mergedAt: Date?; let isDraft: Bool?
        let headRefOid: String?; let reviewDecision: String?; let statusCheckRollup: CheckRollup?
        let reviewThreads: ThreadConnection?; let reviewRequests: CountConnection?
        func item(kind: GitHubWorkKind) -> GitHubWorkItem {
            GitHubWorkItem(id: id, number: number, title: title, url: url, state: state, updatedAt: updatedAt, closedAt: closedAt, closureReason: stateReason, mergedAt: mergedAt, isDraft: isDraft ?? false, kind: kind, headRevision: headRefOid, checkStatus: statusCheckRollup?.state, reviewDecision: reviewDecision, checkCounts: statusCheckRollup?.contexts?.counts, reviewThreads: reviewThreads?.summary, reviewRequestCount: reviewRequests?.totalCount, reviewThreadObservedAt: reviewThreads == nil ? nil : .now, details: nil)
        }
    }
    private struct CheckRollup: Decodable { let state: String; let contexts: CheckContexts? }
    private struct StateCount: Decodable { let state: String; let count: Int }
    private struct CheckContexts: Decodable {
        let totalCount: Int
        let checkRunCountsByState: [StateCount]?
        let statusContextCountsByState: [StateCount]?
        var counts: GitHubCheckCounts? {
            guard totalCount >= 0 else { return nil }
            var red = 0, yellow = 0, green = 0, other = 0
            let entries = (checkRunCountsByState ?? []) + (statusContextCountsByState ?? [])
            guard entries.allSatisfy({ $0.count >= 0 }) else { return nil }
            for entry in entries {
                switch entry.state {
                case "FAILURE", "ERROR", "STARTUP_FAILURE", "TIMED_OUT": red += entry.count
                case "PENDING", "EXPECTED", "QUEUED", "IN_PROGRESS", "WAITING": yellow += entry.count
                case "SUCCESS": green += entry.count
                default: other += entry.count
                }
            }
            let complete = checkRunCountsByState != nil && statusContextCountsByState != nil && red + yellow + green + other == totalCount
            return GitHubCheckCounts(total: totalCount, red: red, yellow: yellow, green: green, other: other, isComplete: complete)
        }
    }
    private struct CountConnection: Decodable { let totalCount: Int }
    private struct ThreadNode: Decodable { let isResolved: Bool }
    private struct ThreadConnection: Decodable {
        let totalCount: Int; let nodes: [ThreadNode?]; let pageInfo: PageInfo
        var summary: GitHubReviewThreads? {
            guard totalCount >= 0 else { return nil }
            let observed = nodes.compactMap { $0 }
            return GitHubReviewThreads(total: totalCount, observedUnresolved: observed.filter { !$0.isResolved }.count,
                isComplete: !pageInfo.hasNextPage && observed.count == totalCount)
        }
    }
}
