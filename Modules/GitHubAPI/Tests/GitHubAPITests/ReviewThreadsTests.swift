import Foundation
import Testing
@testable import GitHubAPI

struct ReviewThreadsTests {
    @Test func followsPagesAndCountsOnlyUnresolved() async throws {
        let client = GitHubReviewThreadsClient { request in
            let body = try JSONSerialization.jsonObject(with: request.httpBody!) as! [String: Any]
            let variables = body["variables"] as! [String: Any]
            let next = variables["after"] as? String == "cursor"
            let threads = next
                ? #"{"totalCount":3,"nodes":[{"id":"t3","isResolved":false}],"pageInfo":{"hasNextPage":false,"endCursor":null}}"#
                : #"{"totalCount":3,"nodes":[{"id":"t1","isResolved":true},{"id":"t2","isResolved":false}],"pageInfo":{"hasNextPage":true,"endCursor":"cursor"}}"#
            let json = #"{"data":{"node":{"id":"P1","headRefOid":"abc","reviewThreads":\#(threads)}}}"#
            return (Data(json.utf8), HTTPURLResponse(url: request.url!, statusCode: 200, httpVersion: nil, headerFields: nil)!)
        }
        let result = try await client.load(token: "token", pullRequestID: "P1", expectedHead: "abc")
        #expect(result.total == 3 && result.observedUnresolved == 2 && result.isComplete)
    }

    @Test func doesNotTreatNewHeadAsTheOriginalObservation() async throws {
        let client = GitHubReviewThreadsClient { request in
            let json = #"{"data":{"node":{"id":"P1","headRefOid":"new","reviewThreads":{"totalCount":0,"nodes":[],"pageInfo":{"hasNextPage":false}}}}}"#
            return (Data(json.utf8), HTTPURLResponse(url: request.url!, statusCode: 200, httpVersion: nil, headerFields: nil)!)
        }
        await #expect(throws: ReviewThreadsError.revisionChanged) {
            try await client.load(token: "token", pullRequestID: "P1", expectedHead: "old")
        }
    }

    @Test func limitLeavesCoverageExplicitlyPartial() async throws {
        let client = GitHubReviewThreadsClient { request in
            let json = #"{"data":{"node":{"id":"P1","headRefOid":"abc","reviewThreads":{"totalCount":2,"nodes":[{"id":"t1","isResolved":false}],"pageInfo":{"hasNextPage":true,"endCursor":"next"}}}}}"#
            return (Data(json.utf8), HTTPURLResponse(url: request.url!, statusCode: 200, httpVersion: nil, headerFields: nil)!)
        }
        let result = try await client.load(token: "token", pullRequestID: "P1", expectedHead: "abc", maxPages: 1)
        #expect(result.total == 2 && result.observedUnresolved == 1 && !result.isComplete)
    }

    @Test func repeatedThreadsAreNotCountedTwice() async throws {
        let client = GitHubReviewThreadsClient { request in
            let json = #"{"data":{"node":{"id":"P1","headRefOid":"abc","reviewThreads":{"totalCount":2,"nodes":[{"id":"t1","isResolved":false},{"id":"t1","isResolved":false}],"pageInfo":{"hasNextPage":false}}}}}"#
            return (Data(json.utf8), HTTPURLResponse(url: request.url!, statusCode: 200, httpVersion: nil, headerFields: nil)!)
        }
        await #expect(throws: ReviewThreadsError.collectionChanged) {
            try await client.load(token: "token", pullRequestID: "P1", expectedHead: "abc")
        }
    }
}
