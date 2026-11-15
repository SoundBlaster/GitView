# Review thread inactivity: source candidate

Working source direction for 0062. For a previously confirmed thread, PR and Repository association, request pages independently without retrieving comment bodies. Compare the captured evaluation time to the maximum applicable publication time of confirmed submitted comments; a missing publication time, unresolved identity, partial page, source error or unsuitable scope limits the result. A pending comment does not establish a new published reply. Validate thread ownership, access, mutable pagination and state freshness independently; this operation alone does not prove a complete snapshot or that a person owes a response.

```graphql
query GitViewReviewThreadCommentTimes($thread: ID!, $pageSize: Int!, $cursor: String) {
  node(id: $thread) {
    __typename
    ... on PullRequestReviewThread {
      id isResolved
      pullRequest { id repository { id } }
      comments(first: $pageSize, after: $cursor) {
        pageInfo { hasNextPage endCursor }
        nodes { id state publishedAt }
      }
    }
  }
}
```

A prior query discovers thread identities; this operation pages one thread at a time. `publishedAt` is nullable in the schema; creation and draft times are not substituted for an unavailable publication time. Static schema validation is separate from permissions, live response, ordering, and source coverage.
