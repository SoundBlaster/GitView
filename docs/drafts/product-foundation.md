# GitView: product foundation

Status: exploratory foundation for review, not canonical specs or implemented
behavior. The source is `.specgraph/root_intent.md` and the Git-tracked
conversation sketch at revision `998677aa29ca4a7597997b7e751cc546`, especially
`overview`, `attention`, `metrics`, `zoom-grid`, `calendar`, `apple-look`,
`foundations`, `foundation-first`, `project-repository` and
`github-organizations`.

## Idea

GitView is a personal native iOS view of work across GitHub repositories,
including the high volume of PRs and issues produced by coding agents. It
should help its owner understand what is active, what awaits review, what is
ready, and where CI or review discussions need attention. Metrics, lightweight
review and sharing support that overview.

## Candidate domain vocabulary

These are working definitions for discussion, not accepted ontology terms:

| Concept | Working meaning | Boundary / question |
| --- | --- | --- |
| Account | GitHub identity whose accessible work is viewed | Multiple accounts and organization access are open |
| Repository | GitHub container for issues and PRs | Can belong to multiple GitView projects |
| Project | A GitView project contains one or more repositories | Default: one project per repository; membership is many-to-many |
| GitHub organization | GitHub metadata associated with repositories | A project may contain repositories from different organizations |
| Work item | A PR or issue shown in context | Other object types are not excluded yet |
| Pull request | Proposed code change with review and checks | Review and CI do not alone prove readiness |
| Issue | GitHub-tracked item that can describe work or a problem | Relationship to PRs needs definition |
| Review thread | Discussion attached to a PR review | Long-running and unresolved are different properties |
| Check | CI or status result for a particular revision | Required checks, incomplete data and freshness need policies |
| Activity | Events over time | Event volume is distinct from current health |
| Metric | Measurement with a defined population and time range | Exact definitions and historical data sources are open |
| View scale | Amount of context and detail shown | Time-based calendar cells differ from project cells |

GitHub is the external source of repository, PR, issue and check facts; the
application's derived state and any local annotations need their own explicit
provenance and freshness. An agent may produce work, but its identity cannot be
inferred reliably merely from a PR author.

The project/repository relationship and cross-organization membership are the
user's clarification in `conversation:gitview/excerpt-10`. In
`conversation:gitview/excerpt-11` the user clarified that **Project** is the
domain concept. In `excerpt-12` the user noted that a separate Group concept
could be defined but is currently redundant; revisit if a distinct need arises.
Details of how
default projects are created, named, edited or synchronized remain open. No
identity with the separate GitHub Projects feature is assumed.

## Application boundary

Proposed responsibilities: discover selected work, present its current state and
changes, let the user inspect and share it, and calculate understandable metrics.
Authentication, refresh, storage, notifications and write actions remain open.
FSD iOS is the intended architectural approach; SpecificationCore is intended
for suitable domain decisions. Neither is an implemented integration yet.

## UX direction

The accepted direction is an Apple-like native interface with system components,
SF Symbols, system colors and Liquid Glass. A Photos-inspired zoomable grid is
the central idea. A calendar at the farthest level and a deeper view inside a
PR was suggested as a future possibility; the user subsequently clarified
that the current scope does not delve inside a PR and should show its metrics
instead (`conversation:gitview/excerpt-14`). Pinch behavior, navigation,
accessibility alternatives and what appears at each scale need design review.

## Proposed specification map

These are candidate concerns, not allocated spec nodes or a commitment to a
particular hierarchy:

1. Product intent and scope.
2. Domain vocabulary, relationships, provenance and freshness.
3. Application boundary and GitHub access.
4. UX principles, navigation and scale.
5. Work-state interpretation and attention.
6. Metrics, sharing and lightweight review.
7. Evidence: tests and real-device observations for each implemented slice.

## SpecGraph observation

The installed runtime produced `runs/exploration_preview.json`, with
`review_state: preview_only` and no canonical mutation. Its assumption,
hypothesis and proposal nodes are placeholders: it did not derive this domain
vocabulary. The vocabulary and map above are agent-authored proposals based on
the cited conversation, not tool-generated or owner-approved ontology.

The earlier intake experiment's `owner_confirmed` domain attribution was not
valid human confirmation; see `first-specgraph-intake.md` before using it.
