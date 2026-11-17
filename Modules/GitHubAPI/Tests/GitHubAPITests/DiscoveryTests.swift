import Foundation
import Testing
@testable import GitHubAPI

struct DiscoveryTests {
    @Test func installationsDecodeAndPreservePagination() async throws {
        let client = GitHubDiscoveryClient { request in
            #expect(request.url?.path == "/user/installations")
            #expect(request.value(forHTTPHeaderField: "Authorization") == "Bearer token")
            let response = HTTPURLResponse(url: request.url!, statusCode: 200, httpVersion: nil, headerFields: ["Link": "<https://api.github.com/user/installations?per_page=100&page=2>; rel=\"next\""])!
            return (Data(#"{"total_count":101,"installations":[{"id":42}]}"#.utf8), response)
        }
        let page = try await client.installations(token: "token", page: 1)
        #expect(page.items.map(\.id) == [42])
        #expect(page.nextPage == 2)
        #expect(page.totalCount == 101)
    }

    @Test func repositoriesAreScopedToInstallation() async throws {
        let client = GitHubDiscoveryClient { request in
            #expect(request.url?.path == "/user/installations/42/repositories")
            return (Data(#"{"total_count":1,"repositories":[{"id":123,"node_id":"R_node","full_name":"user/repo","private":true}]}"#.utf8), HTTPURLResponse(url: request.url!, statusCode: 200, httpVersion: nil, headerFields: nil)!)
        }
        let result = try await client.repositories(token: "token", installationID: 42, page: 1)
        #expect(result.items.first?.fullName == "user/repo")
        #expect(result.items.first?.isPrivate == true)
        #expect(result.items.first?.nodeID == "R_node")
        #expect(result.nextPage == nil)
    }

    @Test func untrustedPaginationLinksAreRejected() async throws {
        let client = GitHubDiscoveryClient { request in
            (Data(#"{"total_count":1,"installations":[]}"#.utf8), HTTPURLResponse(url: request.url!, statusCode: 200, httpVersion: nil, headerFields: ["Link": "<https://evil.example/user/installations?page=2>; rel=\"next\""])!)
        }
        await #expect(throws: DiscoveryError.invalidPagination) { try await client.installations(token: "token", page: 1) }
    }

    @Test func httpErrorsAreNotEmptyResults() async throws {
        let client = GitHubDiscoveryClient { request in
            (Data(), HTTPURLResponse(url: request.url!, statusCode: 403, httpVersion: nil, headerFields: nil)!)
        }
        await #expect(throws: DiscoveryError.httpStatus(403)) { try await client.installations(token: "token", page: 1) }
    }
}
