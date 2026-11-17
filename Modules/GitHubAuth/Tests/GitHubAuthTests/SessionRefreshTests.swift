import Foundation
import Testing
@testable import GitHubAuth

struct SessionRefreshTests {
    @Test func refreshUsesCorrectGrantAndReturnsRotatedTokens() async throws {
        let client = OAuthClient(clientID: "id", clientSecret: "secret", redirectURI: URL(string: "gitview://oauth/callback")!) { request in
            let body = String(data: request.httpBody!, encoding: .utf8)!
            let values = URLComponents(string: "?" + body)!.queryItems!
            #expect(values.first(where: { $0.name == "grant_type" })?.value == "refresh_token")
            #expect(values.first(where: { $0.name == "refresh_token" })?.value == "refresh+token")
            let json = #"{"access_token":"new","token_type":"bearer","refresh_token":"rotated","expires_in":3600,"refresh_token_expires_in":7200}"#
            return (Data(json.utf8), HTTPURLResponse(url: request.url!, statusCode: 200, httpVersion: nil, headerFields: nil)!)
        }
        let result = try await client.refresh("refresh+token")
        #expect(result.accessToken == "new")
        #expect(result.refreshToken == "rotated")
    }

    @Test func unexpiredSessionDoesNotRefresh() async throws {
        let now = Date(timeIntervalSince1970: 1000)
        let credential = SavedGitHubCredential(identity: GitHubIdentity(id: 1, login: "a"), accessToken: "old", refreshToken: "refresh", accessTokenExpiresAt: now.addingTimeInterval(3600), refreshTokenExpiresAt: nil)
        let manager = GitHubSessionManager(load: { credential }, save: { _, _, _ in Issue.record("Unexpected save") }, refresh: { _ in Issue.record("Unexpected refresh"); throw TestError.failed })
        #expect(try await manager.usableSession(now: now).accessToken == "old")
    }

    @Test func expiredSessionRequiresSuccessfulSaveBeforeReturn() async throws {
        let now = Date(timeIntervalSince1970: 1000)
        let credential = SavedGitHubCredential(identity: GitHubIdentity(id: 1, login: "a"), accessToken: "old", refreshToken: "refresh", accessTokenExpiresAt: now.addingTimeInterval(-1), refreshTokenExpiresAt: nil)
        let manager = GitHubSessionManager(load: { credential }, save: { _, _, _ in throw TestError.failed }, refresh: { _ in OAuthToken(accessToken: "new", refreshToken: "rotated", expiresIn: 3600, refreshTokenExpiresIn: 7200) })
        await #expect(throws: SessionRefreshError.rotatedButNotStored) { try await manager.usableSession(now: now) }
    }

    @Test func expiredRefreshTokenDoesNotCallNetwork() async throws {
        let now = Date(timeIntervalSince1970: 1000)
        let credential = SavedGitHubCredential(identity: GitHubIdentity(id: 1, login: "a"), accessToken: "old", refreshToken: "refresh", accessTokenExpiresAt: now, refreshTokenExpiresAt: now)
        let manager = GitHubSessionManager(load: { credential }, save: { _, _, _ in Issue.record("Unexpected save") }, refresh: { _ in Issue.record("Unexpected refresh"); throw TestError.failed })
        await #expect(throws: SessionRefreshError.reauthorizationRequired) { try await manager.usableSession(now: now) }
    }

    @Test func parallelRequestsShareRotation() async throws {
        let now = Date(timeIntervalSince1970: 1000)
        let fixture = RefreshFixture(now: now)
        let manager = GitHubSessionManager(load: { fixture.load() }, save: { fixture.save($0, $1, $2) }, refresh: { _ in
            fixture.recordRefresh()
            try await Task.sleep(for: .milliseconds(50))
            return OAuthToken(accessToken: "new", refreshToken: "rotated", expiresIn: 3600, refreshTokenExpiresIn: 7200)
        })
        async let first = manager.usableSession(now: now)
        async let second = manager.usableSession(now: now)
        let results = try await [first, second]
        #expect(results.allSatisfy { $0.accessToken == "new" })
        #expect(fixture.refreshCount == 1)
    }

    @Test func retriesStorageWithoutRotatingAgain() async throws {
        let now = Date(timeIntervalSince1970: 1000)
        let fixture = RefreshFixture(now: now)
        let manager = GitHubSessionManager(load: { fixture.load() }, save: { identity, token, date in
            if fixture.shouldFailSave() { throw TestError.failed }
            fixture.save(identity, token, date)
        }, refresh: { _ in
            fixture.recordRefresh()
            return OAuthToken(accessToken: "new", refreshToken: "rotated", expiresIn: 3600, refreshTokenExpiresIn: 7200)
        })
        await #expect(throws: SessionRefreshError.rotatedButNotStored) { try await manager.usableSession(now: now) }
        #expect(try await manager.usableSession(now: now).refreshToken == "rotated")
        #expect(fixture.refreshCount == 1)
    }

