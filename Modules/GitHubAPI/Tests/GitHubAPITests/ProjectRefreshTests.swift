import Foundation
import Testing
@testable import GitHubAPI

private actor RequestLog {
    private(set) var ids: [Int64] = []
    func record(_ id: Int64) { ids.append(id) }
}

struct ProjectRefreshTests {
    @Test func trackedRefreshAdvancesOnlyFromItsOwnStartingCursor() async throws {
        let original = try #require(GitHubOpenContinuation(issueAfter: "old", pullAfter: nil))
        let next = try #require(GitHubOpenContinuation(issueAfter: "next", pullAfter: nil))
        let concurrent = try #require(GitHubOpenContinuation(issueAfter: "other", pullAfter: nil))
        let service = GitHubProjectRefresh(tracksOpenContinuation: true, continuations: [1: original]) { _, _ in
            GitHubWorkPage(items: [], isIncomplete: true, observedRepository: nil, issueCursor: nil, pullCursor: nil, openContinuation: next)
        }
        let result = try await service.fetch(token: "token", repositories: [.init(id: 1, fullName: "a/b", nodeID: nil)])
        let initial = ProjectWorkArchive().applying([.init(id: 1, name: "a/b", outcome: .received([], complete: false),
            continuationUpdate: .replace(original))], at: .now)
        #expect(initial.applying(result.observations, at: .now).repositories.first?.openContinuation == next)
        let newer = initial.applying([.init(id: 1, name: "a/b", outcome: .received([], complete: false),
            continuationUpdate: .replace(concurrent))], at: .now)
        #expect(newer.applying(result.observations, at: .now).repositories.first?.openContinuation == concurrent)
    }
    @Test func laterPageFailureKeepsFetchedWorkAndExplainsTheFailure() async throws {
        let client = GitHubWorkClient { request in
            let body = try JSONSerialization.jsonObject(with: request.httpBody!) as! [String: Any]
            let variables = body["variables"] as! [String: Any]
            if variables["pullAfter"] != nil {
                return (Data(), HTTPURLResponse(url: request.url!, statusCode: 503, httpVersion: nil, headerFields: nil)!)
            }
            let json = #"{"data":{"repository":{"databaseId":42,"issues":{"nodes":[],"pageInfo":{"hasNextPage":false}},"pullRequests":{"nodes":[{"id":"P1","number":1,"title":"First","url":"https://github.com/a/b/pull/1","state":"OPEN","updatedAt":"2026-11-17T10:00:00Z"}],"pageInfo":{"hasNextPage":true,"endCursor":"next"}}}}}"#
            return (Data(json.utf8), HTTPURLResponse(url: request.url!, statusCode: 200, httpVersion: nil, headerFields: nil)!)
        }
        let service = GitHubProjectRefresh { token, repository in
            try await client.load(token: token, repositoryID: repository.id, fullName: repository.fullName)
        }
        let result = try await service.fetch(token: "token", repositories: [.init(id: 42, fullName: "a/b", nodeID: nil)])
        let prior = #"{"id":"P0","number":2,"title":"Earlier","url":"https://github.com/a/b/pull/2","state":"OPEN","updatedAt":0,"isDraft":false,"kind":"pullRequest"}"#
        let saved = try JSONDecoder().decode(GitHubWorkItem.self, from: Data(prior.utf8))
        let previous = ProjectWorkArchive().applying([.init(id: 42, name: "a/b", outcome: .received([saved], complete: true))], at: .distantPast)
        let archive = previous.applying(result.observations, at: .now)
        #expect(Set(archive.items.map(\.id)) == ["P0", "P1"])
        #expect(archive.repositories.first?.refreshProblem?.contains("503") == true)
        #expect(archive.repositories.first?.observedAt == .distantPast)
        #expect(archive.hasRefreshProblems)
    }

    @Test(arguments: [true, false]) func laterPageCancellationOrIdentityMismatchDoesNotCommitPartialWork(cancelled: Bool) async throws {
        let client = GitHubWorkClient { request in
            let body = try JSONSerialization.jsonObject(with: request.httpBody!) as! [String: Any]
            let variables = body["variables"] as! [String: Any]
            if variables["pullAfter"] != nil {
                if cancelled { throw CancellationError() }
                let json = #"{"data":{"repository":{"databaseId":99,"pullRequests":{"nodes":[],"pageInfo":{"hasNextPage":false}}}}}"#
                return (Data(json.utf8), HTTPURLResponse(url: request.url!, statusCode: 200, httpVersion: nil, headerFields: nil)!)
            }
            let json = #"{"data":{"repository":{"databaseId":42,"issues":{"nodes":[],"pageInfo":{"hasNextPage":false}},"pullRequests":{"nodes":[],"pageInfo":{"hasNextPage":true,"endCursor":"next"}}}}}"#
            return (Data(json.utf8), HTTPURLResponse(url: request.url!, statusCode: 200, httpVersion: nil, headerFields: nil)!)
        }
        if cancelled {
            await #expect(throws: CancellationError.self) { try await client.load(token: "token", repositoryID: 42, fullName: "a/b") }
        } else {
            await #expect(throws: WorkFetchError.repositoryIdentityMismatch) { try await client.load(token: "token", repositoryID: 42, fullName: "a/b") }
        }
    }
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
