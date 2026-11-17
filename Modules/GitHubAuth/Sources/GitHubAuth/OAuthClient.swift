import Foundation

public enum OAuthExchangeError: Error, Equatable {
    case httpFailure
    case rejected
    case invalidResponse
}

public struct OAuthToken: Sendable {
    public let accessToken: String
    public let refreshToken: String?
    public let expiresIn: Int?
    public let refreshTokenExpiresIn: Int?
    public init(accessToken: String, refreshToken: String?, expiresIn: Int?, refreshTokenExpiresIn: Int?) {
        self.accessToken = accessToken; self.refreshToken = refreshToken
        self.expiresIn = expiresIn; self.refreshTokenExpiresIn = refreshTokenExpiresIn
    }
}

/// Exchanges a validated one-time code; obtaining a token does not prove account identity.
public struct OAuthClient: Sendable {
    public typealias Transport = @Sendable (URLRequest) async throws -> (Data, HTTPURLResponse)
    private let clientID: String
    private let clientSecret: String
    private let redirectURI: URL
    private let transport: Transport

    public init(clientID: String, clientSecret: String, redirectURI: URL, transport: @escaping Transport = OAuthClient.send) {
        self.clientID = clientID
        self.clientSecret = clientSecret
        self.redirectURI = redirectURI
        self.transport = transport
    }

    public func exchange(_ authorization: OAuthAuthorizationCode) async throws -> OAuthToken {
        try await requestToken([
            URLQueryItem(name: "code", value: authorization.code),
            URLQueryItem(name: "redirect_uri", value: redirectURI.absoluteString),
            URLQueryItem(name: "code_verifier", value: authorization.codeVerifier)
        ])
    }

    public func refresh(_ refreshToken: String) async throws -> OAuthToken {
        guard !refreshToken.isEmpty else { throw OAuthExchangeError.invalidResponse }
        let token = try await requestToken([
            URLQueryItem(name: "grant_type", value: "refresh_token"),
            URLQueryItem(name: "refresh_token", value: refreshToken)
        ])
        guard let rotated = token.refreshToken, !rotated.isEmpty else { throw OAuthExchangeError.invalidResponse }
        return token
    }

    private func requestToken(_ parameters: [URLQueryItem]) async throws -> OAuthToken {
        var request = URLRequest(url: URL(string: "https://github.com/login/oauth/access_token")!)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        var body = URLComponents()
        body.queryItems = [
            URLQueryItem(name: "client_id", value: clientID),
            URLQueryItem(name: "client_secret", value: clientSecret)
        ] + parameters
        // URLComponents does not escape '+' in query values; form decoding treats it as a space.
        request.httpBody = body.percentEncodedQuery?.replacingOccurrences(of: "+", with: "%2B").data(using: .utf8)
        let (data, response) = try await transport(request)
        guard (200..<300).contains(response.statusCode) else { throw OAuthExchangeError.httpFailure }
        guard let payload = try? JSONDecoder().decode(Response.self, from: data) else { throw OAuthExchangeError.invalidResponse }
        if payload.error != nil { throw OAuthExchangeError.rejected }
        guard let token = payload.accessToken, !token.isEmpty,
              payload.tokenType?.lowercased() == "bearer" else { throw OAuthExchangeError.invalidResponse }
        return OAuthToken(accessToken: token, refreshToken: payload.refreshToken, expiresIn: payload.expiresIn, refreshTokenExpiresIn: payload.refreshTokenExpiresIn)
    }

    public static func send(_ request: URLRequest) async throws -> (Data, HTTPURLResponse) {
        let session = URLSession(configuration: .ephemeral, delegate: RedirectBlocker(), delegateQueue: nil)
        defer { session.invalidateAndCancel() }
        let (data, response) = try await session.data(for: request)
        guard let http = response as? HTTPURLResponse else { throw OAuthExchangeError.invalidResponse }
        return (data, http)
    }

    private struct Response: Decodable {
        let accessToken: String?
        let tokenType: String?
        let refreshToken: String?
        let expiresIn: Int?
        let refreshTokenExpiresIn: Int?
        let error: String?
        enum CodingKeys: String, CodingKey {
            case accessToken = "access_token", tokenType = "token_type", refreshToken = "refresh_token"
            case expiresIn = "expires_in", refreshTokenExpiresIn = "refresh_token_expires_in", error
        }
    }
}

private final class RedirectBlocker: NSObject, URLSessionTaskDelegate, Sendable {
    func urlSession(_ session: URLSession, task: URLSessionTask, willPerformHTTPRedirection response: HTTPURLResponse, newRequest request: URLRequest, completionHandler: @escaping @Sendable (URLRequest?) -> Void) {
        completionHandler(nil)
    }
}
