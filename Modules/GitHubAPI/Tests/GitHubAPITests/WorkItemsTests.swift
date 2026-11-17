import Foundation
import Testing
@testable import GitHubAPI

struct WorkItemsTests {
    @Test func looksUpRepositoryByNodeAndPreserves64BitIdentity() async throws {
        let client = GitHubWorkClient { request in
            let body = try JSONSerialization.jsonObject(with: request.httpBody!) as! [String: Any]
            let query = body["query"] as! String
            let variables = body["variables"] as! [String: Any]
            #expect(query.contains("node(id:$nodeID)"))
            #expect(query.contains("fullDatabaseId"))
            #expect(variables["nodeID"] as? String == "R_node")
            let json = #"{"data":{"node":{"id":"R_node","fullDatabaseId":"3000000001","nameWithOwner":"new/name","isPrivate":true,"issues":{"nodes":[],"pageInfo":{"hasNextPage":false}},"pullRequests":{"nodes":[],"pageInfo":{"hasNextPage":false}}}}}"#
            return (Data(json.utf8), HTTPURLResponse(url: request.url!, statusCode: 200, httpVersion: nil, headerFields: nil)!)
        }
        let result = try await client.firstPage(token: "token", repositoryID: 3000000001, fullName: "old/name", nodeID: "R_node")
        #expect(result.observedRepository?.fullName == "new/name")
        #expect(result.observedRepository?.id == 3000000001)
    }

