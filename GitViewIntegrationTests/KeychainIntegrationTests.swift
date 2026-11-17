import Foundation
import GitHubAuth
import GitHubAPI
import ProjectStore
import Security
import WorkCache
import XCTest
@testable import GitView

@MainActor final class ProjectRefreshPersistenceTests: XCTestCase {
    func testBoundedRefreshKeepsUnvisitedRepositoryAndProjectTimestamp() throws {
        let cache = try WorkCache(inMemory: true)
        let projectID = UUID()
        let time = Date(timeIntervalSince1970: 1_000)
        let original = ProjectWorkArchive().applying([
            .init(id: 1, name: "owner/one", outcome: .received([], complete: true), observedAt: time),
            .init(id: 2, name: "owner/two", outcome: .received([], complete: true), observedAt: time)
        ], at: time)
        try cache.save(accountID: 1, projectID: projectID, payload: JSONEncoder().encode(original), observedAt: time, complete: true)
        let result = try ProjectRefreshPersistence.commit(cache: cache, accountID: 1, projectID: projectID,
            observations: [.init(id: 1, name: "owner/one", outcome: .received([], complete: true), observedAt: time.addingTimeInterval(10))],
            fallback: nil, at: time.addingTimeInterval(10), scope: [1, 2])
        XCTAssertTrue(result.saved)
        XCTAssertFalse(result.complete)
        let stored = try XCTUnwrap(cache.load(accountID: 1, projectID: projectID))
        XCTAssertEqual(stored.observedAt, time)
        let archive = try ProjectWorkArchive.decode(stored.payload)
        XCTAssertEqual(archive.repositories.first(where: { $0.id == 1 })?.observedAt, time.addingTimeInterval(10))
        XCTAssertEqual(archive.repositories.first(where: { $0.id == 2 })?.observedAt, time)
    }

    func testBackgroundRefreshRotatesRepositoryBatches() async throws {
        let library = try ProjectLibrary(accountID: 1, store: ProjectStore(inMemory: true))
        try library.create(name: "Test", repository: RepositoryReference(id: 1, fullName: "owner/one", isPrivate: false))
        let id = try XCTUnwrap(library.projects.first?.id)
        for index in 2...4 { try library.add(repository: RepositoryReference(id: Int64(index), fullName: "owner/\(index)", isPrivate: false), to: id) }
        let project = try XCTUnwrap(library.projects.first)
        var fetched: [[Int64]] = []
        let coordinator = BackgroundRefreshCoordinator(session: { .init(accountID: 1, token: "token", expiresAt: nil) },
            projects: { _ in [project] }, fetch: { _, repositories in
                fetched.append(repositories.map(\.id))
                return repositories.map { .init(id: $0.id, name: $0.fullName, outcome: .received([], complete: true)) }
            }, save: { _, _ in })
        let first = try await coordinator.run(after: nil)
        let second = try await coordinator.run(after: nil, repositoryAfter: { _ in 3 })
        XCTAssertEqual(first, .updated(id, lastRepository: 3))
        XCTAssertEqual(second, .updated(id, lastRepository: 4))
        XCTAssertEqual(fetched, [[1, 2, 3], [4]])
    }

    func testBackgroundRefreshDoesNotSaveAfterAccountChange() async throws {
        let library = try ProjectLibrary(accountID: 1, store: ProjectStore(inMemory: true))
        try library.create(name: "Test", repository: RepositoryReference(id: 1, fullName: "owner/repo", isPrivate: true))
        let project = try XCTUnwrap(library.projects.first)
        var session: BackgroundRefreshSession? = .init(accountID: 1, token: "first", expiresAt: nil)
        var saved = false
        let coordinator = BackgroundRefreshCoordinator(session: { session }, projects: { _ in [project] },
            fetch: { _, _ in
                session = .init(accountID: 2, token: "second", expiresAt: nil)
                return []
            }, save: { _, _ in saved = true })
        let result = try await coordinator.run(after: nil)
        XCTAssertEqual(result, .superseded)
        XCTAssertFalse(saved)
    }

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
