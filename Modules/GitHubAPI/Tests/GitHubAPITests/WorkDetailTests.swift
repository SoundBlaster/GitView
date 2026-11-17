import Foundation
import Testing
@testable import GitHubAPI

struct WorkDetailTests {
    @Test func loadsPullRequestDetailsWithoutConflatingForkRepositories() async throws {
        let client = GitHubWorkDetailClient { request in
            let json = ###"{"data":{"node":{"__typename":"PullRequest","id":"P1","body":"## Motivation\nFix it","createdAt":"2026-11-17T10:00:00Z","author":{"login":"alice"},"labels":{"nodes":[{"name":"bug"}],"pageInfo":{"hasNextPage":false}},"headRefOid":"abc","headRefName":"work","baseRefName":"main","baseRepository":{"nameWithOwner":"org/base"},"headRepository":{"nameWithOwner":"alice/fork"},"additions":12,"deletions":3,"changedFiles":2,"commits":{"totalCount":4}}}}"###
            return (Data(json.utf8), HTTPURLResponse(url: request.url!, statusCode: 200, httpVersion: nil, headerFields: nil)!)
        }
        let result = try await client.load(token: "token", id: "P1", kind: .pullRequest, expectedHead: "abc", observedAt: Date(timeIntervalSince1970: 200))
        #expect(result.body == "## Motivation\nFix it")
        #expect(result.author == "alice" && result.labels == ["bug"] && result.labelsComplete == true)
        #expect(result.baseRepository == "org/base" && result.headRepository == "alice/fork")
        #expect(result.additions == 12 && result.deletions == 3 && result.changedFiles == 2 && result.commits == 4)
    }

    @Test func rejectsDetailsForChangedPullRequestHead() async throws {
        let client = GitHubWorkDetailClient { request in
            let json = #"{"data":{"node":{"__typename":"PullRequest","id":"P1","body":"text","headRefOid":"new"}}}"#
            return (Data(json.utf8), HTTPURLResponse(url: request.url!, statusCode: 200, httpVersion: nil, headerFields: nil)!)
        }
        await #expect(throws: WorkDetailError.revisionChanged) {
            try await client.load(token: "token", id: "P1", kind: .pullRequest, expectedHead: "old")
        }
    }

    @Test func issueDetailsDoNotInventPullRequestFields() async throws {
        let client = GitHubWorkDetailClient { request in
            let json = #"{"data":{"node":{"__typename":"Issue","id":"I1","body":"Problem","author":null,"labels":{"nodes":[],"pageInfo":{"hasNextPage":false}}}}}"#
            return (Data(json.utf8), HTTPURLResponse(url: request.url!, statusCode: 200, httpVersion: nil, headerFields: nil)!)
        }
        let details = try await client.load(token: "token", id: "I1", kind: .issue)
        #expect(details.body == "Problem" && details.author == nil)
        #expect(details.labels == [] && details.labelsComplete == true)
        #expect(details.commits == nil && details.baseRepository == nil && details.additions == nil)
    }
}
