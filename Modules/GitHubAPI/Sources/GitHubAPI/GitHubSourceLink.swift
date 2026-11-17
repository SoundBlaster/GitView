import Foundation

/// Accepts an observed work URL only when it matches the selected source context.
public enum GitHubSourceLink {
    public static func eligible(_ url: URL, repository: String?, kind: GitHubWorkKind, number: Int) -> URL? {
        guard number > 0, let repository,
              let components = URLComponents(url: url, resolvingAgainstBaseURL: false),
              components.scheme?.lowercased() == "https", components.host?.lowercased() == "github.com",
              components.user == nil, components.password == nil, components.port == nil,
              components.percentEncodedQuery == nil, components.percentEncodedFragment == nil else { return nil }
        let source = repository.split(separator: "/", omittingEmptySubsequences: false).map(String.init)
        var path = components.percentEncodedPath.split(separator: "/", omittingEmptySubsequences: false).map(String.init)
        if path.last == "" { path.removeLast() }
        guard source.count == 2, !source.contains(where: \.isEmpty), path.count == 5, path[0].isEmpty,
              let owner = path[1].removingPercentEncoding, let name = path[2].removingPercentEncoding,
              !owner.contains("/"), !name.contains("/"),
              owner.caseInsensitiveCompare(source[0]) == .orderedSame,
              name.caseInsensitiveCompare(source[1]) == .orderedSame,
              path[3] == (kind == .issue ? "issues" : "pull"), path[4] == String(number) else { return nil }
        return url
    }
}
