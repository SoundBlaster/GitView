import Foundation
import Testing
@testable import GitHubAPI

struct RateLimitTests {
    @Test func gateStopsAnotherNetworkRequestUntilSourceDeadline() async throws {
        let gate = GitHubRateLimitGate()
        let url = URL(string: "https://api.github.com/graphql")!
        let request = URLRequest(url: url)
        let response = HTTPURLResponse(url: url, statusCode: 429, httpVersion: nil, headerFields: ["Retry-After": "120"])!
        do {
            _ = try await gate.perform(request) { _ in (Data(), response) }
            Issue.record("Expected the first limited response to report deferral")
        } catch GitHubRateLimitError.deferred { }
        do {
            _ = try await gate.perform(request) { _ in
                Issue.record("Transport must not run while GitHub's limit applies")
                return (Data(), response)
            }
            Issue.record("Expected deferred request")
        } catch GitHubRateLimitError.deferred { }
        catch { Issue.record("Unexpected error: \(error)") }
    }

    @Test func successfulResponseAtLimitIsReturnedButStopsLaterRequests() async throws {
        let gate = GitHubRateLimitGate()
        let url = URL(string: "https://api.github.com/graphql")!
        let response = HTTPURLResponse(url: url, statusCode: 200, httpVersion: nil,
                                       headerFields: ["x-ratelimit-remaining": "0", "x-ratelimit-reset": "\(Int(Date().timeIntervalSince1970) + 120)"])!
        let data = Data(#"{"data":{"repository":{"id":"ok"}}}"#.utf8)
        let result = try await gate.perform(URLRequest(url: url)) { _ in (data, response) }
        #expect(result.0 == data)
        await #expect(throws: GitHubRateLimitError.self) { try await gate.check() }
    }

    @Test func graphQLSecondaryLimitReportsDeferralOnFirstResponse() async throws {
        let gate = GitHubRateLimitGate()
        let url = URL(string: "https://api.github.com/graphql")!
        let response = HTTPURLResponse(url: url, statusCode: 200, httpVersion: nil, headerFields: nil)!
        let body = Data(#"{"errors":[{"message":"You have exceeded a secondary rate limit"}]}"#.utf8)
        await #expect(throws: GitHubRateLimitError.self) {
            try await gate.perform(URLRequest(url: url)) { _ in (body, response) }
        }
    }
    @Test func primaryLimitUsesResetEvenForHTTP200() async throws {
        let now = Date(timeIntervalSince1970: 1_000)
        let gate = GitHubRateLimitGate()
        let response = HTTPURLResponse(url: URL(string: "https://api.github.com/graphql")!, statusCode: 200, httpVersion: nil,
                                       headerFields: ["x-ratelimit-remaining": "0", "x-ratelimit-reset": "1120"])!
        await gate.observe(response, data: Data(), now: now)
        await #expect(throws: GitHubRateLimitError.deferred(until: Date(timeIntervalSince1970: 1_120))) {
            try await gate.check(now: now)
        }
        try await gate.check(now: Date(timeIntervalSince1970: 1_120))
    }

    @Test func secondaryLimitUsesRetryAfterAndDoesNotTreatOrdinaryForbiddenAsLimit() async throws {
        let now = Date(timeIntervalSince1970: 2_000)
        let gate = GitHubRateLimitGate()
        let url = URL(string: "https://api.github.com/graphql")!
        let forbidden = HTTPURLResponse(url: url, statusCode: 403, httpVersion: nil, headerFields: nil)!
        await gate.observe(forbidden, data: Data(#"{"message":"Resource not accessible"}"#.utf8), now: now)
        try await gate.check(now: now)
        let limited = HTTPURLResponse(url: url, statusCode: 403, httpVersion: nil, headerFields: ["Retry-After": "45"])!
        await gate.observe(limited, data: Data(), now: now)
        await #expect(throws: GitHubRateLimitError.deferred(until: now.addingTimeInterval(45))) { try await gate.check(now: now) }
    }
}
