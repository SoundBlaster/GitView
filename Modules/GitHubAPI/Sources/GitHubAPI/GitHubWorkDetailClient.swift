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
    public let observedAt: Date?
}

public enum GitHubIssueRelationKind: String, Hashable, Sendable {
    case blockedBy, blocking, subIssues
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
    public let observedAt: Date?
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

    public func replacingPullRequestReferences(_ references: GitHubPullRequestReferences) -> GitHubWorkDetails? {
        guard let relations = issueRelationships else { return nil }
        return GitHubWorkDetails(body: body, createdAt: createdAt, author: author, labels: labels, labelsComplete: labelsComplete,
            headBranch: headBranch, baseBranch: baseBranch, headRepository: headRepository, baseRepository: baseRepository,
            additions: additions, deletions: deletions, changedFiles: changedFiles, commits: commits,
            issueRelationships: GitHubIssueRelationships(parent: relations.parent, parentObserved: relations.parentObserved,
                blockedBy: relations.blockedBy, blocking: relations.blocking, subIssues: relations.subIssues, pullRequests: references),
            observedAt: observedAt)
    }

    public func replacingIssueRelation(_ page: GitHubIssueRelationPage, kind: GitHubIssueRelationKind) -> GitHubWorkDetails? {
        guard let relations = issueRelationships else { return nil }
        return GitHubWorkDetails(body: body, createdAt: createdAt, author: author, labels: labels, labelsComplete: labelsComplete,
            headBranch: headBranch, baseBranch: baseBranch, headRepository: headRepository, baseRepository: baseRepository,
            additions: additions, deletions: deletions, changedFiles: changedFiles, commits: commits,
            issueRelationships: GitHubIssueRelationships(parent: relations.parent, parentObserved: relations.parentObserved,
                blockedBy: kind == .blockedBy ? page : relations.blockedBy, blocking: kind == .blocking ? page : relations.blocking,
                subIssues: kind == .subIssues ? page : relations.subIssues, pullRequests: relations.pullRequests), observedAt: observedAt)
    }
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

    public func loadIssueRelation(token: String, id: String, kind: GitHubIssueRelationKind, maxPages: Int = 10) async throws -> GitHubIssueRelationPage {
        guard !id.isEmpty, !token.isEmpty, !token.contains("\n"), !token.contains("\r"), maxPages > 0 else { throw WorkDetailError.invalidRequest }
        let query = """
        query IssueRelation($id:ID!, $after:String) {
          node(id:$id) { __typename ... on Issue { id
            \(kind.rawValue)(first:50, after:$after) {
              totalCount nodes { id number title url state repository { nameWithOwner } } pageInfo { hasNextPage endCursor }
            }
          } }
        }
        """
        var after: String?, cursors = Set<String>(), seen = Set<String>()
        var items: [GitHubIssueReference] = []
        var initialTotal: Int?, currentTotal = 0, consistent = true, hasMore = true
        for _ in 0..<maxPages {
            try Task.checkCancellation()
            var request = URLRequest(url: URL(string: "https://api.github.com/graphql")!)
            request.httpMethod = "POST"
            request.setValue("Bearer " + token, forHTTPHeaderField: "Authorization")
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.httpBody = try JSONEncoder().encode(RelationQuery(query: query, variables: RelationVariables(id: id, after: after)))
            let (data, response) = try await transport(request)
            guard (200..<300).contains(response.statusCode) else { throw WorkDetailError.httpStatus(response.statusCode) }
            guard let envelope = try? JSONDecoder().decode(Envelope.self, from: data) else { throw WorkDetailError.invalidResponse }
            guard envelope.errors?.isEmpty != false else { throw WorkDetailError.graphQLFailure }
            guard let node = envelope.data?.node, node.id == id, node.typename == "Issue" else { throw WorkDetailError.invalidResponse }
            let connection: IssueConnection?
            switch kind { case .blockedBy: connection = node.blockedBy; case .blocking: connection = node.blocking; case .subIssues: connection = node.subIssues }
            guard let connection, connection.totalCount >= 0 else { throw WorkDetailError.invalidResponse }
            if let initialTotal { consistent = consistent && initialTotal == connection.totalCount } else { initialTotal = connection.totalCount }
            currentTotal = connection.totalCount
            for node in connection.nodes {
                guard let node else { consistent = false; continue }
                guard seen.insert(node.id).inserted else { consistent = false; continue }
                items.append(node.reference)
            }
            after = try nextCursor(connection.pageInfo, seen: &cursors)
            hasMore = after != nil
            if !hasMore { break }
        }
        return GitHubIssueRelationPage(items: items, total: currentTotal,
            isComplete: consistent && !hasMore && items.count == currentTotal, observedAt: .now)
    }

