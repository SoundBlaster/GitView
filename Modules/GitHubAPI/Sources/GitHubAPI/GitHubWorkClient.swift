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

    public func withReviewThreads(_ threads: GitHubReviewThreads, forHead head: String, observedAt: Date) -> GitHubWorkItem? {
        guard kind == .pullRequest, headRevision == head,
              reviewThreadObservedAt.map({ $0 <= observedAt }) ?? true else { return nil }
        return GitHubWorkItem(id: id, number: number, title: title, url: url, state: state, updatedAt: updatedAt,
            closedAt: closedAt, mergedAt: mergedAt, isDraft: isDraft, kind: kind, headRevision: headRevision,
            checkStatus: checkStatus, reviewDecision: reviewDecision, checkCounts: checkCounts,
            reviewThreads: threads, reviewRequestCount: reviewRequestCount, reviewThreadObservedAt: observedAt)
    }
}

public struct GitHubWorkPage: Sendable {
    public let items: [GitHubWorkItem]
    public let isIncomplete: Bool
    let issueCursor: String?
    let pullCursor: String?
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

    public func firstPage(token: String, repositoryID: Int64, fullName: String) async throws -> GitHubWorkPage {
        try await page(token: token, repositoryID: repositoryID, fullName: fullName, issueAfter: nil, pullAfter: nil, loadIssues: true, loadPulls: true)
    }

    /// Limits requests per repository; truncated results are explicitly incomplete.
    public func load(token: String, repositoryID: Int64, fullName: String, maxRequests: Int = 20) async throws -> GitHubWorkPage {
        guard maxRequests > 0 else { throw WorkFetchError.invalidRequest }
        var issueAfter: String?, pullAfter: String?
        var loadIssues = true, loadPulls = true
        var items: [GitHubWorkItem] = []
        var seen: Set<String> = []
        var issueCursors: Set<String> = [], pullCursors: Set<String> = []
        for _ in 0..<maxRequests {
            try Task.checkCancellation()
            let result = try await page(token: token, repositoryID: repositoryID, fullName: fullName, issueAfter: issueAfter, pullAfter: pullAfter, loadIssues: loadIssues, loadPulls: loadPulls)
            for item in result.items where seen.insert(item.id).inserted { items.append(item) }
            issueAfter = result.issueCursor
            pullAfter = result.pullCursor
            if let issueAfter, !issueCursors.insert(issueAfter).inserted { throw WorkFetchError.invalidResponse }
            if let pullAfter, !pullCursors.insert(pullAfter).inserted { throw WorkFetchError.invalidResponse }
            loadIssues = issueAfter != nil
            loadPulls = pullAfter != nil
            if !loadIssues && !loadPulls { return GitHubWorkPage(items: items, isIncomplete: false, issueCursor: nil, pullCursor: nil) }
        }
        return GitHubWorkPage(items: items, isIncomplete: true, issueCursor: issueAfter, pullCursor: pullAfter)
    }