    @Test func lateRefreshDoesNotReplaceAnotherAccount() async throws {
        let now = Date(timeIntervalSince1970: 1000)
        let fixture = RefreshFixture(now: now)
        let manager = GitHubSessionManager(load: { fixture.load() }, save: { fixture.save($0, $1, $2) }, refresh: { _ in
            fixture.switchAccount(now: now)
            return OAuthToken(accessToken: "new", refreshToken: "rotated", expiresIn: 3600, refreshTokenExpiresIn: 7200)
        })
        await #expect(throws: SessionRefreshError.sessionChanged) { try await manager.usableSession(now: now) }
        #expect(fixture.load().identity.id == 2)
        #expect(fixture.load().accessToken == "other")
    }

    @Test func screenCannotUseAnotherAccountsSession() async throws {
        let now = Date(timeIntervalSince1970: 1000)
        let fixture = RefreshFixture(now: now)
        fixture.switchAccount(now: now)
        let manager = GitHubSessionManager(load: { fixture.load() }, save: { fixture.save($0, $1, $2) }, refresh: { _ in
            Issue.record("Must not refresh another account")
            throw TestError.failed
        })
        await #expect(throws: SessionRefreshError.sessionChanged) { try await manager.usableSession(for: 1, now: now) }
    }

    @Test func disconnectPreventsLateRefreshFromRestoringSession() async throws {
        let now = Date(timeIntervalSince1970: 1000)
        let store = DisconnectStore(credential: RefreshFixture(now: now).load())
        let gate = RefreshGate()
        let manager = GitHubSessionManager(load: { store.load() }, save: { _, _, _ in Issue.record("Disconnected session was saved again") }, refresh: { _ in
            await gate.pause()
            return OAuthToken(accessToken: "new", refreshToken: "rotated", expiresIn: 3600, refreshTokenExpiresIn: 7200)
        })
        let task = Task { try await manager.usableSession(for: 1, now: now) }
        await gate.waitUntilPaused()
        try await manager.disconnect { store.clear() }
        await gate.release()
        await #expect(throws: SessionRefreshError.missingSession) { try await task.value }
        #expect(store.load() == nil)
    }

    @Test func failedDisconnectDoesNotPretendSessionWasRemoved() async throws {
        let now = Date(timeIntervalSince1970: 1000)
        let credential = SavedGitHubCredential(identity: GitHubIdentity(id: 1, login: "a"), accessToken: "old", refreshToken: nil, accessTokenExpiresAt: nil, refreshTokenExpiresAt: nil)
        let manager = GitHubSessionManager(load: { credential }, save: { _, _, _ in }, refresh: { _ in throw TestError.failed })
        await #expect(throws: TestError.failed) { try await manager.disconnect { throw TestError.failed } }
        #expect(try await manager.usableSession(for: 1, now: now).accessToken == "old")
    }
}
private enum TestError: Error { case failed }

private final class DisconnectStore: @unchecked Sendable {
    private let lock = NSLock()
    private var credential: SavedGitHubCredential?
    init(credential: SavedGitHubCredential) { self.credential = credential }
    func load() -> SavedGitHubCredential? { lock.withLock { credential } }
    func clear() { lock.withLock { credential = nil } }
}

private actor RefreshGate {
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

private final class RefreshFixture: @unchecked Sendable {
    private let lock = NSLock()
    private var credential: SavedGitHubCredential
    private var count = 0
    private var failSave = true
    init(now: Date) {
        credential = SavedGitHubCredential(identity: GitHubIdentity(id: 1, login: "a"), accessToken: "old", refreshToken: "refresh", accessTokenExpiresAt: now, refreshTokenExpiresAt: nil)
    }
    func load() -> SavedGitHubCredential { lock.withLock { credential } }
    func recordRefresh() { lock.withLock { count += 1 } }
    var refreshCount: Int { lock.withLock { count } }
    func shouldFailSave() -> Bool { lock.withLock { defer { failSave = false }; return failSave } }
    func switchAccount(now: Date) {
        lock.withLock {
            credential = SavedGitHubCredential(identity: GitHubIdentity(id: 2, login: "b"), accessToken: "other", refreshToken: "other-refresh", accessTokenExpiresAt: now, refreshTokenExpiresAt: nil)
        }
    }
    func save(_ identity: GitHubIdentity, _ token: OAuthToken, _ now: Date) {
        lock.withLock {
            credential = SavedGitHubCredential(identity: identity, accessToken: token.accessToken, refreshToken: token.refreshToken,
                accessTokenExpiresAt: token.expiresIn.map { now.addingTimeInterval(TimeInterval($0)) },
                refreshTokenExpiresAt: token.refreshTokenExpiresIn.map { now.addingTimeInterval(TimeInterval($0)) })
        }
    }
}
