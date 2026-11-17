import Foundation
import Testing
@testable import GitHubAPI

struct ProjectWorkArchiveTests {
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
        let restored = try ProjectWorkArchive.decode(JSONEncoder().encode(updated))
        #expect(restored.items.map(\.id) == ["a-new", "b-old"] && restored.hasRefreshProblems)
    }

    @Test func firstFailureIsNotACompleteEmptyObservation() {
        let archive = ProjectWorkArchive().applying([.init(id: 1, name: "a", outcome: .failed("offline"))], at: .now)
        #expect(archive.repositories[0].observedAt == nil)
        #expect(!archive.repositories[0].complete && archive.repositories[0].refreshProblem == "offline")
    }

    @Test func incompletePageDoesNotEraseEarlierCompleteData() throws {
        let oldDate = Date(timeIntervalSince1970: 10), next = Date(timeIntervalSince1970: 20)
        let old = ProjectWorkArchive().applying([.init(id: 1, name: "a", outcome: .received([try item("old")], complete: true))], at: oldDate)
        let incomplete = old.applying([.init(id: 1, name: "a", outcome: .received([try item("partial")], complete: false))], at: next)
        #expect(incomplete.items.map(\.id) == ["old"])
        #expect(incomplete.repositories[0].observedAt == oldDate)
        #expect(incomplete.repositories[0].refreshProblem != nil)
    }

    @Test func legacyDataSurvivesPartialAndGoesAwayAfterCompleteRefresh() throws {
        let legacy = try ProjectWorkArchive.decode(JSONEncoder().encode([try item("old")]))
        let partial = legacy.applying([.init(id: 1, name: "a", outcome: .failed("offline"))], at: .now)
        #expect(partial.items.map(\.id) == ["old"])
        let complete = partial.applying([.init(id: 1, name: "a", outcome: .received([try item("new")], complete: true))], at: .now)
        #expect(complete.items.map(\.id) == ["new"] && complete.legacyItems.isEmpty)
    }
}
