import Foundation
import Testing
@testable import GitHubAPI

struct ProjectWorkArchiveTests {
    @Test func olderRefreshCannotOverwriteNewerContinuation() throws {
        let start = try #require(GitHubOpenContinuation(issueAfter: "one", pullAfter: nil))
        let later = try #require(GitHubOpenContinuation(issueAfter: "two", pullAfter: nil))
        let stale = try #require(GitHubOpenContinuation(issueAfter: "stale", pullAfter: nil))
        let initial = ProjectWorkArchive().applying([.init(id: 1, name: "a", outcome: .received([], complete: false),
            continuationUpdate: .replace(start))], at: .now)
        let afterNew = initial.applying([.init(id: 1, name: "a", outcome: .received([try item("new")], complete: false),
            continuationUpdate: .advance(from: start, to: later))], at: .now)
        let afterStale = afterNew.applying([.init(id: 1, name: "a", outcome: .received([try item("stale")], complete: false),
            continuationUpdate: .advance(from: start, to: stale))], at: .now)
        #expect(afterStale.repositories.first?.openContinuation == later)
        #expect(Set(afterStale.items.map(\.id)) == ["new", "stale"])
    }

    @Test func continuationFollowsItsRepositoryThroughMembershipChanges() throws {
        let cursor = try #require(GitHubOpenContinuation(issueAfter: nil, pullAfter: "next"))
        let initial = ProjectWorkArchive().applying([.init(id: 1, name: "a", outcome: .received([], complete: false),
            continuationUpdate: .replace(cursor)), .init(id: 2, name: "b", outcome: .received([], complete: false))], at: .now)
        let removed = initial.restricting(to: [2])
        #expect(removed.repositories.first?.openContinuation == nil)
        #expect(removed.detachedRepositories?.first?.openContinuation == cursor)
        let restored = try ProjectWorkArchive.decode(JSONEncoder().encode(removed)).restricting(to: [1, 2])
        #expect(restored.repositories.first(where: { $0.id == 1 })?.openContinuation == cursor)
        #expect(restored.repositories.first(where: { $0.id == 2 })?.openContinuation == nil)
    }
    @Test func continuationSurvivesReopenAndUntrackedRefreshButIsClearedByCompleteRefresh() throws {
        let cursor = try #require(GitHubOpenContinuation(issueAfter: nil, pullAfter: "next"))
        let first = ProjectWorkArchive().applying([.init(id: 1, name: "a/b", outcome: .received([], complete: false),
            continuationUpdate: .replace(cursor))], at: .now)
        let reopened = try ProjectWorkArchive.decode(JSONEncoder().encode(first))
        #expect(reopened.repositories.first?.openContinuation == cursor)
        let background = reopened.applying([.init(id: 1, name: "a/b", outcome: .received([], complete: false))], at: .now)
        #expect(background.repositories.first?.openContinuation == cursor)
        let complete = background.applying([.init(id: 1, name: "a/b", outcome: .received([], complete: true))], at: .now)
        #expect(complete.repositories.first?.openContinuation == nil)
    }
    @Test func forgettingOneRepositoryKeepsOtherRepositoryAndInvalidatesCoverage() throws {
        let archive = ProjectWorkArchive().applying([
            .init(id: 1, name: "a/one", outcome: .received([try item("one")], complete: true)),
            .init(id: 2, name: "a/two", outcome: .received([try item("two")], complete: true))
        ], at: .now)
        let updated = try archive.forgetting(repositoryID: 1)
        #expect(updated.items.map(\.id) == ["two"])
        #expect(updated.detachedRepositories?.contains(where: { $0.id == 1 }) != true)
        #expect(!updated.hasCompleteObservation(for: [1, 2]))
        #expect(archive.items.count == 2)
        let detached = archive.restricting(to: [2])
        #expect(detached.detachedRepositories?.contains(where: { $0.id == 1 }) == true)
        let forgotten = try detached.forgetting(repositoryID: 1)
        #expect(forgotten.detachedRepositories?.contains(where: { $0.id == 1 }) != true)
    }

