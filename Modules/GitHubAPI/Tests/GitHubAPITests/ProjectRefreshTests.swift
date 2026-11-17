import Foundation
import Testing
@testable import GitHubAPI

private actor RequestLog {
    private(set) var ids: [Int64] = []
    func record(_ id: Int64) { ids.append(id) }
}

struct ProjectRefreshTests {
    @Test func collectsIndependentResultsAndKeepsFailuresVisible() async throws {
        let log = RequestLog()
        let service = GitHubProjectRefresh { _, repository in
            await log.record(repository.id)
            if repository.id == 2 { throw WorkFetchError.httpStatus(403) }
            return GitHubWorkPage(items: [], isIncomplete: repository.id == 3, observedRepository: nil, issueCursor: nil, pullCursor: nil)
        }
        let repositories = (1...3).map { RefreshRepository(id: Int64($0), fullName: "example/\($0)", nodeID: nil) }
        let result = try await service.fetch(token: "token", repositories: repositories)
        #expect(await log.ids == [1, 2, 3])
        #expect(result.observations.map(\.id) == [1, 2, 3])
        if case .received(_, let complete) = result.observations[0].outcome { #expect(complete) }
        else { Issue.record("First repository should be complete") }
        if case .failed(let message) = result.observations[1].outcome { #expect(message == "GitHub HTTP 403") }
        else { Issue.record("A failed repository must remain visible") }
        if case .received(_, let complete) = result.observations[2].outcome { #expect(!complete) }
        else { Issue.record("Partial result should remain partial") }
    }

    @Test func cancellationStopsTheWholeRefresh() async throws {
        let log = RequestLog()
        let service = GitHubProjectRefresh { _, repository in
            await log.record(repository.id)
            throw CancellationError()
        }
        let repositories = (1...2).map { RefreshRepository(id: Int64($0), fullName: "example/\($0)", nodeID: nil) }
        await #expect(throws: CancellationError.self) { try await service.fetch(token: "token", repositories: repositories) }
        #expect(await log.ids == [1])
    }
}
