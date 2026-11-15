# Issue, relationships and Project summary: contract review

Agent-authored comparison of the owner-selected [Issue fields](issue-ontology-options.md)
with 0039, 0057, 0063, 0077–0078 and 0092. These are pre-canonical product
contracts, not an independent semantic approval or evidence of live GitHub data.

| Owner-selected concern | Product interpretation in the graph | Before implementation readiness |
| --- | --- | --- |
| Identity, title, original text and source | 0039 retains typed Issue and Repository identity, readable original description and eligible source link. A PR represented by an Issues endpoint is not automatically another Issue. | Establish supported identifier association, field-level source mapping and the read-only source handoff contract. |
| Lifecycle, reason, type and labels | Open/closed is separate from source-supported reason, type and labels; closed does not automatically mean completed. | Verify field availability, current applicability, null/error interpretation and permissions. |
| Linked PR, parent/child and dependencies | 0078 keeps source-supported relation kinds and direction separate. A closing link, mention, hierarchy and blocked-by relation do not establish an actor's motive. | Complete per-connection visibility, source identity, pagination and safe navigation mapping; an external target does not become Project membership. |
| Blocked attention | 0063 counts distinct open affected Issues having at least one confirmed open direct blocker, while 0092 retains this condition on navigation. A blocker may be outside the Project. | Prove the source, target state and temporal applicability required for positive and negative results; define behavior when private relationship evidence cannot be disclosed. |
| Discussion and child counters | 0077 distinguishes Issue comments, participating GitHub Users and latest comment creation time; 0078 counts direct children and their supported lifecycle independently. | Verify population, visibility and ordering, including whether the source-labeled User count meets the intended broader participant meaning; do not replace it with a guessed author count. |
| Project and portfolio | 0057 and 0063 count an affected Issue once in each applicable Project and once in an explicitly deduplicated portfolio. An Issue and linked PR remain distinct objects, not necessarily independent tasks. | Provide typed scoped evidence and recoverable identity; establish completeness for any exact count and apply current disclosure. |

The added `shared_affected_issue_and_linked_pr` scenario in 0063 tests the
intended relationship and counting meanings together. It is a textual acceptance
candidate, not an executed test or a source observation. Future deterministic
tests should control identity, scope, access and time separately; actual GitHub
permissions, relationship semantics and native inspection require their own
evidence. Exact queries, visibility and the broader meaning of participant
remain open rather than being inferred from schema availability.
