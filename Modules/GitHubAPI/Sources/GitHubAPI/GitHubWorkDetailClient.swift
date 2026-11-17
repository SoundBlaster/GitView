import Foundation

public struct GitHubIssueReference: Codable, Identifiable, Sendable {
    public let id: String
    public let number: Int
    public let title: String
    public let url: URL
    public let state: String
    public let repository: String
}

public struct GitHubIssueRelationPage: Codable, Sendable {
    public let items: [GitHubIssueReference]
    public let total: Int
    public let isComplete: Bool
}

public struct GitHubPullRequestReference: Codable, Identifiable, Sendable {
    public let id: String
    public let number: Int
    public let title: String
    public let url: URL
    public let state: String
    public let repository: String
    public let willCloseTarget: Bool
    /// Nil on older cached cross-reference records.
    public let crossReferenced: Bool?
    public let manuallyLinked: Bool?
}

public struct GitHubPullRequestReferences: Codable, Sendable {
    public let items: [GitHubPullRequestReference]
    public let isComplete: Bool
    public let manualLinksComplete: Bool?
}

public struct GitHubIssueRelationships: Codable, Sendable {
    public let parent: GitHubIssueReference?
    public let parentObserved: Bool
    public let blockedBy: GitHubIssueRelationPage?
    public let blocking: GitHubIssueRelationPage?
    public let subIssues: GitHubIssueRelationPage?
    public let pullRequests: GitHubPullRequestReferences?
}

public struct GitHubWorkDetails: Codable, Sendable {
    public let body: String?
    public let createdAt: Date?
    public let author: String?
    public let labels: [String]?
    public let labelsComplete: Bool?
    public let headBranch: String?
    public let baseBranch: String?
    public let headRepository: String?
    public let baseRepository: String?
    public let additions: Int?
    public let deletions: Int?
    public let changedFiles: Int?
    public let commits: Int?
    public let issueRelationships: GitHubIssueRelationships?
    public let observedAt: Date
}

public enum WorkDetailError: Error, Equatable {
    case invalidRequest
    case invalidResponse
    case httpStatus(Int)
    case graphQLFailure
    case revisionChanged
}

public struct GitHubWorkDetailClient: Sendable {
    private let transport: GitHubDiscoveryClient.Transport
    public init(transport: @escaping GitHubDiscoveryClient.Transport = GitHubDiscoveryClient.send) { self.transport = transport }

