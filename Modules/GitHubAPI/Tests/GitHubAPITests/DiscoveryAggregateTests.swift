import Foundation
import Testing
@testable import GitHubAPI

struct DiscoveryAggregateTests {
    @Test func aggregatesAndDeduplicatesAcrossInstallations() async throws {
        let client = GitHubDiscoveryClient { request in
            let path = request.url!.path
            let json: String
            if path == "/user/installations" { json = #"{"total_count":2,"installations":[{"id":1},{"id":2}]}"# }
            else if path.contains("/1/") { json = #"{"total_count":2,"repositories":[{"id":3,"full_name":"a/r","private":true},{"id":4,"full_name":"a/s","private":false}]}"# }
            else { json = #"{"total_count":1,"repositories":[{"id":3,"full_name":"a/r","private":true}]}"# }
            return (Data(json.utf8), HTTPURLResponse(url: request.url!, statusCode: 200, httpVersion: nil, headerFields: nil)!)
        }
        let result = try await GitHubDiscovery(client: client).load(token: "token")
        #expect(result.repositories.map(\.id) == [3, 4])
        #expect(result.failures.isEmpty)
    }

    @Test func failureKeepsOtherInstallationResultsAndMarksIncomplete() async throws {
        let client = GitHubDiscoveryClient { request in
            let path = request.url!.path
            if path.contains("/2/") { return (Data(), HTTPURLResponse(url: request.url!, statusCode: 403, httpVersion: nil, headerFields: nil)!) }
            let json = path == "/user/installations" ? #"{"total_count":2,"installations":[{"id":1},{"id":2}]}"# : #"{"total_count":1,"repositories":[{"id":3,"full_name":"a/r","private":false}]}"#
            return (Data(json.utf8), HTTPURLResponse(url: request.url!, statusCode: 200, httpVersion: nil, headerFields: nil)!)
        }
        let result = try await GitHubDiscovery(client: client).load(token: "token")
        #expect(result.repositories.map(\.id) == [3])
        #expect(result.failures == [.repositoryPage(installationID: 2, page: 1)])
        #expect(!result.isComplete)
    }

    @Test func followsEachPageAndDetectsMissingCoverage() async throws {
        let client = GitHubDiscoveryClient { request in
            let path = request.url!.path
            let page = URLComponents(url: request.url!, resolvingAgainstBaseURL: false)!.queryItems!.first(where: { $0.name == "page" })!.value!
            if path == "/user/installations" {
                let json = page == "1" ? #"{"total_count":2,"installations":[{"id":1}]}"# : #"{"total_count":2,"installations":[{"id":2}]}"#
                let headers = page == "1" ? ["Link": "<https://api.github.com/user/installations?page=2>; rel=\"next\""] : [:]
                return (Data(json.utf8), HTTPURLResponse(url: request.url!, statusCode: 200, httpVersion: nil, headerFields: headers)!)
            }
            let json = #"{"total_count":2,"repositories":[{"id":3,"full_name":"a/r","private":false}]}"#
            return (Data(json.utf8), HTTPURLResponse(url: request.url!, statusCode: 200, httpVersion: nil, headerFields: nil)!)
        }
        let result = try await GitHubDiscovery(client: client).load(token: "token")
        #expect(result.repositories.map(\.id) == [3])
        #expect(result.failures == [.incompleteRepositories(installationID: 1), .incompleteRepositories(installationID: 2)])
    }

    @Test func cancellationIsNotReportedAsPartialSuccess() async throws {
        let client = GitHubDiscoveryClient { _ in throw CancellationError() }
        await #expect(throws: CancellationError.self) { try await GitHubDiscovery(client: client).load(token: "token") }
    }

    @Test func failedFirstInstallationPageIsNotAnEmptySuccess() async throws {
        let client = GitHubDiscoveryClient { request in
            (Data(), HTTPURLResponse(url: request.url!, statusCode: 500, httpVersion: nil, headerFields: nil)!)
        }
        let result = try await GitHubDiscovery(client: client).load(token: "token")
        #expect(result.failures == [.installationPage(1)])
        #expect(!result.isComplete)
    }
}
