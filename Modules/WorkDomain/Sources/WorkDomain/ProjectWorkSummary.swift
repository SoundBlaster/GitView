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

public enum AttentionSignal: Sendable {
    case failedCI, changesRequested, reviewRequested, unresolvedThreads
}

public enum AttentionAssessment: Sendable, Equatable {
    case matches, doesNotMatch, unknown
}

public struct AttentionSignalSpecification: Specification {
    public let signal: AttentionSignal
    public init(signal: AttentionSignal) { self.signal = signal }
    public func isSatisfiedBy(_ candidate: WorkMetricRecord) -> Bool { evaluate(candidate) == .matches }
    public func evaluate(_ candidate: WorkMetricRecord) -> AttentionAssessment {
        guard candidate.kind == .pullRequest else { return .doesNotMatch }
        guard candidate.state != .unknown else { return .unknown }
        guard candidate.state == .open else { return .doesNotMatch }
        switch signal {
        case .failedCI:
            switch candidate.checkStatus {
            case "ERROR", "FAILURE": return .matches
            case "SUCCESS", "PENDING", "EXPECTED": return .doesNotMatch
            default: return .unknown
            }
        case .changesRequested:
            switch candidate.reviewDecision {
            case "CHANGES_REQUESTED": return .matches
            case "APPROVED", "REVIEW_REQUIRED": return .doesNotMatch
            default: return .unknown
            }
        case .reviewRequested:
            guard let count = candidate.reviewRequestCount, count >= 0 else { return .unknown }
            return count > 0 ? .matches : .doesNotMatch
        case .unresolvedThreads:
            guard let count = candidate.unresolvedThreads, count >= 0 else { return .unknown }
            if count > 0 { return .matches }
            return candidate.threadsComplete == true ? .doesNotMatch : .unknown
        }
    }
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
        func metric(_ signal: AttentionSignal) -> ObservedMetric {
            let rule = AttentionSignalSpecification(signal: signal)
            let values = openPR.map(rule.evaluate)
            return ObservedMetric(count: values.filter { $0 == .matches }.count, unavailable: values.filter { $0 == .unknown }.count)
        }
        failedCI = metric(.failedCI)
        changesRequested = metric(.changesRequested)
        waitingForReview = metric(.reviewRequested)
        affectedByThreads = metric(.unresolvedThreads)
        unresolvedThreads = ObservedMetric(count: openPR.compactMap { $0.unresolvedThreads.flatMap { $0 >= 0 ? $0 : nil } }.reduce(0, +),
            unavailable: openPR.filter { ($0.unresolvedThreads ?? -1) < 0 || $0.threadsComplete != true }.count)
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
