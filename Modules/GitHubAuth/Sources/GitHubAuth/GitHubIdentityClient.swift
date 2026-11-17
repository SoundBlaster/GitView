import Foundation

public struct GitHubIdentity: Codable, Equatable, Sendable {
    public let id: Int64
    public let login: String
}

public enum GitHubIdentityError: Error, Equatable {
    case httpFailure
    case invalidResponse
}

public struct GitHubIdentityClient: Sendable {
    private let transport: OAuthClient.Transport

    public init(transport: @escaping OAuthClient.Transport = OAuthClient.send) {
        self.transport = transport
    }

    public func currentUser(accessToken: String) async throws -> GitHubIdentity {
        guard !accessToken.isEmpty, !accessToken.contains("\n"), !accessToken.contains("\r") else { throw GitHubIdentityError.invalidResponse }
        var request = URLRequest(url: URL(string: "https://api.github.com/user")!)
        request.setValue("Bearer " + accessToken, forHTTPHeaderField: "Authorization")
        request.setValue("application/vnd.github+json", forHTTPHeaderField: "Accept")
        let (data, response) = try await transport(request)
        guard (200..<300).contains(response.statusCode) else { throw GitHubIdentityError.httpFailure }
        guard let user = try? JSONDecoder().decode(GitHubIdentity.self, from: data), user.id > 0, !user.login.isEmpty else { throw GitHubIdentityError.invalidResponse }
        return user
    }
}

public enum ConnectionAttemptError: Error, Equatable {
    case superseded
}

/// Serializes attempt replacement with the synchronous credential commit.
public actor GitHubConnectionService {
    public typealias Save = @Sendable (GitHubIdentity, OAuthToken) throws -> Void
    private let identityClient: GitHubIdentityClient
    private let save: Save
    private var activeAttempt: UUID?

    public init(identityClient: GitHubIdentityClient, save: @escaping Save) {
        self.identityClient = identityClient
        self.save = save
    }

    public func begin() -> UUID {
        let attempt = UUID()
        activeAttempt = attempt
        return attempt
    }

    public func cancel(_ attempt: UUID) {
        if activeAttempt == attempt { activeAttempt = nil }
    }

    public func confirm(_ token: OAuthToken, attempt: UUID) async throws -> GitHubIdentity {
        guard activeAttempt == attempt else { throw ConnectionAttemptError.superseded }
        let identity = try await identityClient.currentUser(accessToken: token.accessToken)
        try Task.checkCancellation()
        guard activeAttempt == attempt else { throw ConnectionAttemptError.superseded }
        try save(identity, token)
        activeAttempt = nil
        return identity
    }
}
