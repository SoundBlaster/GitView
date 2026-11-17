import Foundation
import Testing
@testable import GitHubAPI

struct WorkDetailTests {
    @Test func mergesManualAndCrossReferenceWithoutCallingManualLinkAClosingReference() async throws {
        let client = GitHubWorkDetailClient { request in
            let body = try JSONSerialization.jsonObject(with: request.httpBody!) as! [String: Any]
            #expect((body["query"] as! String).contains("userLinkedOnly:true"))
            let json = #"{"data":{"node":{"__typename":"Issue","id":"I1","timelineItems":{"nodes":[{"__typename":"CrossReferencedEvent","willCloseTarget":true,"source":{"__typename":"PullRequest","id":"P1","number":4,"title":"Shared","url":"https://github.com/a/b/pull/4","state":"OPEN","repository":{"nameWithOwner":"a/b"}}}],"pageInfo":{"hasNextPage":false}},"closedByPullRequestsReferences":{"nodes":[{"id":"P1","number":4,"title":"Shared","url":"https://github.com/a/b/pull/4","state":"OPEN","repository":{"nameWithOwner":"a/b"}},{"id":"P2","number":5,"title":"Manual","url":"https://github.com/a/b/pull/5","state":"OPEN","repository":{"nameWithOwner":"a/b"}}],"pageInfo":{"hasNextPage":true}}}}}"#
            return (Data(json.utf8), HTTPURLResponse(url: request.url!, statusCode: 200, httpVersion: nil, headerFields: nil)!)
        }
        let details = try await client.load(token: "token", id: "I1", kind: .issue)
        let page = try #require(details.issueRelationships?.pullRequests)
        #expect(page.items.count == 2 && page.isComplete && page.manualLinksComplete == false)
        let shared = try #require(page.items.first { $0.id == "P1" })
        #expect(shared.crossReferenced == true && shared.manuallyLinked == true && shared.willCloseTarget)
        let manual = try #require(page.items.first { $0.id == "P2" })
        #expect(manual.crossReferenced == false && manual.manuallyLinked == true && !manual.willCloseTarget)
        let cached = try JSONDecoder().decode(GitHubWorkDetails.self, from: JSONEncoder().encode(details))
        #expect(cached.issueRelationships?.pullRequests?.items.count == 2)
    }
    @Test func issueCrossReferencesCombinePullRequestEvidenceWithoutInventingCoverage() async throws {
        let client = GitHubWorkDetailClient { request in
            let body = try JSONSerialization.jsonObject(with: request.httpBody!) as! [String: Any]
            #expect((body["query"] as! String).contains("CROSS_REFERENCED_EVENT"))
            let json = #"{"data":{"node":{"__typename":"Issue","id":"I1","timelineItems":{"nodes":[{"__typename":"CrossReferencedEvent","willCloseTarget":false,"source":{"__typename":"PullRequest","id":"P1","number":4,"title":"Change","url":"https://github.com/a/b/pull/4","state":"OPEN","repository":{"nameWithOwner":"a/b"}}},{"__typename":"CrossReferencedEvent","willCloseTarget":true,"source":{"__typename":"PullRequest","id":"P1","number":4,"title":"Change","url":"https://github.com/a/b/pull/4","state":"OPEN","repository":{"nameWithOwner":"a/b"}}},{"__typename":"CrossReferencedEvent","willCloseTarget":false,"source":{"__typename":"Issue"}},null],"pageInfo":{"hasNextPage":true}}}}}"#
            return (Data(json.utf8), HTTPURLResponse(url: request.url!, statusCode: 200, httpVersion: nil, headerFields: nil)!)
        }
        let details = try await client.load(token: "token", id: "I1", kind: .issue)
        let page = try #require(details.issueRelationships?.pullRequests)
        #expect(page.items.count == 1)
        #expect(page.items.first?.id == "P1" && page.items.first?.willCloseTarget == true)
        #expect(page.isComplete == false)
        let cached = try JSONDecoder().decode(GitHubWorkDetails.self, from: JSONEncoder().encode(details))
        #expect(cached.issueRelationships?.pullRequests?.items.first?.repository == "a/b")
    }
    @Test func issueRelationshipsPreserveDirectionCoverageAndCache() async throws {
        let client = GitHubWorkDetailClient { request in
            let body = try JSONSerialization.jsonObject(with: request.httpBody!) as! [String: Any]
            let query = body["query"] as! String
            #expect(query.contains("blockedBy(first:20)"))
            #expect(query.contains("blocking(first:20)"))
            let json = #"{"data":{"node":{"__typename":"Issue","id":"I1","body":"Problem","parent":{"id":"IP","number":3,"title":"Parent","url":"https://github.com/a/b/issues/3","state":"OPEN","repository":{"nameWithOwner":"a/b"}},"blockedBy":{"totalCount":2,"nodes":[{"id":"IB","number":4,"title":"Blocker","url":"https://github.com/a/b/issues/4","state":"OPEN","repository":{"nameWithOwner":"a/b"}}],"pageInfo":{"hasNextPage":true}},"blocking":{"totalCount":0,"nodes":[],"pageInfo":{"hasNextPage":false}},"subIssues":{"totalCount":1,"nodes":[null],"pageInfo":{"hasNextPage":false}}}}}"#
            return (Data(json.utf8), HTTPURLResponse(url: request.url!, statusCode: 200, httpVersion: nil, headerFields: nil)!)
        }
        let details = try await client.load(token: "token", id: "I1", kind: .issue)
        let links = try #require(details.issueRelationships)
        #expect(links.parent?.id == "IP" && links.parentObserved)
        #expect(links.blockedBy?.items.first?.id == "IB" && links.blockedBy?.isComplete == false)
        #expect(links.blocking?.total == 0 && links.blocking?.isComplete == true)
        #expect(links.subIssues?.items.isEmpty == true && links.subIssues?.isComplete == false)
        let cached = try JSONDecoder().decode(GitHubWorkDetails.self, from: JSONEncoder().encode(details))
        #expect(cached.issueRelationships?.blockedBy?.items.first?.repository == "a/b")
        let old = #"{"body":"Old","observedAt":0}"#
        #expect(try JSONDecoder().decode(GitHubWorkDetails.self, from: Data(old.utf8)).issueRelationships == nil)
    }
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
