import Foundation
import Testing
@testable import WorkDomain

struct WorkSummaryTests {
    @Test func attentionSelectionKeepsUnknownSeparateFromNonmatch() {
        let unknown = WorkMetricRecord(id: "P1", kind: .pullRequest, state: .open, isDraft: false,
            unresolvedThreads: 0, threadsComplete: false)
        let confirmed = WorkMetricRecord(id: "P2", kind: .pullRequest, state: .open, isDraft: false,
            unresolvedThreads: 2, threadsComplete: false)
        let closed = WorkMetricRecord(id: "P3", kind: .pullRequest, state: .merged, isDraft: false,
            unresolvedThreads: 3, threadsComplete: true)
        let rule = AttentionSignalSpecification(signal: .unresolvedThreads)
        #expect(rule.evaluate(unknown) == .unknown)
        #expect(rule.evaluate(confirmed) == .matches)
        #expect(rule.evaluate(closed) == .doesNotMatch)
        let summary = ProjectWorkSummary(records: [unknown, confirmed, closed], coverageComplete: true, now: now, calendar: calendar)
        #expect(summary.affectedByThreads.count == 1 && summary.affectedByThreads.unavailable == 1)
        #expect([unknown, confirmed, closed].filter(rule.isSatisfiedBy).map(\.id) == ["P2"])
    }
    private let now = Date(timeIntervalSince1970: 1_700_000_000)
    private var calendar: Calendar {
        var calendar = Calendar(identifier: .gregorian)
        calendar.timeZone = TimeZone(secondsFromGMT: 0)!
        return calendar
    }

    @Test func countsUniqueWorkAndIndependentSignals() {
        let pr = WorkMetricRecord(id: "P1", kind: .pullRequest, state: .open, isDraft: true,
            checkStatus: "FAILURE", reviewDecision: "CHANGES_REQUESTED", reviewRequestCount: 1,
            unresolvedThreads: 2, threadsComplete: true, mergedAt: nil)
        let issue = WorkMetricRecord(id: "I1", kind: .issue, state: .open, isDraft: false)
        let summary = ProjectWorkSummary(records: [pr, pr, issue], coverageComplete: true, now: now, calendar: calendar)
        #expect(summary.openPullRequests == 1 && summary.draftPullRequests == 1 && summary.openIssues == 1)
        #expect(summary.failedCI.count == 1 && summary.changesRequested.count == 1 && summary.waitingForReview.count == 1)
        #expect(summary.unresolvedThreads.count == 2 && summary.affectedByThreads.count == 1)
        #expect(summary.mergedByDay?.count == 7)
    }

    @Test func incompleteOrUnknownHistoryNeverProducesZeroFilledChart() {
        let incomplete = ProjectWorkSummary(records: [], coverageComplete: false, now: now, calendar: calendar)
        #expect(incomplete.mergedByDay == nil)
        let missingDate = WorkMetricRecord(id: "P1", kind: .pullRequest, state: .merged, isDraft: false)
        let unknown = ProjectWorkSummary(records: [missingDate], coverageComplete: true, now: now, calendar: calendar)
        #expect(unknown.mergedByDay == nil)
        let unknownState = WorkMetricRecord(id: "P2", kind: .pullRequest, state: .unknown, isDraft: false)
        let uncertain = ProjectWorkSummary(records: [unknownState], coverageComplete: true, now: now, calendar: calendar)
        #expect(!uncertain.coverageComplete && uncertain.mergedByDay == nil)
    }

    @Test func mergedEventsUseLocalCalendarDaysAndExcludeFuture() throws {
        let today = calendar.startOfDay(for: now)
        let yesterday = try #require(calendar.date(byAdding: .day, value: -1, to: today))
        let records = [
            WorkMetricRecord(id: "P1", kind: .pullRequest, state: .merged, isDraft: false, mergedAt: yesterday),
            WorkMetricRecord(id: "P2", kind: .pullRequest, state: .merged, isDraft: false, mergedAt: now.addingTimeInterval(60)),
            WorkMetricRecord(id: "I1", kind: .issue, state: .closed, isDraft: false, mergedAt: yesterday)
        ]
        let summary = ProjectWorkSummary(records: records, coverageComplete: true, now: now, calendar: calendar)
        let days = try #require(summary.mergedByDay)
        #expect(days.first(where: { $0.day == yesterday })?.count == 1)
        #expect(days.reduce(0) { $0 + $1.count } == 1)
    }
}
