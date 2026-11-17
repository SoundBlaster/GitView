# GitView implementation status

This is a code-progress record, not a claim that a product specification is fully implemented.

| Product specification | Implemented slice | Evidence | Remaining |
| --- | --- | --- | --- |
| GITVIEW-SPEC-0007 | Time eligibility, identity-checked paginated work grid and project-scoped filters; bounded refresh pages open work and the general stream independently and persists open-page progress for the next Project refresh | WorkDomain and GitHubWorkClient tests; iPhone Air Simulator UI tests with 100 synthetic work items, filtering and foreground return | Cross-refresh continuation remains best effort, not evidence of complete coverage; live app verification, full refresh recovery and accessibility review |
| GITVIEW-SPEC-0049 | Reevaluate cached Today selection when the system reports a day, significant-time or time-zone change, preserving project, filter and selected-object state | WorkDomain day-boundary tests; iOS simulator build | System-notification behavior during an active gesture or preview and physical-device verification |
| GITVIEW-SPEC-0058 | PKCE attempt, token exchange, identity lookup and Keychain adapter | GitHubAuth tests; synthetic Keychain write/read/update and system GitHub sign-in prompt on signed iOS 27.0 simulator | Live GitHub authorization, callback, token refresh and saved session lifecycle |
| GITVIEW-SPEC-0019 | Saved work remains visible on source failure; network, timeout and HTTP failures are distinguished without asserting revocation; complete discovery shows previously added repositories that were not returned and links to their Projects; detail offers retry and access management; user can remove attributable saved work for one Project, pause and resume synchronization | Simulator UI tests for complete and incomplete discovery, saved-work navigation, erasure and resume; storage/coordinator integration tests; synthetic HTTP 401, 403 and 404 and offline failures | Confirmed revocation, successful live recovery, unattributed legacy-data removal and physical-device verification |
| GITVIEW-SPEC-0059 | GitHub App installation and repository page fetch, partial-result aggregation and repository selection; incomplete refresh retains prior entries and permits freshly confirmed ones, while errors expose retry and empty results offer refresh | GitHubAPI DiscoveryTests and DiscoveryAggregateTests; simulator UI flows with synthetic session and network responses cover partial refresh, retry, empty results, and selecting a repository, creating a Project and displaying an Issue | Live GitHub App integration and broader error recovery |
| GITVIEW-SPEC-0045 | Account-scoped Core Data project creation, retrieval and repository membership editing; repository discovery is reachable directly from an empty or populated Projects overview | ProjectStoreTests including SQLite reopen; simulator UI tests for empty overview and discovery navigation | Live source admission and broader recovery verification |
| GITVIEW-SPEC-0023 | Account and project-scoped local work snapshot, per-repository merge and freshness; incomplete pages add and update observed objects while retaining unobserved work, including when a later page fails | WorkCache and ProjectWorkArchive tests, GitHub API pagination failure tests, simulator integration tests | Per-object observation timestamps, live revocation attribution, real integration and on-device verification |
| GITVIEW-SPEC-0048 | Manual and foreground refresh, bounded background task request, shared session rotation for an active account with unpaused work, project-scoped open-page continuation and rate-limit deferral | GitHubAPI and WorkDomain tests; simulator integration tests for concurrent foreground/background rotation, paused projects, preparation failure and cancellation, account change during preparation, batching, membership changes, preserved observations and pagination progress; plist configuration check | Physical-device BGTaskScheduler registration and execution, live background token rotation and GitHub rate-limit behavior |
| GITVIEW-SPEC-0014 | Discrete density steps, zoom menu, tap detail, long-press preview, ambiguous-target fallback and visible-work anchoring | GridDensityTests; iPhone Air Simulator UI tests for zoom after scrolling, both pinch directions, preview and filter preservation | Anchor behavior across data changes and rapid gestures, physical-device performance and broader accessibility verification |
| GITVIEW-SPEC-0015 | Long-press preview plus named accessibility action and menu path to a preview sheet preserving work identity; saved description and unambiguous source limitation remain visible | Simulator UI tests for preview-sheet navigation, cached Issue with a synthetic source failure, and failure observed on foreground return while preview is open | VoiceOver action, focus restoration, confirmed revocation and day-change verification on device |
| GITVIEW-SPEC-0011 | Independent CI and compact review indicators; attention takes precedence and approval requires complete zero-unresolved thread evidence | WorkDomain policy tests and dense-grid Simulator UI test | Full review source coverage, physical-device legibility and accessibility review |
| GITVIEW-SPEC-0031 | Preserve known source limitation and last observation when locally opening a cached object from preview; pass source context for metric selection | Simulator UI tests with synthetic HTTP 403 cover an already-open preview and recovery on foreground return while Issue detail remains open; existing metric-navigation test | Confirmed GitHub revocation attribution and physical-device verification |
| GITVIEW-SPEC-0033 | Restrict offered Issue and PR source links to observed matching repository, type and number; reject URLs with user information, query or fragment | GitHubAPI source-link policy tests; simulator UI tests confirm that a matching link remains available and a credential-bearing link is not offered while the object remains visible | Source identity after address reuse, handoff-time revalidation, private-data disclosure policy and live source opening remain unverified |
| GITVIEW-SPEC-0004 | Project grid with cached summaries, attention signals, synchronization-pause indication, scoped navigation, bounded foreground refresh, pull to refresh and visible-project anchoring during density changes | Simulator UI tests for project preview, signal navigation, paused source, zoom and summary reload on return after a work-only update; refresh coordination tests | Live revocation status, anchoring during rapid gestures or project changes, broader physical-device review |
| GITVIEW-SPEC-0047 | Project tiles show observed open PR and Issue counts alongside attention counts and an incomplete-data indicator; six- and eight-column cells use a single priority signal and show full summaries in context previews; accessibility text sizes use a single flexible column | Simulator UI tests and screenshots cover one-digit counts in light mode, three-digit counts in dark mode at normal and one accessibility text size, six/eight-column layouts, preview and failed-CI navigation | Other text sizes, VoiceOver operation, full metric coverage and physical-device presentation |
| GITVIEW-SPEC-0005 | Project work grid and separate labeled demo grid | Simulator UI tests with synthetic project data, pinch, previews and filters | Live GitHub data and full grid behavior |
| GITVIEW-SPEC-0029 | Project metrics identify each source observation time, refresh error and synchronization pause | Simulator UI tests for a synthetic failed source and a paused repository | Full live source validation |
| GITVIEW-SPEC-0030 | Keep a separately captured complete repository snapshot for seven-day merge and last-observed-closed Issue metrics when later refreshes are incomplete; recalculate only for covered current membership and label observation times | GitHubAPI archive tests for scope and erasure; SQLite reopen and synthetic recovery integration test; simulator UI tests for saved graph, selection, historical detail, app relaunch and changing project membership | Earlier archives without the new snapshot have no retroactive baseline; confirmed revocation and live GitHub coverage remain unverified |

