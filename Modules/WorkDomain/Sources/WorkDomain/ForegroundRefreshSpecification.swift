import Foundation
import SpecificationCore

/// Selects whether an observation should be refreshed after returning to the app.
public struct ForegroundRefreshSpecification: Specification {
    public let now: Date
    public let maximumAge: TimeInterval

    public init(now: Date, maximumAge: TimeInterval) {
        self.now = now
        self.maximumAge = maximumAge
    }

    public func isSatisfiedBy(_ observedAt: Date?) -> Bool {
        guard let observedAt else { return true }
        let age = now.timeIntervalSince(observedAt)
        return age < 0 || age >= maximumAge
    }
}
