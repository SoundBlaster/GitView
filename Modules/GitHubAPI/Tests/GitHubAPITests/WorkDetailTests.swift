import Foundation
import Testing
@testable import GitHubAPI

struct WorkDetailTests {
    @Test func closedSubIssueCountRequiresCompleteKnownStates() {
        let open = GitHubIssueReference(id: "I1", number: 1, title: "Open", url: URL(string: "https://github.com/a/b/issues/1")!, state: "OPEN", repository: "a/b")
        let closed = GitHubIssueReference(id: "I2", number: 2, title: "Closed", url: URL(string: "https://github.com/a/b/issues/2")!, state: "CLOSED", repository: "a/b")
        let unknown = GitHubIssueReference(id: "I3", number: 3, title: "Unknown", url: URL(string: "https://github.com/a/b/issues/3")!, state: "FUTURE_STATE", repository: "a/b")
        let complete = GitHubIssueRelationPage(items: [open, closed], total: 2, isComplete: true, observedAt: nil)
        #expect(complete.closedCount == 1)
        #expect(GitHubIssueRelationPage(items: [closed], total: 2, isComplete: false, observedAt: nil).closedCount == nil)
        #expect(GitHubIssueRelationPage(items: [closed, unknown], total: 2, isComplete: true, observedAt: nil).closedCount == nil)
        #expect(GitHubIssueRelationPage(items: [], total: 0, isComplete: true, observedAt: nil).closedCount == 0)
        #expect(GitHubIssueRelationPage(items: [closed], total: 2, isComplete: true, observedAt: nil).closedCount == nil)
    }
    @Test func issueContextSeparatesCountsAndPartialAssignees() async throws {
        let client = GitHubWorkDetailClient { request in
            let json = #"{"data":{"node":{"__typename":"Issue","id":"I1","repository":{"nameWithOwner":"a/b"},"issueType":{"name":"Bug"},"assignees":{"totalCount":2,"nodes":[{"login":"alice"}],"pageInfo":{"hasNextPage":true}},"milestone":{"title":"First release"},"participants":{"totalCount":7},"comments":{"totalCount":4,"nodes":[{"createdAt":"2026-11-17T10:00:00Z"}]}}}}"#
            return (Data(json.utf8), HTTPURLResponse(url: request.url!, statusCode: 200, httpVersion: nil, headerFields: nil)!)
        }
        let details = try await client.load(token: "token", id: "I1", kind: .issue)
        let context = try #require(details.issueContext)
        #expect(context.repository == "a/b" && context.type == "Bug")
        #expect(context.assignees == ["alice"] && context.assigneesTotal == 2 && context.assigneesComplete == false)
        #expect(context.milestone == "First release")
        #expect(context.commentCount == 4 && context.participantCount == 7 && context.lastCommentAt != nil)
        let restored = try JSONDecoder().decode(GitHubWorkDetails.self, from: JSONEncoder().encode(details))
        #expect(restored.issueContext?.assignees == ["alice"])
        let old = #"{"body":"Old","observedAt":0}"#
        #expect(try JSONDecoder().decode(GitHubWorkDetails.self, from: Data(old.utf8)).issueContext == nil)
    }
    @Test func pagesIssueDependenciesAndDetectsChangingCounts() async throws {
        let client = GitHubWorkDetailClient { request in
            let body = try JSONSerialization.jsonObject(with: request.httpBody!) as! [String: Any]
            let vars = body["variables"] as! [String: Any]
            let second = vars["after"] as? String == "next"
            let json: String
            if second {
                json = #"{"data":{"node":{"__typename":"Issue","id":"I1","blockedBy":{"totalCount":2,"nodes":[{"id":"I3","number":3,"title":"Second","url":"https://github.com/a/b/issues/3","state":"OPEN","repository":{"nameWithOwner":"a/b"}}],"pageInfo":{"hasNextPage":false}}}}}"#
            } else {
                #expect((body["query"] as! String).contains("blockedBy(first:50"))
                json = #"{"data":{"node":{"__typename":"Issue","id":"I1","blockedBy":{"totalCount":2,"nodes":[{"id":"I2","number":2,"title":"First","url":"https://github.com/a/b/issues/2","state":"OPEN","repository":{"nameWithOwner":"a/b"}}],"pageInfo":{"hasNextPage":true,"endCursor":"next"}}}}}"#
            }
            return (Data(json.utf8), HTTPURLResponse(url: request.url!, statusCode: 200, httpVersion: nil, headerFields: nil)!)
        }
        let result = try await client.loadIssueRelation(token: "token", id: "I1", kind: .blockedBy)
        #expect(result.isComplete && result.total == 2 && result.items.map(\.id) == ["I2", "I3"] && result.observedAt != nil)
        let limited = try await client.loadIssueRelation(token: "token", id: "I1", kind: .blockedBy, maxPages: 1)
        #expect(!limited.isComplete && limited.items.count == 1)
    }

