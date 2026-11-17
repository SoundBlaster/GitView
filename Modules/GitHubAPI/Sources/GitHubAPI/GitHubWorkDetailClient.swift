import Foundation

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
            ... on Issue { id body createdAt author { login } labels(first:30) { nodes { name } pageInfo { hasNextPage } } }
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
            commits: node.commits?.totalCount, observedAt: observedAt)
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
        enum CodingKeys: String, CodingKey { case typename = "__typename", id, body, createdAt, author, labels, headRefOid, headRefName, baseRefName, headRepository, baseRepository, additions, deletions, changedFiles, commits }
    }
    private struct Actor: Decodable { let login: String }
    private struct Labels: Decodable { let nodes: [Label?]; let pageInfo: PageInfo }
    private struct Label: Decodable { let name: String }
    private struct PageInfo: Decodable { let hasNextPage: Bool }
    private struct Repository: Decodable { let nameWithOwner: String }
    private struct Count: Decodable { let totalCount: Int }
}
