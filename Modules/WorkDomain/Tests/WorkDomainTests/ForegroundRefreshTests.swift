import Foundation
import Testing
@testable import WorkDomain

struct ForegroundRefreshTests {
    @Test func refreshesUnknownAndStaleObservations() {
        let now = Date(timeIntervalSince1970: 10_000)
        let policy = ForegroundRefreshSpecification(now: now, maximumAge: 900)
        #expect(policy.isSatisfiedBy(nil))
        #expect(policy.isSatisfiedBy(now.addingTimeInterval(-900)))
        #expect(!policy.isSatisfiedBy(now.addingTimeInterval(-899)))
        #expect(policy.isSatisfiedBy(now.addingTimeInterval(1)))
    }
}
