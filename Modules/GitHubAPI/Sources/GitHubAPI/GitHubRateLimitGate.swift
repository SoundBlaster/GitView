import Foundation

public enum GitHubRateLimitError: Error, Equatable, Sendable {
    case deferred(until: Date)
}

/// Defers subsequent requests after GitHub reports exhausted or secondary limits.
actor GitHubRateLimitGate {
    static let shared = GitHubRateLimitGate(persistent: true)
    private static let storageKey = "GitGrid.github.rateLimitUntil"
    private let persistent: Bool
    private var until: Date?

    init(persistent: Bool = false) { self.persistent = persistent }

    func perform(_ request: URLRequest, send: GitHubDiscoveryClient.Transport) async throws -> (Data, HTTPURLResponse) {
        try check()
        let (data, response) = try await send(request)
        let limited = observe(response, data: data)
        if limited && (response.statusCode >= 400 || Self.hasGraphQLErrors(data)) { try check() }
        return (data, response)
    }

    func check(now: Date = .now) throws {
        if persistent, let stored = UserDefaults.standard.object(forKey: Self.storageKey) as? Date {
            until = max(until ?? stored, stored)
        }
        if let until, until > now { throw GitHubRateLimitError.deferred(until: until) }
        until = nil
        if persistent { UserDefaults.standard.removeObject(forKey: Self.storageKey) }
    }

    @discardableResult func observe(_ response: HTTPURLResponse, data: Data, now: Date = .now) -> Bool {
        let remaining = response.value(forHTTPHeaderField: "x-ratelimit-remaining")
        let retry = response.value(forHTTPHeaderField: "retry-after").flatMap(Double.init)
        let exhausted = remaining == "0"
        let secondary = Self.hasSecondaryLimitMessage(data)
        let statusLimited = response.statusCode == 429 || (response.statusCode == 403 && retry != nil)
        guard exhausted || secondary || statusLimited else { return false }

        var deadlines: [Date] = []
        if let retry, retry.isFinite, retry >= 0 { deadlines.append(now.addingTimeInterval(max(retry, 1))) }
        if exhausted, let reset = response.value(forHTTPHeaderField: "x-ratelimit-reset").flatMap(Double.init), reset.isFinite {
            deadlines.append(Date(timeIntervalSince1970: reset))
        }
        let deadline = max(deadlines.max() ?? now.addingTimeInterval(60), now.addingTimeInterval(1))
        until = max(until ?? deadline, deadline)
        if persistent { UserDefaults.standard.set(until, forKey: Self.storageKey) }
        return true
    }

    private static func hasGraphQLErrors(_ data: Data) -> Bool {
        guard let object = (try? JSONSerialization.jsonObject(with: data)) as? [String: Any],
              let errors = object["errors"] as? [Any] else { return false }
        return !errors.isEmpty
    }

    private static func hasSecondaryLimitMessage(_ data: Data) -> Bool {
        guard let object = (try? JSONSerialization.jsonObject(with: data)) as? [String: Any] else { return false }
        let messages = ([object["message"] as? String] + ((object["errors"] as? [[String: Any]]) ?? []).map { $0["message"] as? String }).compactMap { $0 }
        return messages.contains { $0.localizedCaseInsensitiveContains("secondary rate limit") }
    }
}
