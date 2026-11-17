import Foundation
import BackgroundTasks
import GitHubAuth
import GitHubAPI
import ProjectStore
import Security
import WorkCache
import XCTest
@testable import GitView

@MainActor final class ProjectRefreshPersistenceTests: XCTestCase {
    func testEraseSavedWorkIsScopedToOneProjectAndPausesSync() throws {
        let library = try ProjectLibrary(accountID: 1, store: ProjectStore(inMemory: true))
        let repository = RepositoryReference(id: 1, fullName: "owner/repo", isPrivate: true)
        try library.create(name: "First", repository: repository)
        try library.create(name: "Second", repository: repository)
        let first = try XCTUnwrap(library.projects.first { $0.name == "First" })
        let second = try XCTUnwrap(library.projects.first { $0.name == "Second" })
        let cache = try WorkCache(inMemory: true)
        let json = #"{"id":"I1","number":1,"title":"saved","url":"https://github.com/a/b/issues/1","state":"OPEN","updatedAt":0,"isDraft":false,"kind":"issue"}"#
        let item = try JSONDecoder().decode(GitHubWorkItem.self, from: Data(json.utf8))
        let archive = ProjectWorkArchive().applying([.init(id: 1, name: "owner/repo", outcome: .received([item], complete: true))], at: .now)
        for project in [first, second] { try cache.save(accountID: 1, projectID: project.id, payload: JSONEncoder().encode(archive), observedAt: .now, complete: true) }
        try library.eraseSavedWork(repositoryID: 1, from: first.id, cache: cache)
        let firstSnapshot = try XCTUnwrap(cache.load(accountID: 1, projectID: first.id))
        let secondSnapshot = try XCTUnwrap(cache.load(accountID: 1, projectID: second.id))
        XCTAssertTrue(try ProjectWorkArchive.decode(firstSnapshot.payload).items.isEmpty)
        XCTAssertEqual(try ProjectWorkArchive.decode(secondSnapshot.payload).items.count, 1)
        XCTAssertTrue(try XCTUnwrap(library.projects.first { $0.id == first.id }?.repositories.first).syncPaused)
        XCTAssertFalse(try XCTUnwrap(library.projects.first { $0.id == second.id }?.repositories.first).syncPaused)
        try library.setSyncPaused(false, repositoryID: 1, projectID: first.id)
        XCTAssertFalse(try XCTUnwrap(library.projects.first { $0.id == first.id }?.repositories.first).syncPaused)
        XCTAssertTrue(try ProjectWorkArchive.decode(XCTUnwrap(cache.load(accountID: 1, projectID: first.id)).payload).items.isEmpty)
    }

    func testEraseDoesNotPauseOrDiscardUnattributedData() throws {
        let library = try ProjectLibrary(accountID: 1, store: ProjectStore(inMemory: true))
        try library.create(name: "First", repository: .init(id: 1, fullName: "owner/repo", isPrivate: true))
        let project = try XCTUnwrap(library.projects.first)
        let cache = try WorkCache(inMemory: true)
        let json = #"[{"id":"I1","number":1,"title":"saved","url":"https://github.com/a/b/issues/1","state":"OPEN","updatedAt":0,"isDraft":false,"kind":"issue"}]"#
        try cache.save(accountID: 1, projectID: project.id, payload: Data(json.utf8), observedAt: .now, complete: false)
        XCTAssertThrowsError(try library.eraseSavedWork(repositoryID: 1, from: project.id, cache: cache))
        XCTAssertFalse(try XCTUnwrap(library.projects.first?.repositories.first).syncPaused)
        XCTAssertEqual(try cache.load(accountID: 1, projectID: project.id)?.payload, Data(json.utf8))
    }
    func testOverviewRefreshReusesRepositoryAcrossProjects() async throws {
        let library = try ProjectLibrary(accountID: 1, store: ProjectStore(inMemory: true))
        let repo = RepositoryReference(id: 1, fullName: "owner/repo", isPrivate: false)
        try library.create(name: "First", repository: repo)
        try library.create(name: "Second", repository: repo)
        var fetched: [Int64] = []
        var saved: [UUID] = []
        let coordinator = ForegroundOverviewRefreshCoordinator(
            projects: { library.projects }, isCurrent: { true }, needsRefresh: { _ in true },
            fetch: { repository in
                fetched.append(repository.id)
                return .init(id: repository.id, name: repository.fullName, outcome: .received([], complete: true))
            }, save: { project, _ in saved.append(project.id) })
        try await coordinator.run()
        XCTAssertEqual(fetched, [1])
        XCTAssertEqual(Set(saved), Set(library.projects.map(\.id)))
    }

