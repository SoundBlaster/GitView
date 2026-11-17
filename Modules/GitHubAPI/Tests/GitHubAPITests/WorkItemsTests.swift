import Foundation
import Testing
@testable import GitHubAPI

struct WorkItemsTests {
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
