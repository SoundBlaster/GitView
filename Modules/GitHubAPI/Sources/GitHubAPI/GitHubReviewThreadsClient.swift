import Foundation

public enum ReviewThreadsError: Error, Equatable {
    case invalidRequest
    case invalidResponse
    case httpStatus(Int)
    case graphQLFailure
    case revisionChanged
    case collectionChanged
}

/// Loads a bounded observation of a single PR's review threads at an expected head revision.
public struct GitHubReviewThreadsClient: Sendable {
    private let transport: GitHubDiscoveryClient.Transport
    public init(transport: @escaping GitHubDiscoveryClient.Transport = GitHubDiscoveryClient.send) { self.transport = transport }

    public func load(token: String, pullRequestID: String, expectedHead: String, maxPages: Int = 10) async throws -> GitHubReviewThreads {
        guard !token.isEmpty, !token.contains("\n"), !token.contains("\r"),
              !pullRequestID.isEmpty, !expectedHead.isEmpty, maxPages > 0 else { throw ReviewThreadsError.invalidRequest }
        var after: String?
        var cursors = Set<String>()
        var seen = Set<String>()
        var unresolved = 0
        var expectedTotal: Int?
        for _ in 0..<maxPages {
            try Task.checkCancellation()
            let query = """
            query Threads($id:ID!, $after:String) {
              node(id:$id) { ... on PullRequest {
                id headRefOid reviewThreads(first:100, after:$after) {
                  totalCount nodes { id isResolved } pageInfo { hasNextPage endCursor }
                }
              } }
            }
            """
            var request = URLRequest(url: URL(string: "https://api.github.com/graphql")!)
            request.httpMethod = "POST"
            request.setValue("Bearer " + token, forHTTPHeaderField: "Authorization")
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.httpBody = try JSONEncoder().encode(Query(query: query, variables: Variables(id: pullRequestID, after: after)))
            let (data, response) = try await transport(request)
            guard (200..<300).contains(response.statusCode) else { throw ReviewThreadsError.httpStatus(response.statusCode) }
            guard let envelope = try? JSONDecoder().decode(Envelope.self, from: data) else { throw ReviewThreadsError.invalidResponse }
            guard envelope.errors?.isEmpty != false else { throw ReviewThreadsError.graphQLFailure }
            guard let pr = envelope.data?.node, pr.id == pullRequestID, pr.reviewThreads.totalCount >= 0 else { throw ReviewThreadsError.invalidResponse }
            guard pr.headRefOid == expectedHead else { throw ReviewThreadsError.revisionChanged }
            if let expectedTotal, expectedTotal != pr.reviewThreads.totalCount { throw ReviewThreadsError.collectionChanged }
            expectedTotal = pr.reviewThreads.totalCount
            for node in pr.reviewThreads.nodes {
                guard let node, seen.insert(node.id).inserted else { throw ReviewThreadsError.collectionChanged }
                if !node.isResolved { unresolved += 1 }
            }
            if !pr.reviewThreads.pageInfo.hasNextPage {
                guard seen.count == pr.reviewThreads.totalCount else { throw ReviewThreadsError.collectionChanged }
                return GitHubReviewThreads(total: pr.reviewThreads.totalCount, observedUnresolved: unresolved, isComplete: true)
            }
            guard let cursor = pr.reviewThreads.pageInfo.endCursor, !cursor.isEmpty, cursors.insert(cursor).inserted else { throw ReviewThreadsError.invalidResponse }
            after = cursor
        }
        return GitHubReviewThreads(total: expectedTotal ?? 0, observedUnresolved: unresolved, isComplete: false)
    }

    private struct Query: Encodable { let query: String; let variables: Variables }
    private struct Variables: Encodable { let id: String; let after: String? }
    private struct Envelope: Decodable { let data: DataValue?; let errors: [GraphError]? }
    private struct GraphError: Decodable { let message: String }
    private struct DataValue: Decodable { let node: PullRequest? }
    private struct PullRequest: Decodable { let id: String; let headRefOid: String?; let reviewThreads: ThreadConnection }
    private struct ThreadConnection: Decodable { let totalCount: Int; let nodes: [Thread?]; let pageInfo: PageInfo }
    private struct Thread: Decodable { let id: String; let isResolved: Bool }
    private struct PageInfo: Decodable { let hasNextPage: Bool; let endCursor: String? }
}
