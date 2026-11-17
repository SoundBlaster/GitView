# GitView implementation status

This is a code-progress record, not a claim that a product specification is fully implemented.

| Product specification | Implemented slice | Evidence | Remaining |
| --- | --- | --- | --- |
| GITVIEW-SPEC-0007 | Time eligibility, identity-checked paginated work grid and project-scoped filters | WorkDomain and GitHubWorkClient tests and iOS build | Live verification, full refresh recovery, accessibility and pinch interaction |
| GITVIEW-SPEC-0058 | PKCE attempt, token exchange, identity lookup and Keychain adapter | GitHubAuth sources and tests; Keychain adapter itself is not yet integration-tested | Real GitHub and Keychain integration tests, token refresh, saved session restoration and lifecycle |
| GITVIEW-SPEC-0059 | GitHub App installation and repository page fetch with partial-result aggregation | GitHubAPI DiscoveryTests and DiscoveryAggregateTests | UI, selection, persistence and live integration |
| GITVIEW-SPEC-0045 | Account-scoped Core Data project creation and retrieval, explicit single-repository creation UI | ProjectStoreTests including SQLite reopen; iOS build | Live source admission, UI tests, editing, recovery and synchronization |
| GITVIEW-SPEC-0023 | Account and project-scoped local work snapshot with freshness | WorkCacheTests, API Codable roundtrip, iOS build | Per-repository merge, revocation attribution, background refresh, real integration and UI tests |
| GITVIEW-SPEC-0014 | Discrete density steps, zoom menu, tap detail and ambiguous-target fallback | GridDensityTests and iOS build | Interactive pinch animation, position preservation and device/UI verification |
| GITVIEW-SPEC-0004 | Project grid with cached observed open PR and Issue counts and explicit coverage | iOS build; actual UI still under verification | Refresh orchestration, attention signals, chart/navigation and revocation status |
| GITVIEW-SPEC-0005 | Demo-only compact grid | TodayPage, injected DemoWork data | Navigation, pinch, previews, real data and full grid behavior |

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

## Initial delivery sequence

1. Today eligibility, FSD application shell and demo grid (in progress).
2. GitHub account access and source adapters using URLSession, with deterministic network fixtures.
3. Persistent local data and refresh; retain prior data when refresh fails.
4. Projects, repository membership, Today grid, persisted filters, navigation and preview.
5. Review/CI signals, metrics and other product flows, each tied to their graph nodes and module boundaries.

Order within later slices may change with the dependency and product decisions; none are reported complete merely because a node exists.

OAuth decision: web authorization with PKCE, no backend; a bundled GitHub client secret is extractable and is not treated as proof of client identity. Actual GitHub registration and connection remain to be completed.

A native connection screen now invokes the system web authentication session; it requires a separately registered GitHub App and local build configuration. No live authorization has been verified.

Simulator startup comparison: on the same clean iPhone Air simulator, the ad-hoc signed app started without the Keychain read error, while the linker-signed build displayed it. This is a signing-dependent observation, not verification of saving a token or real GitHub authorization. The connection screen now distinguishes Keychain errors from project-store errors and logs only a Keychain status code.
