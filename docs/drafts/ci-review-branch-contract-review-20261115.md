# CI and review: branch contract review

This is an agent-authored comparison of the owner's selected counters and
overview with candidates 0028, 0041, 0057, 0060–0062, 0092–0093 and 0119. It
is not independent semantic approval or implementation readiness. It does not
change the owner's decision to defer visual review-indicator work.

| Requirement | Current product contract | Remaining specification work | Later evidence |
| --- | --- | --- | --- |
| PR CI failure, pending, success and total counts | 0028 and 0060–0061 use distinct applicable check entries and separate category from total; partial and special results retain their meaning. | Establish the source-specific current attempt/entry selection, head versus test-merge applicability, typed exchange and coverage. A REST combined pending state can describe zero statuses and is not one pending entry. | Actual GitHub permissions, query responses, retries and equivalence to a real PR status box; native readability. |
| PR review assessment and thread counters | 0041 and 0062 expose source assessment and total/unresolved counters independently; thread bodies and source editing are not required. | Establish source-specific assessment applicability, thread identity/resolution and coverage; define typed field failure and access exchange. | Real source behavior, permissions and native accessibility. |
| Project attention and signal navigation | 0057 and 0092 distinguish affected open PRs from check entries or thread counts and preserve each named predicate. 0115 has a cross-route example. | Bind summary and destination to compatible source contexts and explicit unknowns; finalize category-to-control design without inventing merge readiness. | Controlled route tests with doubles, then source and device observations. |
| Stale, partial and restricted observations | 0044/0046, 0060–0062 and 0093 distinguish per-field context, revision, missing coverage and current disclosure. | Define concrete source-to-domain interpretation and persistence of scope, revision, attempt and safely attributable limitations. | Real network error and null behavior, durable recovery and active access changes. |
| Long or unresolved review threads | 0057/0094 separately describe unresolved counts and a proposed 24-hour observed-comment proxy. | Validate that the proxy matches the intended product meaning and identify source operations, applicability and coverage. It does not measure actual thread age or silence. | Live evidence and usability review; no claim that the owner approved this threshold. |
| Ready work | 0125 proposes a separate open non-draft filter; 0028 does not treat CI or review as a merge decision. | Resolve the broader meaning of ready and whether any combined predicate is in release scope. | Later source/policy verification for whatever meaning is selected. |

## Long discussion: meaning before measurement

The owner requested a way to notice long review threads while selecting only
thread counters for the PR overview. The following are distinct possible
meanings, not interchangeable signals:

| Meaning | What would support it | What it does not establish |
| --- | --- | --- |
| Long-lived unresolved discussion | Adequate evidence of when the currently unresolved interval began and whether it continued. | An old comment alone does not prove that interval. |
| Little recent activity | Evidence of the latest relevant activity and adequate coverage of it. | An old observed comment does not prove no later comment exists. |
| Substantial discussion | A separately defined count of relevant comments with adequate coverage. | Volume does not prove elapsed duration or who owes a reply. |
| Old observed comment on an unresolved thread | An applicable unresolved state and at least one supported old comment. | Continuous duration, inactivity and reviewer responsibility remain unknown. |

The last row is the optional 0094 proxy, not a selected interpretation. The
current recorded review-thread query returns identity and resolution state but
no comments or comment times; it alone cannot decide any of these temporal or
volume meanings. The separate evidence matrix documents a possible comment-time
field, not live access or coverage. 0062 keeps the product obligation visible
without inventing a threshold, showing thread bodies or declaring the ordinary
unresolved count sufficient. A precise predicate and suitable evidence remain
necessary before a long-discussion counter is implementation-ready.

## Source boundaries checked here

GitHub's [REST combined commit-status endpoint](https://docs.github.com/en/rest/commits/statuses#get-the-combined-status-for-a-specific-reference)
describes pending when no statuses exist and refers to the latest status for
contexts. Its aggregate is not a check entry, does not include proof of check-run
coverage, and does not define the behavior of the separate GraphQL rollup.
The [check-run listing](https://docs.github.com/en/rest/checks/runs#list-check-runs-for-a-git-reference)
documents `latest` and `all` filters; that alone does not establish the
GitView current set or equivalence to the GitHub PR interface. These are
documentation observations, not live results or confirmed permissions.

The graph's YAML scenarios describe expected outcomes; SpecGraph candidate and
ontology checks do not execute them or validate the reasoning in this table.
Current read-only product scope also leaves review submission, resolving
threads, retrying CI and merging outside GitView's specified actions.
