# Project → Today: candidate boundary exchange contract

Status: agent-authored, pre-canonical interface design for 0104, 0110, 0115,
0116, 0119 and 0126. The names below identify contract roles; they are not
ontology entities, Swift declarations, selected packages or evidence of an
implemented adapter. Parent decisions and dependency readiness still apply.

## Shared envelope

Every exchange carries the applicable identifiers and context, rather than
relying on callback order or a visible cell position. A required component that
cannot be established fails preparation or yields an explicitly limited scope;
it is never supplied with a guessed default.

| Role | Required content | Optional or separately established |
| --- | --- | --- |
| Route evaluation | Route-instance and evaluation identities; Project identity; Project-wide or explicitly selected Repository intent; captured calendar day `[start, end)`; explicit type, lifecycle and attention filters. | Permitted density, anchor and origin are navigation context; they are not source identity or access evidence. An intentionally empty selection differs from an unrestricted filter. |
| Membership basis | Project configuration read outcome, with distinct confirmed Repository identities and supported configuration context. | Partial/unavailable membership and per-entry limitations remain explicit. A previous saved membership or operation receipt is not a current read. |
| Source observation | Source instance, account context, subject kind and identity, Repository association, field or event meaning, returned value or supported semantic absence, observation context. | Applicable event time, revision, ordering evidence, access and source representation are carried when needed for the particular claim. A failed, omitted or unrequested field is not a supported absence. |
| Scoped coverage | Exact requested Repository set or known scope, type, predicate and reference; independently supported completeness, partial/unproven or unavailable result. | A source aggregate may support its own count without materializing objects; a cursor and terminal page do not independently prove a complete population. |
| Effect outcome | Operation identity and bound intended effect; supported applied, terminal rejection/conflict or indeterminate outcome. | Source attempt, local fact write, coverage retention and history effect keep separate outcomes. A receipt is not a later read. |
| Disclosure | Current applicable access decision and its supported scope at each app-controlled presentation or handoff. | Historical authorization is provenance, not a current grant. A restricted identity or revealing count is not included merely to explain uncertainty. |

## Exchange by responsibility

| Producer → consumer | Request | Response and forbidden inference |
| --- | --- | --- |
| Project boundary → route | Read one Project or the requested portfolio under local context. | Valid configuration and version, supported absence, or partial/unavailable/inconsistent read. Membership is local; it does not assert GitHub work or current permission. |
| Source boundary → coordinator | For each admitted Repository, typed object category and discovery purpose, supply the effective query and account scope. | Attributable usable observations, field/portion limitations and traversal outcome. A returned object is not a complete Project population; one shared transport can carry independently attributed portions. |
| Coordinator → observation store | Submit one logical retention effect with its immutable operation binding and sufficient subject, fact and interpretation evidence; request current-cache/history effects separately. | Applied, terminal rejection/conflict or indeterminate for that effect. Do not repeat a conflicting operation merely because acknowledgement is missing; preserve the original source outcome independently. |
| Observation store → coordinator | Read requested subject or scope and field meanings with an authorized disclosure context. | Independently recoverable facts and scoped gaps, plus separately recoverable coverage and attempt/effect outcomes. No local record is not an empty GitHub result. |
| Coordinator → Today decision | Supply one confirmed typed candidate, its scope, captured day, explicit filters and prepared true/false/unknown predicate facts with applicable evidence. | Match, non-match or unknown for that candidate only. Non-applicability or unexpected no-result is an integration outcome, not silently a non-match. The decision does no I/O and does not establish population coverage. |
| Coordinator → summary decision | Supply a named metric and unit, captured scope and membership, independently applicable facts and coverage for that metric. | Complete-for-stated-context, observed subset with limitation, or unavailable/indeterminate. Do not reuse Today card count as an exact aggregate without compatible evidence. |
| Coordinator → route | Supply decisions, independently assessed coverage, effect/refresh limitations and permitted presentation facts bound to the evaluation identity. | Route presents permitted matches and reachable uncertainty, or a supported empty/filter state. A late old result cannot replace a newer route, filter, position or restriction. |

## Compatibility and lifecycle rules

1. Normalize identities only with source-supported associations. An open and a
   recent portion may identify the same PR; keep one candidate but retain each
   observation and portion's time, scope and limitation. An unresolved
   association is not a second confirmed card or a fabricated distinct count.
2. A new day, membership set, selected filter or applicable disclosure change
   produces a new evaluation context. Individual facts may be reused only where
   their identity, subject, time, scope and access remain applicable. Old
   coverage cannot be relabeled as coverage of the new context.
3. A returned page may carry both usable facts and an error. After a local
   retention failure, a still-permitted fact may be shown transiently with a
   limitation; after restart an independently valid read is needed. A newer
   access restriction governs both visible and accessible output immediately.
4. A source-confirmed zero, no local record, no matching known candidates,
   incomplete source coverage and an intentionally empty filter are distinct
   outcomes. None is silently converted into another.

The [worked example](today-source-union-worked-example-20261115.md) and
[assembly state](today-assembly-state-contract-20261115.md) specify expected
observable behavior. TDD should exercise the exchanges using separately
replaceable source, store, clock and access doubles; real permissions,
persistent restart and device behavior require separate evidence. Remaining
decisions include exact public Swift types and module ownership, selected
SpecificationCore version and no-result behavior, source-specific operations,
physical storage and platform scheduling. This document narrows those choices
but does not claim they have been selected or that all graph leaves are ready.
