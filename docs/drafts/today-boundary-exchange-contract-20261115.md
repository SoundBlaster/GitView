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

## Limitations that cross a boundary

These are semantic cases, not a prescribed exception hierarchy. An outcome may
carry multiple independent limitations; the consuming route must not flatten
them to one success flag or one catch-all empty collection.

| Origin and condition | Minimum supported handoff | What the receiver can and cannot conclude |
| --- | --- | --- |
| Local Project read unavailable or inconsistent | Read context, safe local limitation and any independently valid isolated entries. | It cannot confirm an empty portfolio or admit writes whose required configuration is unverified. Source reachability is independent. |
| Source portion not admitted, deferred or locally cancelled before a usable result | Captured portion and scheduling outcome; preserve a real source-attempt time if independently established, without inventing one for unstarted work. | It is unobserved, not a GitHub error or a terminal empty page. Cancellation does not prove an independently submitted storage effect was undone. |
| Source request failed, was rate-limited or timed out | Attempt scope and only the reason and retry constraints supported by actual evidence; the source outcome is separate from saved facts. | Eligible last-known facts retain their time and access limitations. An ambiguous error is not automatically a credential rejection, Repository denial or zero. |
| Source response has usable facts plus a field/portion error | Supported facts plus an attributable field or scope limitation, each with its own context. | A title can be usable while CI or review is unavailable; neither the sibling success nor HTTP status makes the whole selection complete. An unscoped error does not identify a particular hidden object. |
| Current credential generation is authoritatively rejected | Applicable generation and restriction context under 0112, separate from the reason for rejection. | Affected private material is restricted; do not invent whether expiry, revocation or a particular Repository caused it. A late rejection for an older generation is not automatically a rejection of its replacement. |
| Fact or limitation write is indeterminate | Original logical operation identity, bound intent, effect and indeterminate outcome. | Source evidence may remain usable transiently if allowed; the write is neither confirmed rolled back nor durable, and an unsafe new operation is not admitted. |
| Current local fact read unavailable or evidence binding inconsistent | Requested scope and safely attributable local limitation, plus any independently recoverable compatible facts. | A historical receipt does not substitute for a readable current fact; an unrelated fact does not repair the missing field, coverage or time. |
| Candidate identity, scope or fact applicability unresolved | Safe unresolved scope or candidate limitation where disclosure permits; preserve any separately supported facts. | It cannot be sent as a different confirmed object, a confirmed non-match or a source deletion. A restricted identity need not be revealed in an uncertainty list. |
| Decision has an invalid required input or an unexpected no-result | Integration/preparation failure tied to its captured evaluation, without assigning a domain decision. | Do not interpret it as `unknown`, `false`, source failure or empty selection. Valid domain `unknown` remains a separate supported result. |
| Route or disclosure context changes before completion | Result's original evaluation and access scope, and a later current-context check. | Preserve eligible facts for their own scope if policy allows, but do not replace newer choices or expose content under an invalidated grant. Re-evaluation has its own identity. |

For every case, raw authorization values, private source paths and unneeded
error messages stay outside the presentation contract. Last-success timestamps
belong only to the source scope and meaning they actually establish. A
limitation remains recoverable after restart only if its own attributable
evidence was retained and can be read; otherwise report the supported unknown,
not a reconstructed error reason.

The [worked example](today-source-union-worked-example-20261115.md) and
[assembly state](today-assembly-state-contract-20261115.md) specify expected
observable behavior. TDD should exercise the exchanges using separately
replaceable source, store, clock and access doubles; real permissions,
persistent restart and device behavior require separate evidence. Remaining
decisions include exact public Swift types and module ownership, selected
SpecificationCore version and no-result behavior, source-specific operations,
physical storage and platform scheduling. This document narrows those choices
but does not claim they have been selected or that all graph leaves are ready.
