import Foundation
import Testing
@testable import GitHubAuth

struct OAuthAttemptTests {
    let callback = URL(string: "gitview://oauth/callback")!

    private func attempt() throws -> OAuthAttempt {
        try OAuthAttempt(
            clientID: "client-id",
            redirectURI: callback,
            verifier: "dBjftJeZ4CVP-mB92K27uhbUJU1p1r_wW1gFWFOEjXk",
            state: "this-is-an-unpredictable-state"
        )
    }

    @Test func authorizationUsesPKCEAndTheSameCallback() throws {
        let components = try #require(URLComponents(url: attempt().authorizationURL, resolvingAgainstBaseURL: false))
        #expect(components.scheme == "https")
        #expect(components.host == "github.com")
        #expect(components.path == "/login/oauth/authorize")
        let fields = Dictionary(uniqueKeysWithValues: (components.queryItems ?? []).map { ($0.name, $0.value ?? "") })
        #expect(fields["client_id"] == "client-id")
        #expect(fields["redirect_uri"] == callback.absoluteString)
        #expect(fields["state"] == "this-is-an-unpredictable-state")
        #expect(fields["code_challenge_method"] == "S256")
        #expect(fields["code_challenge"] == "E9Melhoa2OwvFrEMTJguCHaoeK1t8URWbuGJSstw-cM")
    }

    @Test func validCallbackReturnsCodeAndVerifier() throws {
        let value = try attempt().receiveCallback(URL(string: "gitview://oauth/callback?code=hello&state=this-is-an-unpredictable-state")!)
        #expect(value.code == "hello")
        #expect(value.codeVerifier == "dBjftJeZ4CVP-mB92K27uhbUJU1p1r_wW1gFWFOEjXk")
    }

    @Test func rejectsWrongCallbackAndState() throws {
        let attempt = try attempt()
        #expect(throws: OAuthCallbackError.invalidCallback) {
            try attempt.receiveCallback(URL(string: "gitview://oauth/wrong?code=hello&state=this-is-an-unpredictable-state")!)
        }
        #expect(throws: OAuthCallbackError.invalidState) {
            try attempt.receiveCallback(URL(string: "gitview://oauth/callback?code=hello&state=wrong")!)
        }
        #expect(throws: OAuthCallbackError.invalidState) {
            try attempt.receiveCallback(URL(string: "gitview://oauth/callback?code=hello")!)
        }
    }

    @Test func rejectsAmbiguousOrIncompleteCallback() throws {
        let attempt = try attempt()
        #expect(throws: OAuthCallbackError.invalidCallback) {
            try attempt.receiveCallback(URL(string: "gitview://oauth/callback?code=one&code=two&state=this-is-an-unpredictable-state")!)
        }
        #expect(throws: OAuthCallbackError.invalidCallback) {
            try attempt.receiveCallback(URL(string: "gitview://oauth/callback?state=this-is-an-unpredictable-state")!)
        }
    }

    @Test func sourceRejectionIsNotAConnection() throws {
        let attempt = try attempt()
        #expect(throws: OAuthCallbackError.authorizationDenied) {
            try attempt.receiveCallback(URL(string: "gitview://oauth/callback?error=access_denied&state=this-is-an-unpredictable-state")!)
        }
    }

    @Test func productionAttemptsGenerateDifferentValues() throws {
        let a = try OAuthAttempt.make(clientID: "client", redirectURI: callback)
        let b = try OAuthAttempt.make(clientID: "client", redirectURI: callback)
        #expect(a.authorizationURL != b.authorizationURL)
    }
}
