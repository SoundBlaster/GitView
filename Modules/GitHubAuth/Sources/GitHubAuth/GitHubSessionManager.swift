import Foundation

public enum SessionRefreshError: Error, Equatable {
    case missingSession
    case reauthorizationRequired
    case rotatedButNotStored
    case sessionChanged
}

/// Serializes refreshes and keeps a rotated credential in memory if persistence fails.
public actor GitHubSessionManager {
    public typealias Load = @Sendable () throws -> SavedGitHubCredential?
    public typealias Save = @Sendable (GitHubIdentity, OAuthToken, Date) throws -> Void
    public typealias Refresh = @Sendable (String) async throws -> OAuthToken

    private struct Pending: Sendable {
        let original: SavedGitHubCredential
        let token: OAuthToken
        let receivedAt: Date
    }
    private let load: Load
    private let save: Save
    private let refresh: Refresh
    private var inFlight: (id: UUID, original: SavedGitHubCredential, task: Task<OAuthToken, Error>)?
    private var pending: Pending?

    public init(load: @escaping Load, save: @escaping Save, refresh: @escaping Refresh) {
        self.load = load
        self.save = save
        self.refresh = refresh
    }

    /// Removes the local credential and prevents a late refresh from saving it again.
    public func disconnect(remove: @Sendable () throws -> Void) throws {
        try remove()
        inFlight?.task.cancel()
        inFlight = nil
        pending = nil
    }

    /// Checks a response against the credential currently stored for the active account.
    public func isCurrent(accountID: Int64, accessToken: String) throws -> Bool {
        guard let current = try load() else { return false }
        return current.identity.id == accountID && current.accessToken == accessToken
    }

    public func usableSession(for accountID: Int64? = nil, now: Date = .now) async throws -> SavedGitHubCredential {
        if let pending {
            guard accountID == nil || pending.original.identity.id == accountID else { throw SessionRefreshError.sessionChanged }
            return try persist(pending)
        }
        guard let current = try load() else { throw SessionRefreshError.missingSession }
        guard accountID == nil || current.identity.id == accountID else { throw SessionRefreshError.sessionChanged }
        guard let expiry = current.accessTokenExpiresAt, expiry <= now else { return current }
        guard let refreshToken = current.refreshToken, !refreshToken.isEmpty,
              current.refreshTokenExpiresAt.map({ $0 > now }) ?? true else {
            throw SessionRefreshError.reauthorizationRequired
        }
        let flight: (id: UUID, original: SavedGitHubCredential, task: Task<OAuthToken, Error>)
        if let inFlight {
            guard inFlight.original.identity.id == current.identity.id,
                  inFlight.original.refreshToken == current.refreshToken else {
                throw SessionRefreshError.sessionChanged
            }
            flight = inFlight
        } else {
            let refresh = self.refresh
            flight = (UUID(), current, Task { try await refresh(refreshToken) })
            inFlight = flight
        }
        let token: OAuthToken
        do {
            token = try await flight.task.value
        } catch {
            if inFlight?.id == flight.id { inFlight = nil }
            throw error
        }
        // A concurrent waiter may already have saved this refresh result.
        guard inFlight?.id == flight.id else {
            if let pending { return try persist(pending) }
            guard let saved = try load() else { throw SessionRefreshError.missingSession }
            guard accountID == nil || saved.identity.id == accountID else { throw SessionRefreshError.sessionChanged }
            return saved
        }
        inFlight = nil
        let value = Pending(original: flight.original, token: token, receivedAt: now)
        pending = value
        return try persist(value)
    }

    private func persist(_ value: Pending) throws -> SavedGitHubCredential {
        guard let current = try load(), current.identity.id == value.original.identity.id,
              current.refreshToken == value.original.refreshToken else {
            pending = nil
            throw SessionRefreshError.sessionChanged
        }
        do {
            try save(value.original.identity, value.token, value.receivedAt)
        } catch {
            throw SessionRefreshError.rotatedButNotStored
        }
        pending = nil
        return SavedGitHubCredential(identity: value.original.identity, accessToken: value.token.accessToken,
            refreshToken: value.token.refreshToken,
            accessTokenExpiresAt: value.token.expiresIn.map { value.receivedAt.addingTimeInterval(TimeInterval($0)) },
            refreshTokenExpiresAt: value.token.refreshTokenExpiresIn.map { value.receivedAt.addingTimeInterval(TimeInterval($0)) })
    }
}
