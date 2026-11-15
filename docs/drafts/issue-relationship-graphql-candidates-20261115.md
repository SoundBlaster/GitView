# Issue relationships: candidate GraphQL operations

Agent-authored pre-canonical query examples for a previously identified permitted Issue and its intended Repository. Each operation carries its own source, access, attempt and observation context. Validate the typed source parent and `repository { id }` against the intended identity under 0080 and 0101; validate each permitted target with its own returned type, identity, Repository and disclosure context before showing or opening it. A target outside the originating Project does not change Project membership. Access to an Issue does not imply access to every relationship or private target. Restricted relationships and revealing counts must not be exposed through the page, accessibility or sharing.

## Parent

```graphql
query GitViewIssueParent($objectID: ID!) {
  node(id: $objectID) {
    __typename
    ... on Issue {
      id repository { id }
      parent { id number title url state repository { id } }
    }
  }
}
```

The nullable `parent` is the source's current parent observation where independently interpretable. A field error, omission or inaccessible parent is not proof of no parent; a prior parent does not prove a current one. Reassignment and unordered conflicts follow 0078 and 0053.

## Direct children

```graphql
query GitViewIssueChildren($objectID: ID!, $pageSize: Int!, $cursor: String) {
  node(id: $objectID) {
    __typename
    ... on Issue {
      id repository { id }
      subIssues(first: $pageSize, after: $cursor) {
        pageInfo { hasNextPage endCursor }
        nodes { id number title url state repository { id } }
      }
    }
  }
}
```

This is a direct-child connection candidate; an observed child is not a transitive descendant count or proof of full coverage. A closed child is not necessarily successfully completed.

## Issues blocking this Issue

```graphql
query GitViewIssueBlockedBy($objectID: ID!, $pageSize: Int!, $cursor: String) {
  node(id: $objectID) {
    __typename
    ... on Issue {
      id repository { id }
      blockedBy(first: $pageSize, after: $cursor) {
        pageInfo { hasNextPage endCursor }
        nodes { id number title url state repository { id } }
      }
    }
  }
}
```

A returned supported edge is directed from the selected affected Issue to an Issue blocking it. A known relation does not establish that the blocker is currently open; its usable state and time are separate evidence.

## Issues blocked by this Issue

```graphql
query GitViewIssueBlocking($objectID: ID!, $pageSize: Int!, $cursor: String) {
  node(id: $objectID) {
    __typename
    ... on Issue {
      id repository { id }
      blocking(first: $pageSize, after: $cursor) {
        pageInfo { hasNextPage endCursor }
        nodes { id number title url state repository { id } }
      }
    }
  }
}
```

A returned supported edge describes an Issue blocked by the selected Issue. It is not the selected Issue’s `blockedBy` list.

## Closing PR references

```graphql
query GitViewIssueClosingPullRequests($objectID: ID!, $pageSize: Int!, $cursor: String) {
  node(id: $objectID) {
    __typename
    ... on Issue {
      id repository { id }
      closedByPullRequestsReferences(
        first: $pageSize, after: $cursor,
        includeClosedPrs: true, excludeUserLinked: false, userLinkedOnly: false
      ) {
        pageInfo { hasNextPage endCursor }
        nodes { id number title url state repository { id } }
      }
    }
  }
}
```

The explicit arguments request inclusion of closed PRs and do not intentionally select only or exclude user-linked references. Preserve the actual query and argument context; source behavior, visibility and complete coverage still require verification. A returned connection is not a list of all mentions or commit-message paths to closure, proof of an actor's motive, or a promise that a future merge will close this Issue. Mention discovery requires separate source semantics and is not covered by this query.

## Shared limits

All list requests have independent cursors and outcomes. A terminal page is not a documented immutable source snapshot. Partial pages, null nodes, field errors, omitted fields and GraphQL non-null propagation must be interpreted from the actual response; no missing relation becomes an empty list or a fabricated exact count. The examples do not define numerical page sizes or automatic background collection. Static schema compatibility establishes neither account permission nor endpoint visibility, relation completeness or actual GitHub behavior; no user data was requested.
