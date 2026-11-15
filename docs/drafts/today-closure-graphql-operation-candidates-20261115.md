# Closure-event acquisition candidates for Today

Status: agent-authored working direction, pre-canonical. Specification 0102 selects these typed timeline operations when supported closure evidence is needed for a discovered or retained object. They supplement the selected initial discovery operations; they do not establish a complete history, verified permission or live source behavior.

Given a separately identified candidate object, query its typed timeline and request source event and subject identities. Both operations take an object Node ID, a page size and cursor. No temporal cutoff is applied here: eligibility for a captured local day is assessed from each supported event time. Page size, request budget, stopping policy, mutation during pagination and authorization remain open. A null node, wrong type, field error, partial response or incomplete traversal is not evidence of absence. Even successful traversal requires independent justification of visibility, temporal scope, pagination behavior and subject association before any exhaustive history claim.

## Issue

```graphql
query GitViewIssueClosures($objectID: ID!, $pageSize: Int!, $cursor: String) {
  node(id: $objectID) {
    __typename
    ... on Issue {
      id
      repository { id }
      timelineItems(first: $pageSize, after: $cursor, itemTypes: [CLOSED_EVENT]) {
        pageInfo { hasNextPage endCursor }
        nodes {
          __typename
          ... on ClosedEvent {
            id
            createdAt
            stateReason
            closable {
              __typename
              ... on Issue { id repository { id } }
            }
          }
        }
      }
    }
  }
}
```

## Pull Request

```graphql
query GitViewPullRequestClosures($objectID: ID!, $pageSize: Int!, $cursor: String) {
  node(id: $objectID) {
    __typename
    ... on PullRequest {
      id
      repository { id }
      timelineItems(first: $pageSize, after: $cursor, itemTypes: [CLOSED_EVENT]) {
        pageInfo { hasNextPage endCursor }
        nodes {
          __typename
          ... on ClosedEvent {
            id
            createdAt
            closable {
              __typename
              ... on PullRequest { id repository { id } }
            }
          }
        }
      }
    }
  }
}
```

## Interpretation and open work

Bind a usable event to its confirmed typed subject, Repository, source instance, access and observation context; an unexpected or unavailable `closable` is not silently assigned to the queried object. An Issue event reason is separately nullable and belongs to that event, not to a later current Issue state. Preserve event identity and time so reopening, repeated closures and overlapping pages do not collapse into a fabricated single state. A PR close event does not by itself determine whether or when the PR merged: evaluate merge evidence independently. The known candidate set can itself be incomplete; enumerating timelines only for discovered objects cannot establish repository-wide Today coverage. A terminal cursor is not a documented snapshot guarantee. Static schema validation says nothing about permissions, live response, cost, completeness, ordering or the relationship between merge and close events.
