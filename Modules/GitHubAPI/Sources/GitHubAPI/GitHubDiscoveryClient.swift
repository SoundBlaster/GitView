import Foundation

public struct GitHubInstallation: Decodable, Sendable, Identifiable {
    public let id: Int64
}

public struct GitHubRepository: Decodable, Sendable, Identifiable {
    public let id: Int64
    public let fullName: String
    public let isPrivate: Bool
    public let nodeID: String?
    enum CodingKeys: String, CodingKey { case id, fullName = "full_name", isPrivate = "private", nodeID = "node_id" }
}

public struct DiscoveryPage<Item: Sendable>: Sendable {
    public let items: [Item]
    public let totalCount: Int
    public let nextPage: Int?
}

public enum DiscoveryError: Error, Equatable {
    case invalidRequest
    case invalidResponse
    case invalidPagination
    case httpStatus(Int)
}

public struct GitHubDiscoveryClient: Sendable {
    public typealias Transport = @Sendable (URLRequest) async throws -> (Data, HTTPURLResponse)
    private let transport: Transport
    public init(transport: @escaping Transport = GitHubDiscoveryClient.send) { self.transport = transport }

    public func installations(token: String, page: Int) async throws -> DiscoveryPage<GitHubInstallation> {
        let path = "/user/installations"
        let (data, next) = try await request(token: token, page: page, path: path)
        guard let result = try? JSONDecoder().decode(Installations.self, from: data), result.totalCount >= 0 else { throw DiscoveryError.invalidResponse }
        return DiscoveryPage(items: result.installations, totalCount: result.totalCount, nextPage: next)
    }

    public func repositories(token: String, installationID: Int64, page: Int) async throws -> DiscoveryPage<GitHubRepository> {
        guard installationID > 0 else { throw DiscoveryError.invalidRequest }
        let path = "/user/installations/\(installationID)/repositories"
        let (data, next) = try await request(token: token, page: page, path: path)
        guard let result = try? JSONDecoder().decode(Repositories.self, from: data), result.totalCount >= 0 else { throw DiscoveryError.invalidResponse }
        return DiscoveryPage(items: result.repositories, totalCount: result.totalCount, nextPage: next)
    }

    private func request(token: String, page: Int, path: String) async throws -> (Data, Int?) {
        guard page > 0, !token.isEmpty, !token.contains("\n"), !token.contains("\r") else { throw DiscoveryError.invalidRequest }
        var url = URLComponents(); url.scheme = "https"; url.host = "api.github.com"; url.path = path
        url.queryItems = [URLQueryItem(name: "per_page", value: "100"), URLQueryItem(name: "page", value: String(page))]
        guard let endpoint = url.url else { throw DiscoveryError.invalidRequest }
        var request = URLRequest(url: endpoint)
        request.setValue("Bearer " + token, forHTTPHeaderField: "Authorization")
        request.setValue("application/vnd.github+json", forHTTPHeaderField: "Accept")
        let (data, response) = try await transport(request)
        guard (200..<300).contains(response.statusCode) else { throw DiscoveryError.httpStatus(response.statusCode) }
        let next = try nextPage(response.value(forHTTPHeaderField: "Link"), path: path, current: page)
        return (data, next)
    }

    private func nextPage(_ header: String?, path: String, current: Int) throws -> Int? {
        guard let header else { return nil }
        let nextLinks = header.split(separator: ",").filter { $0.contains("rel=\"next\"") }
        guard nextLinks.count <= 1 else { throw DiscoveryError.invalidPagination }
        guard let link = nextLinks.first else { return nil }
        guard let left = link.firstIndex(of: "<"), let right = link.firstIndex(of: ">"), left < right,
              let parts = URLComponents(string: String(link[link.index(after: left)..<right])),
              parts.scheme == "https", parts.host == "api.github.com", parts.port == nil,
              parts.user == nil, parts.password == nil, parts.fragment == nil, parts.path == path else { throw DiscoveryError.invalidPagination }
        let pages = (parts.queryItems ?? []).filter { $0.name == "page" }
        guard pages.count == 1, let value = pages.first?.value, let number = Int(value), number > current else { throw DiscoveryError.invalidPagination }
        return number
    }

    public static func send(_ request: URLRequest) async throws -> (Data, HTTPURLResponse) {
        let session = URLSession(configuration: .ephemeral, delegate: NoRedirect(), delegateQueue: nil)
        defer { session.invalidateAndCancel() }
        let (data, response) = try await session.data(for: request)
        guard let response = response as? HTTPURLResponse else { throw DiscoveryError.invalidResponse }
        return (data, response)
    }

    private struct Installations: Decodable {
        let totalCount: Int; let installations: [GitHubInstallation]
        enum CodingKeys: String, CodingKey { case totalCount = "total_count", installations }
    }
    private struct Repositories: Decodable {
        let totalCount: Int; let repositories: [GitHubRepository]
        enum CodingKeys: String, CodingKey { case totalCount = "total_count", repositories }
    }
}

private final class NoRedirect: NSObject, URLSessionTaskDelegate, Sendable {
    func urlSession(_ session: URLSession, task: URLSessionTask, willPerformHTTPRedirection response: HTTPURLResponse, newRequest request: URLRequest, completionHandler: @escaping @Sendable (URLRequest?) -> Void) { completionHandler(nil) }
}
