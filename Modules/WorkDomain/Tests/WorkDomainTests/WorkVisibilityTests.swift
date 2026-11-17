import Testing
@testable import WorkDomain

struct WorkVisibilityTests {
    @Test func defaultsShowEveryKnownStateAndKind() {
        let rule = WorkVisibilitySpecification(filters: WorkFilters())
        for state in [WorkState.open, .merged, .closed, .unknown] {
            #expect(rule.isSatisfiedBy(WorkVisibilityContext(kind: .pullRequest, state: state)))
            #expect(rule.isSatisfiedBy(WorkVisibilityContext(kind: .issue, state: state)))
        }
    }

    @Test func lifecycleAndKindFiltersNarrowIndependently() {
        let rule = WorkVisibilitySpecification(filters: WorkFilters(showMerged: false, showIssues: false))
        #expect(!rule.isSatisfiedBy(WorkVisibilityContext(kind: .pullRequest, state: .merged)))
        #expect(!rule.isSatisfiedBy(WorkVisibilityContext(kind: .issue, state: .open)))
        #expect(rule.isSatisfiedBy(WorkVisibilityContext(kind: .pullRequest, state: .open)))
        #expect(rule.isSatisfiedBy(WorkVisibilityContext(kind: .pullRequest, state: .unknown)))
    }
}
