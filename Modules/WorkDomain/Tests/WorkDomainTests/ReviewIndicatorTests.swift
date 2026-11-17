import Testing
@testable import WorkDomain

struct ReviewIndicatorTests {
    @Test func requestsAndUnresolvedThreadsTakePriorityOverApproval() {
        let changed = WorkMetricRecord(id: "1", kind: .pullRequest, state: .open, isDraft: false,
            reviewDecision: "CHANGES_REQUESTED", unresolvedThreads: 0, threadsComplete: true)
        let openThread = WorkMetricRecord(id: "2", kind: .pullRequest, state: .open, isDraft: false,
            reviewDecision: "APPROVED", unresolvedThreads: 1, threadsComplete: false)
        let policy = ReviewIndicatorDecision()
        #expect(policy.decide(changed) == .attention)
        #expect(policy.decide(openThread) == .attention)
    }

    @Test func approvalRequiresKnownCompleteThreadCoverage() {
        let approved = WorkMetricRecord(id: "1", kind: .pullRequest, state: .open, isDraft: false,
            reviewDecision: "APPROVED", unresolvedThreads: 0, threadsComplete: true)
        let partial = WorkMetricRecord(id: "2", kind: .pullRequest, state: .open, isDraft: false,
            reviewDecision: "APPROVED", unresolvedThreads: 0, threadsComplete: false)
        let unknown = WorkMetricRecord(id: "3", kind: .pullRequest, state: .open, isDraft: false,
            reviewDecision: "APPROVED")
        let policy = ReviewIndicatorDecision()
        #expect(policy.decide(approved) == .approved)
        #expect(policy.decide(partial) == nil)
        #expect(policy.decide(unknown) == nil)
    }

    @Test func reviewRequestsAreDistinctAndIssuesAreNotReviewBadges() {
        let requested = WorkMetricRecord(id: "1", kind: .pullRequest, state: .open, isDraft: false, reviewRequestCount: 1)
        let required = WorkMetricRecord(id: "2", kind: .pullRequest, state: .open, isDraft: false, reviewDecision: "REVIEW_REQUIRED")
        let issue = WorkMetricRecord(id: "3", kind: .issue, state: .open, isDraft: false, reviewRequestCount: 1)
        let merged = WorkMetricRecord(id: "4", kind: .pullRequest, state: .merged, isDraft: false, reviewRequestCount: 1)
        let policy = ReviewIndicatorDecision()
        #expect(policy.decide(requested) == .requested)
        #expect(policy.decide(required) == .requested)
        #expect(policy.decide(issue) == nil)
        #expect(policy.decide(merged) == nil)
    }
}
