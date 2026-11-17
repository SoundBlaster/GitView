import Foundation
import Testing
@testable import GitHubAuth

struct OAuthClientTests {
    private func authorization() throws -> OAuthAuthorizationCode {
        let attempt = try OAuthAttempt(clientID: "id", redirectURI: URL(string: "gitview://oauth/callback")!, verifier: "dBjftJeZ4CVP-mB92K27uhbUJU1p1r_wW1gFWFOEjXk", state: "state")
        return try attempt.receiveCallback(URL(string: "gitview://oauth/callback?code=one%2Btwo&state=state")!)
    }

    @Test func exchangesCodeWithPKCEAndDecodesToken() async throws {
        let client = OAuthClient(clientID: "id", clientSecret: "secret", redirectURI: URL(string: "gitview://oauth/callback")!) { request in
            #expect(request.url?.absoluteString == "https://github.com/login/oauth/access_token")
            #expect(request.httpMethod == "POST")
            #expect(request.value(forHTTPHeaderField: "Accept") == "application/json")
            let body = String(data: request.httpBody!, encoding: .utf8)!
            let fields = URLComponents(string: "?" + body)!.queryItems!
            #expect(fields.first(where: { $0.name == "code" })?.value == "one+two")
            #expect(fields.first(where: { $0.name == "code_verifier" })?.value == "dBjftJeZ4CVP-mB92K27uhbUJU1p1r_wW1gFWFOEjXk")
            let response = HTTPURLResponse(url: request.url!, statusCode: 200, httpVersion: nil, headerFields: nil)!
            return (Data(#"{"access_token":"test-token","token_type":"bearer"}"#.utf8), response)
        }
        let token = try await client.exchange(authorization())
        #expect(token.accessToken == "test-token")
    }

    @Test func githubErrorIsNotSuccess() async throws {
        let client = OAuthClient(clientID: "id", clientSecret: "secret", redirectURI: URL(string: "gitview://oauth/callback")!) { request in
            (Data(#"{"error":"bad_verification_code","error_description":"sensitive"}"#.utf8), HTTPURLResponse(url: request.url!, statusCode: 200, httpVersion: nil, headerFields: nil)!)
        }
        await #expect(throws: OAuthExchangeError.rejected) { try await client.exchange(authorization()) }
    }

    @Test func httpErrorIsNotSuccess() async throws {
        let client = OAuthClient(clientID: "id", clientSecret: "secret", redirectURI: URL(string: "gitview://oauth/callback")!) { request in
            (Data(), HTTPURLResponse(url: request.url!, statusCode: 500, httpVersion: nil, headerFields: nil)!)
        }
        await #expect(throws: OAuthExchangeError.httpFailure) { try await client.exchange(authorization()) }
    }

    @Test func missingOrNonBearerTokenIsRejected() async throws {
        let client = OAuthClient(clientID: "id", clientSecret: "secret", redirectURI: URL(string: "gitview://oauth/callback")!) { request in
            (Data(#"{"access_token":"","token_type":"bearer"}"#.utf8), HTTPURLResponse(url: request.url!, statusCode: 200, httpVersion: nil, headerFields: nil)!)
        }
        await #expect(throws: OAuthExchangeError.invalidResponse) { try await client.exchange(authorization()) }
    }
}
