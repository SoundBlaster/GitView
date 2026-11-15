# PR and Issue references: candidate GraphQL operations

Agent-authored pre-canonical examples for a separately identified permitted PR or Issue. Bind each usable typed parent to the intended object and associated Repository under 0080 and 0101; establish each relation, endpoint, Repository and permitted disclosure independently. A source-visible target in another Repository does not become a Project member. These shapes do not establish live access, actual permission, a stable snapshot or full reference history.

## PR closing-Issue references

```graphql
query GitViewPRClosingIssues($objectID: ID!, $pageSize: Int!, $cursor: String) {
  node(id: $objectID) {
    __typename
    ... on PullRequest {
      id repository { id }
      closingIssuesReferences(
        first: $pageSize, after: $cursor,
        excludeUserLinked: false, userLinkedOnly: false
      ) {
        pageInfo { hasNextPage endCursor }
        nodes { id number title url state repository { id } }
      }
    }
  }
}
```

The schema describes Issues that *may* be closed by the PR. Record actual arguments: neither user-linked-only nor exclude-user-linked restriction is intentionally selected. A supported connection entry does not establish that a merge will occur or that an Issue has closed, that every mention or commit reference is represented, or why an actor acted. A null, error, omitted connection, incomplete page or inaccessible target is not a complete empty set.

## PR timeline references

```graphql
query GitViewPRCrossReferences($objectID: ID!, $pageSize: Int!, $cursor: String) {
  node(id: $objectID) {
    __typename
    ... on PullRequest {
      id repository { id }
      timelineItems(first: $pageSize, after: $cursor, itemTypes: [CROSS_REFERENCED_EVENT]) {
        pageInfo { hasNextPage endCursor }
        nodes {
          __typename
          ... on CrossReferencedEvent {
            id createdAt referencedAt isCrossRepository willCloseTarget
            source {
              __typename
              ... on Issue { id repository { id } }
              ... on PullRequest { id repository { id } }
            }
            target {
              __typename
              ... on Issue { id repository { id } }
              ... on PullRequest { id repository { id } }
            }
          }
        }
      }
    }
  }
}
```

## Issue timeline references

```graphql
query GitViewIssueCrossReferences($objectID: ID!, $pageSize: Int!, $cursor: String) {
  node(id: $objectID) {
    __typename
    ... on Issue {
      id repository { id }
      timelineItems(first: $pageSize, after: $cursor, itemTypes: [CROSS_REFERENCED_EVENT]) {
        pageInfo { hasNextPage endCursor }
        nodes {
          __typename
          ... on CrossReferencedEvent {
            id createdAt referencedAt isCrossRepository willCloseTarget
            source {
              __typename
              ... on Issue { id repository { id } }
              ... on PullRequest { id repository { id } }
            }
            target {
              __typename
              ... on Issue { id repository { id } }
              ... on PullRequest { id repository { id } }
            }
          }
        }
      }
    }
  }
}
```

The public schema describes `source` as the Issue or PR that made the reference, `target` as the Issue or PR referenced, and `referencedAt` separately from event `createdAt`. The timeline parent is not assumed to be the event source: compare actual supported typed identities and preserve direction. A permitted event can support a source-reported reference at its own time; it is not automatically a current body mention, an actor's motive, a complete reference collection or proof of a subsequent merge or closure. `willCloseTarget` is a source-returned field attached to the event and its context, not independent evidence that closure occurred or an unconditional promise. A future union member, unavailable endpoint, field error or unassociated identity remains limited. Actor information and body text are intentionally not selected.

## Coverage and privacy

Each connection, pagination cursor, event and observation has its own scope and access; independently observed current closing connections and earlier reference events do not automatically update one another. A reference may be deleted, changed, unavailable or omitted from a timeline; no absence or full mention coverage follows from one connection or a terminal cursor. Apply current disclosure to the relationship itself, each endpoint and any derived counts before presentation, accessibility or sharing. Withhold a restricted relationship rather than exposing its existence through a target placeholder. Static schema validation is not live-source or permission verification; no request to the user's data is made.
