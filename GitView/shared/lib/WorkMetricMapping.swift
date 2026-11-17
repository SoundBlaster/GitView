import GitHubAPI
import WorkDomain
import Foundation

struct ProjectAttentionOrigin {
    let signal: AttentionSignal
    let metric: ObservedMetric
    let snapshotAt: Date
    let repositoryIDs: Set<Int64>
    let partial: Bool
}

extension GitHubWorkItem {
    var metricRecord: WorkMetricRecord {
        let kind: WorkKind = self.kind == .pullRequest ? .pullRequest : .issue
        let state: WorkState = switch self.state {
        case "OPEN": .open
        case "MERGED": .merged
        case "CLOSED": .closed
        default: .unknown
        }
        return WorkMetricRecord(id: id, kind: kind, state: state, isDraft: isDraft,
            checkStatus: checkStatus, reviewDecision: reviewDecision, reviewRequestCount: reviewRequestCount,
            unresolvedThreads: reviewThreads?.observedUnresolved, threadsComplete: reviewThreads?.isComplete,
            mergedAt: mergedAt, closedAt: closedAt, closureReason: closureReason)
    }
}
