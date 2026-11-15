# Participants and discussion: candidate GraphQL operations

Agent-authored, pre-canonical examples supplement the independently scoped Issue and PR overviews. Each takes a previously confirmed object Node ID; usable typed parent and `repository { id }` must be source-associated with the intended Repository under 0080 and 0101. Current access and disclosure apply independently to every actor, count and observation. These are not selected production operations, live permission checks or evidence of complete source history. Do not log or share private participant identities or source payloads.

## Issue participants count and assignees

```graphql
query GitViewIssueParticipantsAndAssignees($objectID: ID!, $pageSize: Int!, $cursor: String) {
  node(id: $objectID) {
    __typename
    ... on Issue {
      id repository { id }
      participants(first: $pageSize) { totalCount }
      assignees(first: $pageSize, after: $cursor) {
        pageInfo { hasNextPage endCursor }
        nodes { id login url }
      }
    }
  }
}
```

The source participants count concerns GitHub Users in its documented conversation population; it is not automatically all actors, distinct comment authors, or the assignee count. The query does not list participants. Assignee page traversal, its scope and errors are independent of the participants aggregate. A valid totalCount does not enumerate its members, authorize disclosing them or prove another connection complete. A user assigned to an Issue is not thereby proven to be its author or the GitView operator.

## Issue comment times

```graphql
query GitViewIssueCommentTimes($objectID: ID!, $pageSize: Int!, $cursor: String) {
  node(id: $objectID) {
    __typename
    ... on Issue {
      id repository { id }
      comments(first: $pageSize, after: $cursor) {
        pageInfo { hasNextPage endCursor }
        nodes { id createdAt updatedAt }
      }
    }
  }
}
```

This candidate fetches no comment bodies or authors. Distinguish a comment's creation and edit times and the retrieval time. A known maximum among observed comment creation times is only an observed maximum until population, ordering, visibility, access, pagination and consistency evidence support a claim for the applicable population. GitHub's documented update ordering alone does not identify latest creation. A terminal cursor alone is not a snapshot guarantee; missing or restricted nodes cannot yield a known empty population. This operation does not prove deleted-comment history or participant counts.

## Named PR review requests

```graphql
query GitViewPRRequestedReviewers($objectID: ID!, $pageSize: Int!, $cursor: String) {
  node(id: $objectID) {
    __typename
    ... on PullRequest {
      id repository { id } headRefOid
      reviewRequests(first: $pageSize, after: $cursor) {
        pageInfo { hasNextPage endCursor }
        nodes {
          id
          requestedReviewer {
            __typename
            ... on User { id login url }
            ... on Bot { id login url }
            ... on Team { id name slug url }
            ... on EnterpriseTeam { id name slug }
            ... on Mannequin { id login url }
          }
        }
      }
    }
  }
}
```

Reviewer types and fields reflect the saved schema snapshot, not an assertion that every variant appears or is visible to a given account. Preserve each usable request and eligible reviewer identity and type independently; a nullable or error-affected target is not an empty request or a different named actor. A future union member can yield only its supported type and limits detailed display. Requested reviewers, the current aggregate review decision and unresolved threads remain separate. Current disclosure governs both identities and counts; a request does not establish GitView User identity, responsibility or merge readiness.

## Shared boundaries

Page sizes are variables, not selected budgets. Interpret null and errors using the actual response paths and non-null propagation. A successful sibling field does not make a separately failed field current; a prior permitted value retains its original observation context. Request and storage outcomes are separately attributable. Schema validation does not establish live permissions, a stable or complete page sequence, source population semantics, iOS behavior or implementation.
