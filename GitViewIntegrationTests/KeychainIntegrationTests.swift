import Foundation
import GitHubAuth
import GitHubAPI
import Security
import WorkCache
import XCTest
@testable import GitView

@MainActor final class ProjectRefreshPersistenceTests: XCTestCase {
    func testPartialRefreshKeepsCompleteSnapshotTimeAndEarlierData() throws {
        let cache = try WorkCache(inMemory: true)
        let projectID = UUID()
        let originalTime = Date(timeIntervalSince1970: 1_000)
        let original = ProjectWorkArchive().applying([
            .init(id: 1, name: "owner/repo", outcome: .received([], complete: true), observedAt: originalTime)
        ], at: originalTime)
        try cache.save(accountID: 1, projectID: projectID, payload: JSONEncoder().encode(original), observedAt: originalTime, complete: true)
        let result = try ProjectRefreshPersistence.commit(cache: cache, accountID: 1, projectID: projectID,
            observations: [.init(id: 1, name: "owner/repo", outcome: .failed("Offline"))], fallback: nil,
            at: originalTime.addingTimeInterval(30))
        XCTAssertTrue(result.saved)
        XCTAssertFalse(result.complete)
        let snapshot = try XCTUnwrap(cache.load(accountID: 1, projectID: projectID))
        XCTAssertEqual(snapshot.observedAt, originalTime)
        XCTAssertTrue(snapshot.complete)
        let archive = try ProjectWorkArchive.decode(snapshot.payload)
        XCTAssertEqual(archive.repositories.first?.refreshProblem, "Offline")
        XCTAssertEqual(archive.repositories.first?.observedAt, originalTime)
    }
}

final class KeychainIntegrationTests: XCTestCase {
    func testSaveLoadAndUpdateSyntheticCredential() throws {
        let service = "ru.egormerkushev.gitview.test." + UUID().uuidString
        let account = "synthetic-test"
        let query: [String: Any] = [kSecClass as String: kSecClassGenericPassword, kSecAttrService as String: service, kSecAttrAccount as String: account]
        defer { SecItemDelete(query as CFDictionary) }
        let store = KeychainCredentialStore(service: service, account: account)
        XCTAssertNil(try store.load())
        let user = GitHubIdentity(id: 123, login: "test-user")
        let now = Date(timeIntervalSince1970: 1_700_000_000)
        let first = OAuthToken(accessToken: "synthetic-first", refreshToken: "synthetic-refresh", expiresIn: 3600, refreshTokenExpiresIn: nil)
        try store.save(identity: user, token: first, now: now)
        let stored = try XCTUnwrap(store.load())
        XCTAssertEqual(stored.identity, user)
        XCTAssertEqual(stored.accessToken, "synthetic-first")
        XCTAssertEqual(stored.accessTokenExpiresAt, now.addingTimeInterval(3600))
        let second = OAuthToken(accessToken: "synthetic-second", refreshToken: nil, expiresIn: nil, refreshTokenExpiresIn: nil)
        try store.save(identity: user, token: second, now: now)
        XCTAssertEqual(try store.load()?.accessToken, "synthetic-second")
        try store.remove()
        XCTAssertNil(try store.load())
        try store.remove()
    }
}
