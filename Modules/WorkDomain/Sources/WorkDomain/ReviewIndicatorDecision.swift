import SpecificationCore

public enum ReviewIndicator: Equatable, Sendable {
    case attention, requested, approved
}

/// Selects one compact review signal without turning approval into merge readiness.
public struct ReviewIndicatorDecision: DecisionSpec {
    public init() {}

    public func decide(_ candidate: WorkMetricRecord) -> ReviewIndicator? {
        guard candidate.kind == .pullRequest, candidate.state == .open else { return nil }
        if AttentionSignalSpecification(signal: .changesRequested).evaluate(candidate) == .matches ||
            AttentionSignalSpecification(signal: .unresolvedThreads).evaluate(candidate) == .matches {
            return .attention
        }
        if AttentionSignalSpecification(signal: .reviewRequested).evaluate(candidate) == .matches ||
            candidate.reviewDecision == "REVIEW_REQUIRED" { return .requested }
        if candidate.reviewDecision == "APPROVED", candidate.unresolvedThreads == 0,
           candidate.threadsComplete == true { return .approved }
        return nil
    }
}
