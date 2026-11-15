# Object overview: candidate GraphQL operations

These agent-authored, pre-canonical queries complement the separately scoped Today discovery. They are examples of selected individual fields, not a complete first-version overview, chosen production query, proof of permission or recommendation to fetch all fields in one request. Each request addresses a previously confirmed typed source object with its own opaque Node ID and requires an independently associated Repository identity and applicable access context. The `repository { id }` witness is checked against the intended Repository under 0080 and 0101 before attributing fields. `node` null, a mismatched type, an invalid or error-affected Repository witness, and unassociated IDs do not establish a deleted object or an empty overview. A source may return private authored text: use only under current disclosure policy, do not include bodies or credentials in diagnostics, and avoid acquiring or retaining content unnecessarily.

## Issue: authored text and independently scoped scalar facts

```graphql
query GitViewIssueOverview($objectID: ID!, $pageSize: Int!) {
  node(id: $objectID) {
    __typename
    ... on Issue {
      id number title body url state stateReason createdAt updatedAt closedAt
      repository { id }
      author { __typename login url }
      issueType { id name }
      milestone { id title }
      comments(first: $pageSize) { totalCount }
    }
  }
}
```

The comment `totalCount` concerns Issue comments and is distinct from participants, last-comment time or PR review threads. The query does not select comment contents or establish coverage of any related collection. `stateReason`, author, type and milestone are nullable in the saved public schema: use an actual error-free source result and applicable semantics; a field error, unselected field or null-propagated parent is not a supported absence. `closedAt` is not complete closure history. A body is authored text, not proof of motivation or outcome.

## Pull Request: change counts and independently scoped context

```graphql
query GitViewPullRequestOverview($objectID: ID!, $pageSize: Int!) {
  node(id: $objectID) {
    __typename
    ... on PullRequest {
      id number title body url state isDraft createdAt updatedAt closedAt mergedAt
      repository { id }
      author { __typename login url }
      headRefName baseRefName headRefOid baseRefOid
      additions deletions changedFiles
      commits(first: $pageSize) { totalCount }
    }
  }
}
```

The commit count carries the source connection's head-versus-base meaning; it is not an enumerated list or a count of every historical PR commit. Each counter and revision keeps its own actual source context; successful schema validation and one response do not prove an atomic revision snapshot. Branch names do not prove that branches or forks currently exist. The query does not select check runs, review threads, requested reviewers, labels or linked Issues.

## Result and remaining scope

Both operations use a variable page size only because the selected connection accepts pagination arguments; a numerical size or request budget is not selected. Interpret actual GraphQL paths and non-null propagation before accepting sibling facts: a non-null failure may null a parent, so separate fields survive only if the actual response supports them. Separate observations, stale values, attempt limitations and storage outcomes retain their own contexts. Neither a successful field nor `totalCount` proves a full page, access to other categories, historical coverage or a complete Today population. Labels, participants, Issue links, hierarchy, blockers, PR reviewers, review and CI counters, and their coverage still require separate candidate operations and permission verification. No request to the user's GitHub account, live-source check or product implementation is claimed.