    @Test func changingIssueRelationCountDoesNotProduceCompleteResult() async throws {
        let client = GitHubWorkDetailClient { request in
            let vars = try JSONSerialization.jsonObject(with: request.httpBody!) as! [String: Any]
            let second = (vars["variables"] as! [String: Any])["after"] as? String == "next"
            let json = second
                ? #"{"data":{"node":{"__typename":"Issue","id":"I1","subIssues":{"totalCount":1,"nodes":[],"pageInfo":{"hasNextPage":false}}}}}"#
                : #"{"data":{"node":{"__typename":"Issue","id":"I1","subIssues":{"totalCount":2,"nodes":[],"pageInfo":{"hasNextPage":true,"endCursor":"next"}}}}}"#
            return (Data(json.utf8), HTTPURLResponse(url: request.url!, statusCode: 200, httpVersion: nil, headerFields: nil)!)
        }
        let result = try await client.loadIssueRelation(token: "token", id: "I1", kind: .subIssues)
        #expect(!result.isComplete && result.total == 1)
    }
    @Test func pagesIssueLinksIndependentlyAndCombinesEvidence() async throws {
        let client = GitHubWorkDetailClient { request in
            let body = try JSONSerialization.jsonObject(with: request.httpBody!) as! [String: Any]
            let vars = body["variables"] as! [String: Any]
            let json: String
            if vars["crossAfter"] as? String == "next" {
                #expect(vars["loadManual"] as? Bool == false)
                json = #"{"data":{"node":{"__typename":"Issue","id":"I1","timelineItems":{"nodes":[{"__typename":"CrossReferencedEvent","willCloseTarget":true,"source":{"__typename":"PullRequest","id":"P1","number":1,"title":"Shared","url":"https://github.com/a/b/pull/1","state":"OPEN","repository":{"nameWithOwner":"a/b"}}}],"pageInfo":{"hasNextPage":false}}}}}"#
            } else {
                json = #"{"data":{"node":{"__typename":"Issue","id":"I1","timelineItems":{"nodes":[],"pageInfo":{"hasNextPage":true,"endCursor":"next"}},"closedByPullRequestsReferences":{"nodes":[{"id":"P1","number":1,"title":"Shared","url":"https://github.com/a/b/pull/1","state":"OPEN","repository":{"nameWithOwner":"a/b"}}],"pageInfo":{"hasNextPage":false}}}}}"#
            }
            return (Data(json.utf8), HTTPURLResponse(url: request.url!, statusCode: 200, httpVersion: nil, headerFields: nil)!)
        }
        let page = try await client.loadIssuePullRequestReferences(token: "token", id: "I1")
        #expect(page.isComplete && page.manualLinksComplete == true && page.items.count == 1)
        #expect(page.items[0].crossReferenced == true && page.items[0].manuallyLinked == true && page.items[0].willCloseTarget)
    }

    @Test func rejectsMissingPaginationCursor() async throws {
        let client = GitHubWorkDetailClient { request in
            let json = #"{"data":{"node":{"__typename":"Issue","id":"I1","timelineItems":{"nodes":[],"pageInfo":{"hasNextPage":true}},"closedByPullRequestsReferences":{"nodes":[],"pageInfo":{"hasNextPage":false}}}}}"#
            return (Data(json.utf8), HTTPURLResponse(url: request.url!, statusCode: 200, httpVersion: nil, headerFields: nil)!)
        }
        await #expect(throws: WorkDetailError.invalidResponse) { try await client.loadIssuePullRequestReferences(token: "token", id: "I1") }
    }
    @Test func boundedLinkPaginationReportsPartialAndRejectsRepeatedCursor() async throws {
        let client = GitHubWorkDetailClient { request in
            let json = #"{"data":{"node":{"__typename":"Issue","id":"I1","timelineItems":{"nodes":[],"pageInfo":{"hasNextPage":true,"endCursor":"same"}},"closedByPullRequestsReferences":{"nodes":[],"pageInfo":{"hasNextPage":false}}}}}"#
            return (Data(json.utf8), HTTPURLResponse(url: request.url!, statusCode: 200, httpVersion: nil, headerFields: nil)!)
        }
        let partial = try await client.loadIssuePullRequestReferences(token: "token", id: "I1", maxPages: 1)
        #expect(!partial.isComplete && partial.manualLinksComplete == true && partial.observedAt != nil)
        await #expect(throws: WorkDetailError.invalidResponse) {
            try await client.loadIssuePullRequestReferences(token: "token", id: "I1", maxPages: 3)
        }
    }
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
