import CryptoKit
import Foundation
import Security

public enum OAuthConfigurationError: Error, Equatable {
    case invalidConfiguration
    case randomnessUnavailable
}

public enum OAuthCallbackError: Error, Equatable {
    case invalidCallback
    case invalidState
    case authorizationDenied
    case authorizationFailed
}

/// An authorization code is only an intermediate result, not a connected account.
public struct OAuthAuthorizationCode: Sendable {
    public let code: String
    public let codeVerifier: String
}

/// One web authorization attempt. Callers own its lifetime and must discard it on
/// cancellation or replacement; callback validation alone does not establish a session.
public struct OAuthAttempt: Sendable {
    public let authorizationURL: URL
    private let redirectURI: URL
    private let verifier: String
    private let state: String

    public static func make(clientID: String, redirectURI: URL) throws -> OAuthAttempt {
        try OAuthAttempt(
            clientID: clientID,
            redirectURI: redirectURI,
            verifier: randomURLSafeString(),
            state: randomURLSafeString()
        )
    }

    // Deterministic construction is internal for test vectors only.
    init(clientID: String, redirectURI: URL, verifier: String, state: String) throws {
        let allowedVerifierCharacters = CharacterSet(charactersIn: "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789-._~")
        guard !clientID.isEmpty, !state.isEmpty,
              (43...128).contains(verifier.utf8.count),
              verifier.unicodeScalars.allSatisfy({ allowedVerifierCharacters.contains($0) }),
              let callback = URLComponents(url: redirectURI, resolvingAgainstBaseURL: false),
              let scheme = callback.scheme, !scheme.isEmpty, scheme.lowercased() != "http",
              callback.host != nil, callback.user == nil, callback.password == nil,
              callback.query == nil, callback.fragment == nil else {
            throw OAuthConfigurationError.invalidConfiguration
        }
        let digest = SHA256.hash(data: Data(verifier.utf8))
        let challenge = Self.urlSafeBase64(Data(digest))
        var components = URLComponents()
        components.scheme = "https"
        components.host = "github.com"
        components.path = "/login/oauth/authorize"
        components.queryItems = [
            URLQueryItem(name: "client_id", value: clientID),
            URLQueryItem(name: "redirect_uri", value: redirectURI.absoluteString),
            URLQueryItem(name: "state", value: state),
            URLQueryItem(name: "code_challenge", value: challenge),
            URLQueryItem(name: "code_challenge_method", value: "S256")
        ]
        guard let url = components.url else { throw OAuthConfigurationError.invalidConfiguration }
        self.authorizationURL = url
        self.redirectURI = redirectURI
        self.verifier = verifier
        self.state = state
    }

    public func receiveCallback(_ url: URL) throws -> OAuthAuthorizationCode {
        guard let received = URLComponents(url: url, resolvingAgainstBaseURL: false),
              let expected = URLComponents(url: redirectURI, resolvingAgainstBaseURL: false),
              received.scheme?.lowercased() == expected.scheme?.lowercased(),
              received.host?.lowercased() == expected.host?.lowercased(),
              received.port == expected.port, received.path == expected.path,
              received.user == nil, received.password == nil, received.fragment == nil else {
            throw OAuthCallbackError.invalidCallback
        }
        let items = received.queryItems ?? []
        let states = items.filter { $0.name == "state" }
        guard states.count == 1, states[0].value == state else { throw OAuthCallbackError.invalidState }
        let codes = items.filter { $0.name == "code" }
        let errors = items.filter { $0.name == "error" }
        guard codes.count <= 1, errors.count <= 1, !(codes.count == 1 && errors.count == 1) else {
            throw OAuthCallbackError.invalidCallback
        }
        if let error = errors.first?.value {
            throw error == "access_denied" ? OAuthCallbackError.authorizationDenied : .authorizationFailed
        }
        guard let code = codes.first?.value, !code.isEmpty else { throw OAuthCallbackError.invalidCallback }
        return OAuthAuthorizationCode(code: code, codeVerifier: verifier)
    }

    private static func randomURLSafeString() throws -> String {
        var bytes = [UInt8](repeating: 0, count: 32)
        let result = bytes.withUnsafeMutableBytes { buffer in
            SecRandomCopyBytes(kSecRandomDefault, buffer.count, buffer.baseAddress!)
        }
        guard result == errSecSuccess else { throw OAuthConfigurationError.randomnessUnavailable }
        return urlSafeBase64(Data(bytes))
    }

    private static func urlSafeBase64(_ data: Data) -> String {
        data.base64EncodedString()
            .replacingOccurrences(of: "+", with: "-")
            .replacingOccurrences(of: "/", with: "_")
            .replacingOccurrences(of: "=", with: "")
    }
}
