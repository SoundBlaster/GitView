import Foundation
import Testing
@testable import WorkCache

@MainActor struct WorkCacheTests {
    @Test func enrichesPartialSnapshotWithoutClaimingNewProjectObservation() throws {
        let cache = try WorkCache(inMemory: true)
        let id = UUID()
        let date = Date(timeIntervalSince1970: 1000)
        try cache.save(accountID: 1, projectID: id, payload: Data("old".utf8), observedAt: date, complete: false)
        let snapshot = try #require(try cache.load(accountID: 1, projectID: id))
        #expect(try cache.replacePayload(accountID: 1, projectID: id, expected: snapshot, payload: Data("enriched".utf8)))
        let updated = try #require(try cache.load(accountID: 1, projectID: id))
        #expect(updated.payload == Data("enriched".utf8))
        #expect(updated.observedAt == date && !updated.complete)
        #expect(try !cache.replacePayload(accountID: 1, projectID: id, expected: snapshot, payload: Data("stale".utf8)))
    }

    @Test func enrichmentDoesNotOverwriteAnotherStoreUpdate() throws {
        let directory = FileManager.default.temporaryDirectory.appendingPathComponent(UUID().uuidString, isDirectory: true)
        try FileManager.default.createDirectory(at: directory, withIntermediateDirectories: true)
        defer { try? FileManager.default.removeItem(at: directory) }
        let url = directory.appendingPathComponent("cache.sqlite")
        let id = UUID()
        let first = try WorkCache(url: url)
        let second = try WorkCache(url: url)
        try first.save(accountID: 1, projectID: id, payload: Data("old".utf8), observedAt: Date(timeIntervalSince1970: 10), complete: true)
        let old = try #require(try first.load(accountID: 1, projectID: id))
        try second.save(accountID: 1, projectID: id, payload: Data("new".utf8), observedAt: Date(timeIntervalSince1970: 20), complete: true)
        #expect(try !first.replacePayload(accountID: 1, projectID: id, expected: old, payload: Data("stale".utf8)))
        #expect(try first.load(accountID: 1, projectID: id)?.payload == Data("new".utf8))
    }
    @Test func completeSnapshotSurvivesPartialRefreshAndIsAccountScoped() throws {
        let cache = try WorkCache(inMemory: true)
        let project = UUID()
        let date = Date(timeIntervalSince1970: 1000)
        try cache.save(accountID: 1, projectID: project, payload: Data("complete".utf8), observedAt: date, complete: true)
        try cache.save(accountID: 1, projectID: project, payload: Data("partial".utf8), observedAt: date.addingTimeInterval(100), complete: false)
        let saved = try #require(try cache.load(accountID: 1, projectID: project))
        #expect(saved.payload == Data("complete".utf8))
        #expect(saved.observedAt == date)
        #expect(saved.complete)
        #expect(try cache.load(accountID: 2, projectID: project) == nil)
    }

    @Test func olderCompleteSnapshotCannotReplaceNewer() throws {
        let cache = try WorkCache(inMemory: true)
        let id = UUID()
        try cache.save(accountID: 1, projectID: id, payload: Data("new".utf8), observedAt: Date(timeIntervalSince1970: 20), complete: true)
        try cache.save(accountID: 1, projectID: id, payload: Data("old".utf8), observedAt: Date(timeIntervalSince1970: 10), complete: true)
        #expect(try cache.load(accountID: 1, projectID: id)?.payload == Data("new".utf8))
    }

    @Test func partialFirstSnapshotIsRetainedWithItsCoverage() throws {
        let cache = try WorkCache(inMemory: true)
        let id = UUID()
        try cache.save(accountID: 1, projectID: id, payload: Data("partial".utf8), observedAt: .now, complete: false)
        #expect(try cache.load(accountID: 1, projectID: id)?.complete == false)
    }

    @Test func sqliteSnapshotSurvivesReopen() throws {
        let directory = FileManager.default.temporaryDirectory.appendingPathComponent(UUID().uuidString, isDirectory: true)
        try FileManager.default.createDirectory(at: directory, withIntermediateDirectories: true)
        defer { try? FileManager.default.removeItem(at: directory) }
        let url = directory.appendingPathComponent("cache.sqlite")
        let id = UUID()
        let one = try WorkCache(url: url)
        try one.save(accountID: 1, projectID: id, payload: Data("saved".utf8), observedAt: .now, complete: true)
        let two = try WorkCache(url: url)
        #expect(try two.load(accountID: 1, projectID: id)?.payload == Data("saved".utf8))
    }
}