The demo data is deliberately labeled and is not a GitHub integration. SpecGraph `next-move` and `lint` describe graph structure; they are not implementation evidence. Module boundaries are recorded in SpecPM packages next to their code.

## SpecGraph work item

The installed runtime was used to generate an implementation delta and work index for `GITVIEW-SPEC-0007`:

```sh
SPECGRAPH=/Users/egor/.local/share/specgraph/runtime-aa9f6cb9-py313/specgraph-runtime
"$SPECGRAPH" --workspace "$PWD" supervisor -- --build-implementation-delta-snapshot \
  --target-scope-kind spec --target-spec-ids GITVIEW-SPEC-0007 \
  --operator-intent 'Track implementation of Today time eligibility in WorkDomain.'
"$SPECGRAPH" --workspace "$PWD" supervisor -- --build-implementation-work-index
```

The resulting local `runs/implementation_work_index.json` is derived, ignored, and reproducible; it reports `blocked_by_trace_gap` with missing trace and evidence baselines. It does not establish that this whole spec has been implemented or tested. The implementation table above provides direct code/test links until a supported binding is established.

The same `--build-implementation-delta-snapshot` command was run for `GITVIEW-SPEC-0048` on 2026-11-17, including after the session orchestration change. It returned `ready_for_planning` and `tracked_artifacts_written: false`: this is a planning result, not a trace binding or evidence that system background execution occurred. The simulator reports `BGTaskScheduler` unavailable; the scheduler registration test is therefore skipped there and remains a device check.

The delta snapshot for `GITVIEW-SPEC-0049` likewise returned `ready_for_planning` and `tracked_artifacts_written: false`; the day-boundary slice above is not a complete implementation or a verified trace binding.

The delta snapshot for `GITVIEW-SPEC-0004` returned the same planning status without tracked artifacts. The foreground overview coordinator is covered by tests for shared repositories and changes to account or membership; it does not establish live GitHub App access.

The delta snapshot for `GITVIEW-SPEC-0023` also returned planning status without tracked artifacts. An incomplete page preserves the last complete observation time; individual merged objects do not yet carry separate source-observation timestamps.

The delta snapshot for `GITVIEW-SPEC-0015` returned planning status without tracked artifacts. The preview UI tests exercise the menu and sheet path, not VoiceOver's custom-action rotor or focus behavior.

The delta snapshot for `GITVIEW-SPEC-0031` returned planning status without tracked artifacts. A synthetic HTTP 403 verifies disclosure of a known source problem; it does not establish that GitHub confirmed access revocation.

The delta snapshot for `GITVIEW-SPEC-0011` returned planning status without tracked artifacts. The compact review badge is a source-specific signal, not a readiness-to-merge decision.

