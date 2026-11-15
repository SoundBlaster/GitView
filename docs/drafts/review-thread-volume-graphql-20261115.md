# Review discussion volume: initial GraphQL query

Agent-authored working query for 0062, supplementing the independently scoped review operations in `pr-review-ci-graphql-candidates-20261115.md`. It requests no comment body or list of comments. `first: 1` supplies the required connection bound; the selection requests only its aggregate `totalCount`. Caller-provided page size and cursor belong to the thread connection, not an API budget decision.

```graphql
query GitViewReviewThreadVolumes($objectID: ID!, $pageSize: Int!, $cursor: String) {
  node(id: $objectID) {
    __typename
    ... on PullRequest {
      id
      repository { id }
      headRefOid
      reviewThreads(first: $pageSize, after: $cursor) {
        pageInfo { hasNextPage endCursor }
        nodes {
          id
          isResolved
          comments(first: 1) { totalCount }
        }
      }
    }
  }
}
```

Associate each supported count and resolution fact with its source-identified PR, Repository, thread and actual observation context. Compute the maximum only over eligible unresolved threads, applying 0062's partial-coverage and disclosure rules. Nulls, errors or missing pages do not establish zero, a current exact maximum or a number of missing threads. The local schema check does not validate GitHub's connection-limit enforcement, permissions, source population, temporal consistency or live behavior; verify these during integration. This is not a user-facing list of individual threads.