    @Test func forgettingRejectsUnattributedLegacyData() throws {
        let legacy = try ProjectWorkArchive.decode(JSONEncoder().encode([try item("unknown")]))
        #expect(throws: ProjectWorkArchive.RemovalError.unattributedData) { try legacy.forgetting(repositoryID: 1) }
    }
    @Test func repositoryContextIsUnavailableWhenSourceIdentityIsAmbiguous() throws {
        let json = #"{"id":"I1","number":1,"title":"Issue","url":"https://github.com/a/one/issues/1","state":"OPEN","updatedAt":0,"isDraft":false,"kind":"issue"}"#
        let item = try JSONDecoder().decode(GitHubWorkItem.self, from: Data(json.utf8))
        let one = ProjectWorkArchive().applying([
            .init(id: 1, name: "a/one", outcome: .received([item], complete: true))
        ], at: .now)
        #expect(one.repositoryNamesByWorkID["I1"] == "a/one")
        #expect(one.repositoryObservationsByWorkID["I1"]?.id == 1)
        let conflicting = ProjectWorkArchive().applying([
            .init(id: 1, name: "a/one", outcome: .received([item], complete: true)),
            .init(id: 2, name: "a/two", outcome: .received([item], complete: true))
        ], at: .now)
        #expect(conflicting.repositoryNamesByWorkID["I1"] == nil)
        #expect(conflicting.repositoryObservationsByWorkID["I1"] == nil)
    }
    @Test func boundedRefreshPreservesUnvisitedRepositoriesAndTheirObservationTimes() throws {
        let start = Date(timeIntervalSince1970: 100)
        let previous = ProjectWorkArchive().applying([
            .init(id: 1, name: "a/one", outcome: .received([], complete: true), observedAt: start),
            .init(id: 2, name: "a/two", outcome: .received([], complete: true), observedAt: start)
        ], at: start)
        let next = previous.applyingPartial([
            .init(id: 1, name: "a/one", outcome: .failed("Offline"))
        ], in: [1, 2], at: start.addingTimeInterval(10))
        #expect(Set(next.repositories.map(\.id)) == [1, 2])
        #expect(next.repositories.first(where: { $0.id == 1 })?.refreshProblem == "Offline")
        #expect(next.repositories.first(where: { $0.id == 2 })?.observedAt == start)
        #expect(next.repositories.first(where: { $0.id == 2 })?.refreshProblem == nil)
        #expect(next.hasCompleteObservation(for: [1, 2]))
    }
    private func item(_ id: String) throws -> GitHubWorkItem {
        let json = #"{"id":"\#(id)","number":1,"title":"work","url":"https://github.com/a/b/issues/1","state":"OPEN","updatedAt":0,"isDraft":false,"kind":"issue"}"#
        return try JSONDecoder().decode(GitHubWorkItem.self, from: Data(json.utf8))
    }

    @Test func partialFailureKeepsOldFailedRepositoryAndAcceptsOtherUpdate() throws {
        let oldDate = Date(timeIntervalSince1970: 10), newDate = Date(timeIntervalSince1970: 20)
        let initial = ProjectWorkArchive().applying([
            .init(id: 1, name: "a", outcome: .received([try item("a-old")], complete: true)),
            .init(id: 2, name: "b", outcome: .received([try item("b-old")], complete: true))
        ], at: oldDate)
        let updated = initial.applying([
            .init(id: 1, name: "a", outcome: .received([try item("a-new")], complete: true)),
            .init(id: 2, name: "b", outcome: .failed("HTTP 403"))
        ], at: newDate)
        #expect(updated.items.map(\.id) == ["a-new", "b-old"])
        #expect(updated.repositories[0].observedAt == newDate)
        #expect(updated.repositories[1].observedAt == oldDate)
        #expect(updated.repositories[1].refreshProblem == "HTTP 403")
        #expect(updated.coversRepositories([1, 2]))
        #expect(!updated.coversRepositories([1, 2, 3]))
        let restored = try ProjectWorkArchive.decode(JSONEncoder().encode(updated))
        #expect(restored.items.map(\.id) == ["a-new", "b-old"] && restored.hasRefreshProblems)
    }

