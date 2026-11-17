import Foundation
import SpecificationCore

/// Only the observed facts needed for the time-based Today rule.
public enum WorkProgress: Sendable {
    case unfinished
    case completed(at: Date)
    case unknown
}

public enum TodayTimeResult: Equatable, Sendable {
    case eligible
    /// Other inclusion conditions may still make this work eligible.
    case notEstablishedByTime
    case unknown
}

public struct TodayEligibility {
    private let specification: TodayTimeSpecification

    public init(now: Date, calendar: Calendar) {
        self.specification = TodayTimeSpecification(now: now, calendar: calendar)
    }

    public func evaluate(_ progress: WorkProgress) -> TodayTimeResult {
        if case .unknown = progress { return .unknown }
        return specification.isSatisfiedBy(progress) ? .eligible : .notEstablishedByTime
    }
}

/// The source's local-calendar-day rule, independent of network and storage.
struct TodayTimeSpecification: Specification {
    let now: Date
    let calendar: Calendar

    func isSatisfiedBy(_ candidate: WorkProgress) -> Bool {
        switch candidate {
        case .unfinished:
            return true
        case .completed(let date):
            return date <= now && calendar.isDate(date, inSameDayAs: now)
        case .unknown:
            return false
        }
    }
}