The delta snapshot for `GITVIEW-SPEC-0014` returned planning status without tracked artifacts. Simulator tests cover one visible-work anchor through zoom in and out; they do not establish full transition or gesture behavior.

The delta snapshot for `GITVIEW-SPEC-0019` returned planning status without tracked artifacts. Retrying a synthetic failed detail request leaves saved details visible; opening GitHub settings and successful access recovery have not been verified end to end.

Project-scoped erasure removes attributable observations from the selected archive and pauses that repository in that Project; it does not modify other Projects or GitHub. If legacy work cannot be attributed to a repository, erasure is refused. This is logical removal through Core Data, not a claim of forensic erasure from SQLite pages or backups.

An isolated Simulator UI test and an erasure-to-resume UI test verified that the explicit Resume sync control clears the paused state. They use synthetic local data and do not demonstrate a successful subsequent GitHub fetch.

## Initial delivery sequence

1. Today eligibility, FSD application shell and demo grid (in progress).
2. GitHub account access and source adapters using URLSession, with deterministic network fixtures.
3. Persistent local data and refresh; retain prior data when refresh fails.
4. Projects, repository membership, Today grid, persisted filters, navigation and preview.
5. Review/CI signals, metrics and other product flows, each tied to their graph nodes and module boundaries.

Order within later slices may change with the dependency and product decisions; none are reported complete merely because a node exists.

OAuth decision: web authorization with PKCE, no backend; a bundled GitHub client secret is extractable and is not treated as proof of client identity. A development GitHub App has been registered and installed on one account, and its credentials configured locally. This does not establish a successful user authorization.

A native connection screen invokes the system web authentication session. A signed Simulator UI test confirmed the GitGrid system prompt; a separate live probe found GitHub's sign-in accessibility element, although its screenshot was still loading. On 2026-11-17 the user reported successfully connecting their personal GitHub account and creating a Project with ISOInspector on the physical iPhone Air. These are user-reported outcomes; work loading and token/session lifecycle have not yet been independently verified.

The user subsequently supplied Air screenshots showing the ISOInspector Project with PR #1131, zooming the work grid, and opening PR details with CI and review counters. The screenshots demonstrate that specific live path, not complete repository coverage or general session recovery.

In response to that device observation, grid cells use ungrouped identifiers, readable primary text and a separate compact review icon; a simulator UI test and screenshots cover PR #1131 at compact and expanded scales. The revised layout has not yet been visually verified on the physical device.

On 2026-11-17 the current app was built, installed, and launched on a physical iPhone Air via CoreDevice. That launch evidence alone does not establish visual behavior or GitHub authentication.

The implementation delta snapshot for `GITVIEW-SPEC-0033` returned `ready_for_planning` and `tracked_artifacts_written: false`; the link validation slice above is not a complete trace binding or proof of external handoff.

The implementation delta snapshot for `GITVIEW-SPEC-0047` likewise returned `ready_for_planning` and did not write tracked evidence; the compact counters do not implement the entire Project summary specification.

Read-only GraphQL probes using the separate GitHub CLI session accepted the exact work, PR detail, review thread, Issue detail, Issue link and Issue relation query shapes against public repositories. On 2026-11-17, two opt-in Swift tests also decoded live GitView repository work and PR details, and a public Swift Issue with its links and relations. Both live tests skip without an explicit flag. These observations do not establish GitGrid authorization or the user's installation permissions.

An additional opt-in probe on 2026-11-17 used the GitHub CLI credential to run the open-priority and general-stream requests against the GitView repository and decode PR details and threads. It confirms these request shapes and decoding for that repository, not OAuth or access through GitGrid's GitHub App.

A four-request opt-in probe against public `swiftlang/swift` on 2026-11-17 returned more than 100 distinct open Issues and explicitly incomplete coverage. A second bounded refresh resumed the open cursor and returned additional Issues not present in the first result. Both used the GitHub CLI credential; neither demonstrates a complete refresh or GitGrid OAuth.

Historical fallback uses the last separately captured complete observation and the oldest observation time among included repositories. Existing archives created before this snapshot was introduced do not gain a fabricated historical baseline; a future complete refresh must establish one. Current work counters remain based on the latest retained observations, with source limitations.

Simulator startup comparison: on the same clean iPhone Air simulator, the ad-hoc signed app started without the Keychain read error, while the linker-signed build displayed it. This is a signing-dependent observation, not verification of saving a token or real GitHub authorization. The connection screen now distinguishes Keychain errors from project-store errors and logs only a Keychain status code.

`GitViewIntegrationTests/KeychainIntegrationTests.swift` exercises a UUID-scoped synthetic credential on an ad-hoc signed iPhone Air simulator; the result is not evidence of a live GitHub authorization or physical-device behavior.