    @Test func firstFailureIsNotACompleteEmptyObservation() {
        let archive = ProjectWorkArchive().applying([.init(id: 1, name: "a", outcome: .failed("offline"))], at: .now)
        #expect(archive.repositories[0].observedAt == nil)
        #expect(!archive.repositories[0].complete && archive.repositories[0].refreshProblem == "offline")
    }

    @Test func recordsEachRepositoryObservationTimeSeparately() {
        let first = Date(timeIntervalSince1970: 10), second = Date(timeIntervalSince1970: 20)
        let archive = ProjectWorkArchive().applying([
            .init(id: 1, name: "a", outcome: .received([], complete: true), observedAt: first),
            .init(id: 2, name: "b", outcome: .received([], complete: true), observedAt: second)
        ], at: Date(timeIntervalSince1970: 30))
        #expect(archive.repositories[0].observedAt == first)
        #expect(archive.repositories[1].observedAt == second)
    }

    @Test func incompletePageDoesNotEraseEarlierCompleteData() throws {
        let oldDate = Date(timeIntervalSince1970: 10), next = Date(timeIntervalSince1970: 20)
        let old = ProjectWorkArchive().applying([.init(id: 1, name: "a", outcome: .received([try item("old")], complete: true))], at: oldDate)
        let incomplete = old.applying([.init(id: 1, name: "a", outcome: .received([try item("partial")], complete: false))], at: next)
        #expect(Set(incomplete.items.map(\.id)) == ["old", "partial"])
        #expect(incomplete.repositories[0].observedAt == oldDate)
        #expect(incomplete.repositories[0].refreshProblem != nil)
    }

    @Test func incompletePageUpdatesKnownWorkWithoutDiscardingUnobservedWork() throws {
        func issue(_ id: String, state: String, updated: Int) throws -> GitHubWorkItem {
            let json = #"{"id":"\#(id)","number":1,"title":"work","url":"https://github.com/a/b/issues/1","state":"\#(state)","updatedAt":\#(updated),"isDraft":false,"kind":"issue"}"#
            return try JSONDecoder().decode(GitHubWorkItem.self, from: Data(json.utf8))
        }
        let first = Date(timeIntervalSince1970: 100), second = Date(timeIntervalSince1970: 200)
        let previous = ProjectWorkArchive().applying([.init(id: 1, name: "a", outcome: .received([
            try issue("updated", state: "OPEN", updated: 10), try issue("unseen", state: "OPEN", updated: 10)
        ], complete: true))], at: first)
        let refreshed = previous.applying([.init(id: 1, name: "a", outcome: .received([
            try issue("updated", state: "CLOSED", updated: 20), try issue("new", state: "OPEN", updated: 20)
        ], complete: false))], at: second)
        #expect(Set(refreshed.items.map(\.id)) == ["updated", "unseen", "new"])
        #expect(refreshed.items.first { $0.id == "updated" }?.state == "CLOSED")
        #expect(refreshed.repositories[0].observedAt == first)
        #expect(refreshed.repositories[0].refreshProblem != nil)
    }

    @Test func incompletePageDoesNotRegressNewerKnownObject() throws {
        func issue(state: String, updated: Int) throws -> GitHubWorkItem {
            let json = #"{"id":"I1","number":1,"title":"work","url":"https://github.com/a/b/issues/1","state":"\#(state)","updatedAt":\#(updated),"isDraft":false,"kind":"issue"}"#
            return try JSONDecoder().decode(GitHubWorkItem.self, from: Data(json.utf8))
        }
        let old = ProjectWorkArchive().applying([.init(id: 1, name: "a", outcome: .received([try issue(state: "CLOSED", updated: 20)], complete: true))], at: .now)
        let partial = old.applying([.init(id: 1, name: "a", outcome: .received([try issue(state: "OPEN", updated: 10)], complete: false))], at: .now)
        #expect(partial.items.first?.state == "CLOSED")
    }

