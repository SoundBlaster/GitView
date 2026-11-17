import SpecificationCore

public enum WorkKind: Sendable, Equatable { case issue, pullRequest }
public enum WorkState: Sendable, Equatable { case open, merged, closed, unknown }

public struct WorkVisibilityContext: Sendable {
    public let kind: WorkKind
    public let state: WorkState
    public init(kind: WorkKind, state: WorkState) { self.kind = kind; self.state = state }
}

public struct WorkFilters: Sendable {
    public var showOpen: Bool
    public var showMerged: Bool
    public var showClosed: Bool
    public var showIssues: Bool
    public var showPullRequests: Bool

    public init(showOpen: Bool = true, showMerged: Bool = true, showClosed: Bool = true, showIssues: Bool = true, showPullRequests: Bool = true) {
        self.showOpen = showOpen; self.showMerged = showMerged; self.showClosed = showClosed
        self.showIssues = showIssues; self.showPullRequests = showPullRequests
    }
}

public struct WorkVisibilitySpecification: Specification {
    public let filters: WorkFilters
    public init(filters: WorkFilters) { self.filters = filters }
    public func isSatisfiedBy(_ candidate: WorkVisibilityContext) -> Bool {
        switch candidate.kind {
        case .issue where !filters.showIssues: return false
        case .pullRequest where !filters.showPullRequests: return false
        default: break
        }
        switch candidate.state {
        case .open: return filters.showOpen
        case .merged: return filters.showMerged
        case .closed: return filters.showClosed
        case .unknown: return true
        }
    }
}
