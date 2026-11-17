import Foundation
import GitHubAuth
import Security
import XCTest

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
    }
}