    @Test func removedRepositoryIsRetainedAndCanBeRestoredOffline() throws {
        let date = Date(timeIntervalSince1970: 10)
        let initial = ProjectWorkArchive().applying([
            .init(id: 1, name: "a", outcome: .received([try item("a")], complete: true)),
            .init(id: 2, name: "b", outcome: .received([try item("b")], complete: true))
        ], at: date)
        let removed = initial.restricting(to: [1])
        #expect(!removed.hasCompleteObservation(for: [1]))
        #expect(removed.items.map(\.id) == ["a"])
        #expect(removed.detachedRepositories?.first?.items.first?.id == "b")
        let persisted = try ProjectWorkArchive.decode(JSONEncoder().encode(removed))
        let refreshed = persisted.applying([.init(id: 1, name: "a", outcome: .received([try item("new-a")], complete: true))], at: .now)
        #expect(refreshed.hasCompleteObservation(for: [1]))
        #expect(refreshed.detachedRepositories?.first?.items.first?.id == "b")
        let restored = refreshed.restricting(to: [1, 2])
        #expect(restored.items.map(\.id) == ["new-a", "b"])
        #expect(!restored.hasCompleteObservation(for: [1, 2]))
        #expect(restored.repositories[1].observedAt == date)
    }

    @Test func detailsSurviveRefreshOnlyForTheSamePullRequestRevision() throws {
        func pull(_ head: String) throws -> GitHubWorkItem {
            let json = #"{"id":"P1","number":1,"title":"work","url":"https://github.com/a/b/pull/1","state":"OPEN","updatedAt":0,"isDraft":false,"kind":"pullRequest","headRevision":"\#(head)"}"#
            return try JSONDecoder().decode(GitHubWorkItem.self, from: Data(json.utf8))
        }
        let details = GitHubWorkDetails(body: "Description", createdAt: nil, author: nil, labels: nil, labelsComplete: nil,
            headBranch: nil, baseBranch: nil, headRepository: nil, baseRepository: nil,
            additions: nil, deletions: nil, changedFiles: nil, commits: nil, issueRelationships: nil, issueContext: nil, observedAt: Date(timeIntervalSince1970: 20))
        var archive = ProjectWorkArchive().applying([.init(id: 1, name: "a", outcome: .received([try pull("abc")], complete: true))], at: .now)
        let didUpdate = archive.updateDetails(itemID: "P1", head: "abc", details: details)
        #expect(didUpdate)
        let sameHead = archive.applying([.init(id: 1, name: "a", outcome: .received([try pull("abc")], complete: true))], at: .now)
        let persisted = try ProjectWorkArchive.decode(JSONEncoder().encode(sameHead))
        #expect(persisted.items.first?.details?.body == "Description")
        let partialSameHead = persisted.applying([.init(id: 1, name: "a", outcome: .received([try pull("abc")], complete: false))], at: .now)
        #expect(partialSameHead.items.first?.details?.body == "Description")
        let partialNewHead = persisted.applying([.init(id: 1, name: "a", outcome: .received([try pull("def")], complete: false))], at: .now)
        #expect(partialNewHead.items.first?.details == nil)
        let newHead = persisted.applying([.init(id: 1, name: "a", outcome: .received([try pull("def")], complete: true))], at: .now)
        #expect(newHead.items.first?.details == nil)
    }

    @Test func legacyDataSurvivesPartialAndGoesAwayAfterCompleteRefresh() throws {
        let legacy = try ProjectWorkArchive.decode(JSONEncoder().encode([try item("old")]))
        #expect(!legacy.coversRepositories([1]))
        let partial = legacy.applying([.init(id: 1, name: "a", outcome: .failed("offline"))], at: .now)
        #expect(partial.items.map(\.id) == ["old"])
        let complete = partial.applying([.init(id: 1, name: "a", outcome: .received([try item("new")], complete: true))], at: .now)
        #expect(complete.items.map(\.id) == ["new"] && complete.legacyItems.isEmpty)
        #expect(complete.retainedLegacyItems?.first?.id == "old")
    }
}