    func testOverviewRefreshDoesNotSaveAfterAccountChange() async throws {
        let library = try ProjectLibrary(accountID: 1, store: ProjectStore(inMemory: true))
        try library.create(name: "First", repository: RepositoryReference(id: 1, fullName: "owner/repo", isPrivate: true))
        var current = true
        var saved = false
        let coordinator = ForegroundOverviewRefreshCoordinator(
            projects: { library.projects }, isCurrent: { current }, needsRefresh: { _ in true },
            fetch: { repository in
                current = false
                return .init(id: repository.id, name: repository.fullName, outcome: .received([], complete: true))
            }, save: { _, _ in saved = true })
        try await coordinator.run()
        XCTAssertFalse(saved)
    }

    func testOverviewRefreshDoesNotSaveForChangedMembership() async throws {
        let library = try ProjectLibrary(accountID: 1, store: ProjectStore(inMemory: true))
        try library.create(name: "First", repository: RepositoryReference(id: 1, fullName: "owner/one", isPrivate: false))
        let id = try XCTUnwrap(library.projects.first?.id)
        var saved = false
        let coordinator = ForegroundOverviewRefreshCoordinator(
            projects: { library.projects }, isCurrent: { true }, needsRefresh: { _ in true },
            fetch: { repository in
                try library.add(repository: RepositoryReference(id: 2, fullName: "owner/two", isPrivate: false), to: id)
                return .init(id: repository.id, name: repository.fullName, outcome: .received([], complete: true))
            }, save: { _, _ in saved = true })
        try await coordinator.run()
        XCTAssertFalse(saved)
    }

    func testOverviewRefreshSkipsPausedRepository() async throws {
        let library = try ProjectLibrary(accountID: 1, store: ProjectStore(inMemory: true))
        try library.create(name: "First", repository: .init(id: 1, fullName: "owner/one", isPrivate: true))
        let id = try XCTUnwrap(library.projects.first?.id)
        try library.add(repository: .init(id: 2, fullName: "owner/two", isPrivate: false), to: id)
        try library.setSyncPaused(true, repositoryID: 1, projectID: id)
        var fetched: [Int64] = []
        let coordinator = ForegroundOverviewRefreshCoordinator(projects: { library.projects }, isCurrent: { true }, needsRefresh: { _ in true },
            fetch: { repository in
                fetched.append(repository.id)
                return .init(id: repository.id, name: repository.fullName, outcome: .received([], complete: true))
            }, save: { _, _ in })
        try await coordinator.run()
        XCTAssertEqual(fetched, [2])
    }

    func testOverviewRefreshDoesNotSaveAfterPauseDuringFetch() async throws {
        let library = try ProjectLibrary(accountID: 1, store: ProjectStore(inMemory: true))
        try library.create(name: "First", repository: .init(id: 1, fullName: "owner/one", isPrivate: true))
        let id = try XCTUnwrap(library.projects.first?.id)
        var saved = false
        let coordinator = ForegroundOverviewRefreshCoordinator(projects: { library.projects }, isCurrent: { true }, needsRefresh: { _ in true },
            fetch: { repository in
                try library.setSyncPaused(true, repositoryID: repository.id, projectID: id)
                return .init(id: repository.id, name: repository.fullName, outcome: .received([], complete: true))
            }, save: { _, _ in saved = true })
        try await coordinator.run()
        XCTAssertFalse(saved)
    }

