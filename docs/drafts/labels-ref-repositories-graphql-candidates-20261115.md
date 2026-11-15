# Labels and PR ref repositories: candidate GraphQL operations

Pre-canonical, agent-authored query shapes for a source-confirmed Issue or PR. Bind the usable typed parent and returned associated Repository identity to the intended object and Repository under 0080 and 0101. Current access, disclosure, actual GraphQL paths and non-null propagation remain independent of source identity. Page size and cursor are caller inputs, not chosen budgets. No live permission, source coverage or product implementation is claimed.

## Issue labels

```graphql
query GitViewIssueLabels($objectID: ID!, $pageSize: Int!, $cursor: String) {
  node(id: $objectID) {
    __typename
    ... on Issue {
      id repository { id }
      labels(first: $pageSize, after: $cursor) {
        pageInfo { hasNextPage endCursor }
        nodes { id name color }
      }
    }
  }
}
```

## PR labels

```graphql
query GitViewPullRequestLabels($objectID: ID!, $pageSize: Int!, $cursor: String) {
  node(id: $objectID) {
    __typename
    ... on PullRequest {
      id repository { id }
      labels(first: $pageSize, after: $cursor) {
        pageInfo { hasNextPage endCursor }
        nodes { id name color }
      }
    }
  }
}
```

For each operation an observed label has source identity, name, color and actual observation and access context. Do not identify labels across Repositories from equal names, or treat label color as lifecycle, CI, review or Issue type. A null label connection, omitted or errored field, missing node or partial page does not establish an empty list. The two operations have separate scope and cursors; a later title or state response does not refresh labels. A terminal cursor alone does not prove stable pagination or source visibility. Show permitted names and any safe limitation without requiring color alone; do not reveal restricted labels or counts.

## Associated, base and head repositories

```graphql
query GitViewPullRequestRefRepositories($objectID: ID!) {
  node(id: $objectID) {
    __typename
    ... on PullRequest {
      id repository { id nameWithOwner url }
      baseRepository { id nameWithOwner url }
      headRepository { id nameWithOwner url }
      baseRefName headRefName baseRefOid headRefOid
    }
  }
}
```

The public schema describes `repository` as the PR-associated Repository and `baseRepository` and `headRepository` as the Repositories associated with the respective refs. Their identities are separately observed; a head fork need not be the associated Repository or a Project member. An error-free null base or head remains a nullable source result with no invented cause. An omitted, inaccessible or error-affected field has its own limitation and does not establish deletion or substitute the associated Repository. Branch names can survive deletion of the respective ref and names or URLs are not stable identity. OIDs and associated counters must retain their actual independent source and revision context; this response is not proof of atomic source state or present access to a fork. Each permissible linked target has its own disclosure and opening eligibility, and showing it does not change Project membership.

## Shared boundary

These are candidate query documents, not complete PR or Issue overviews, selected production operations or a request to GitHub. Schema acceptance does not verify user permissions, live API behavior, pagination completeness or revision consistency. Do not persist unnecessary response payloads or put tokens, private label content or restricted Repository names in diagnostics.
