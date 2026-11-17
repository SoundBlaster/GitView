import Foundation
import Testing
@testable import GitHubAPI

struct GitHubSourceLinkTests {
    @Test func acceptsOnlyMatchingWorkSource() throws {
        let url = try #require(URL(string: "https://github.com/Owner/Repo/pull/42"))
        #expect(GitHubSourceLink.eligible(url, repository: "owner/repo", kind: .pullRequest, number: 42) == url)
        #expect(GitHubSourceLink.eligible(url, repository: "owner/other", kind: .pullRequest, number: 42) == nil)
        #expect(GitHubSourceLink.eligible(url, repository: nil, kind: .pullRequest, number: 42) == nil)
        #expect(GitHubSourceLink.eligible(url, repository: "owner/repo", kind: .issue, number: 42) == nil)
        #expect(GitHubSourceLink.eligible(url, repository: "owner/repo", kind: .pullRequest, number: 43) == nil)
    }

    @Test(arguments: ["https://user:secret@github.com/owner/repo/issues/7",
                      "https://github.com/owner/repo/issues/7?token=secret",
                      "https://github.com/owner/repo/issues/7#secret",
                      "https://github.com.evil.example/owner/repo/issues/7",
                      "https://github.com:443/owner/repo/issues/7",
                      "https://github.com/owner%2Frepo/repo/issues/7",
                      "http://github.com/owner/repo/issues/7",
                      "https://github.com/owner/repo/issues/7/extra"])
    func rejectsUnsafeURLs(_ raw: String) throws {
        let url = try #require(URL(string: raw))
        #expect(GitHubSourceLink.eligible(url, repository: "owner/repo", kind: .issue, number: 7) == nil)
    }
}
