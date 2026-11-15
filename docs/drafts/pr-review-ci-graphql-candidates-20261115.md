# PR review and CI: candidate GraphQL operations

Agent-authored pre-canonical query shapes, for a previously identified permitted PR and its expected Repository. Each result requires a usable typed parent, source-supported identity association, relevant access and actual error-path interpretation. The page size and independent cursor are caller inputs; no request budget, frequency or production transport is selected. Do not include source payloads, reviewer identities or credentials in diagnostics. Static schema validation does not prove a live response, access, source coverage or equivalence to GitHub UI.

## Aggregate review decision

```graphql
query GitViewReviewDecision($objectID: ID!) {
  node(id: $objectID) {
    __typename
    ... on PullRequest {
      id repository { id } headRefOid reviewDecision
    }
  }
}
```

An error-free null `reviewDecision` is distinct from a field error or omitted field and does not explain its cause. Review decision is not the requested-reviewer collection, unresolved-thread count, CI result or merge verdict. Head OID context from the same response is not by itself proof that GitHub's aggregate decision applies to that revision atomically.

## Review threads

```graphql
query GitViewReviewThreads($objectID: ID!, $pageSize: Int!, $cursor: String) {
  node(id: $objectID) {
    __typename
    ... on PullRequest {
      id repository { id } headRefOid
      reviewThreads(first: $pageSize, after: $cursor) {
        pageInfo { hasNextPage endCursor }
        nodes { id isResolved }
      }
    }
  }
}
```

Count identified applicable threads separately as total and unresolved; a partial or null node does not establish zero or a full collection. Resolution is not the review decision. Thread comments, age and bodies are not retrieved; long-thread proxy needs separately justified comment-time evidence. Pagination does not prove simultaneous snapshot.

## Requested reviewers

```graphql
query GitViewReviewRequests($objectID: ID!, $pageSize: Int!, $cursor: String) {
  node(id: $objectID) {
    __typename
    ... on PullRequest {
      id repository { id } headRefOid
      reviewRequests(first: $pageSize, after: $cursor) {
        pageInfo { hasNextPage endCursor }
        nodes { id requestedReviewer { __typename } }
      }
    }
  }
}
```

The query permits independently identifying requests and a returned reviewer type but does not obtain names, actionable reviewer details or prove an unknown future type. A request is not necessarily addressed to the GitView operator and does not establish `REVIEW_REQUIRED`; an incomplete page or null connection is not an empty request list. Detailed reviewer presentation requires a separate permission-aware shape.

## Head-ref check rollup

```graphql
query GitViewHeadCheckContexts($objectID: ID!, $pageSize: Int!, $cursor: String) {
  node(id: $objectID) {
    __typename
    ... on PullRequest {
      id repository { id } headRefOid
      statusCheckRollup {
        id
        commit { oid }
        contexts(first: $pageSize, after: $cursor) {
          pageInfo { hasNextPage endCursor }
          nodes {
            __typename
            ... on CheckRun { id status conclusion }
            ... on StatusContext { id state }
          }
        }
      }
    }
  }
}
```

The public schema describes the PR rollup as head-ref information and separately provides the rollup commit. Preserve both actual values; only compatible, supported evidence associates a particular entry set to a relevant revision. Null or inaccessible commit, rollup, contexts, entry or source field does not mean no checks or success. Categorize individually identified applicable CheckRuns and StatusContexts under 0060 and 0061; an aggregate status is not an individual entry. Unknown union members and incomplete pages limit counts. A test-merge revision, retries, source selection, pagination stability and equivalence to the complete GitHub PR status box require separate evidence. Never add counts from incompatible times or revisions.

In particular, a head or rollup revision change between pages prevents treating the two pages as a complete current set. Earlier supported results retain their original revision as last-known evidence, and the newer revision needs its own applicable results. Conversely, equal returned OIDs on several pages do not by themselves prove that the underlying check entries and retry selection did not change during traversal. See the conditional `paged_revision_change` contract and scenario in 0060; neither behavior has been demonstrated on a live GitHub PR here.

## Shared boundaries

Selection, per-connection cursor and coverage are independent. A successful sibling does not turn another operation's null, failure or missing page into empty or current, and non-null propagation is interpreted on the actual response. Exact filter, identity, revision, permission, retry and full-coverage semantics remain open. No live GitHub operation, permission check or product code was performed.
