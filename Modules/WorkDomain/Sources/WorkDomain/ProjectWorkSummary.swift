import Foundation
import SpecificationCore

public struct WorkMetricRecord: Sendable {
    public let id: String
    public let kind: WorkKind
    public let state: WorkState
    public let isDraft: Bool
    public let checkStatus: String?
    public let reviewDecision: String?
    public let reviewRequestCount: Int?
    public let unresolvedThreads: Int?
    public let threadsComplete: Bool?
    public let mergedAt: Date?

    public init(id: String, kind: WorkKind, state: WorkState, isDraft: Bool, checkStatus: String? = nil,
                reviewDecision: String? = nil, reviewRequestCount: Int? = nil, unresolvedThreads: Int? = nil,
                threadsComplete: Bool? = nil, mergedAt: Date? = nil) {
        self.id = id; self.kind = kind; self.state = state; self.isDraft = isDraft
        self.checkStatus = checkStatus; self.reviewDecision = reviewDecision; self.reviewRequestCount = reviewRequestCount
        self.unresolvedThreads = unresolvedThreads; self.threadsComplete = threadsComplete; self.mergedAt = mergedAt
    }
}

public struct ObservedMetric: Sendable {
    public let count: Int
    public let unavailable: Int
}

public struct MergedDay: Identifiable, Sendable {
    public let day: Date
    public let count: Int
    public var id: Date { day }
}

public struct ProjectWorkSummary: Sendable {
    public let coverageComplete: Bool
    public let openPullRequests: Int
    public let draftPullRequests: Int
    public let openIssues: Int
    public let failedCI: ObservedMetric
    public let changesRequested: ObservedMetric
    public let waitingForReview: ObservedMetric
    public let affectedByThreads: ObservedMetric
    public let unresolvedThreads: ObservedMetric
    /// Nil means history is unavailable or incomplete; it must not be rendered as zeros.
    public let mergedByDay: [MergedDay]?

    public init(records: [WorkMetricRecord], coverageComplete: Bool, now: Date, calendar: Calendar) {
        var seen = Set<String>()
        let unique = records.filter { seen.insert($0.id).inserted }
        let observedComplete = coverageComplete && unique.allSatisfy { $0.state != .unknown }
        self.coverageComplete = observedComplete
        let openPR = unique.filter(OpenPullRequestSpecification().isSatisfiedBy)
        openPullRequests = openPR.count
        draftPullRequests = openPR.filter(\.isDraft).count
        openIssues = unique.filter { $0.kind == .issue && $0.state == .open }.count
        func metric(_ predicate: (WorkMetricRecord) -> Bool?) -> ObservedMetric {
            let values = openPR.map(predicate)
            return ObservedMetric(count: values.filter { $0 == true }.count, unavailable: values.filter { $0 == nil }.count)
        }
        failedCI = metric { record in
            switch record.checkStatus {
            case "ERROR", "FAILURE": true
            case "SUCCESS", "PENDING", "EXPECTED": false
            default: nil
            }
        }
        changesRequested = metric { record in
            switch record.reviewDecision {
            case "CHANGES_REQUESTED": true
            case "APPROVED", "REVIEW_REQUIRED": false
            default: nil
            }
        }
        waitingForReview = metric { $0.reviewRequestCount.map { $0 > 0 } }
        affectedByThreads = metric { record in
            guard let count = record.unresolvedThreads else { return nil }
            if count > 0 { return true }
            return record.threadsComplete == true ? false : nil
        }
        unresolvedThreads = ObservedMetric(count: openPR.compactMap(\.unresolvedThreads).reduce(0, +),
            unavailable: openPR.filter { $0.unresolvedThreads == nil || $0.threadsComplete != true }.count)
        let missingMergeTime = unique.contains { $0.kind == .pullRequest && $0.state == .merged && $0.mergedAt == nil }
        if observedComplete && !missingMergeTime {
            let today = calendar.startOfDay(for: now)
            let days = (0..<7).reversed().compactMap { calendar.date(byAdding: .day, value: -$0, to: today) }
            if days.count == 7 {
                mergedByDay = days.map { day in
                    let rule = MergedOnDaySpecification(day: day, now: now, calendar: calendar)
                    return MergedDay(day: day, count: unique.filter(rule.isSatisfiedBy).count)
                }
            } else { mergedByDay = nil }
        } else { mergedByDay = nil }
    }
}

private struct OpenPullRequestSpecification: Specification {
    func isSatisfiedBy(_ candidate: WorkMetricRecord) -> Bool { candidate.kind == .pullRequest && candidate.state == .open }
}

private struct MergedOnDaySpecification: Specification {
    let day: Date
    let now: Date
    let calendar: Calendar
    func isSatisfiedBy(_ candidate: WorkMetricRecord) -> Bool {
        guard candidate.kind == .pullRequest, candidate.state == .merged, let date = candidate.mergedAt else { return false }
        return date <= now && calendar.isDate(date, inSameDayAs: day)
    }
}
