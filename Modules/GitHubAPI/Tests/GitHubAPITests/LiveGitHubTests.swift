import Foundation
import Testing
@testable import GitHubAPI

/// Opt-in read-only probe. CI and ordinary unit tests do not require credentials or network.
struct LiveGitHubTests {
    @Test(.enabled(if: ProcessInfo.processInfo.environment["GITGRID_LIVE_PROBE"] == "1"))
    func decodesRepositoryWorkAndPullRequestDetails() async throws {
        let environment = ProcessInfo.processInfo.environment
        let token = try #require(environment["GITGRID_LIVE_TOKEN"])
        let rawID = try #require(environment["GITGRID_LIVE_REPOSITORY_ID"])
        let repositoryID = try #require(Int64(rawID))
        let nodeID = try #require(environment["GITGRID_LIVE_REPOSITORY_NODE_ID"])
        let page = try await GitHubWorkClient().firstPage(token: token, repositoryID: repositoryID,
                                                          fullName: "SoundBlaster/GitView", nodeID: nodeID)
        #expect(page.observedRepository?.id == repositoryID)
        let pull = try #require(page.items.first { $0.kind == .pullRequest && $0.headRevision != nil })
        let head = try #require(pull.headRevision)
        let details = try await GitHubWorkDetailClient().load(token: token, id: pull.id, kind: .pullRequest, expectedHead: head)
        #expect(details.observedAt <= .now)
        let threads = try await GitHubReviewThreadsClient().load(token: token, pullRequestID: pull.id, expectedHead: head, maxPages: 1)
        #expect(threads.total >= threads.observedUnresolved)
    }

    @Test(.enabled(if: ProcessInfo.processInfo.environment["GITGRID_LIVE_PROBE"] == "1"))
    func decodesIssueDetailsAndRelations() async throws {
        let environment = ProcessInfo.processInfo.environment
        let token = try #require(environment["GITGRID_LIVE_TOKEN"])
        let issueID = try #require(environment["GITGRID_LIVE_ISSUE_ID"])
        let client = GitHubWorkDetailClient()
        let detail = try await client.load(token: token, id: issueID, kind: .issue, expectedHead: nil)
        #expect(detail.observedAt <= .now)
        for kind in [GitHubIssueRelationKind.blockedBy, .blocking, .subIssues] {
            let page = try await client.loadIssueRelation(token: token, id: issueID, kind: kind, maxPages: 1)
            #expect(page.total >= page.items.count)
        }
        let links = try await client.loadIssuePullRequestReferences(token: token, id: issueID, maxPages: 1)
        #expect(Set(links.items.map(\.id)).count == links.items.count)
    }
}