    public func loadIssuePullRequestReferences(token: String, id: String, maxPages: Int = 10) async throws -> GitHubPullRequestReferences {
        guard !id.isEmpty, !token.isEmpty, !token.contains("\n"), !token.contains("\r"), maxPages > 0 else { throw WorkDetailError.invalidRequest }
        let query = """
        query IssueLinks($id:ID!, $crossAfter:String, $manualAfter:String, $loadCross:Boolean!, $loadManual:Boolean!) {
          node(id:$id) { __typename ... on Issue { id
            timelineItems(first:50, after:$crossAfter, itemTypes:[CROSS_REFERENCED_EVENT]) @include(if:$loadCross) {
              nodes { __typename ... on CrossReferencedEvent { willCloseTarget source {
                __typename ... on PullRequest { id number title url state repository { nameWithOwner } }
              } } } pageInfo { hasNextPage endCursor }
            }
            closedByPullRequestsReferences(first:20, after:$manualAfter, includeClosedPrs:true, userLinkedOnly:true) @include(if:$loadManual) {
              nodes { id number title url state repository { nameWithOwner } } pageInfo { hasNextPage endCursor }
            }
          } }
        }
        """
        var crossAfter: String?, manualAfter: String?
        var loadCross = true, loadManual = true, crossValid = true
        var manualValid: Bool? = true
        var crossCursors = Set<String>(), manualCursors = Set<String>()
        var items: [GitHubPullRequestReference] = [], positions: [String: Int] = [:]
        for _ in 0..<maxPages {
            try Task.checkCancellation()
            var request = URLRequest(url: URL(string: "https://api.github.com/graphql")!)
            request.httpMethod = "POST"
            request.setValue("Bearer " + token, forHTTPHeaderField: "Authorization")
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.httpBody = try JSONEncoder().encode(LinkQuery(query: query, variables: LinkVariables(id: id, crossAfter: crossAfter,
                manualAfter: manualAfter, loadCross: loadCross, loadManual: loadManual)))
            let (data, response) = try await transport(request)
            guard (200..<300).contains(response.statusCode) else { throw WorkDetailError.httpStatus(response.statusCode) }
            guard let envelope = try? JSONDecoder().decode(Envelope.self, from: data) else { throw WorkDetailError.invalidResponse }
            guard envelope.errors?.isEmpty != false else { throw WorkDetailError.graphQLFailure }
            guard let node = envelope.data?.node, node.id == id, node.typename == "Issue" else { throw WorkDetailError.invalidResponse }
            if loadCross {
                guard let cross = node.timelineItems else { throw WorkDetailError.invalidResponse }
                crossValid = crossValid && cross.contentComplete
                crossAfter = try nextCursor(cross.pageInfo, seen: &crossCursors)
                loadCross = crossAfter != nil
            }
            if loadManual {
                if let manual = node.closedByPullRequestsReferences {
                    manualValid = (manualValid == true) && manual.nodes.allSatisfy { $0 != nil }
                    manualAfter = try nextCursor(manual.pageInfo, seen: &manualCursors)
                    loadManual = manualAfter != nil
                } else { manualValid = nil; loadManual = false }
            }
            for item in node.pullRequestReferences?.items ?? [] {
                if let index = positions[item.id] {
                    let old = items[index]
                    items[index] = GitHubPullRequestReference(id: item.id, number: item.number, title: item.title, url: item.url,
                        state: item.state, repository: item.repository, willCloseTarget: old.willCloseTarget || item.willCloseTarget,
                        crossReferenced: old.crossReferenced == true || item.crossReferenced == true,
                        manuallyLinked: old.manuallyLinked == true || item.manuallyLinked == true)
                } else { positions[item.id] = items.count; items.append(item) }
            }
            if !loadCross && !loadManual { break }
        }
        return GitHubPullRequestReferences(items: items, isComplete: crossValid && !loadCross,
            manualLinksComplete: manualValid.map { $0 && !loadManual }, observedAt: .now)
    }

    private func nextCursor(_ page: PageInfo, seen: inout Set<String>) throws -> String? {
        guard page.hasNextPage else { return nil }
        guard let cursor = page.endCursor, !cursor.isEmpty, seen.insert(cursor).inserted else { throw WorkDetailError.invalidResponse }
        return cursor
    }

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
    private struct LinkQuery: Encodable { let query: String; let variables: LinkVariables }
    private struct RelationQuery: Encodable { let query: String; let variables: RelationVariables }
    private struct RelationVariables: Encodable { let id: String; let after: String? }
    private struct LinkVariables: Encodable { let id: String; let crossAfter: String?; let manualAfter: String?; let loadCross: Bool; let loadManual: Bool }
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
            return .init(items: items, isComplete: cross?.isComplete ?? false, manualLinksComplete: manualComplete, observedAt: nil)
        }
    }
    private struct ManualPullRequests: Decodable { let nodes: [RelatedIssue?]; let pageInfo: PageInfo }
    private struct TimelineConnection: Decodable {
        let nodes: [CrossReference?]; let pageInfo: PageInfo
        var contentComplete: Bool {
            nodes.allSatisfy { event in
                guard let event, event.typename == "CrossReferencedEvent", let source = event.source else { return false }
                guard source.typename == "PullRequest" else { return true }
                return source.id != nil && source.number != nil && source.title != nil && source.url != nil && source.state != nil && source.repository != nil && event.willCloseTarget != nil
            }
        }
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
            return .init(items: items, isComplete: complete, manualLinksComplete: nil, observedAt: nil)
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
                         isComplete: totalCount >= 0 && !pageInfo.hasNextPage && items.count == totalCount && nodes.count == items.count, observedAt: nil)
        }
    }
    private struct Actor: Decodable { let login: String }
    private struct Labels: Decodable { let nodes: [Label?]; let pageInfo: PageInfo }
    private struct Label: Decodable { let name: String }
    private struct PageInfo: Decodable { let hasNextPage: Bool; let endCursor: String? }
    private struct Repository: Decodable { let nameWithOwner: String }
    private struct Count: Decodable { let totalCount: Int }
}