    private func page(token: String, repositoryID: Int64, fullName: String, issueAfter: String?, pullAfter: String?, loadIssues: Bool, loadPulls: Bool) async throws -> GitHubWorkPage {
        let names = fullName.split(separator: "/", omittingEmptySubsequences: false)
        guard names.count == 2, names.allSatisfy({ !$0.isEmpty }), repositoryID > 0,
              !token.isEmpty, !token.contains("\n"), !token.contains("\r") else { throw WorkFetchError.invalidRequest }
        let query = """
        query Work($owner:String!, $name:String!, $issueAfter:String, $pullAfter:String, $loadIssues:Boolean!, $loadPulls:Boolean!) {
          repository(owner:$owner, name:$name) {
            databaseId
            issues(first:100, after:$issueAfter, orderBy:{field:UPDATED_AT,direction:DESC}) @include(if:$loadIssues) {
              nodes { id number title url state updatedAt closedAt }
              pageInfo { hasNextPage endCursor }
            }
            pullRequests(first:100, after:$pullAfter, orderBy:{field:UPDATED_AT,direction:DESC}) @include(if:$loadPulls) {
              nodes {
                id number title url state updatedAt closedAt mergedAt isDraft headRefOid reviewDecision
                statusCheckRollup { state contexts(first:1) { totalCount checkRunCountsByState { state count } statusContextCountsByState { state count } } }
                reviewRequests(first:1) { totalCount }
                reviewThreads(first:20) { totalCount nodes { isResolved } pageInfo { hasNextPage } }
              }
              pageInfo { hasNextPage endCursor }
            }
          }
        }
        """
        var request = URLRequest(url: URL(string: "https://api.github.com/graphql")!)
        request.httpMethod = "POST"
        request.setValue("Bearer " + token, forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("application/vnd.github+json", forHTTPHeaderField: "Accept")
        request.httpBody = try JSONEncoder().encode(Query(query: query, variables: Variables(owner: String(names[0]), name: String(names[1]), issueAfter: issueAfter, pullAfter: pullAfter, loadIssues: loadIssues, loadPulls: loadPulls)))
        let (data, response) = try await transport(request)
        guard (200..<300).contains(response.statusCode) else { throw WorkFetchError.httpStatus(response.statusCode) }
        let decoder = JSONDecoder(); decoder.dateDecodingStrategy = .iso8601
        guard let envelope = try? decoder.decode(Envelope.self, from: data) else { throw WorkFetchError.invalidResponse }
        guard envelope.errors?.isEmpty != false else { throw WorkFetchError.graphQLFailure }
        guard let repository = envelope.data?.repository else { throw WorkFetchError.invalidResponse }
        guard repository.databaseId == repositoryID else { throw WorkFetchError.repositoryIdentityMismatch }
        guard (!loadIssues || repository.issues != nil), (!loadPulls || repository.pullRequests != nil) else { throw WorkFetchError.invalidResponse }
        let issues = repository.issues?.nodes.map { $0.item(kind: .issue) } ?? []
        let pulls = repository.pullRequests?.nodes.map { $0.item(kind: .pullRequest) } ?? []
        let issueCursor = try cursor(repository.issues?.pageInfo)
        let pullCursor = try cursor(repository.pullRequests?.pageInfo)
        return GitHubWorkPage(items: issues + pulls, isIncomplete: issueCursor != nil || pullCursor != nil, issueCursor: issueCursor, pullCursor: pullCursor)
    }

    private func cursor(_ info: PageInfo?) throws -> String? {
        guard let info, info.hasNextPage else { return nil }
        guard let cursor = info.endCursor, !cursor.isEmpty else { throw WorkFetchError.invalidResponse }
        return cursor
    }

    private struct Query: Encodable { let query: String; let variables: Variables }
    private struct Variables: Encodable { let owner: String; let name: String; let issueAfter: String?; let pullAfter: String?; let loadIssues: Bool; let loadPulls: Bool }
    private struct Envelope: Decodable { let data: DataValue?; let errors: [GraphError]? }
    private struct GraphError: Decodable { let message: String }
    private struct DataValue: Decodable { let repository: Repository? }
    private struct Repository: Decodable { let databaseId: Int64?; let issues: Connection?; let pullRequests: Connection? }
    private struct Connection: Decodable { let nodes: [Node]; let pageInfo: PageInfo }
    private struct PageInfo: Decodable { let hasNextPage: Bool; let endCursor: String? }
    private struct Node: Decodable {
        let id: String; let number: Int; let title: String; let url: URL; let state: String
        let updatedAt: Date; let closedAt: Date?; let mergedAt: Date?; let isDraft: Bool?
        let headRefOid: String?; let reviewDecision: String?; let statusCheckRollup: CheckRollup?
        let reviewThreads: ThreadConnection?; let reviewRequests: CountConnection?
        func item(kind: GitHubWorkKind) -> GitHubWorkItem {
            GitHubWorkItem(id: id, number: number, title: title, url: url, state: state, updatedAt: updatedAt, closedAt: closedAt, mergedAt: mergedAt, isDraft: isDraft ?? false, kind: kind, headRevision: headRefOid, checkStatus: statusCheckRollup?.state, reviewDecision: reviewDecision, checkCounts: statusCheckRollup?.contexts?.counts, reviewThreads: reviewThreads?.summary, reviewRequestCount: reviewRequests?.totalCount, reviewThreadObservedAt: reviewThreads == nil ? nil : .now)
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
