import Foundation
import Testing
@testable import WorkDomain

struct TodayEligibilityTests {
    private let now = Date(timeIntervalSince1970: 1_700_006_400)

    private func calendar(offset: Int = 0) -> Calendar {
        var calendar = Calendar(identifier: .gregorian)
        calendar.timeZone = TimeZone(secondsFromGMT: offset)!
        return calendar
    }

    @Test func unfinishedWorkRemainsEligible() {
        let policy = TodayEligibility(now: now, calendar: calendar())
        #expect(policy.evaluate(.unfinished) == .eligible)
    }

    @Test func completionTodayRemainsEligible() {
        let policy = TodayEligibility(now: now, calendar: calendar())
        #expect(policy.evaluate(.completed(at: now)) == .eligible)
    }

    @Test func previousDayAloneDoesNotEstablishEligibility() {
        let policy = TodayEligibility(now: now, calendar: calendar())
        #expect(policy.evaluate(.completed(at: now.addingTimeInterval(-86_400))) == .notEstablishedByTime)
    }

    @Test func unknownIsNotAnExclusionOrCompletion() {
        let policy = TodayEligibility(now: now, calendar: calendar())
        #expect(policy.evaluate(.unknown) == .unknown)
    }

    @Test func localTimeZoneDeterminesTheCalendarDay() {
        let instant = Date(timeIntervalSince1970: 1_704_067_200) // 2024-01-01 00:00 UTC
        let completed = instant.addingTimeInterval(-3_600)
        let utc = TodayEligibility(now: instant, calendar: calendar())
        let west = TodayEligibility(now: instant, calendar: calendar(offset: -8 * 3_600))
        #expect(utc.evaluate(.completed(at: completed)) == .notEstablishedByTime)
        #expect(west.evaluate(.completed(at: completed)) == .eligible)
    }

    @Test func finishedAndUnfinishedWorkStayInTheSameSelection() {
        let policy = TodayEligibility(now: now, calendar: calendar())
        let states: [WorkProgress] = Array(repeating: .completed(at: now), count: 95)
            + Array(repeating: .unfinished, count: 5)
        #expect(states.filter { policy.evaluate($0) == .eligible }.count == 100)
    }
}
