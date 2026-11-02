# GitView product discovery

Status: pre-canonical notes from the initial product conversation. These notes
are inputs to review and specification, not claims about implemented behavior.

## Problem and scale

The owner wants a more compact view than the official GitHub iOS app for work
generated across many repositories, including work produced by coding agents.
An event-by-event inbox makes it hard to see the current state of a project or
identify what needs attention. The intended usage includes dozens of active
repositories and a high volume of contributions and pull requests.

## Agreed direction

- `User` means the operator of GitView. GitHub identities remain separate;
  authors, reviewers and assignees are not automatically that operator
  (`conversation:gitview/excerpt-53-reply`).

- Native iOS with an Apple Look: system components and colors, SF Symbols,
  Liquid Glass, and minimal custom decorative UI.
- A zoomable grid inspired by Photos, moving between a portfolio of projects,
  project contents, and a pull request or issue. Pinch is a primary interaction;
  accessible alternatives also matter.
- Within one scope, zoom has many density steps, including roughly eight small
  cells per row and about a hundred visible objects. The two-column prototype
  showed only a large scale. Sliding preview is especially useful for dense
  cells: it reveals details while preserving the bird's-eye view (`excerpt-46`).
- A broad view of activity, work awaiting review, ready work, and problems
  including failed CI and long or unresolved review threads.
- Charts and metrics, lightweight review, and convenient sharing.
- First-version requirement: long-press Peek and Pop on cards, with a preview
  before opening the object (`excerpt-43`). A later sliding rich preview should
  follow the object under the finger across cards. Long press as its activation
  is a tentative user hypothesis (`excerpt-44`); exact pan/hover behavior remains
  to be specified. See `docs/drafts/ux-preview-interactions.md`.
- GitView offers a minimal overview rather than replacing GitHub: entities can
  link to their original source, with title, ID, badges and text as the user's
  examples of compact content (`excerpt-15`).
- SpecGraph manages the product specification workflow; FSD iOS informs
  application architecture; SpecificationCore is an intended Swift policy
  library.
- A GitView project contains one or more repositories. A repository may belong to
  several projects; by default there is one project per repository. GitHub
  organizations are metadata, and a project may include repositories from
  different organizations (conversation `excerpt-10`). Project is the domain
  concept; a separate Group concept is currently redundant, though it could be
  defined if needed (`excerpt-11`, `excerpt-12`).
- Current product scope is specifically GitHub-managed repositories. GitHub
  acts on Repository, establishing a management relation in which it is called
  `GitHubRepository` (`excerpt-31`). The application expects GitHub-specific
  properties, whose exact set remains open. GitLab and BitBucket may be added
  later; `GitManagementSystem` and `ManagedRepository` are unnecessary
  generalizations for the current product.
- Project properties and summary are agreed in `conversation:gitview/excerpt-41`:
  local ID, name, optional description and repository membership; combined
  PR/Issue counts, attention signals, period results and graphs with visible
  data coverage. Navigation supports both the repository grid and direct
  filtered work selections from Project counters. A single-repository Project
  opens its PR/Issue contents without a duplicate repository screen. Portfolio
  totals count shared repositories once. Exact computation and navigation rules
  remain specification work; see `docs/drafts/project-summary-proposal.md`.

## Ideas to refine

- `Activity` likely concerns actions, distinguished for now from the current
  state of PRs and CI. The owner agreed not to introduce a separate Activity
  entity yet and suggested observing the project before settling its meaning
  (`conversation:gitview/excerpt-28-reply`, responding to the two linked agent
  proposals). This remains a working hypothesis, not a settled definition.
- A GitHub-style activity calendar may be the most distant view. A calendar
  cell represents a day, whereas a project-grid cell represents a repository;
  a transition between them needs explicit time and scope semantics.
- Separate a current-state view from changes since the previous visit.
- Preserve the selected object and position while changing scale, where the
  navigation model permits it.
- Keep activity volume separate from CI/review health. An incomplete or stale
  result should not be shown as ready.
- Add a deeper view inside a PR later; its scope is not defined yet.

## Open questions

Current priority is ontology completeness first, then the specification graph
built on it (`excerpt-52`). Further visual review-indicator work is deferred.
See `ontology/domain-model.md`, `ontology/review/completeness.md` and
`docs/drafts/specification-coverage-map.md` for the consolidation and gaps.

1. What is the smallest first useful version, and which actions must it support?
2. What is the precise meaning of ready, blocked, awaiting review, and unknown?
3. Which GitHub accounts and repositories are in scope, and how is access granted?
4. Which metrics, periods, and definitions are useful? What data is available?
5. How do date selection, project selection, zoom levels, and return navigation
   relate, especially when moving between time and repository views?
6. What freshness guarantees, offline behavior, and notification expectations
   are needed?
7. What content is included when sharing, particularly for private repositories?
8. Which iOS deployment target, data persistence strategy, dependency versions,
   and FSD integration mode should be selected?
9. Can agent provenance be distinguished from GitHub data for this user's
   workflow, or does it require explicit labels or another source?

The proposed UI mockups from the conversation are exploratory illustrations,
not approved visual or functional specifications.
