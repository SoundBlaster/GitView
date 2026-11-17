import Foundation
import Testing
@testable import GitHubAuth

struct GitHubIdentityTests {
    @Test func loadsAuthenticatedIdentityUsingBearerToken() async throws {
        let client = GitHubIdentityClient { request in
            #expect(request.url?.absoluteString == "https://api.github.com/user")
            #expect(request.value(forHTTPHeaderField: "Authorization") == "Bearer token")
            let response = HTTPURLResponse(url: request.url!, statusCode: 200, httpVersion: nil, headerFields: nil)!
            return (Data(#"{"id":123,"login":"egor"}"#.utf8), response)
        }
        let identity = try await client.currentUser(accessToken: "token")
        #expect(identity.id == 123)
        #expect(identity.login == "egor")
    }

    @Test func rejectsInvalidResponseAndHttpFailure() async throws {
        let client = GitHubIdentityClient { request in
            (Data(#"{"id":123,"login":""}"#.utf8), HTTPURLResponse(url: request.url!, statusCode: 200, httpVersion: nil, headerFields: nil)!)
        }
        await #expect(throws: GitHubIdentityError.invalidResponse) { try await client.currentUser(accessToken: "token") }
        let failed = GitHubIdentityClient { request in
            (Data(), HTTPURLResponse(url: request.url!, statusCode: 401, httpVersion: nil, headerFields: nil)!)
        }
        await #expect(throws: GitHubIdentityError.httpFailure) { try await failed.currentUser(accessToken: "token") }
    }

    @Test func storageFailureDoesNotConfirmConnection() async throws {
        let client = GitHubIdentityClient { request in
            (Data(#"{"id":1,"login":"alice"}"#.utf8), HTTPURLResponse(url: request.url!, statusCode: 200, httpVersion: nil, headerFields: nil)!)
        }
        let connection = GitHubConnectionService(identityClient: client, save: { _, _ in throw StorageError.failed })
        let token = OAuthToken(accessToken: "token", refreshToken: nil, expiresIn: nil, refreshTokenExpiresIn: nil)
        let attempt = await connection.begin()
        await #expect(throws: StorageError.failed) { try await connection.confirm(token, attempt: attempt) }
    }

    @Test func supersededAttemptCannotSaveLateIdentity() async throws {
        let gate = ResponseGate()
        let client = GitHubIdentityClient { request in
            await gate.pause()
            return (Data(#"{"id":1,"login":"alice"}"#.utf8), HTTPURLResponse(url: request.url!, statusCode: 200, httpVersion: nil, headerFields: nil)!)
        }
        let connection = GitHubConnectionService(identityClient: client, save: { _, _ in
            Issue.record("A superseded attempt must not save credentials")
        })
        let old = await connection.begin()
        let token = OAuthToken(accessToken: "token", refreshToken: nil, expiresIn: nil, refreshTokenExpiresIn: nil)
        let task = Task { try await connection.confirm(token, attempt: old) }
        await gate.waitUntilPaused()
        _ = await connection.begin()
        await gate.release()
        await #expect(throws: ConnectionAttemptError.superseded) { try await task.value }
    }

    @Test func successReturnsVerifiedIdentity() async throws {
        let client = GitHubIdentityClient { request in
            (Data(#"{"id":1,"login":"alice"}"#.utf8), HTTPURLResponse(url: request.url!, statusCode: 200, httpVersion: nil, headerFields: nil)!)
        }
        let connection = GitHubConnectionService(identityClient: client, save: { identity, token in
            #expect(identity.id == 1)
            #expect(token.accessToken == "token")
        })
        let token = OAuthToken(accessToken: "token", refreshToken: nil, expiresIn: nil, refreshTokenExpiresIn: nil)
        let attempt = await connection.begin()
        #expect(try await connection.confirm(token, attempt: attempt).login == "alice")
    }
}
private enum StorageError: Error { case failed }

private actor ResponseGate {
    private var continuation: CheckedContinuation<Void, Never>?
    private var started: CheckedContinuation<Void, Never>?
    func pause() async {
        await withCheckedContinuation { continuation in
            self.continuation = continuation
            started?.resume()
            started = nil
        }
    }
    func waitUntilPaused() async {
        if continuation != nil { return }
        await withCheckedContinuation { started = $0 }
    }
    func release() { continuation?.resume(); continuation = nil }
}