    func testBackgroundRefreshSkipsPausedRepository() async throws {
        let library = try ProjectLibrary(accountID: 1, store: ProjectStore(inMemory: true))
        try library.create(name: "First", repository: .init(id: 1, fullName: "owner/one", isPrivate: true))
        let id = try XCTUnwrap(library.projects.first?.id)
        try library.add(repository: .init(id: 2, fullName: "owner/two", isPrivate: false), to: id)
        try library.setSyncPaused(true, repositoryID: 1, projectID: id)
        var fetched: [Int64] = []
        let coordinator = BackgroundRefreshCoordinator(session: { .init(accountID: 1, token: "token", expiresAt: nil) },
            projects: { _ in library.projects }, fetch: { _, repositories in
                fetched = repositories.map(\.id)
                return repositories.map { .init(id: $0.id, name: $0.fullName, outcome: .received([], complete: true)) }
            }, save: { _, _ in })
        let outcome = try await coordinator.run(after: nil)
        XCTAssertEqual(fetched, [2])
        XCTAssertEqual(outcome, .updated(id, lastRepository: 2))
    }
    func testBackgroundRefreshConfiguration() {
        let modes = Bundle.main.object(forInfoDictionaryKey: "UIBackgroundModes") as? [String] ?? []
        let identifiers = Bundle.main.object(forInfoDictionaryKey: "BGTaskSchedulerPermittedIdentifiers") as? [String] ?? []
        XCTAssertTrue(modes.contains("fetch"))
        XCTAssertTrue(identifiers.contains(BackgroundRefreshRuntime.identifier))
    }

    func testBackgroundRefreshRequestIsRegistered() async throws {
        #if targetEnvironment(simulator)
        throw XCTSkip("BGTaskScheduler is unavailable on Simulator; verify registration on a device.")
        #else
        let identifier = BackgroundRefreshRuntime.identifier
        BGTaskScheduler.shared.cancel(taskRequestWithIdentifier: identifier)
        defer { BGTaskScheduler.shared.cancel(taskRequestWithIdentifier: identifier) }
        do { try BGTaskScheduler.shared.submit(BGAppRefreshTaskRequest(identifier: identifier)) }
        catch { XCTFail("Could not schedule background refresh: \(error)"); return }
        let isPending = await withCheckedContinuation { continuation in
            BGTaskScheduler.shared.getPendingTaskRequests { requests in
                continuation.resume(returning: requests.contains { $0.identifier == identifier })
            }
        }
        XCTAssertTrue(isPending)
        #endif
    }

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

    func testPartialPagePersistsNewWorkAlongsideSavedWork() throws {
        func issue(_ id: String) throws -> GitHubWorkItem {
            let json = #"{"id":"\#(id)","number":1,"title":"work","url":"https://github.com/a/b/issues/1","state":"OPEN","updatedAt":0,"isDraft":false,"kind":"issue"}"#
            return try JSONDecoder().decode(GitHubWorkItem.self, from: Data(json.utf8))
        }
        let cache = try WorkCache(inMemory: true)
        let project = UUID(), originalTime = Date(timeIntervalSince1970: 1_000)
        let original = ProjectWorkArchive().applying([
            .init(id: 1, name: "owner/repo", outcome: .received([try issue("old")], complete: true))
        ], at: originalTime)
        try cache.save(accountID: 1, projectID: project, payload: JSONEncoder().encode(original), observedAt: originalTime, complete: true)
        let result = try ProjectRefreshPersistence.commit(cache: cache, accountID: 1, projectID: project,
            observations: [.init(id: 1, name: "owner/repo", outcome: .received([try issue("new")], complete: false))],
            fallback: nil, at: originalTime.addingTimeInterval(10))
        XCTAssertTrue(result.saved)
        XCTAssertFalse(result.complete)
        let snapshot = try XCTUnwrap(cache.load(accountID: 1, projectID: project))
        XCTAssertEqual(snapshot.observedAt, originalTime)
        let restored = try ProjectWorkArchive.decode(snapshot.payload)
        XCTAssertEqual(Set(restored.items.map(\.id)), ["old", "new"])
        XCTAssertNotNil(restored.repositories.first?.refreshProblem)
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