    @Test func nodeLookupCannotTransferWorkToDifferentNumericIdentity() async throws {
        let client = GitHubWorkClient { request in
            let json = #"{"data":{"node":{"id":"R_node","fullDatabaseId":"99","nameWithOwner":"old/name","isPrivate":false,"issues":{"nodes":[],"pageInfo":{"hasNextPage":false}},"pullRequests":{"nodes":[],"pageInfo":{"hasNextPage":false}}}}}"#
            return (Data(json.utf8), HTTPURLResponse(url: request.url!, statusCode: 200, httpVersion: nil, headerFields: nil)!)
        }
        await #expect(throws: WorkFetchError.repositoryIdentityMismatch) {
            try await client.firstPage(token: "token", repositoryID: 42, fullName: "old/name", nodeID: "R_node")
        }
    }
    @Test func distinguishesPartialThreadsAndSpecialChecks() async throws {
        let client = GitHubWorkClient { request in
            let body = try JSONSerialization.jsonObject(with: request.httpBody!) as! [String: Any]
            let query = body["query"] as! String
            #expect(query.contains("checkRunCountsByState"))
            #expect(query.contains("reviewThreads"))
            let json = #"{"data":{"repository":{"databaseId":42,"issues":{"nodes":[],"pageInfo":{"hasNextPage":false}},"pullRequests":{"nodes":[{"id":"P1","number":2,"title":"Fix","url":"https://github.com/a/b/pull/2","state":"OPEN","closedAt":null,"mergedAt":null,"updatedAt":"2026-11-17T10:00:00Z","isDraft":false,"headRefOid":"abc","statusCheckRollup":{"state":"FAILURE","contexts":{"totalCount":6,"checkRunCountsByState":[{"state":"SUCCESS","count":2},{"state":"FAILURE","count":1},{"state":"SKIPPED","count":1}],"statusContextCountsByState":[{"state":"PENDING","count":2}]}},"reviewThreads":{"totalCount":3,"nodes":[{"isResolved":false},{"isResolved":true}],"pageInfo":{"hasNextPage":true}},"reviewRequests":{"totalCount":1}}],"pageInfo":{"hasNextPage":false}}}}}"#
            return (Data(json.utf8), HTTPURLResponse(url: request.url!, statusCode: 200, httpVersion: nil, headerFields: nil)!)
        }
        let item = try #require(await client.firstPage(token: "token", repositoryID: 42, fullName: "a/b").items.first)
        let checks = try #require(item.checkCounts)
        #expect(checks.total == 6)
        #expect(checks.red == 1 && checks.yellow == 2 && checks.green == 2 && checks.other == 1)
        let threads = try #require(item.reviewThreads)
        #expect(threads.total == 3 && threads.observedUnresolved == 1 && !threads.isComplete)
        #expect(item.reviewRequestCount == 1)
        let restored = try JSONDecoder().decode(GitHubWorkItem.self, from: JSONEncoder().encode(item))
        #expect(restored.reviewThreads?.isComplete == false)
        let observedAt = Date().addingTimeInterval(60)
        let enriched = try #require(item.withReviewThreads(threads, forHead: "abc", observedAt: observedAt))
        #expect(enriched.reviewThreadObservedAt == observedAt)
        #expect(item.withReviewThreads(threads, forHead: "different", observedAt: observedAt) == nil)
        #expect(item.withReviewThreads(threads, forHead: "abc", observedAt: .distantPast) == nil)
    }

    @Test func doesNotPresentMissingCheckBucketsAsComplete() async throws {
        let client = GitHubWorkClient { request in
            let json = #"{"data":{"repository":{"databaseId":42,"issues":{"nodes":[],"pageInfo":{"hasNextPage":false}},"pullRequests":{"nodes":[{"id":"P1","number":2,"title":"Fix","url":"https://github.com/a/b/pull/2","state":"OPEN","updatedAt":"2026-11-17T10:00:00Z","isDraft":false,"headRefOid":"abc","statusCheckRollup":{"state":"SUCCESS","contexts":{"totalCount":1,"checkRunCountsByState":[{"state":"SUCCESS","count":1}],"statusContextCountsByState":null}},"reviewThreads":{"totalCount":0,"nodes":[],"pageInfo":{"hasNextPage":false}}}],"pageInfo":{"hasNextPage":false}}}}}"#
            return (Data(json.utf8), HTTPURLResponse(url: request.url!, statusCode: 200, httpVersion: nil, headerFields: nil)!)
        }
        let item = try #require(await client.firstPage(token: "token", repositoryID: 42, fullName: "a/b").items.first)
        #expect(item.checkCounts?.isComplete == false)
        #expect(item.reviewThreads?.total == 0)
        #expect(item.reviewThreads?.isComplete == true)
        #expect(item.reviewThreads?.observedUnresolved == 0)
    }
    @Test func oldCachedItemWithoutSignalsRemainsReadable() throws {
        let json = #"{"id":"P1","number":2,"title":"Fix","url":"https://github.com/a/b/pull/2","state":"OPEN","updatedAt":0,"isDraft":false,"kind":"pullRequest"}"#
        let item = try JSONDecoder().decode(GitHubWorkItem.self, from: Data(json.utf8))
        #expect(item.checkStatus == nil)
        #expect(item.reviewDecision == nil)
        #expect(item.headRevision == nil)
    }
    @Test func preservesIndependentCurrentCheckAndReviewSignals() async throws {
        let client = GitHubWorkClient { request in
            let body = try JSONSerialization.jsonObject(with: request.httpBody!) as! [String: Any]
            let query = body["query"] as! String
            #expect(query.contains("statusCheckRollup"))
            #expect(query.contains("reviewDecision"))
            let json = #"{"data":{"repository":{"databaseId":42,"issues":{"nodes":[],"pageInfo":{"hasNextPage":false}},"pullRequests":{"nodes":[{"id":"P1","number":2,"title":"Fix","url":"https://github.com/a/b/pull/2","state":"OPEN","closedAt":null,"mergedAt":null,"updatedAt":"2026-11-17T10:00:00Z","isDraft":false,"headRefOid":"abc","statusCheckRollup":{"state":"FAILURE"},"reviewDecision":"APPROVED"}],"pageInfo":{"hasNextPage":false}}}}}"#
            return (Data(json.utf8), HTTPURLResponse(url: request.url!, statusCode: 200, httpVersion: nil, headerFields: nil)!)
        }
        let item = try #require(await client.firstPage(token: "token", repositoryID: 42, fullName: "a/b").items.first)
        #expect(item.checkStatus == "FAILURE")
        #expect(item.reviewDecision == "APPROVED")
        #expect(item.headRevision == "abc")
        let restored = try JSONDecoder().decode(GitHubWorkItem.self, from: JSONEncoder().encode(item))
        #expect(restored.checkStatus == "FAILURE")
    }
    @Test func decodesSeparatePullRequestsAndIssuesAndCoverage() async throws {
        let client = GitHubWorkClient { request in
            #expect(request.url?.absoluteString == "https://api.github.com/graphql")
            #expect(request.value(forHTTPHeaderField: "Authorization") == "Bearer token")
            let json = #"{"data":{"repository":{"databaseId":42,"issues":{"nodes":[{"id":"I1","number":1,"title":"Bug","url":"https://github.com/a/b/issues/1","state":"OPEN","closedAt":null,"updatedAt":"2026-11-17T09:00:00Z"}],"pageInfo":{"hasNextPage":false}},"pullRequests":{"nodes":[{"id":"P1","number":2,"title":"Fix","url":"https://github.com/a/b/pull/2","state":"MERGED","closedAt":"2026-11-17T10:00:00Z","mergedAt":"2026-11-17T10:00:00Z","updatedAt":"2026-11-17T10:00:00Z","isDraft":false}],"pageInfo":{"hasNextPage":true,"endCursor":"pr1"}}}}}"#
            return (Data(json.utf8), HTTPURLResponse(url: request.url!, statusCode: 200, httpVersion: nil, headerFields: nil)!)
        }
        let result = try await client.firstPage(token: "token", repositoryID: 42, fullName: "a/b")
        #expect(result.items.map(\.id) == ["I1", "P1"])
        #expect(result.items[1].state == "MERGED")
        #expect(result.items[1].kind == .pullRequest)
        #expect(result.isIncomplete)
        let saved = try JSONEncoder().encode(result.items)
        let restored = try JSONDecoder().decode([GitHubWorkItem].self, from: saved)
        #expect(restored.map(\.id) == ["I1", "P1"])
        #expect(restored[1].mergedAt == result.items[1].mergedAt)
    }

    @Test func followsIndependentCursorsWithoutReloadingFinishedCollection() async throws {
        let client = GitHubWorkClient { request in
            let body = try JSONSerialization.jsonObject(with: request.httpBody!) as! [String: Any]
            let variables = body["variables"] as! [String: Any]
            let json: String
            if variables["pullAfter"] as? String == "pr1" {
                #expect(variables["loadIssues"] as? Bool == false)
                json = #"{"data":{"repository":{"databaseId":42,"pullRequests":{"nodes":[{"id":"P2","number":3,"title":"Second","url":"https://github.com/a/b/pull/3","state":"OPEN","closedAt":null,"mergedAt":null,"updatedAt":"2026-11-17T10:00:00Z","isDraft":false}],"pageInfo":{"hasNextPage":false,"endCursor":"pr2"}}}}}"#
            } else {
                #expect(variables["loadIssues"] as? Bool == true)
                json = #"{"data":{"repository":{"databaseId":42,"issues":{"nodes":[],"pageInfo":{"hasNextPage":false,"endCursor":null}},"pullRequests":{"nodes":[{"id":"P1","number":2,"title":"First","url":"https://github.com/a/b/pull/2","state":"OPEN","closedAt":null,"mergedAt":null,"updatedAt":"2026-11-17T10:00:00Z","isDraft":false}],"pageInfo":{"hasNextPage":true,"endCursor":"pr1"}}}}}"#
            }
            return (Data(json.utf8), HTTPURLResponse(url: request.url!, statusCode: 200, httpVersion: nil, headerFields: nil)!)
        }
        let result = try await client.load(token: "token", repositoryID: 42, fullName: "a/b")
        #expect(result.items.map(\.id) == ["P1", "P2"])
        #expect(!result.isIncomplete)
    }

    @Test func requestLimitReportsIncompleteResults() async throws {
        let client = GitHubWorkClient { request in
            let json = #"{"data":{"repository":{"databaseId":42,"issues":{"nodes":[],"pageInfo":{"hasNextPage":true,"endCursor":"issue-next"}},"pullRequests":{"nodes":[],"pageInfo":{"hasNextPage":false,"endCursor":null}}}}}"#
            return (Data(json.utf8), HTTPURLResponse(url: request.url!, statusCode: 200, httpVersion: nil, headerFields: nil)!)
        }
        let result = try await client.load(token: "token", repositoryID: 42, fullName: "a/b", maxRequests: 1)
        #expect(result.isIncomplete)
    }

    @Test func rejectsMissingNextCursor() async throws {
        let client = GitHubWorkClient { request in
            let json = #"{"data":{"repository":{"databaseId":42,"issues":{"nodes":[],"pageInfo":{"hasNextPage":true,"endCursor":null}},"pullRequests":{"nodes":[],"pageInfo":{"hasNextPage":false,"endCursor":null}}}}}"#
            return (Data(json.utf8), HTTPURLResponse(url: request.url!, statusCode: 200, httpVersion: nil, headerFields: nil)!)
        }
        await #expect(throws: WorkFetchError.invalidResponse) { try await client.load(token: "token", repositoryID: 42, fullName: "a/b") }
    }

    @Test func mismatchedRepositoryIdentityDoesNotReturnWork() async throws {
        let client = GitHubWorkClient { request in
            let json = #"{"data":{"repository":{"databaseId":99,"issues":{"nodes":[],"pageInfo":{"hasNextPage":false}},"pullRequests":{"nodes":[],"pageInfo":{"hasNextPage":false}}}}}"#
            return (Data(json.utf8), HTTPURLResponse(url: request.url!, statusCode: 200, httpVersion: nil, headerFields: nil)!)
        }
        await #expect(throws: WorkFetchError.repositoryIdentityMismatch) { try await client.firstPage(token: "token", repositoryID: 42, fullName: "a/b") }
    }

    @Test func graphQLErrorsAreNotEmptySuccess() async throws {
        let client = GitHubWorkClient { request in
            (Data(#"{"errors":[{"message":"denied"}],"data":{"repository":null}}"#.utf8), HTTPURLResponse(url: request.url!, statusCode: 200, httpVersion: nil, headerFields: nil)!)
        }
        await #expect(throws: WorkFetchError.graphQLFailure) { try await client.firstPage(token: "token", repositoryID: 42, fullName: "a/b") }
    }
}