    public func load(token: String, id: String, kind: GitHubWorkKind, expectedHead: String? = nil, observedAt: Date = .now) async throws -> GitHubWorkDetails {
        guard !token.isEmpty, !token.contains("\n"), !token.contains("\r"), !id.isEmpty,
              kind != .pullRequest || (expectedHead?.isEmpty == false) else { throw WorkDetailError.invalidRequest }
        let query = """
        query Detail($id:ID!) {
          node(id:$id) {
            __typename
            ... on Issue {
              id body createdAt author { login } labels(first:30) { nodes { name } pageInfo { hasNextPage } }
              parent { id number title url state repository { nameWithOwner } }
              blockedBy(first:20) { totalCount nodes { id number title url state repository { nameWithOwner } } pageInfo { hasNextPage } }
              blocking(first:20) { totalCount nodes { id number title url state repository { nameWithOwner } } pageInfo { hasNextPage } }
              subIssues(first:20) { totalCount nodes { id number title url state repository { nameWithOwner } } pageInfo { hasNextPage } }
              timelineItems(first:50, itemTypes:[CROSS_REFERENCED_EVENT]) {
                nodes { __typename ... on CrossReferencedEvent {
                  willCloseTarget source { __typename ... on PullRequest { id number title url state repository { nameWithOwner } } }
                } }
                pageInfo { hasNextPage }
              }
              closedByPullRequestsReferences(first:20, includeClosedPrs:true, userLinkedOnly:true) {
                nodes { id number title url state repository { nameWithOwner } } pageInfo { hasNextPage }
              }
            }
            ... on PullRequest {
              id body createdAt author { login } labels(first:30) { nodes { name } pageInfo { hasNextPage } }
              headRefOid headRefName baseRefName baseRepository { nameWithOwner } headRepository { nameWithOwner }
              additions deletions changedFiles commits(first:1) { totalCount }
            }
          }
        }
        """
        var request = URLRequest(url: URL(string: "https://api.github.com/graphql")!)
        request.httpMethod = "POST"
        request.setValue("Bearer " + token, forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try JSONEncoder().encode(Query(query: query, variables: Variables(id: id)))
        let (data, response) = try await transport(request)
        guard (200..<300).contains(response.statusCode) else { throw WorkDetailError.httpStatus(response.statusCode) }
        let decoder = JSONDecoder(); decoder.dateDecodingStrategy = .iso8601
        guard let envelope = try? decoder.decode(Envelope.self, from: data) else { throw WorkDetailError.invalidResponse }
        guard envelope.errors?.isEmpty != false else { throw WorkDetailError.graphQLFailure }
        let typename = kind == .pullRequest ? "PullRequest" : "Issue"
        guard let node = envelope.data?.node, node.id == id, node.typename == typename else { throw WorkDetailError.invalidResponse }
        if kind == .pullRequest && node.headRefOid != expectedHead { throw WorkDetailError.revisionChanged }
        return GitHubWorkDetails(body: node.body, createdAt: node.createdAt, author: node.author?.login,
            labels: node.labels?.nodes.compactMap { $0?.name },
            labelsComplete: node.labels.map { !$0.pageInfo.hasNextPage && $0.nodes.allSatisfy { $0 != nil } },
            headBranch: node.headRefName, baseBranch: node.baseRefName,
            headRepository: node.headRepository?.nameWithOwner, baseRepository: node.baseRepository?.nameWithOwner,
            additions: node.additions, deletions: node.deletions, changedFiles: node.changedFiles,
            commits: node.commits?.totalCount,
            issueRelationships: kind == .issue ? GitHubIssueRelationships(parent: node.parent?.reference,
                parentObserved: node.blockedBy != nil && node.blocking != nil && node.subIssues != nil,
                blockedBy: node.blockedBy?.page, blocking: node.blocking?.page, subIssues: node.subIssues?.page,
                pullRequests: node.pullRequestReferences) : nil,
            observedAt: observedAt)
    }

    private struct Query: Encodable { let query: String; let variables: Variables }
    private struct Variables: Encodable { let id: String }
    private struct Envelope: Decodable { let data: DataValue?; let errors: [GraphError]? }
    private struct GraphError: Decodable { let message: String }
    private struct DataValue: Decodable { let node: Node? }
    private struct Node: Decodable {
        let typename: String; let id: String; let body: String?; let createdAt: Date?; let author: Actor?
        let labels: Labels?; let headRefOid: String?; let headRefName: String?; let baseRefName: String?
        let headRepository: Repository?; let baseRepository: Repository?
        let additions: Int?; let deletions: Int?; let changedFiles: Int?; let commits: Count?
        let parent: RelatedIssue?; let blockedBy: IssueConnection?; let blocking: IssueConnection?; let subIssues: IssueConnection?
        let timelineItems: TimelineConnection?
        let closedByPullRequestsReferences: ManualPullRequests?
        enum CodingKeys: String, CodingKey { case typename = "__typename", id, body, createdAt, author, labels, headRefOid, headRefName, baseRefName, headRepository, baseRepository, additions, deletions, changedFiles, commits, parent, blockedBy, blocking, subIssues, timelineItems, closedByPullRequestsReferences }
        var pullRequestReferences: GitHubPullRequestReferences? {
            guard timelineItems != nil || closedByPullRequestsReferences != nil else { return nil }
            let cross = timelineItems?.references
            var items = cross?.items ?? []
            var positions = Dictionary(uniqueKeysWithValues: items.enumerated().map { ($0.element.id, $0.offset) })
            var manualComplete = closedByPullRequestsReferences.map { !$0.pageInfo.hasNextPage && $0.nodes.allSatisfy { $0 != nil } }
            for entry in closedByPullRequestsReferences?.nodes ?? [] {
                guard let entry else { continue }
                let index = positions[entry.id]
                let old = index.map { items[$0] }
                let value = GitHubPullRequestReference(id: entry.id, number: entry.number, title: entry.title, url: entry.url,
                    state: entry.state, repository: entry.repository.nameWithOwner, willCloseTarget: old?.willCloseTarget ?? false,
                    crossReferenced: old != nil, manuallyLinked: true)
                if let index { items[index] = value } else { positions[entry.id] = items.count; items.append(value) }
            }
            if let connection = closedByPullRequestsReferences, Set(connection.nodes.compactMap { $0?.id }).count != connection.nodes.count { manualComplete = false }
            return .init(items: items, isComplete: cross?.isComplete ?? false, manualLinksComplete: manualComplete)
        }
    }
    private struct ManualPullRequests: Decodable { let nodes: [RelatedIssue?]; let pageInfo: PageInfo }
    private struct TimelineConnection: Decodable {
        let nodes: [CrossReference?]; let pageInfo: PageInfo
        var references: GitHubPullRequestReferences {
            var positions: [String: Int] = [:]
            var items: [GitHubPullRequestReference] = []
            var complete = !pageInfo.hasNextPage
            for event in nodes {
                guard let event, event.typename == "CrossReferencedEvent", let source = event.source else { complete = false; continue }
                guard source.typename == "PullRequest" else { continue }
                guard let id = source.id, let number = source.number, let title = source.title, let url = source.url,
                      let state = source.state, let repository = source.repository?.nameWithOwner,
                      let closes = event.willCloseTarget else { complete = false; continue }
                let index = positions[id]
                let combined = closes || index.map { items[$0].willCloseTarget } == true
                let reference = GitHubPullRequestReference(id: id, number: number, title: title, url: url, state: state,
                                                          repository: repository, willCloseTarget: combined, crossReferenced: true, manuallyLinked: nil)
                if let index { items[index] = reference } else { positions[id] = items.count; items.append(reference) }
            }
            return .init(items: items, isComplete: complete, manualLinksComplete: nil)
        }
    }
    private struct CrossReference: Decodable {
        let typename: String; let willCloseTarget: Bool?; let source: ReferenceSource?
        enum CodingKeys: String, CodingKey { case typename = "__typename", willCloseTarget, source }
    }
    private struct ReferenceSource: Decodable {
        let typename: String; let id: String?; let number: Int?; let title: String?; let url: URL?; let state: String?; let repository: Repository?
        enum CodingKeys: String, CodingKey { case typename = "__typename", id, number, title, url, state, repository }
    }
    private struct RelatedIssue: Decodable {
        let id: String; let number: Int; let title: String; let url: URL; let state: String; let repository: Repository
        var reference: GitHubIssueReference { .init(id: id, number: number, title: title, url: url, state: state, repository: repository.nameWithOwner) }
    }
    private struct IssueConnection: Decodable {
        let totalCount: Int; let nodes: [RelatedIssue?]; let pageInfo: PageInfo
        var page: GitHubIssueRelationPage {
            var seen = Set<String>()
            let items = nodes.compactMap { $0?.reference }.filter { seen.insert($0.id).inserted }
            return .init(items: items, total: totalCount,
                         isComplete: totalCount >= 0 && !pageInfo.hasNextPage && items.count == totalCount && nodes.count == items.count)
        }
    }
    private struct Actor: Decodable { let login: String }
    private struct Labels: Decodable { let nodes: [Label?]; let pageInfo: PageInfo }
    private struct Label: Decodable { let name: String }
    private struct PageInfo: Decodable { let hasNextPage: Bool }
    private struct Repository: Decodable { let nameWithOwner: String }
    private struct Count: Decodable { let totalCount: Int }
}
