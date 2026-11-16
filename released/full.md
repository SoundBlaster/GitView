# GitView: полный снимок графа

Git `f36727a904035a08751629ba1bb477eb9d41fbe5`. Исходные YAML; это не экспорт HyperPrompt.

## GITVIEW-SPEC-0001: GitView - product intent and scope

Источник `specs/nodes/GITVIEW-SPEC-0001.yaml`, SHA-256 `4ce9118d194212a4be43d79340e78e28b9e23273abc9243e0fd15de41906bae4`

```yaml
id: GITVIEW-SPEC-0001
title: GitView - product intent and scope
kind: spec
created_at: '2026-11-15T17:42:00Z'
updated_at: '2026-11-16T19:20:35Z'
status: specified
depends_on: []
relates_to: []
sources:
  root_intent: .specgraph/root_intent.md
  discovery_draft: docs/product-discovery.md
  predecessor_draft: docs/drafts/GITVIEW-SPEC-0001.yaml
  predecessor_revision: 77bea62b255c4ac6ada9228111c1f2b72b0944c9
  current_work_decision:
    path: conversation_memory/sketches/gitview/revisions/a748240310ba46aca7e16424b35f2b3c/notes.hc
    node: grid-today-current-work
  merged_pr_decision:
    path: conversation_memory/sketches/gitview/revisions/a939a7dabd094fe29fa89305b56695d6/notes.hc
    node: current-work-merge-metrics-decision
  today_all_states_and_persistent_filters:
    path: conversation_memory/sketches/gitview/revisions/ed322706b55a4798a4328a69982fcbae/notes.hc
    node: today-all-states-persistent-filters
  today_calendar_boundary:
    path: conversation_memory/sketches/gitview/revisions/cc419cb9283f471b88b6f4b66e56c5ad/notes.hc
    node: today-calendar-boundary-decision
  today_timezone:
    path: conversation_memory/sketches/gitview/revisions/3077fdcd9a8247769def8d6403c2e61c/notes.hc
    node: today-timezone-decision
  historical_signal_filter_override:
    path: conversation_memory/sketches/gitview/revisions/32213bd5294945d0ba9f0a63c37298de/notes.hc
    node: historical-signal-filter-decision
  historical_membership_decision:
    path: conversation_memory/sketches/gitview/revisions/a55f271ca16f4283bfaf67095616ee7a/notes.hc
    node: historical-project-membership-decision
  revoked_private_data_decision:
    path: conversation_memory/sketches/gitview/revisions/b0795ae580e94ba0be8c59cefcbd3a97/notes.hc
    node: revoked-private-display-decision
  ontology_context: ontology/packages/gitview/versions/0.2.0/composition-context.yaml
  signal_filter_context_decision: conversation_memory/sketches/gitview/revisions/9544eaa87e5b4afcb48910299d60c520/metadata.json
  ready_meaning_decision: conversation_memory/sketches/gitview/revisions/23fe1cc490924a219f38c4bee721511f/metadata.json
  review_wait_meaning_decision: conversation_memory/sketches/gitview/revisions/8cefadc82b764a64b09fd8c3123f2f28/metadata.json
  calendar_farthest_zoom_direction: conversation_memory/sketches/gitview/revisions/a854ef50dc2a4548b9003227f731e31e/metadata.json
  product_narrative_feedback: conversation_memory/sketches/gitview/revisions/7f506a455c2d448985358f5f5a2a977e/metadata.json
  root_finalization_request: conversation_memory/sketches/gitview/revisions/23cd347571cb4cd69879ff82a46c18f9/metadata.json
specification:
  ontology_refs:
  - gitview:User
  - gitview:Project
  - gitview:Repository
  - gitview:GitHubRepository
  - gitview:projectIncludesRepository
  - gitview:GitHub
  - gitview:PullRequest
  - gitview:Issue
  - gitview:ReviewThread
  - gitview:CIStatus
  - gitview:Metric
  objective: Give a person managing many GitHub repositories a compact native iOS overview of current
    PR and Issue work, including work produced by coding agents, attention and outcomes, with a path to
    the original GitHub objects.
  authority_boundary: This node specifies the selected product intent and scope at the root level in response
    to the owner’s finalization request. Open items below are delegated refinements, not silently chosen
    answers. Linked drafts remain drafts and child specifications retain their own statuses; the selected
    local ontology was accepted separately. This status does not claim a working application, full-graph
    approval, or readiness to implement or release.
  product_scope:
    organization: GitView Projects each contain one or more GitHub repositories. A repository may belong
      to more than one Project; by default there is one Project per repository. A Project can include
      repositories from different GitHub organizations.
    repository_identity: A source-confirmed rename or transfer of the same GitHub repository preserves
      its identity, history and Project membership. A reused address or name does not itself establish
      identity.
    current_work: Today is the opening view of current work, not a past-state viewer. It includes unfinished
      work from earlier days and work completed during the current calendar day in the user's local time
      zone. A completion on the previous day alone does not qualify an object for the next day's Today;
      other applicable conditions may do so. Its unfiltered Project grid includes PRs and Issues in all
      lifecycle states, including merged and closed; explicit filters may hide them. An applicable confirmed
      merged PR leaves an unfinished-only selection, not the unfiltered Today grid; its supported result
      is reflected in the appropriate metric when sufficient evidence exists. A partial or failed refresh
      does not by itself establish a merge, deletion or empty selection. Source coverage and how much
      historical work is loaded remain to be specified; an unfiltered view alone does not prove every
      source object was retrieved.
    overview: The operator can inspect PRs and Issues with their source context and selected status, review,
      CI and discussion signals, including failed CI and unresolved or long-waiting review threads. Distinct
      source facts and metrics retain their meanings; missing or stale observations are not reported as
      success or zero. The owner wants to notice review threads that have long awaited a reply to the
      latest message; threshold and evidence remain open. For PRs, the primary «Done» indicator means
      merged; show readiness to merge separately, with its predicate and evidence still to be defined.
    interaction: A Photos-inspired zoomable grid supports inspecting work at different densities using
      pinch, and navigation from Projects to their work and object overviews. Density changes occur in
      discrete levels; when a cell reaches its maximum size, pinch enters the corresponding next level
      when the intended target is unambiguous. Ordinary entry to a multi-Repository Project opens its
      shared work grid; its Repository list is in Project settings. First-version long-press preview,
      explicit opening, returning to context and accessible alternatives to gestures are part of the selected
      direction. Exact transition details and gesture arbitration require refinement; sliding preview
      and deeper in-app PR exploration are later ideas.
    source: GitView offers a path to the original GitHub object and lightweight sharing of supported source
      objects; sharing the local Project itself is not required for the first version; it is an overview,
      not a replacement for GitHub.
    history: 'Historical measurements and charts are in scope. A viewer reconstructing the Project at
      an earlier date is not required. The owner envisages a contribution-style calendar as the farthest
      zoom level: its day cells indicate intensity of work in the selected Project scope, not CI health;
      calendar time cells and Project or repository cells have different meanings. Further zooming out
      from Today is the proposed route to that view. Historical Project graphs are recalculated over the
      selected period using current Project Repository membership, subject to applicable evidence and
      access; this does not reconstruct past Project membership. Metric units, period, scope and evidence
      require refinement.'
    descriptions: The owner selected structured Issue and PR description templates, including Problem,
      Motivation, Expected outcome and References; the PR template also includes Changes and Validation.
      Their application and enforcement for different authoring paths remain to be specified; existing
      external objects retain their original content.
    filters: The operator can explicitly hide applicable lifecycle states. With no saved exclusions, Today
      includes all applicable states; explicitly selected filters persist between app launches and are
      restored when applicable, so a saved exclusion may narrow the opening view. Failed or unavailable
      persistence must not be presented as a confirmed save. The exact scope of saved filters, reset interaction
      and synchronization across devices require refinement. Opening a historical merged-PR counter temporarily
      overrides a saved exclusion of merged PRs for that transition so its supported result can be shown;
      this temporary override does not itself rewrite the saved preference. Other filter interactions
      and return behavior require refinement. A signal originating within a filtered scope opens its work
      within that scope. A signal originating outside a filter context is not narrowed by that unrelated
      filter; the destination follows the actual origin context under 0092. Other scope details remain
      open. The previously selected historical merged-counter case concerns a counter whose originating
      scope includes merged PRs; a saved exclusion outside that origin does not narrow its destination.
      A counter defined inside a merged-excluding scope instead retains that origin scope.
    data: GitView stores previously received data locally so supported available information can be revisited
      without repeatedly fetching it. Offer manual refresh, using pull-to-refresh or an appropriate equivalent.
      Request a refresh of stale information on opening when applicable, and use iOS background opportunities
      without promising a fixed frequency. A failed GitHub refresh must be clearly indicated, with the
      last successful update time for its supported scope when known; incomplete or failed refresh is
      not a confirmed empty result. Observation times and limitations retain their actual scopes. After
      external GitHub access revocation for a private Repository, keep already saved local data; while
      its account remains active, show it with a revocation indicator and the supported last update time
      when known. Stop synchronizing that Repository while revocation applies. While account B is active,
      do not show private data saved from account A; switching does not delete that data. This account
      boundary applies to the other visibility rules in this graph under 0019. Do not invent a time or
      treat network failure alone as proof of revocation. Other private-data cases remain open.
    platform: Prefer Apple system appearance and components, SF Symbols, system colors and Liquid Glass
      with minimal decoration, while providing accessibility and alternatives to gesture- or color-only
      operation.
    engineering: The owner requested SpecGraph in a separate product workspace, testability, dependency
      injection, TDD and appropriate network and data mocks, FSD-iOS for architectural organization and
      SpecificationCore for suitable named domain decisions. Concrete integration requires refinement
      and verification.
  open_questions:
  - Behavior when the user's time zone or day changes, other inclusion conditions, and source coverage
    represented by the unfiltered Today grid.
  - Scope, reset behavior and cross-device synchronization, if any, for persistent filters.
  - Predicate and evidence for readiness to merge and for waiting for a reply to the latest review message;
    duration threshold remains open.
  - Private-data availability for ordinary offline use, disconnect, other account changes and restoration;
    exact confirmation and recovery behavior for explicit revocation and presentation of missing update
    times.
  - Sharing payload, historical metric periods and handling uncertain current membership, supported devices
    and exact native interactions.
  - Detailed GitHub source mappings, authorization, storage guarantees and implementation-ready leaf contracts.
  ontology_status: The project selects local.gitview.domain at 0.2.0, approved by the owner as the project
    terminology baseline. Imported packages retain their own status. This specification does not itself
    grant ontology approval or assert a particular action, motivation or source event.
  refinement_boundary: This root establishes product outcomes and the owner-selected scope, not technical
    design or implementation-ready leaf contracts. Its open questions identify work delegated to the applicable
    descendant specifications and future product decisions; they do not automatically choose a solution
    or certify the descendants. Calendar first-version inclusion, reverse pinch details, ready-to-merge
    predicate and long-wait threshold remain unselected.
acceptance:
- The operator can survey Projects and their GitHub repository work, identify attention and supported
  outcomes, and reach the original GitHub objects.
- Projects contain one or more repositories and can share a repository; repository identity and Project
  membership survive a source-confirmed rename or transfer.
- Today presents older unfinished work and work completed in the current local calendar day, including
  merged or closed objects unless applicable persistent filters hide them; an object remains one object
  when its state changes.
- The overview supports discrete zoom and accessible inspection, including first-version long-press preview
  and explicit opening, while retaining valid Project and selection context.
- PR review, CI, discussion and lifecycle remain distinct, with merged PRs represented as the primary
  Done outcome and readiness to merge a separate signal whose predicate remains to be defined.
- Historical Project graphs use current repository membership, disclose missing evidence, and do not portray
  unknown history as zero; the envisaged calendar shows daily work intensity rather than CI health.
- Locally stored supported observations remain distinguishable from current source facts; refresh failure
  is visible and confirmed private Repository revocation follows the selected retained-data and account-switch
  boundaries.
- The product scope preserves system appearance, accessibility, lightweight source sharing and the selected
  engineering directions without declaring an implementation or implementation-ready descendants.

```

## GITVIEW-SPEC-0002: GitView - Repository identity across rename and transfer

Источник `specs/nodes/GITVIEW-SPEC-0002.yaml`, SHA-256 `29242520fd90065c3eef84c5857e8d219bd45fd978616a6d48158542c0f4455e`

```yaml
id: GITVIEW-SPEC-0002
title: GitView - Repository identity across rename and transfer
kind: spec
created_at: '2026-11-15T18:25:00Z'
updated_at: '2026-11-16T19:42:49Z'
status: specified
refines:
- GITVIEW-SPEC-0001
depends_on: []
relates_to: []
sources:
  predecessor_draft: docs/drafts/GITVIEW-SPEC-0002.yaml
  predecessor_revision: 523f1057d5114f800350015721bdf1805fe5e550
  owner_decision: ontology/review/repository-identity.md
  owner_source_identity_decision: conversation:gitview/excerpt-60-reply
  ontology_context: ontology/packages/gitview/versions/0.2.0/composition-context.yaml
  ontology_owner_acceptance: ontology/review/owner-acceptance-20261116.md
  identity_evidence_review: ontology/review/repository-identity-ontology-tension-20261116.md
specification:
  ontology_refs:
  - gitview:GitHub
  - gitview:Repository
  - gitview:GitHubRepository
  - gitview:Project
  - gitview:projectIncludesRepository
  objective: Preserve the identity and context of a GitHub Repository as its name or owner changes.
  authority_boundary: The owner selected continuity for a source-confirmed same object and accepted numeric
    ID examples; the later owner-approved GitView ontology 0.2.0 selects the numeric REST repository ID
    as a same-instance comparison key. This is not evidence that a particular transfer, source response,
    integration or storage implementation was observed. Source coverage, identifier availability and cross-instance
    identity remain separately constrained.
  requirements:
    continuity: When GitHub confirms that a renamed or transferred repository is the same source object,
      GitView keeps one Repository with its existing history and all Project memberships. A change of
      owner does not itself rename a Project or create another Repository.
    address: A repository name, owner or address may change and alone does not establish identity. When
      a changed address is confirmed to be current, GitView updates the supported current source address.
    selected_id_examples: 'Within one GitHub instance, compare confirmed numeric REST repository IDs under
      the selected ontology policy: the same ID identifies the same Repository, while a different ID identifies
      a different Repository even at a reused address. The owner approved the recorded same/different
      numeric examples, and later approved the ontology containing the REST mapping; those are distinct
      decisions. An ID match alone does not prove that a transfer happened.'
    distinct_objects: If GitHub confirms that an object at a previously used address is a different repository,
      it does not inherit the earlier Repository's history or Project memberships merely through that
      address.
    uncertainty: An unavailable, incomplete or ambiguous observation does not establish identity, deletion
      or loss of Project membership. Keep last supported information and represent uncertainty until evidence
      permits reconciliation; the access policy governs whether retained data can be shown.
    history_scope: Preserving existing history does not promise that GitView possesses a complete source
      history or can recover information that was never available.
  open_questions:
  - Availability and reliability of identity evidence for each selected source operation, including transfer
    observations and identifier representation changes.
  - Retention and presentation of prior addresses, alias resolution, and handling source access changes.
  - Storage, reconciliation and explicit deletion or removal behavior.
  ontology_status: Repository, GitHubRepository and Project use the selected ontology vocabulary; identity
    continuity does not establish an actor action, a motive or an uninterrupted management interval.
  scenarios:
    confirmed_change: A repository in Projects P and Q is renamed and then transferred; GitHub confirms
      the same object and the current address. GitView retains one Repository, its existing history and
      both memberships, and updates the current address to the confirmed address.
    reused_address: GitHub confirms that a different repository now occupies the old address. Its record
      does not acquire the earlier repository's history or memberships by address alone.
    unavailable: A lookup yields no reliable current object, for example because access is lost. GitView
      retains last supported information and does not represent the repository as confirmed deleted or
      new.
    not_found: A lookup at the last known address returns HTTP 404. GitView retains the last supported
      record, history and memberships and treats the current state as unknown; display remains subject
      to access policy.
acceptance:
- Source-confirmed rename or transfer preserves one Repository, its existing history and every Project
  membership.
- Reuse of an address by a source-confirmed different repository does not transfer history or memberships.
- An unavailable or ambiguous observation remains uncertain and does not alone establish deletion or identity.
- The same-instance numeric REST repository ID comparison selected in the approved ontology, the owner-accepted
  numeric examples and the 404 outcome are distinguishable from unverified source observations and an
  implementation.

```

## GITVIEW-SPEC-0003: GitView - Stored observations and refresh

Источник `specs/nodes/GITVIEW-SPEC-0003.yaml`, SHA-256 `33e273ba2c6c4d3c0c78bd643d5506f36a6af2f2c39cadaf252cf732ed98ff89`

```yaml
id: GITVIEW-SPEC-0003
title: GitView - Stored observations and refresh
kind: spec
created_at: '2026-11-15T21:19:00Z'
updated_at: '2026-11-16T19:45:17Z'
status: specified
refines:
- GITVIEW-SPEC-0001
depends_on:
- GITVIEW-SPEC-0002
relates_to: []
sources:
  predecessor_draft: docs/drafts/GITVIEW-SPEC-0003.yaml
  predecessor_revision: 852649f
  revoked_private_data_decision: conversation_memory/sketches/gitview/revisions/b0795ae580e94ba0be8c59cefcbd3a97/notes.hc
  ontology_context: ontology/packages/gitview/versions/0.2.0/composition-context.yaml
specification:
  ontology_refs:
  - gitview:GitHub
  - gitview:Repository
  - gitview:PullRequest
  - gitview:Issue
  objective: Reuse previously received data while keeping refresh outcomes, freshness and incomplete coverage
    understandable.
  authority_boundary: The owner proposed app-owned persisted data and requested visible refresh failure,
    opportunistic background updates, stale-on-open and manual refresh. This node does not select a database,
    exact API limits or a background schedule, select private-data display policy beyond the selected
    revocation and A-to-B decisions in 0019, or claim implementation readiness. When GitHub externally
    revokes access to a private Repository, the retained-data visibility and local access described here
    apply while the relevant account remains active. Independently of revocation, while account B is active,
    the account-switch boundary in 0019 applies. Behavior after returning to A is not selected.
  requirements:
    stored: Store accepted observations for reuse across launches; storage failure and actual recoverability
      do not imply unconditional preservation. When stored observations are recoverable and eligible for
      display, make them available without waiting for a new GitHub request; apply the applicable access
      policy.
    scope: Apply accepted successful observations to the facts and scope they support. Record and present
      the supported scope and time of a successful observation separately from refresh attempt outcomes.
      Updating repository metadata does not itself update the PR or Issue list or its last successful
      time.
    failure: A failed refresh visibly identifies the affected scope and GitHub failure and shows its last
      supported successful observation time when known and permitted. Retain eligible last-known data
      without presenting it as newly refreshed. No successful observation is distinct from a confirmed
      empty result; do not invent a success time.
    explicit_revocation: For a private Repository with source-confirmed access revocation, follow 0019
      and retain already saved local observations. While its account remains active, show them with the
      revocation indication and supported last update time when known; stop synchronization while revocation
      applies. Do not treat a transient failure or a 404 alone as proof of revocation or as proof of successful
      refresh.
    partial: A partial response or interrupted retrieval retains actual observation context and incomplete
      coverage. A partial observation has its own time and does not advance the last complete successful
      observation time of the requested scope or establish complete coverage. Failure alone does not erase
      accepted data, establish deletion or turn unknown work into a confirmed empty collection. Explicit
      clearing, independent accepted updates and access changes retain their own effects.
    foreground: On opening with stale data, request an update of the applicable scope subject to available
      API budget. Exact staleness and ordering policy remain open.
    background: Request background refresh opportunities; iOS controls whether and when execution is granted.
      Do not promise a fixed frequency, and keep work bounded by the granted opportunity.
    manual: Offer pull-to-refresh where appropriate to the screen or an equivalent explicit refresh action.
      Manual requests follow applicable source limits and show their own result.
    source_limits: Account for shared applicable GitHub rate limits across manual, foreground and background
      work, query cost and partial retrieval; avoid flooding. When source-directed retry or reset constraints
      apply, avoid retrying before they permit it. Exact request sizes, concurrency, pagination, retry
      scheduling and REST or GraphQL choices require later refinement.
  scenarios:
    failed_refresh: Previously observed PR data remains eligible after a temporary refresh failure without
      access denial. Show the permitted last-known data and supported observation time alongside a visible
      scoped GitHub error.
    independent_scopes: A metadata refresh succeeds while the PR list was not refreshed. The PR list retains
      its own previous observation time and is not presented as newly fetched.
    partial_pages: A retrieval stops before all pages are received. Supported observations may remain
      usable with incomplete coverage; an individual response is not by itself proof that it was durably
      saved.
    first_load: The first Issue-list refresh fails with no prior accepted observation. Show the failure
      and unobserved state, not a zero count or a fabricated last-success time.
  open_questions:
  - Access and disclosure policy for retained private observations, including disconnect and other account
    changes beyond the selected A-to-B rule in 0019; evidence, recovery and missing-time presentation
    for explicit revocation remain open.
  - Storage schema and durability, staleness, prioritization, pagination, retries and exact source budget.
  - Presentation of partial data and exact refresh controls in each interaction context.
  ontology_status: GitHub, Repository, PullRequest and Issue use the selected ontology vocabulary; an
    observation or link alone does not establish a domain action or ontology approval.
acceptance:
- Eligible last-known data can be used without waiting for a new request, subject to applicable access
  restrictions.
- Refresh failure and last supported successful time are distinguishable for the affected scope when known.
- Partial coverage remains visible as incomplete whether the supported selection is empty or nonempty;
  its observation time does not establish a fully refreshed scope.
- Partial, failed or never-observed data is not silently represented as a complete empty result.
- Manual and stale-on-open refresh and system-granted background opportunities respect applicable source
  limits.
- Previously accepted observations are stored locally for subsequent use across launches, subject to applicable
  access policy; failed storage or uncertain recovery is not presented as successful preservation.

```

## GITVIEW-SPEC-0004: GitView - Main overview

Источник `specs/nodes/GITVIEW-SPEC-0004.yaml`, SHA-256 `5031d3d1c77d2669344e0c2dbdc09b687c2a7b7641a73b5b4b036f79e5c72f0c`

```yaml
id: GITVIEW-SPEC-0004
title: GitView - Main overview
kind: spec
created_at: '2026-11-15T21:26:00Z'
updated_at: '2026-11-16T19:42:49Z'
status: specified
refines:
- GITVIEW-SPEC-0001
depends_on:
- GITVIEW-SPEC-0003
- GITVIEW-SPEC-0005
- GITVIEW-SPEC-0019
relates_to:
- GITVIEW-SPEC-0006
- GITVIEW-SPEC-0007
- GITVIEW-SPEC-0047
sources:
  predecessor_draft: docs/drafts/GITVIEW-SPEC-0004.yaml
  predecessor_revision: 32f79fa
  root_intent: .specgraph/root_intent.md
  project_summary: docs/drafts/project-summary-proposal.md
  dense_prototype: docs/drafts/dense-overview-prototype.md
  ontology_context: ontology/packages/gitview/versions/0.2.0/composition-context.yaml
  multi_repository_entry_decision: conversation_memory/sketches/gitview/revisions/35c247299c0b447dbe280e0d9a3bfbd9/metadata.json
specification:
  ontology_refs:
  - gitview:User
  - gitview:Project
  - gitview:Repository
  objective: Let the operator quickly survey Projects, see where work is progressing or needs attention,
    and open the relevant work.
  authority_boundary: This node records the selected Project overview and its relation to work. Exact
    cold-launch navigation, restoration, layout and access behavior remain to be refined; the current-work
    Today mode is not itself a required historical viewer. No native implementation is established. When
    GitHub externally revokes access to a private Repository, the retained-data visibility and local access
    described here apply while the relevant account remains active. Independently of revocation, while
    account B is active, the account-switch boundary in 0019 applies. Behavior after returning to A is
    not selected.
  requirements:
    projects: Provide an overview of saved GitView Projects whose representation is permitted, identifiable
      where their information is permitted, with available work and attention signals inspectable. Project
      means a user-defined collection of Repositories, not a GitHub organization.
    summary: Preserve the actual scope, unit, observation and coverage of Project summaries under 0047;
      do not silently add overlapping Project totals as unique portfolio totals.
    navigation: The operator can open a selected Project and use actionable Project signals to reach corresponding
      scoped work under 0006. The Today work selection follows 0007; ordinary entry to a multi-Repository
      Project opens its Project-wide work grid, and its Repository list is available in Project settings.
      Today is the opening current-work mode, not a decision that the work grid must be the first app
      screen; cold-launch navigation remains open.
    data_states: Distinguish confirmed empty local Project collection from incomplete or unobserved data,
      stale results and refresh failure. A failed refresh retains eligible prior observations and exposes
      scoped failure and supported observation time according to 0003; missing data is not confirmed absence.
    presentation: Use the selected Photos-inspired grid with pinch and multiple density levels within
      a scope under 0014, and Apple system look, with accessible alternatives to gestures and color-only
      distinctions. Exact density, controls and how details fit at different scales require refinement.
    context: Changing density and opening or returning from an object retain valid Project, selection
      and permitted source context; do not silently switch to an unrelated Project when the original cannot
      be established.
    revoked_private: When GitHub confirms access revocation for a private Repository, keep its saved Project
      and available local information for the affected Repository visible as last known with the revocation
      indication and supported update time when known. Stop synchronization for the affected Repository
      and retain a discoverable path to access recovery or explicit local deletion under 0019. Other account-change
      disclosure cases remain open.
  scenarios:
    choose_project: Several identifiable permitted Projects are visible. The operator selects one and
      can reach its work in that context.
    partial: A Project has incomplete source observations. Present available Project information and disclose
      the limitation according to the applicable disclosure policy rather than presenting work as confirmed
      empty. Confirmed private Repository revocation retains the saved Project and affected local data
      visibly under 0019; other account-change disclosure cases remain open.
    signal: Selecting a Project's failed-CI signal opens its corresponding selection in that Project,
      with permitted source context.
  open_questions:
  - First launch and subsequent launch restoration, exact interaction order.
  - Exact layout and accessible control placement across densities, and disclosure of restricted Project
    information.
  - Local collection coverage, loading, failure and ordering contracts in detailed scenarios.
  ontology_status: User, Project and Repository use the selected ontology vocabulary; an overview is a
    presentation, not a new domain entity.
acceptance:
- Permitted Projects are identifiable and their available work and attention are inspectable.
- Project and actionable-signal navigation preserve applicable scope and source context.
- An unobserved or failed source refresh does not become a confirmed empty Project or an invented success
  time.
- The overview remains operable without reliance on color or a single gesture.
- Confirmed private Repository revocation keeps the saved Project and available local information for
  the affected Repository visible with its indication and supported time when known, and preserves recovery
  or explicit local deletion under 0019. Visibility and local access follow the active-account and A-to-B
  boundary in 0019.

```

## GITVIEW-SPEC-0005: GitView - Project composition and membership

Источник `specs/nodes/GITVIEW-SPEC-0005.yaml`, SHA-256 `fa22cb1d6f78ef57696371cf837480fb967b9d09bb7c0f4a638f707f63c0681e`

```yaml
id: GITVIEW-SPEC-0005
title: GitView - Project composition and membership
kind: spec
created_at: '2026-11-15T17:47:00Z'
updated_at: '2026-11-16T19:42:49Z'
status: specified
refines:
- GITVIEW-SPEC-0001
depends_on: []
relates_to: []
sources:
  predecessor_draft: docs/drafts/GITVIEW-SPEC-0005.yaml
  predecessor_revision: 1f910ace120a741dfd30d0d998395a8276b03647
  owner_selection: docs/drafts/project-summary-proposal.md
  default_mechanism_review: docs/drafts/project-default-association-review-20261115.md
  ontology_context: ontology/packages/gitview/versions/0.2.0/composition-context.yaml
specification:
  ontology_refs:
  - gitview:User
  - gitview:Project
  - gitview:Repository
  - gitview:GitHubRepository
  - gitview:projectIncludesRepository
  - gitview:AddRepository
  - gitview:addsRepositoryTo
  - gitview:RemoveRepository
  - gitview:removesRepositoryFrom
  objective: Let the operator organize GitHub repositories into identifiable GitView Projects for work
    overview.
  authority_boundary: This node records the owner's selected composition and user outcomes. The referenced
    draft designs remain candidates; this node does not assert that a particular membership action occurred,
    select a storage mechanism or establish implementation readiness.
  requirements:
    project: A saved Project has a stable local identity, a name, an optional description and one or more
      source-identified GitHub repositories. A Project and its repositories remain distinct objects.
    membership: A repository may belong to more than one Project. Repositories from different GitHub organizations
      may belong to the same Project; organization is source metadata, not the Project boundary.
    default: By default there is one Project per repository. Persistent association with reuse is an agent-authored
      working candidate, not a selected owner requirement; its recovery protocol and alternative mechanisms
      require separate refinement.
    editing: The operator can create, rename and edit a Project and select its repositories. Removing
      membership from one Project does not delete the source repository or alter membership in another
      Project. A saved Project must not become an invalid empty Project; exact editing and recovery interaction
      require refinement.
    identity: When the source confirms the same GitHub repository after rename or transfer, its identity,
      history and Project memberships are preserved. A name or address alone is not sufficient to identify
      a repository.
    uncertainty: An unavailable observation or uncertain save outcome does not prove a repository, Project
      or membership absent. Distinguish an operation outcome from the last supported configuration and
      reconcile when evidence permits; otherwise retain the uncertainty without silently duplicating a
      still-possible previous effect. Recovery is not guaranteed when necessary evidence is unavailable.
  open_questions:
  - How the default setup identifies or offers an existing Project when a repository belongs to several
    Projects.
  - Project-name validation, edit and creation interaction, and handling of an attempted empty composition.
  - Actual persistence, source identity evidence, access policy and recovery contracts for the selected
    design.
  ontology_status: The working Project, Repository, User and membership vocabulary comes from the project's
    selected ontology context; this node does not grant semantic approval or infer an actor, motive or
    event from membership alone.
acceptance:
- A Project with one or more confirmed repositories is distinguishable from each repository and from GitHub
  organizations.
- A repository can participate in two Projects, including one that contains repositories from multiple
  organizations.
- A valid membership change affects its selected Project without changing GitHub or another Project's
  membership.
- The default of one Project per Repository is distinguished from the persistent-association mechanism
  not selected by the owner.
- Unknown identity, unavailable configuration and an indeterminate save do not become a confirmed absence
  or safe duplicate.

```

## GITVIEW-SPEC-0006: GitView - Project contents and navigation

Источник `specs/nodes/GITVIEW-SPEC-0006.yaml`, SHA-256 `267a6e0ba6de6640276942072f11b119061168fff2fc52dc6ff747949d2c463e`

```yaml
id: GITVIEW-SPEC-0006
title: GitView - Project contents and navigation
kind: spec
created_at: '2026-11-15T20:53:00Z'
updated_at: '2026-11-16T19:42:49Z'
status: specified
refines:
- GITVIEW-SPEC-0001
depends_on:
- GITVIEW-SPEC-0005
relates_to:
- GITVIEW-SPEC-0007
sources:
  predecessor_draft: docs/drafts/GITVIEW-SPEC-0006.yaml
  predecessor_revision: eed15c6dc028565c5ade0bc0283d6480b2102cd3
  owner_selection: docs/drafts/project-summary-proposal.md
  ux_candidate: docs/drafts/ux-zoom-levels-proposal.md
  ontology_context: ontology/packages/gitview/versions/0.2.0/composition-context.yaml
  multi_repository_entry_decision: conversation_memory/sketches/gitview/revisions/35c247299c0b447dbe280e0d9a3bfbd9/metadata.json
specification:
  ontology_refs:
  - gitview:Project
  - gitview:Repository
  - gitview:projectIncludesRepository
  - gitview:PullRequest
  - gitview:Issue
  objective: Let the operator navigate from a Project overview to its repositories and their work while
    retaining context.
  authority_boundary: This node records selected navigation outcomes and bounded refinement, not the complete
    predecessor draft, ontology approval or implementation readiness.
  requirements:
    context: Project and Repository remain distinct and identifiable in the permitted context. Repository
      membership follows its identity rather than its current organization, owner or name. One Repository
      in two Projects retains the context of the Project from which it was opened.
    composition_route: For a Project with several Repositories, ordinary Project entry opens one Project-wide
      PR and Issue grid spanning the applicable member scope. The list of member Repositories is available
      in Project settings. The operator can inspect permitted members and reach each member’s work; the
      exact navigation route remains open. Repositories from different GitHub organizations remain within
      the same Project; restricted information follows the applicable access policy.
    single_repository: For a Project containing one Repository, reach its work without a redundant intermediate
      Repository screen. Preserve the distinction and permitted source context of both Project and Repository.
    signal_route: A selectable Project summary signal offers direct access to its corresponding work selection
      across the applicable member scope without first traversing individual Repositories. Show each object's
      source Repository where permitted, and retain the origin signal or filter and its scope. Selection
      semantics, metric computation and evidence require separate refinement.
    continuity: Density changes within the same scope do not silently change Project, Repository scope,
      applicable time period or filters. When returning from an object, preserve the valid originating
      context, applicable period, filter and scale, and restore position where possible; if the origin
      is no longer valid or cannot be verified, do not silently present a different scope as the original.
    observations: Incomplete or unavailable observations do not establish an empty Repository, remove
      a Project member, or prove that a signal selection is exhaustive. Convey applicable coverage limitations
      without disclosing restricted data.
  scenarios:
    single_member: A Project has one Repository. The operator reaches its PR and Issue work without an
      equivalent second Repository screen, while the Project and source Repository remain distinguishable
      where permitted.
    multiple_members: A Project includes two Repositories in different organizations. Opening it shows
      one Project-wide work grid; the operator can inspect the member list in Project settings without
      treating organizations as Project boundaries.
    signal: A Project's failed-CI signal is selected. The corresponding PR selection spans its applicable
      member scope, identifies permitted source Repositories and reflects incomplete coverage where applicable.
    return: After opening a PR from a filtered Project selection, returning retains the valid Project,
      applicable period, filter and density, restoring the prior location when possible rather than silently
      switching Project.
  open_questions:
  - Exact navigation controls and transitions, context restoration when data or membership changes, and
    gesture behavior.
  - Signal predicates, freshness and coverage, selection details, and disclosure after access changes.
  ontology_status: Project, Repository, PullRequest and Issue use the selected ontology vocabulary; navigation
    does not itself establish a domain action, motive or semantic approval of the ontology.
acceptance:
- A single-Repository Project reaches its work without a redundant intermediate Repository screen and
  retains both identities.
- A multi-Repository Project provides permitted member inspection and routes to each member's work.
- A selectable Project signal reaches its corresponding work across the applicable Project scope without
  a Repository-by-Repository detour.
- Density and return navigation preserve supported context without silently switching scope.
- Incomplete source observations are not represented as a confirmed empty member or exhaustive selection.
- Ordinary entry to a multi-Repository Project opens its Project-wide work grid; the member list is available
  in Project settings.

```

## GITVIEW-SPEC-0007: GitView - Today work grid and lifecycle filters

Источник `specs/nodes/GITVIEW-SPEC-0007.yaml`, SHA-256 `43670f1ac3577f40f318537ac1b707402a5041d65ca09452ced9f02e9d623bed`

```yaml
id: GITVIEW-SPEC-0007
title: GitView - Today work grid and lifecycle filters
kind: spec
created_at: '2026-11-15T19:23:00Z'
updated_at: '2026-11-16T19:43:05Z'
status: specified
refines:
- GITVIEW-SPEC-0001
depends_on: []
relates_to:
- GITVIEW-SPEC-0005
sources:
  predecessor_draft: docs/drafts/GITVIEW-SPEC-0007.yaml
  predecessor_revision: 256e9dbf865f54deabe1ac3844ce21a98ca690ac
  all_states_and_filters: conversation_memory/sketches/gitview/revisions/ed322706b55a4798a4328a69982fcbae/notes.hc
  calendar_day_decision: conversation_memory/sketches/gitview/revisions/cc419cb9283f471b88b6f4b66e56c5ad/notes.hc
  timezone_decision: conversation_memory/sketches/gitview/revisions/3077fdcd9a8247769def8d6403c2e61c/notes.hc
  ontology_context: ontology/packages/gitview/versions/0.2.0/composition-context.yaml
  signal_filter_context_decision: conversation_memory/sketches/gitview/revisions/9544eaa87e5b4afcb48910299d60c520/metadata.json
  calendar_farthest_zoom_direction: conversation_memory/sketches/gitview/revisions/a854ef50dc2a4548b9003227f731e31e/metadata.json
specification:
  ontology_refs:
  - gitview:Project
  - gitview:Repository
  - gitview:PullRequest
  - gitview:Issue
  objective: Let the operator see current work and today's completed work together in a compact Project
    grid and narrow it explicitly.
  authority_boundary: This node records the selected Today and lifecycle-filter outcomes, not the complete
    predecessor draft, ontology approval, source integration, storage mechanism or implementation readiness.
  requirements:
    scope: Today provides an overview of applicable PRs and Issues in the selected Project and their source
      Repository context. Membership and access eligibility remain subject to their respective contracts.
    time: Unfinished work remains eligible even if it began on an earlier day. Work completed during the
      current calendar day remains eligible. The day uses the user's local time zone. Completion on the
      previous day alone does not qualify an object for the new Today; other applicable conditions may
      do so.
    identity: Each source-confirmed PR or Issue has one cell in a selection, even if several inclusion
      conditions apply. A linked PR and Issue are distinct objects; equal issue or PR numbers in different
      repositories do not establish identity. Unresolved identity is not presented as confirmed uniqueness.
    states: Without an applicable saved exclusion, eligible objects are shown in all lifecycle states,
      including merged and closed. A PR merged today updates the same cell and remains in unfiltered Today;
      it leaves an unfinished-only selection. Closed without merge is not called merged.
    filters: The operator can explicitly hide applicable states, including merged and closed. Selected
      filters persist between launches and are restored when applicable; failed or unknown persistence
      is not reported as a confirmed save. Filters narrow the view rather than changing source objects.
      When opening a signal originating inside this filtered selection, retain its applicable filter context
      under 0092; a signal outside it follows its own origin context.
    observations: Incomplete or failed refresh, missing pages or unknown status do not prove a merge,
      deletion or empty selection. Last supported permitted observations retain their freshness and access
      limitations; an unfiltered grid is not proof of complete GitHub coverage.
    calendar_direction: The owner envisages zooming out further from Today to reach a calendar of daily
      work intensity for the applicable selected Project scope under 0018. Calendar inclusion in the first
      version and exact interaction remain unselected.
  scenarios:
    completion: With complete coverage and unchanged scope and access, 100 distinct PRs in Today remain
      100 visible cells after 95 are confirmed merged during the current local day, if no lifecycle exclusion
      hides them.
    next_day: On a new local calendar day, an older open PR remains eligible, while yesterday's merge
      alone no longer qualifies another PR. Neither outcome deletes the object or excludes it for every
      other reason.
    filter_restore: In the selected counter case, its originating scope includes merged PRs and the saved
      merged exclusion is outside that scope. The operator hides merged and closed states, leaves the
      app and returns. Once the saved selection is restored in the ordinary Today view, matching eligible
      objects remain hidden while that filter applies; a separately opened historical merged counter can
      temporarily override its conflicting merged exclusion under 0047.
    distinct_identity: A linked Issue and PR each have their own cell; two repositories' Issue number
      42 represent separate objects when source identity confirms they are distinct.
    incomplete_refresh: A previously seen PR is absent from an open-only or failed refresh. That omission
      alone does not establish its completion, deletion, or the absence of work.
  open_questions:
  - Other inclusion conditions, handling of older closed work and source history coverage.
  - How local time zone is determined and what happens when the zone or calendar day changes during interaction.
  - Exact filter scope, controls, reset behavior, and cross-device synchronization if any.
  - Source identity and coverage evidence, access policy, uncertainty presentation and navigation details.
  ontology_status: Project, Repository, PullRequest and Issue use the selected ontology vocabulary; this
    node does not establish semantic approval or infer actor actions from observations.
acceptance:
- Earlier unfinished work and work completed on the current local calendar day remain eligible in Today.
- A change of lifecycle state updates the same object's cell; a linked PR and Issue remain distinct.
- All applicable lifecycle states are visible without saved exclusions, and explicit lifecycle filters
  persist across launches.
- A previous day's completion alone does not qualify an object for the new Today.
- Incomplete source observations do not become confirmed success, deletion or an exhaustive empty result.

```

## GITVIEW-SPEC-0008: GitView - Pull request overview

Источник `specs/nodes/GITVIEW-SPEC-0008.yaml`, SHA-256 `22180f30e999fa5830d8402cb77e61a586a6d92fa1ee1a21d4802e83ebb4a942`

```yaml
id: GITVIEW-SPEC-0008
title: GitView - Pull request overview
kind: spec
created_at: '2026-11-15T21:07:00Z'
updated_at: '2026-11-16T19:45:25Z'
status: specified
refines:
- GITVIEW-SPEC-0001
depends_on:
- GITVIEW-SPEC-0002
relates_to:
- GITVIEW-SPEC-0007
sources:
  predecessor_draft: docs/drafts/GITVIEW-SPEC-0008.yaml
  predecessor_revision: 05c27259cd47f1967ec871802579414dac47301e
  owner_selection: docs/drafts/pull-request-ontology-options.md
  ontology_context: ontology/packages/gitview/versions/0.2.0/composition-context.yaml
specification:
  ontology_refs:
  - gitview:PullRequest
  - gitview:Repository
  - gitview:Issue
  - gitview:pullRequestRepository
  - gitview:pullRequestIssueLink
  - gitview:ReviewThread
  - gitview:CIStatus
  objective: Provide a compact, source-linked overview of a selected PR and its independently meaningful
    signals.
  authority_boundary: The owner selected these categories and the GitHub-oriented checks direction. Exact
    mappings, presentation and data availability require refinement; this node does not establish an implementation
    or ontology approval.
  requirements:
    identity: Show supported permitted source identity, repository-local number, title, description and
      GitHub link, retaining the correct Repository context. An unavailable source link must not be replaced
      with another object.
    lifecycle: Distinguish open, closed without merge and merged from the draft flag, labels, review and
      CI. Show supported labels when available and permitted.
    context: Show the supported permitted target Repository, source and target branches, observed revision,
      author, requested reviewers and related Issues. Keep the supported PR-associated Repository distinct
      from separately supported base or target and head or source Repository contexts; an unavailable
      context remains unknown rather than being inferred from another. This does not require a separate
      head Repository field in the overview. A related Issue does not itself prove an actor’s motive.
    review: Show supported source review assessment and separate counts of total and unresolved review
      threads. Individual thread content is outside the selected overview; unavailable counts or assessment
      are not zero or approval. Where supported, distinguish unavailable assessment, absence of reviews,
      and a source-reported requirement for review; do not infer one from another.
    checks: Show supported counts for red, yellow, green and total current individual PR checks, following
      GitHub's general behavior. Do not count prior retries as additional current checks; precise mappings,
      revision selection and special outcomes require validation. The three color counts are not presumed
      to sum to total.
    change_counts: Show supported additions and deletions separately, changed-file count and commit count;
      these are counts, not an in-app diff, file, commit or run browser.
    times: Distinguish source creation, update, closure or merge times from observation time and source
      when available.
    descriptions: Preserve permitted authored text and the selected Problem, Motivation, Expected outcome,
      Changes, Validation and References format where present. Authored Validation is not proof of current
      CI status.
    source: Provide a route to the original GitHub object and lightweight sharing when an eligible link
      is available.
    uncertainty: Unavailable or stale facts retain their limitations and access context; do not infer
      success, zero or identity.
  scenarios:
    same_number: Two Repositories each have PR 42. Opening the second preserves its own identity, facts
      and link.
    independent_signals: An open draft PR has a failed check and unknown review. Show these independently;
      unknown is not approval.
    retry: A failed check is retried and its current applicable outcome changes. Do not count the old
      attempt as a second current check.
    fork_context: A PR is associated with Repository A and its supported head Repository is fork B. Preserve
      both contexts; do not attribute the PR to B merely because B contains the head branch. If the head
      context is unavailable, do not invent it from A.
  open_questions:
  - Source mappings, evidence and current-check revision and special-outcome rules.
  - Field priority, truncation, freshness, access, sharing payload and exact display.
  ontology_status: PullRequest and related terms use selected ontology vocabulary; links do not prove
    actor actions or semantic approval.
acceptance:
- The selected PR retains its identity and source Repository context, with supported permitted identifying
  fields.
- The supported permitted target Repository is inspectable; supported PR-associated and base or head Repository
  contexts remain distinguishable, and an unavailable context is not invented.
- Lifecycle, draft, review assessment, thread counts, check counts and change counts remain distinct and
  unknown values are not zero.
- The overview offers the source route when an eligible link is available and indicates unavailability
  otherwise; authored description remains separate from observed CI.
- The selected scope does not require in-app diff, individual thread, file, commit or run details.

```

## GITVIEW-SPEC-0009: GitView - Issue overview

Источник `specs/nodes/GITVIEW-SPEC-0009.yaml`, SHA-256 `9478577fd066b35b05be1ecaadec2853375987a8c38f18c41197dd3fcab43f0b`

```yaml
id: GITVIEW-SPEC-0009
title: GitView - Issue overview
kind: spec
created_at: '2026-11-15T21:07:00Z'
updated_at: '2026-11-16T19:45:25Z'
status: specified
refines:
- GITVIEW-SPEC-0001
depends_on:
- GITVIEW-SPEC-0002
relates_to:
- GITVIEW-SPEC-0007
sources:
  predecessor_draft: docs/drafts/GITVIEW-SPEC-0009.yaml
  predecessor_revision: 05c27259cd47f1967ec871802579414dac47301e
  owner_selection: docs/drafts/issue-ontology-options.md
  ontology_context: ontology/packages/gitview/versions/0.2.0/composition-context.yaml
specification:
  ontology_refs:
  - gitview:Issue
  - gitview:Repository
  - gitview:PullRequest
  - gitview:issueRepository
  - gitview:issueClosingPullRequest
  - gitview:issueMentionedPullRequest
  - gitview:issueParent
  - gitview:issueSubIssue
  - gitview:issueBlockedBy
  - gitview:issueBlocks
  objective: Provide a compact, source-linked overview of a selected Issue and its supported relationships.
  authority_boundary: The owner selected the field categories; exact mappings, display and availability
    require refinement. This node does not establish an implementation, an actor's motive or ontology
    approval.
  requirements:
    identity: Show supported permitted source identity, repository-local number, title, description and
      GitHub link while retaining the correct Repository context. Do not substitute another object for
      an unavailable link.
    state: Distinguish open and closed, source-provided state or closure reason, labels and type. Closed
      does not automatically mean completed, and an unavailable reason remains unknown.
    context: Show supported source Repository, author, assignees and milestone without inferring that
      an assignee has begun work.
    relationships: Show supported linked PRs, parent and direct sub-issues, and dependencies in each direction.
      Distinguish a supported closing reference from a mention; the same PR can have both meanings. A
      link alone does not establish a completed outcome or an actor's motive, and incomplete relationship
      evidence is not a confirmed absence.
    dual_link: When the same source-confirmed PR has both supported link meanings, identify it once in
      its Repository context while retaining both the mention and the closing-reference meanings.
    counters: Show supported comment and participant counts, and total and closed direct-sub-issue counts
      separately. These do not establish percent complete; individual comments are outside the selected
      overview. Unknown counts are not zero.
    times: Distinguish creation, update, closure, observation and last-comment times, and observation
      source when available.
    descriptions: Preserve permitted authored text and the selected Problem, Motivation, Expected outcome
      and References format where present; source text and separately supported relationships retain their
      meanings.
    source: Provide a route to the original GitHub object and lightweight sharing when an eligible link
      is available.
    uncertainty: Unavailable or stale facts retain their limitations and access context; do not infer
      successful completion or absence.
  scenarios:
    closure_reason: A closed Issue has an unknown or non-completion reason. Present its supported state
      without calling it completed.
    linked_pr: An Issue mentions PR A and has an explicit closing reference to PR B. Preserve both meanings
      without inferring motive.
    dependencies: An Issue is blocked by A and blocks B. Show the supported direction without calling
      incomplete coverage complete.
  open_questions:
  - Source mappings, relationship and count evidence, API availability and freshness.
  - Field priority, truncation, access, sharing payload and exact display.
  ontology_status: Issue and related terms use selected ontology vocabulary; source links do not prove
    actor actions or semantic approval.
acceptance:
- The selected Issue retains its identity and Repository context with supported permitted identifying
  fields and state reason.
- A closing reference and mention remain distinct supported meanings; a link does not establish motive.
- Relationship directions and selected count units remain distinct, and unknowns are not presented as
  zeros or completion.
- The overview offers the source route when an eligible link is available and indicates unavailability
  otherwise; the selected description remains as authored where available.

```

## GITVIEW-SPEC-0010: GitView - Issue and PR description formats

Источник `specs/nodes/GITVIEW-SPEC-0010.yaml`, SHA-256 `bbb049d4df3950b1657947590e52c1e1a182af460ec1d47171593a17c87377aa`

```yaml
id: GITVIEW-SPEC-0010
title: GitView - Issue and PR description formats
kind: spec
created_at: '2026-11-15T21:32:00Z'
updated_at: '2026-11-16T19:49:26Z'
status: specified
refines:
- GITVIEW-SPEC-0001
depends_on:
- GITVIEW-SPEC-0008
- GITVIEW-SPEC-0009
- GITVIEW-SPEC-0019
relates_to: []
sources:
  predecessor_draft: docs/drafts/GITVIEW-SPEC-0010.yaml
  predecessor_revision: 3fbc0f9
  owner_selection: docs/drafts/github-templates/README.md
  ontology_context: ontology/packages/gitview/versions/0.2.0/composition-context.yaml
specification:
  ontology_refs:
  - gitview:Issue
  - gitview:PullRequest
  objective: Preserve authored Issue and PR descriptions while supporting the selected structured formats.
  authority_boundary: The owner selected mandatory templates and sections for the participating repository
    process. Template deployment, enforcement across creation paths, parsing and versioning need separate
    specification and have not been implemented.
  requirements:
    issue_format: Issue descriptions use Problem, Motivation, Expected outcome and References.
    pr_format: PR descriptions use Problem, Motivation, Expected outcome, Changes, Validation and References.
    participating_process: Require the agreed sections in new Issue and PR descriptions through the participating
      repository process and cover its supported creation paths. Provide the agreed templates for that
      process; templates and agent instructions alone are not evidence of enforcement.
    external: Existing or external objects with another format or missing sections remain visible when
      eligible for display under the access policy in 0019; format alone does not hide them. Preserve
      their authored text, indicate a confirmed missing section and do not invent material or silently
      discard nonconforming objects.
    meaning: Motivation, Expected outcome and Validation are authored statements. A linked Issue is not
      proof of a specific actor's motive; declared outcome is not proof it happened; declared validation
      is distinct from observed CI and independent test evidence. Preserve attribution of authored text
      and the meaning of independently supported source links when available, without inferring an actor's
      motive or causation.
    extraction: When a section cannot reliably be extracted, retain the original permitted text instead
      of inventing structured content.
  scenarios:
    legacy: An existing PR has unstructured text and no headings. Keep the text accessible and do not
      fabricate sections.
    disagreement: A PR description claims validation passed while supported current CI failed. Preserve
      the author's statement and observed CI separately; do not suppress the failure.
  open_questions:
  - Participating repository scope, supported creation paths, installation, versioning and enforcement
    mechanisms.
  - Extraction, display and handling of unavailable or restricted authored content.
  ontology_status: Issue and PullRequest use the selected ontology vocabulary; authored text does not
    establish actor motives as facts.
acceptance:
- The selected Issue and PR formats retain their distinct named sections and apply to new descriptions
  through all supported creation paths of the participating process; the templates support but do not
  prove enforcement.
- Eligible external or legacy descriptions remain visible under the access policy in 0019; format alone
  does not hide them, fabricate sections or silently discard original text.
- Authored motivation, outcomes and validation are distinguishable from independently established facts
  and CI.

```

## GITVIEW-SPEC-0011: GitView - Current checks and review signals

Источник `specs/nodes/GITVIEW-SPEC-0011.yaml`, SHA-256 `509d9aea6172bdc69416bf74f472a47b28903d6774b66b3ea3853acb6b246bc1`

```yaml
id: GITVIEW-SPEC-0011
title: GitView - Current checks and review signals
kind: spec
created_at: '2026-11-15T21:31:00Z'
updated_at: '2026-11-16T19:49:26Z'
status: specified
refines:
- GITVIEW-SPEC-0008
depends_on:
- GITVIEW-SPEC-0003
relates_to: []
sources:
  predecessor_draft: docs/drafts/GITVIEW-SPEC-0011.yaml
  predecessor_revision: 3fbc0f9
  owner_selection: docs/drafts/pull-request-ontology-options.md
  ontology_context: ontology/packages/gitview/versions/0.2.0/composition-context.yaml
specification:
  ontology_refs:
  - gitview:Metric
  - gitview:PullRequest
  - gitview:ReviewThread
  - gitview:CIStatus
  objective: Keep current PR check counts, review assessments and thread counts independently interpretable.
  authority_boundary: The owner selected counts and GitHub behavior as the direction; actual source representations,
    retry equivalence, revision mapping and special conclusions require verification. No native behavior
    or API implementation is established.
  requirements:
    checks: Show supported counts of current individual PR checks as red, yellow, green and total, retaining
      applicable revision, observation and coverage. A workflow run or historical attempt is not automatically
      another current check. When the current check set or revision cannot be established, report the
      limitation rather than a complete count.
    categories: Special or unknown outcomes remain distinguishable until a supported mapping exists. Do
      not assume red, yellow and green sum to total, or that an absent, pending or unknown check result
      is successful.
    review: Show supported permitted source review assessment and both total and unresolved thread counts;
      a review request remains independently meaningful. Where evidence supports it, distinguish an unavailable
      assessment, absence of reviews and a source-reported review requirement. Preserve each fact's context
      and do not infer one from another signal.
    readiness: A CI color, review assessment, zero visible threads or single glyph alone does not establish
      merge readiness. A complete zero-check result is distinct from unobserved checks and is not automatically
      merge-ready.
    revisions: Facts from an earlier revision remain associated with that observation; do not silently
      present an old approval or check outcome as current for a newly observed revision without applicable
      evidence.
    scope: These are counts and summary signals; the selected PR overview does not require in-app thread
      content or run details.
  scenarios:
    retry: A failed check has a later successful result confirmed as the current equivalent for the applicable
      revision. Count the current check once rather than adding the old attempt; unresolved equivalence
      does not prove a complete set.
    review_without_thread: A source reports changes requested while independently supported thread evidence
      establishes zero unresolved threads. Show both facts without treating zero threads as approval or
      a ready-to-merge verdict.
    new_revision: Earlier approval and green CI concern a prior revision; a newer revision has no supported
      current review or CI. Keep old observations in their context or mark the current facts unavailable,
      rather than reporting current approval or green.
  open_questions:
  - Actual GitHub mappings for checks, retries, head revision and special or unknown conclusions.
  - Observation coverage and the exact UI representation of partial or unavailable signals.
  ontology_status: PullRequest, ReviewThread and CIStatus use the selected ontology vocabulary; counters
    do not establish actor actions.
acceptance:
- Supported permitted review assessment and both thread counts are shown; unavailable assessment, absence
  of reviews and source-reported review requirement remain distinct when supported.
- Current check counts retain supported revision and coverage; old attempts are not counted as new current
  checks without evidence.
- Review assessment, review request and thread counts remain independent; unknown or pending is not a
  confirmed success.
- Confirmed zero checks is distinguishable from unobserved checks and does not by itself establish merge
  readiness.

```

## GITVIEW-SPEC-0012: GitView - Repository and Project summaries

Источник `specs/nodes/GITVIEW-SPEC-0012.yaml`, SHA-256 `4afc051fae444092ab860684d2cc67d374f52956aba614ca9f03e0935d4949c3`

```yaml
id: GITVIEW-SPEC-0012
title: GitView - Repository and Project summaries
kind: spec
created_at: '2026-11-15T21:37:00Z'
updated_at: '2026-11-16T19:51:49Z'
status: specified
refines:
- GITVIEW-SPEC-0001
depends_on:
- GITVIEW-SPEC-0003
- GITVIEW-SPEC-0005
- GITVIEW-SPEC-0008
- GITVIEW-SPEC-0009
- GITVIEW-SPEC-0011
relates_to:
- GITVIEW-SPEC-0047
sources:
  predecessor_draft: docs/drafts/GITVIEW-SPEC-0012.yaml
  predecessor_revision: 33887d5
  project_summary: docs/drafts/project-summary-proposal.md
  repository_proposal: docs/drafts/repository-summary-proposal.md
  ontology_context: ontology/packages/gitview/versions/0.2.0/composition-context.yaml
  ready_meaning_decision: conversation_memory/sketches/gitview/revisions/23fe1cc490924a219f38c4bee721511f/metadata.json
specification:
  ontology_refs:
  - gitview:CIStatus
  - gitview:ReviewThread
  - gitview:projectIncludesRepository
  - gitview:pullRequestRepository
  - gitview:issueRepository
  - gitview:pullRequestIssueLink
  - gitview:Project
  - gitview:Repository
  - gitview:PullRequest
  - gitview:Issue
  - gitview:Metric
  objective: Make current work, attention and outcomes interpretable at Repository and Project scopes.
  authority_boundary: The Project summary categories are owner-selected; the Repository summary and precise
    predicates remain working refinements. The selected Project overview categories are owned by 0047;
    this node records shared counting boundaries and the Repository candidate. It does not select a merge-readiness
    rule, source implementation or ontology approval.
  requirements:
    repository: A Repository work summary makes supported permitted open PR counts, draft subset and open
      Issue counts distinguishable, with applicable CI, review, unresolved-thread and blocked-Issue attention.
      Its current facts retain source scope, coverage and freshness; each supported distinct source-confirmed
      identity is counted once within each applicable identity-based Repository measurement, even when
      observed on multiple pages; one PR may still contribute to different overlapping signals.
    project: A Project summary covers its applicable member Repositories under 0047, including a Repository
      also present in another Project. Restrictions and incomplete member observations affect what can
      be disclosed or asserted as complete.
    units: Distinguish affected PRs from individual failed checks and affected Repositories. Attention
      categories may overlap; do not add them as independent problems. A linked PR and Issue are separate
      source objects, not automatically separate tasks.
    outcomes: Distinguish merged PRs and closed Issues by supported reason for a selected period from
      current-state counts. Keep scope, observation context and incomplete evidence visible; closure alone
      does not establish completion. For PRs, the primary «Done» indicator refers to merged PRs; readiness
      to merge is a separate desired signal whose applicable predicate and evidence remain open.
    navigation: An actionable signal retains its actual condition and scope when opening the corresponding
      permitted object selection. A count of checks, threads or events is not automatically the number
      of resulting object cards.
    uniqueness: When a unique portfolio-wide count is asserted, count confirmed Repository and object
      identities once, even if a Repository belongs to multiple Projects. This does not remove its contribution
      from each applicable Project summary.
    candidate_ready: A checks-and-review-passed selection is conditional on a separately accepted applicable
      predicate and is not a guarantee of merge readiness. Do not fabricate it from missing observations.
  scenarios:
    overlap: A single PR has failed CI, requested changes and an unresolved thread. It contributes to
      each supported signal but is not described as three separate PRs or independent tasks.
    units: Two permitted PRs in different Repositories have five supported failed checks. The summary
      distinguishes five checks, two PRs and two Repositories; the corresponding selection contains the
      matching PRs rather than five implied cards. If facts change or coverage is incomplete at opening,
      preserve that context and limitation instead of forcing the earlier count or claiming a complete
      match.
    partial: A Project includes five Repositories but one lacks the relevant observation. Available values
      retain their incomplete scope rather than counting the unobserved Repository as zero.
  open_questions:
  - Exact Repository summary field selection, metric predicates, applicable source evidence and time periods.
  - Partial-coverage presentation, privacy policy and signal-selection behavior when observations change.
  - Definition and applicability of a checks-and-review-passed predicate.
  ontology_status: Repository, Project, PullRequest, Issue and Metric use the selected ontology vocabulary;
    summaries do not add a new domain entity.
acceptance:
- Supported current work and attention retain their Repository or Project scope, units, coverage and freshness.
- Project membership overlap and any claimed unique portfolio count follow confirmed identities without
  double counting.
- Overlapping attention signals and different units are not added as independent tasks or substituted
  for object-card counts.
- Period outcomes remain distinct from current-state counts and unavailable coverage is not presented
  as confirmed zero.

```

## GITVIEW-SPEC-0013: GitView - Metrics, history and charts

Источник `specs/nodes/GITVIEW-SPEC-0013.yaml`, SHA-256 `d040c6ae355548b6ae5d0c2d0a53abb1f3a7e9bd8735e24cacee1e6cd4d681ef`

```yaml
id: GITVIEW-SPEC-0013
title: GitView - Metrics, history and charts
kind: spec
created_at: '2026-11-15T21:19:00Z'
updated_at: '2026-11-16T19:51:49Z'
status: specified
refines:
- GITVIEW-SPEC-0001
depends_on:
- GITVIEW-SPEC-0003
relates_to:
- GITVIEW-SPEC-0047
sources:
  predecessor_draft: docs/drafts/GITVIEW-SPEC-0013.yaml
  predecessor_revision: 852649f
  owner_selection: docs/drafts/project-summary-proposal.md
  historical_membership_decision: conversation_memory/sketches/gitview/revisions/a55f271ca16f4283bfaf67095616ee7a/notes.hc
  ontology_context: ontology/packages/gitview/versions/0.2.0/composition-context.yaml
  ready_meaning_decision: conversation_memory/sketches/gitview/revisions/23fe1cc490924a219f38c4bee721511f/metadata.json
specification:
  ontology_refs:
  - gitview:projectIncludesRepository
  - gitview:pullRequestRepository
  - gitview:issueRepository
  - gitview:pullRequestIssueLink
  - gitview:Metric
  - gitview:Project
  - gitview:Repository
  - gitview:PullRequest
  - gitview:Issue
  objective: Make work and completion trends interpretable without inventing historical observations.
  authority_boundary: Metrics, graphs and visibility of completion and unfinished work are selected. Exact
    metric predicates, periods, source reconstruction, history retention and burn-down formula remain
    open; this node does not establish implementation readiness or a completed data collection.
  requirements:
    definitions: A measurement identifies its subject, unit, scope, period, source and coverage as applicable.
      Distinguish current-state snapshots from historical events and keep observation time separate from
      event time.
    current: Show supported permitted current open PR and open Issue counts separately with their coverage;
      draft PRs are a subset of open PRs. Linked PRs and Issues are distinct source objects but are not
      automatically independent tasks.
    outcomes: With sufficient supported evidence, show merged PR and closed Issue outcomes separately
      for an identified period; preserve supported Issue closure reasons and unknowns. Closed does not
      automatically mean completed. For PRs, the primary «Done» indicator means merged PRs; readiness
      to merge is a separate desired signal, not another name for the merged outcome.
    graphing: Show graphs of applicable summary measurements when sufficient history exists. A missing
      historical value remains a gap or explicitly incomplete, not a zero or a current snapshot backfilled
      as past history.
    project_history_membership: Recalculate a Project's historical graph over the selected period using
      the Project's current Repository membership. Adding a Repository can include its supported earlier
      activity; removing it excludes its contribution on subsequent recalculation. Identify the actual
      membership basis and do not present it as the Project's historical membership. Access, evidence
      and coverage still apply; an unavailable earlier contribution is not zero and a partial result is
      not complete.
    late_evidence: A later permitted source observation may support an earlier event with its real event
      and observation times, but one known event does not prove complete period coverage or reconstruct
      an earlier current-state population.
    burndown: Support understanding of unfinished work and completion; do not claim a defined burn-down
      formula, fixed cohort or independent-task total until separately specified.
    coverage: Each value preserves applicable scope, access, freshness and coverage. Mixed observation
      times or missing data do not become a complete simultaneous snapshot, a successful observation or
      a confirmed zero.
  scenarios:
    history_gap: A historical open-work measurement has no sufficient Tuesday evidence. Show Tuesday as
      unavailable or incomplete, not a fabricated zero or an interpolation described as observed.
    later_observed_event: A later eligible observation establishes one Issue closure on Tuesday. It supports
      that event within its actual scope but does not establish every Tuesday closure or Tuesday's number
      of open Issues.
    linked_work: A PR and Issue refer to the same work. Their separate supported measurements are not
      summed as two completed tasks.
    membership_change: Repository R is added to Project P today. On a supported recalculation of last
      month's Project graph, R's permitted evidence for that earlier period contributes under the current
      membership basis; unavailable history remains incomplete. If R is later removed, a subsequent recalculation
      excludes it without asserting that source history was deleted.
    reopened: An Issue closes, reopens, then closes again. A measurement requiring both closure events
      is asserted only when adequate source or retained event evidence supports it; the latest state alone
      does not establish the event sequence.
  open_questions:
  - Metric-specific predicates, evidence, source mappings and distinction between event counts and distinct
    objects.
  - History retention, time buckets, chart presentation and access policy; evidence when current Project
    membership is uncertain.
  - Burn-down population, cohort and formula if a formal burn-down chart is selected.
  ontology_status: Metric, Project, Repository, PullRequest and Issue use selected ontology vocabulary;
    a displayed metric does not establish ontology approval or a concrete actor action.
acceptance:
- Historical Project graphs use the current Repository membership basis and do not claim it is historical
  Project membership.
- Current work and period outcomes retain distinct subjects, units, scopes and applicable observation
  contexts.
- PR and Issue counts or series are not represented as independent tasks merely because the objects differ.
- Insufficient historical evidence remains a gap or explicitly incomplete rather than a fabricated zero.
- A later-observed event retains its event and observation times and does not prove complete historical
  coverage.
- Formal burn-down semantics are not assumed by this overview.

```

## GITVIEW-SPEC-0014: GitView - Zoomable grid

Источник `specs/nodes/GITVIEW-SPEC-0014.yaml`, SHA-256 `e72ec4841d16fb3cea73e45d8f791cf2b5f7353ec3221e6a471a7537005b6b68`

```yaml
id: GITVIEW-SPEC-0014
title: GitView - Zoomable grid
kind: spec
created_at: '2026-11-15T21:21:00Z'
updated_at: '2026-11-16T19:45:17Z'
status: specified
refines:
- GITVIEW-SPEC-0006
depends_on:
- GITVIEW-SPEC-0007
relates_to: []
sources:
  predecessor_draft: docs/drafts/GITVIEW-SPEC-0014.yaml
  predecessor_revision: 852649f
  dense_prototype: docs/drafts/dense-overview-prototype.md
  ontology_context: ontology/packages/gitview/versions/0.2.0/composition-context.yaml
  pinch_scope_decision: conversation_memory/sketches/gitview/revisions/408e46cab5da424d829e0ce07503fd28/metadata.json
  calendar_farthest_zoom_direction: conversation_memory/sketches/gitview/revisions/a854ef50dc2a4548b9003227f731e31e/metadata.json
specification:
  ontology_refs:
  - gitview:Project
  - gitview:Repository
  - gitview:PullRequest
  - gitview:Issue
  objective: Provide a Photos-inspired grid that moves between dense overview and more detailed cards
    within a stable scope.
  authority_boundary: The owner selected discrete pinch density levels and a transition to the next level
    at maximum cell size. The maximum depends on grid width and the chosen maximum cell size in points;
    its numerical value, target anchoring, native layout and gesture coordination remain open.
  requirements:
    density: Pinch increases or decreases grid detail through discrete density levels. Within a level
      and before its boundary, changes preserve the current scope, selected period, filters and selected
      objects. When an expanding cell reaches its maximum size, the gesture triggers a transition to the
      corresponding next level; the maximum depends on grid width and the chosen maximum cell size in
      points.
    independent_changes: Source observations or membership may independently change the selection; a zoom
      gesture does not guarantee a fixed dataset when other events occur. Preserve the focused identity
      where possible and convey incomplete coverage.
    dense_view: Support a compact bird's-eye work view; approximately eight cells per row and 100 simultaneously
      visible objects illustrate the intended scale, not fixed columns, a device-independent fit guarantee
      or a performance benchmark.
    recognition: Distinguish PR and Issue at compact scale and expose meaningful state without relying
      on color alone. More information can appear as cells grow; content adapts to available space and
      text size.
    navigation: A boundary transition enters the intended object or scope at the next level; do not infer
      a different target when it is ambiguous. Return retains valid scope, applicable filters and scale
      and restores position when possible. How the target is established and exact reverse-transition
      behavior remain open.
    preview: First-version long-press preview supports inspecting an object before opening it. A later
      sliding rich preview lets the operator inspect neighboring cells without leaving the dense overview;
      its activation and gesture arbitration remain open.
    accessibility: Offer an accessible way to change density and open or inspect an object without requiring
      pinch, precise tiny targets or color alone. Adapt layout for large text rather than forcing the
      illustrative column count.
    appearance: Prefer iOS system appearance, colors, typography and SF Symbols with restrained Liquid
      Glass in keeping with the selected Apple Look; exact components remain subject to design and platform
      validation.
    calendar_direction: The owner envisages a further pinch out from Today to a farthest calendar of daily
      work intensity in the applicable Project scope under 0018. This proposed outward transition is distinct
      from the selected expanding-cell maximum; precise threshold, gesture details and first-version scope
      remain open.
  scenarios:
    pinch: A filtered selection contains 100 confirmed objects and no independent data change occurs.
      Pinch increases detail through discrete steps while preserving the selection until the maximum cell-size
      boundary is reached; at the boundary the intended next-level transition occurs when the target is
      unambiguous.
    large_text: When the illustrative eight columns cannot present legible content at the selected text
      size, adapt the layout rather than shrinking required content merely to preserve eight columns.
    ambiguous_target: At the maximum-size boundary, if the intended target is unavailable or ambiguous,
      do not substitute another object; preserve a coherent view and offer a meaningful available fallback
      under 0024.
  open_questions:
  - Native collection behavior, zoom anchors, transitions and gesture conflicts, and measured device performance.
  - Exact object cues at each density, accessible controls and changed-origin recovery interaction.
  ontology_status: Project, Repository, PullRequest and Issue use selected ontology vocabulary; presentation
    does not establish ontology approval.
acceptance:
- Pinch changes detail in discrete steps; on reaching maximum cell size it transitions to the intended
  next level when the target is unambiguous, with the threshold depending on grid width and maximum cell
  size in points.
- Dense view supports the intended scale of approximately 100 simultaneously visible objects without treating
  illustrative object and column counts as fixed device-independent requirements.
- Object type and meaningful state remain accessible without reliance on color or pinch alone.
- A boundary transition retains the intended target and valid context; returning preserves valid context
  where possible.

```

## GITVIEW-SPEC-0015: GitView - Preview and future sliding inspection

Источник `specs/nodes/GITVIEW-SPEC-0015.yaml`, SHA-256 `097cc2f4c332d8d3ff651ee5c687dd84c6872a0740550bd44f9130748d23e6c2`

```yaml
id: GITVIEW-SPEC-0015
title: GitView - Preview and future sliding inspection
kind: spec
created_at: '2026-11-15T21:23:00Z'
updated_at: '2026-11-16T19:45:17Z'
status: specified
refines:
- GITVIEW-SPEC-0014
depends_on:
- GITVIEW-SPEC-0008
- GITVIEW-SPEC-0009
relates_to: []
sources:
  predecessor_draft: docs/drafts/GITVIEW-SPEC-0015.yaml
  predecessor_revision: 852649f
  owner_direction: docs/drafts/ux-preview-interactions.md
  revoked_private_data_decision: conversation_memory/sketches/gitview/revisions/b0795ae580e94ba0be8c59cefcbd3a97/notes.hc
  ontology_context: ontology/packages/gitview/versions/0.2.0/composition-context.yaml
specification:
  ontology_refs:
  - gitview:Project
  - gitview:Repository
  - gitview:PullRequest
  - gitview:Issue
  objective: Let the operator inspect an object without losing the surrounding bird's-eye overview.
  authority_boundary: The owner requested long-press preview in the first version and described a later
    sliding rich preview. Exact native components, activation of sliding, arbitration and access policy
    require refinement; no implementation is established. When GitHub externally revokes access to a private
    Repository, the retained-data visibility and local access described here apply while the relevant
    account remains active. Independently of revocation, while account B is active, the account-switch
    boundary in 0019 applies. Behavior after returning to A is not selected.
  requirements:
    first_version: A recognized long press on an eligible Project, Repository, PR or Issue opens a static
      preview of that same object, exposing additional available permitted details readably without leaving
      the overview. The operator can explicitly open that object or dismiss the preview without navigating.
    identity: The preview and any explicit opening retain the selected object's identity and permitted
      source context; an object with the same visible name or number is not substituted. Apply the current
      access policy.
    return: Dismissing the preview or returning from an object preserves valid originating scope, period,
      filters and density, restoring position when possible. When the origin is no longer valid or cannot
      be verified, provide an available meaningful fallback without silently claiming the old scope.
    accessibility: Offer accessible alternatives to long press for preview, dismissal and direct object
      opening. Direct opening does not replace access to preview.
    later_sliding: A later rich preview can update a single bubble as the operator moves across cells,
      inspecting objects without navigating into each and without leaving the dense overview. Its content
      corresponds to the current object under the finger; a delayed result for a prior object is not presented
      as the current object's details. This is not a first-version prerequisite. Long press as its activation
      remains a hypothesis; pointer hover is optional and is not available on every device.
    observation: Unknown or stale displayed details keep their limitations; a preview must not establish
      success or identity from missing data or bypass applicable restrictions.
    revoked_private: For a private Repository whose access revocation is explicitly established under
      0019, continue to show already saved local details in the applicable preview, including one open
      when the revocation is established, with an access-revoked indication and supported last update
      time when known. Stop synchronization of the affected Repository; retained local visibility is not
      GitHub access, and a missing time is not invented. Independently applicable disclosure restrictions
      still apply; freshness is attributed to the supported observations. Other access and account cases
      remain open.
  scenarios:
    same_object: Long-pressing PR 42 in Repository R previews that PR; explicit opening reaches the same
      PR in R when eligible.
    dismiss: Dismissing a preview from a filtered dense grid retains its valid scope, filter and density
      without opening the object.
    later_slide: In the later sliding mode, moving over three cells changes the same preview without opening
      three screens.
    later_delayed_result: In the later mode the finger moves from A to B while a result for A is delayed;
      A's late details are not shown as B's, and the bubble remains associated with the current object.
    revoked_while_open: The relevant account remains active throughout this scenario. A private PR preview
      is open when revocation is explicitly confirmed. Keep its already saved permitted details visible
      with the revocation indication and supported update time when known, without a source fetch or invented
      time; follow 0019 for late responses.
  open_questions:
  - Native preview and context-menu behavior, gesture coordination, cancellation and changed-origin fallback.
  - Sliding activation, release and edge behavior; applicability of pointer hover.
  - Display, accessibility, freshness and access details for each object kind.
  ontology_status: Project, Repository, PullRequest and Issue use the selected ontology vocabulary; preview
    is an interaction, not a new domain entity.
acceptance:
- First-version preview presents readable additional available permitted details for the same eligible
  object on recognized long press without leaving the overview, and offers explicit open and dismissal.
- Accessible non-long-press paths support preview, dismissal and direct opening.
- Valid origin context is retained on dismissal or return; an invalid origin is not silently substituted.
- Sliding rich inspection remains a later direction with activation and gesture details open.
- An already open preview of saved permitted private data remains visible on confirmed revocation with
  its indication and supported update time when known, without implying source access. Visibility and
  local access follow the active-account and A-to-B boundary in 0019.

```

## GITVIEW-SPEC-0016: GitView - Original source and sharing

Источник `specs/nodes/GITVIEW-SPEC-0016.yaml`, SHA-256 `c42c9cda2038d69d0dde3c7cf50beefdc2689a441468109d9fff7e2840aafd8c`

```yaml
id: GITVIEW-SPEC-0016
title: GitView - Original source and sharing
kind: spec
created_at: '2026-11-15T21:24:00Z'
updated_at: '2026-11-16T19:49:26Z'
status: specified
refines:
- GITVIEW-SPEC-0001
depends_on:
- GITVIEW-SPEC-0008
- GITVIEW-SPEC-0009
relates_to: []
sources:
  predecessor_draft: docs/drafts/GITVIEW-SPEC-0016.yaml
  predecessor_revision: 852649f
  owner_direction: docs/drafts/product-foundation.md
  ontology_context: ontology/packages/gitview/versions/0.2.0/composition-context.yaml
  project_sharing_decision: conversation_memory/sketches/gitview/revisions/5f262787f9ac49e2a8b7abda20d6955b/metadata.json
specification:
  ontology_refs:
  - gitview:User
  - gitview:Repository
  - gitview:PullRequest
  - gitview:Issue
  objective: Let the operator reach the original GitHub object and share useful context from the overview.
  authority_boundary: Source navigation and lightweight sharing are selected. The default payload, private-data
    policy, exact native control and external delivery remain to be specified; this node does not establish
    implementation readiness.
  requirements:
    source: For a Repository, PR or Issue with an eligible source-associated GitHub URL, offer a route
      to that source object. Associate the URL with the correct object and source context. If no eligible
      URL is known, indicate unavailability rather than inventing a confirmed URL or substituting another
      object.
    share: Offer lightweight sharing using the platform's native sharing experience when applicable, subject
      to the selected access and handoff policy. The exact content and default payload require separate
      refinement.
    external_boundary: Sharing a link does not grant recipient access, establish delivery or prove the
      external handler loaded the intended object. Do not claim any of these outcomes merely because the
      share flow or source handoff was initiated.
    access: Current applicable access and disclosure restrictions govern source handoff and shared material.
      A previously observed address is not automatically eligible if its identity, direction or current
      disclosure is uncertain.
    candidate: Source-link-only sharing without automatic private text, repository contents or screenshots
      is an agent-authored candidate, not an independently selected owner requirement.
    local_project: Sharing the local Project itself is not required for now. This does not remove lightweight
      sharing of eligible GitHub Repository, PR or Issue context.
  scenarios:
    unavailable: A selected Issue has no eligible known source URL. Offer an understandable unavailable
      state instead of opening a different object or a fabricated link.
    available: An eligible permitted PR source URL is known. Offer an action to open that source and lightweight
      sharing through the native experience when applicable, without claiming delivery.
    private_link: An eligible source link refers to a private Repository's PR. Presenting sharing does
      not assert that a recipient can open it or that delivery occurred.
  open_questions:
  - Default sharing payload, optional extra context and private-data disclosure.
  - Native controls, source address evidence, eligibility and external handoff behavior.
  ontology_status: Repository, PullRequest and Issue use selected ontology vocabulary; source navigation
    does not establish actor motives or ontology semantic approval.
acceptance:
- An eligible known GitHub source link remains associated with its correct object and Repository context.
- Offer a source-opening route for an eligible known URL and native lightweight sharing when applicable.
- If source-link sharing is offered but no eligible link is available, show that link sharing is unavailable;
  other separately authorized payloads remain open.
- Lightweight sharing does not itself grant recipient access or establish delivery.
- Missing or ineligible source evidence is not replaced by a fabricated or misdirected URL.

```

## GITVIEW-SPEC-0017: GitView - Accessibility and platform behavior

Источник `specs/nodes/GITVIEW-SPEC-0017.yaml`, SHA-256 `21758bf1d8fb70a0cffbba02addb73eff4d6f86cd03ca4a852b0b36027fd7f7c`

```yaml
id: GITVIEW-SPEC-0017
title: GitView - Accessibility and platform behavior
kind: spec
created_at: '2026-11-15T21:33:00Z'
updated_at: '2026-11-16T19:49:26Z'
status: specified
refines:
- GITVIEW-SPEC-0001
depends_on:
- GITVIEW-SPEC-0014
- GITVIEW-SPEC-0015
- GITVIEW-SPEC-0016
- GITVIEW-SPEC-0019
relates_to: []
sources:
  predecessor_draft: docs/drafts/GITVIEW-SPEC-0017.yaml
  predecessor_revision: 3fbc0f9
  root_intent: .specgraph/root_intent.md
  ontology_context: ontology/packages/gitview/versions/0.2.0/composition-context.yaml
specification:
  ontology_refs:
  - gitview:User
  - gitview:Project
  - gitview:Repository
  - gitview:PullRequest
  - gitview:Issue
  objective: Make overview, preview and object access usable with platform accessibility features.
  authority_boundary: Accessible alternatives and Apple system appearance are selected directions. Exact
    native controls, supported platform versions and device behavior require refinement and validation;
    no accessibility testing is claimed. When GitHub externally revokes access to a private Repository,
    the retained-data visibility and local access described here apply while the relevant account remains
    active. Independently of revocation, while account B is active, the account-switch boundary in 0019
    applies. Behavior after returning to A is not selected.
  requirements:
    alternatives: Essential navigation, density, preview, dismissal and opening must not rely exclusively
      on pinch, long press, pointer hover, precise tiny targets or color. Direct object opening does not
      replace accessible preview.
    descriptions: Assistive technologies receive understandable object type, permitted identity and source
      context, relevant known state and limitations. Unknown and stale observations retain their status
      and applicable scope and time when supported; stale success is not announced as current. Unknown
      data is not announced as success. Confirmed private Repository revocation does not hide already
      saved local information under 0019; accessible descriptions retain its applicable revocation indication
      and supported time when known. Other account and external-disclosure cases remain open.
    adaptive: Adapt layout to Dynamic Type and interaction to Reduce Motion. Large text can require fewer
      columns; motion must not be necessary to understand navigation.
    focus: On dismissal or return, restore accessibility focus to the original object when available and
      valid, or provide a sensible available fallback without silently switching origin.
    visual: Prefer system iOS typography, colors, SF Symbols and native controls where appropriate, consistent
      with the selected Apple Look.
  scenarios:
    voiceover: With VoiceOver active on a dense grid, the operator can identify and open an eligible PR
      without interpreting color; its supported permitted context and known state are available.
    voiceover_preview: With VoiceOver active, the operator invokes preview of an eligible PR without long
      press, reads its available permitted detail, and dismisses it. The original grid remains when still
      valid and focus returns to that PR when available; otherwise an accessible permitted fallback is
      provided without silently substituting a different object.
    adaptive_layout: With large text and Reduce Motion enabled, the grid can become more spacious while
      content and navigation remain understandable.
    revoked_saved_preview: The relevant account remains active throughout this scenario. A saved private
      PR preview is open when GitHub confirms access revocation for the relevant account. Its saved details
      remain available visually and through assistive technology as last known with indication and supported
      time when known; synchronization stops, and local routes to recovery and explicit deletion remain
      accessible under 0019 without guaranteeing recovery succeeds.
  open_questions:
  - Exact native accessibility actions, focus fallback, minimum platform support and device verification.
  - Access-safe labels and treatment of unavailable or changing data in each view.
  ontology_status: User, Project, Repository, PullRequest and Issue use selected ontology vocabulary;
    accessibility controls add no domain entities.
acceptance:
- Essential interactions have accessible alternatives to a single gesture and color-only communication.
- Assistive descriptions preserve supported identity, known state and applicable uncertainty; confirmed
  private Repository revocation does not hide saved local content under 0019.
- Larger text and Reduce Motion retain understandable content and navigation without fixed density.
- Return focus uses the valid original object when available or a sensible available fallback.

```

## GITVIEW-SPEC-0018: GitView - Possible calendar view and later depth

Источник `specs/nodes/GITVIEW-SPEC-0018.yaml`, SHA-256 `3c54dfdddf65bf96d4341f2b053f06e88fccbbdd7652b31e50570065ec3f58cc`

```yaml
id: GITVIEW-SPEC-0018
title: GitView - Possible calendar view and later depth
kind: spec
created_at: '2026-11-15T22:11:00Z'
updated_at: '2026-11-16T20:02:31Z'
status: specified
refines:
- GITVIEW-SPEC-0001
depends_on:
- GITVIEW-SPEC-0013
- GITVIEW-SPEC-0014
relates_to:
- GITVIEW-SPEC-0015
sources:
  predecessor_draft: docs/drafts/GITVIEW-SPEC-0018.yaml
  predecessor_revision: 70feca6
  root_intent: .specgraph/root_intent.md
  ontology_context: ontology/packages/gitview/versions/0.2.0/composition-context.yaml
  calendar_farthest_zoom_direction: conversation_memory/sketches/gitview/revisions/a854ef50dc2a4548b9003227f731e31e/metadata.json
specification:
  ontology_refs:
  - gitview:Metric
  - gitview:Project
  - gitview:Repository
  - gitview:PullRequest
  - gitview:Issue
  objective: Describe the owner-envisaged farthest calendar view over work intensity and preserve deeper
    PR exploration as a possible later direction.
  authority_boundary: The owner envisages a contribution-style daily calendar at the farthest zoom and
    a further pinch out from Today to reach it. Its inclusion in the first version, precise interaction,
    activity definition, data source, colours and implementation remain open. Deeper in-app PR exploration
    remains a separate later direction; this node does not assert either feature exists.
  directions:
    calendar: At the envisaged farthest overview, each calendar cell represents a day and its visual intensity
      communicates how much work occurred in that day for the applicable selected Project scope. The scope
      can be all Projects or selected Projects, including a filter such as active Projects. Cells represent
      time, not Project, Repository, PR or Issue identities. Specific activity units, event types, aggregation
      and evidence remain open.
    semantics: The cell conveys work intensity, not individual red CI or other health indicators. Do not
      equate contribution activity with completed work, successful CI or review approval. Missing history
      is not a confirmed zero; evidence and access limitations remain visible. Green, light or neutral
      appearance are examples rather than a selected palette.
    later_pr_depth: Exploration within a PR can be considered later. The selected present overview and
      source handoff do not imply an in-app diff, individual thread or check-run detail browser.
    independence: The selected first-version work grid, long-press preview and object overview do not
      depend on completing calendar, deeper PR exploration or sliding preview; whether to include the
      calendar in that version is not selected.
    navigation: The owner expects an additional pinch-out from the Today view to enter the calendar. Exact
      thresholds, return behavior and accessible alternatives require refinement; no availability guarantee
      or first-version commitment follows from this direction.
  open_questions:
  - Which work events and aggregation determine daily intensity, what evidence and access are required,
    and how active Project filtering is defined.
  - Whether to include the calendar in the first version; exact pinch-out threshold, return and accessible
    navigation.
  - Whether week, month or year views are useful, and their presentation and period semantics.
  - Whether and when to select deeper in-app PR exploration and its boundaries.
  ontology_status: Metric, Project, Repository, PullRequest and Issue use selected ontology vocabulary;
    a calendar cell does not establish a new entity.
  scenario_candidate: In the envisaged calendar, further pinch out from Today leads to a day-cell view
    whose intensity reflects work in the applicable selected Project scope. If history for a day is unavailable,
    it is not described as an observed zero.
acceptance:
- Calendar day cells in this envisaged time view are not confused with Project, Repository or work-object
  identity cells.
- An unavailable historical value is not described as a confirmed zero.
- Contribution activity is not equated with completed work, successful CI or approved review.
- Calendar and deeper PR browsing are not prerequisites for the first-version grid and preview; whether
  the calendar itself is included in that version remains open.
- The envisaged calendar uses daily work intensity for its applicable selected Project scope; cells do
  not show individual CI or health indicators, and the exact intensity definition remains open.
- The owner-envisaged route reaches the calendar by further pinch-out from Today; exact interaction and
  inclusion in the first version remain open.

```

## GITVIEW-SPEC-0019: GitView - GitHub access and repository discovery

Источник `specs/nodes/GITVIEW-SPEC-0019.yaml`, SHA-256 `f0348dd90c0b38c7e33993e384e3d39248d78b5fd4fe26dc623ca718f4d6561b`

```yaml
id: GITVIEW-SPEC-0019
title: GitView - GitHub access and repository discovery
kind: spec
created_at: '2026-11-15T21:28:00Z'
updated_at: '2026-11-16T19:51:27Z'
status: specified
refines:
- GITVIEW-SPEC-0001
depends_on:
- GITVIEW-SPEC-0002
- GITVIEW-SPEC-0003
- GITVIEW-SPEC-0005
relates_to: []
sources:
  predecessor_draft: docs/drafts/GITVIEW-SPEC-0019.yaml
  predecessor_revision: 32f79fa
  root_intent: .specgraph/root_intent.md
  revoked_private_data_decision: conversation_memory/sketches/gitview/revisions/b0795ae580e94ba0be8c59cefcbd3a97/notes.hc
  visibility_rationale: conversation_memory/sketches/gitview/revisions/ef1c2f72ef08420980a423cd63c6d34a/notes.hc
  ontology_context: ontology/packages/gitview/versions/0.2.0/composition-context.yaml
  account_switch_decision: conversation_memory/sketches/gitview/revisions/3bb8ef35b11a499091c40333c03d2566/metadata.json
  external_revocation_clarification: conversation_memory/sketches/gitview/revisions/340a710a3b9946f4892b86895170ddb7/metadata.json
specification:
  ontology_refs:
  - gitview:User
  - gitview:GitHub
  - gitview:Repository
  - gitview:Project
  objective: Provide the operator a path to connect GitHub and find eligible repositories for a GitView
    Project.
  authority_boundary: GitHub access is necessary to the selected product direction. Initial account count,
    authorization method, permission mapping, the other offline disclosure cases and setup flow are not
    selected by this node; predecessor details remain candidates. This specification does not establish
    a live connection, source grant, ontology approval or implementation readiness.
  requirements:
    connect: Offer a way for the operator to authorize access and identify the connected GitHub source
      account. GitView User is the operator and need not be the author or assignee of any source object.
    discovery: Support finding and selecting Repositories available to the connected account for Project
      composition. Incomplete discovery or insufficient access is distinguishable from a confirmed empty
      result; a selection alone does not establish a saved Project or an independent source grant.
    credentials: Protect credentials using platform-provided secure storage and do not include them in
      shared content or ordinary diagnostics. Exact authorization and permission requirements require
      source-specific refinement.
    failure: Distinguish an explicit authentication or permission denial from a temporary network failure
      and a successful empty result. Failure alone does not erase accepted observations or prove deletion;
      the owner's specific explicit-revocation behavior below applies only when supported for the affected
      Repository.
    revoked_private: When GitHub explicitly confirms that access to a private Repository is revoked for
      the relevant account, keep the already saved local data. While that account remains active, continue
      showing it as last known with an explicit access-revoked indication and supported last update time
      when known; the account_change boundary applies when another account is active. Stop synchronization
      of that Repository while the revocation applies; a late response must not silently restart synchronization
      or present itself as a new accepted update after revocation. Do not fabricate an update time, treat
      temporary network failure or a 404 alone as proof of revocation, or claim that retained local visibility
      restores GitHub access. Exact evidence, presentation, recovery and other account-change behavior
      require refinement.
    retained_data_actions: While the relevant account remains active after revocation, preserve a discoverable
      local entry point for understanding it, pursuing access recovery and explicitly deleting locally
      retained data. The available local view and user control do not establish a restored GitHub grant,
      guarantee successful recovery, or delete source objects. Exact native controls and recovery mechanics
      remain open.
    account_change: 'Provide an intentional way to disconnect or reconnect. When GitHub account B is active,
      do not show private data previously saved from account A. This visibility rule does not itself delete
      A’s stored data or determine behavior after returning to A. An external GitHub access revocation
      is distinct from switching accounts: while the relevant account remains active, saved private data
      remains visible under revoked_private with its indication and supported time when known. Other disconnect,
      account and credential-removal cases remain open.'
    boundaries: GitView is an overview with a path to GitHub; source authorization or installation is
      distinct from modifying a PR, Issue or Repository. Additional write features and account models
      are outside this node's selected scope.
  scenarios:
    incomplete_discovery: Some accessible repositories have been observed but discovery is incomplete.
      Show supported results and the limitation rather than stating the list is complete or that unobserved
      repositories do not exist.
    temporary_failure: A refresh fails without a new access decision. A network failure alone does not
      become a confirmed denial or deletion; display remains subject to actual applicable access policy.
    explicit_revocation: A private Repository has locally saved observations with a supported last update
      time; GitHub explicitly confirms access revocation for its account, which remains active. Keep and
      show the saved data with the revocation indicator and supported time, and stop synchronizing that
      Repository while the revocation applies. A previously in-flight response is not presented as a fresh
      successful update merely because it arrives after revocation.
    local_control_after_revocation: After confirmed revocation while the relevant account remains active,
      the operator can still find the already saved Repository and its available data, understand the
      access limitation, and reach both recovery and intentional local deletion. No successful source
      access, restored data or source deletion is implied.
    revoked_without_known_time: A private Repository has saved local data but no reliable update time,
      and access revocation is explicitly confirmed while its account remains active. Continue showing
      the saved data with the revocation indication; do not invent a time. Exact missing-time presentation
      remains open.
    switch_accounts: The operator switches from account A to B. Previously saved private data from A is
      not shown while B is active; it is not thereby deleted. If GitHub revoked A's access while A was
      active, the data was shown with the revocation indication, but remains hidden while B is active.
  open_questions:
  - Account count, GitHub host scope, authorization and required permission set.
  - Evidence of explicit revocation, restoration of access, in-flight response handling and exact presentation
    of missing times.
  - Retained private-data disclosure under ordinary offline, disconnected and other account-change conditions
    beyond the selected A-to-B rule.
  - Repository selection, onboarding, stopping refresh on disconnect, credential removal and uncertain-removal
    recovery, and exact UI behavior.
  ontology_status: User, GitHub, Repository and Project use selected ontology vocabulary; authorization
    does not establish an actor's motive.
acceptance:
- The operator can initiate and complete supported source authorization and identify the connected account.
- The operator can select an eligible discovered Repository for Project composition without treating selection
  alone as a saved Project.
- Discovery distinguishes an incomplete or access-limited result from a confirmed empty result.
- Credentials are protected and are not included in shared content or ordinary diagnostics.
- A network error is not represented as a confirmed source denial, deletion or successful empty result.
- Local disconnection does not by itself delete GitHub Repositories.
- Explicitly revoked private Repository data remains local; while its account remains active it is visible
  with a revocation indication and supported update time when known. Synchronization stops while revocation
  applies; the selected account-change boundary applies when B is active.
- After confirmed revocation while its account remains active, the saved Repository remains a discoverable
  entry point for understanding the limitation, access recovery and explicit local deletion.
- While account B is active, previously saved private data from account A is not shown; switching accounts
  does not itself delete that data.

```

## GITVIEW-SPEC-0020: GitView - Product journey and acceptance direction

Источник `specs/nodes/GITVIEW-SPEC-0020.yaml`, SHA-256 `dd68e58efdd844a0190992282ecf900f90e0aec069a154487d059066e7ae7d2c`

```yaml
id: GITVIEW-SPEC-0020
title: GitView - Product journey and acceptance direction
kind: spec
created_at: '2026-11-15T22:03:00Z'
updated_at: '2026-11-16T20:05:42Z'
status: specified
refines:
- GITVIEW-SPEC-0001
depends_on:
- GITVIEW-SPEC-0003
- GITVIEW-SPEC-0004
- GITVIEW-SPEC-0005
- GITVIEW-SPEC-0006
- GITVIEW-SPEC-0007
- GITVIEW-SPEC-0008
- GITVIEW-SPEC-0009
- GITVIEW-SPEC-0013
- GITVIEW-SPEC-0014
- GITVIEW-SPEC-0015
- GITVIEW-SPEC-0016
- GITVIEW-SPEC-0017
- GITVIEW-SPEC-0019
- GITVIEW-SPEC-0022
- GITVIEW-SPEC-0047
relates_to:
- GITVIEW-SPEC-0021
sources:
  predecessor_draft: docs/drafts/GITVIEW-SPEC-0020.yaml
  predecessor_revision: 5bae442
  root_intent: .specgraph/root_intent.md
  historical_membership_decision: conversation_memory/sketches/gitview/revisions/a55f271ca16f4283bfaf67095616ee7a/notes.hc
  revoked_private_data_decision: conversation_memory/sketches/gitview/revisions/b0795ae580e94ba0be8c59cefcbd3a97/notes.hc
  ontology_context: ontology/packages/gitview/versions/0.2.0/composition-context.yaml
specification:
  ontology_refs:
  - gitview:User
  - gitview:GitHub
  - gitview:Project
  - gitview:Repository
  - gitview:PullRequest
  - gitview:Issue
  - gitview:Metric
  objective: Describe a coherent product journey and observable outcomes without declaring the specification
    graph or implementation complete.
  authority_boundary: These outcomes combine selected directions and conditional scenarios from child
    nodes. They do not select an account count, private-data policies beyond the selected revocation and
    A-to-B decisions in 0019, cold-launch layout, technical implementation or timing of a pilot. All dependent
    contracts and unresolved product decisions need review before any implementation readiness assessment.
    When GitHub externally revokes access to a private Repository, the retained-data visibility and local
    access described here apply while the relevant account remains active. Independently of revocation,
    while account B is active, the account-switch boundary in 0019 applies. Behavior after returning to
    A is not selected.
  journey:
    setup: An operator can connect GitHub, select eligible Repositories and establish Projects. One Project
      per Repository is the default; Projects may contain multiple Repositories and share them. Selection
      or connection alone does not prove a saved Project or observed work. Incomplete discovery and failed
      or uncertain saves remain distinguishable. Authorization cancellation, explicit denial, network
      failure and confirmed empty source are distinct; cancellation or failure leaves an available path
      to continue where supported.
    overview: The operator can identify permitted Projects, inspect available summaries and navigate through
      members or actionable signals to work, preserving source context and truthful coverage. Source restrictions
      are subject to the applicable policy. Any claimed unique portfolio total deduplicates shared supported
      identities.
    current_work: Today includes older unfinished work and work completed during the current user-local
      calendar day. Applicable PR and Issue lifecycle states remain visible without saved exclusions.
      Explicit filters persist, and the selected historical merged-counter transition temporarily overrides
      its conflicting saved merged exclusion without rewriting that preference. The historical destination
      retains the counter's own period and scope rather than becoming ordinary Today; access and coverage
      limitations remain applicable. Other signal-origin transitions preserve filters belonging to the
      signal’s originating scope; unrelated filters do not narrow a signal outside that scope under 0092.
    inspection: A Photos-inspired grid changes density with pinch and accessible alternatives. Each eligible
      confirmed PR or Issue in the selection has one cell. First-version long-press preview of an eligible
      Project, Repository, PR or Issue reveals permitted detail and offers explicit opening of the same
      object or dismissal without navigation, preserving valid origin context; accessible alternatives
      remain available. Object overviews preserve independent states and offer source and sharing routes
      when eligible. Sliding preview and deeper PR exploration are later directions.
    data_and_metrics: Reuse eligible saved observations, request bounded refresh, show scoped errors and
      truthful freshness, and distinguish incomplete from empty. Metrics retain unit, scope and coverage;
      historical charts require sufficient evidence and do not fabricate zeros. Project historical graphs
      are recalculated with current Project membership after membership changes, not as a reconstruction
      of past membership. A limited or restricted result is not a confirmed healthy or complete result.
    accessibility: Essential interactions do not rely on color or a single gesture; supported accessibility
      context and alternatives remain available, including for preview.
  scenarios:
    supported_path: An operator connects an account, selects eligible Repositories and completes supported
      Project setup. With applicable observations and access, the operator opens work, adjusts density,
      previews an object and can open its source if an eligible link exists.
    completion: With complete coverage, unchanged scope and access, 100 distinct PRs in Today include
      95 merged on the same local calendar day. With no lifecycle exclusion they remain visible as their
      own cells; a saved merged exclusion may hide them.
    missing_data: A Project has a supported prior observation for one scope and another scope fails to
      refresh. The permitted last-known facts retain their own time and the affected failure is visible
      without claiming complete current data.
    setup_with_partial_discovery: A first-time operator connects GitHub. Discovery returns Repository
      A but does not establish whether the remaining scope is complete. A is independently eligible and
      the required setup operations succeed. The operator can identify the limitation, choose A and complete
      the supported default setup. A saved Project is distinct from the selection, and its work can still
      be loading or unobserved rather than confirmed empty.
    today_preview_return: An eligible PR in a selected Project is confirmed merged during the user's local
      day and no saved lifecycle exclusion hides it. The same PR remains in Today; the operator can change
      density, preview and explicitly open it, then return to the valid Project, Repository scope, period,
      filter and density context without replacing the PR by another object. An explicit unfinished-only
      filter may hide it without modifying the source PR.
    revoked_after_observation: The relevant account remains active throughout this scenario. A private
      Repository already has saved Project and work observations when GitHub confirms revocation for the
      relevant account. The operator can still find and inspect the saved local information with the revocation
      indication and supported last-update time when known, and reach recovery or explicit local deletion.
      Synchronization of the affected Repository stops while revocation applies, and an earlier in-flight
      response does not become a newly accepted update; opening locally does not establish source access
      or change other Projects.
    shared_repository_signal: Projects P and Q share Repository R. Opening a supported Project-wide attention
      signal from P preserves P, the signal condition, applicable period and each supported Repository
      context; returning does not silently switch to Q. R remains a member of both Projects and an asserted
      unique portfolio total does not count the same confirmed identity twice. Incomplete coverage stays
      distinguishable.
  open_questions:
  - Exact revocation evidence, in-flight and recovery handling; private-data access after disconnect,
    ordinary offline use and other account changes beyond 0019, and exact disconnect outcome.
  - Historical metric measurement units; exact filter hierarchy, persistence and return behavior beyond
    the selected origin-context rule under 0092.
  - Actual first-launch interaction, source coverage and selected account/authorization model.
  - Each product branch needs further refinement and evidence appropriate to its eventual transition;
    this node is not a release gate.
  ontology_status: The selected local ontology is owner-approved; a product journey does not establish
    specific actor motivations or ontology approval.
acceptance:
- The described supported path connects Project setup, overview, work selection, inspection and an eligible
  GitHub source route.
- Unfinished and same-day completed work, persistent filters and the bounded historical merged-counter
  override retain their distinct meanings.
- Refresh failures, restricted or incomplete data and unavailable history are not presented as confirmed
  healthy, complete or empty results.
- Product requirements remain distinct from proof of implementation, integration, device behavior or release
  readiness.

```

## GITVIEW-SPEC-0021: GitView - Testability and architecture direction

Источник `specs/nodes/GITVIEW-SPEC-0021.yaml`, SHA-256 `96213558bed2c3a4abc30d61e31a8ee816117a89641eadb73b7d217a5bd2d6fb`

```yaml
id: GITVIEW-SPEC-0021
title: GitView - Testability and architecture direction
kind: spec
created_at: '2026-11-15T21:25:00Z'
updated_at: '2026-11-16T20:02:31Z'
status: specified
refines:
- GITVIEW-SPEC-0001
depends_on: []
relates_to:
- GITVIEW-SPEC-0003
sources:
  predecessor_draft: docs/drafts/GITVIEW-SPEC-0021.yaml
  predecessor_revision: 852649f
  root_intent: .specgraph/root_intent.md
  ontology_context: ontology/packages/gitview/versions/0.2.0/composition-context.yaml
specification:
  objective: Make product behavior testable and guide implementation without choosing a premature module
    structure.
  authority_boundary: The owner requested testability, dependency injection, TDD, network and data mocks,
    and use of FSD iOS and SpecificationCore. Exact versions, integration, modules and the equivalence
    of currently available checkouts to originally named paths require separate verification; no code
    or integration is established by this node.
  requirements:
    architecture: Use FSD iOS as the intended direction for organizing app responsibilities. Define actual
      layers and dependencies when responsibilities are understood; do not require empty modules or assume
      unverified source versions.
    decisions: Use SpecificationCore for suitable named domain decisions where it clarifies composition
      and testability. Preserve meaningful results such as unknown when required; selection of exact policies
      and integration remains open.
    dependency_injection: Make network, data persistence and other nondeterministic dependencies replaceable
      at appropriate boundaries. A particular DI framework or a protocol for every type is not required
      by this product direction.
    tests: Develop product behavior with TDD and provide appropriate deterministic network and data mocks,
      stubs or fakes; exercise meaningful success, failure and uncertainty. Choose each test double for
      the scenario rather than mandating a specific implementation for every test.
    evidence: Independently tested domain decisions do not prove a live GitHub integration or native UI
      works. Verify relevant adapters and integration paths separately when implementation exists.
    context: Preserve source, scope, freshness and uncertainty across decisions and presentation instead
      of coercing unknown observations into success or zero.
  scenarios:
    offline_test: A behavior uses injected deterministic network or data substitutes to exercise a failure
      without contacting GitHub. A named domain decision receives the resulting observations or failure
      as input rather than performing I/O itself.
    unknown: An unavailable input remains distinguishable from a supported positive or negative result
      through a named decision.
  open_questions:
  - Confirm intended FSD iOS and SpecificationCore sources, versions and integration compatibility before
    implementation.
  - Select actual modules, dependency composition and domain policies after the corresponding product
    contracts are sufficiently refined.
  - Define appropriate integration and device verification for implemented slices.
  ontology_status: The local domain vocabulary is owner-approved; dependency boundaries do not establish
    ontology approval.
acceptance:
- The architecture direction includes FSD iOS and appropriately selected SpecificationCore decisions without
  claiming integration exists.
- Network and data dependencies are replaceable for meaningful deterministic TDD with suitable test doubles.
- Unknown and partial source information retain their meanings across decisions and presentation.
- Passing isolated tests is not presented as proof of live GitHub or native UI integration.

```

## GITVIEW-SPEC-0022: GitView - First launch and Project setup

Источник `specs/nodes/GITVIEW-SPEC-0022.yaml`, SHA-256 `f382b42abf07f41125177838ed5db0d07d20c37b86d63cda3cad8f17304f1491`

```yaml
id: GITVIEW-SPEC-0022
title: GitView - First launch and Project setup
kind: spec
created_at: '2026-11-15T21:35:00Z'
updated_at: '2026-11-16T19:51:27Z'
status: specified
refines:
- GITVIEW-SPEC-0004
depends_on:
- GITVIEW-SPEC-0005
- GITVIEW-SPEC-0019
relates_to:
- GITVIEW-SPEC-0003
sources:
  predecessor_draft: docs/drafts/GITVIEW-SPEC-0022.yaml
  predecessor_revision: 33887d5
  root_intent: .specgraph/root_intent.md
  ontology_context: ontology/packages/gitview/versions/0.2.0/composition-context.yaml
specification:
  ontology_refs:
  - gitview:User
  - gitview:Project
  - gitview:Repository
  - gitview:GitHub
  - gitview:projectIncludesRepository
  objective: Let the operator progress from an empty Project collection to a GitHub-backed Project without
    confusing missing data and failures.
  authority_boundary: One Project per Repository is the selected default. The detailed onboarding flow,
    default association and recovery mechanism are agent-authored candidates, not independently selected
    owner decisions; no actual account or Project is created by this node.
  requirements:
    empty: When a supported current local read establishes an empty Project collection, offer a discoverable
      path toward GitHub connection and repository selection. An unreadable or incomplete local collection
      is not a confirmed empty collection or evidence that the app has never been used. Preserve existing
      saved Projects and membership; make the local limitation and a supported retry discoverable without
      promising recovery.
    connection: The operator can initiate authorization and discover eligible repositories under 0019.
      Cancellation or failure leaves an understandable path to continue and does not establish a connected
      account or successful empty source. Cancellation or failure alone does not delete saved Projects
      or accepted observations; display remains subject to the applicable access policy.
    discovery: A partially observed repository collection remains incomplete, not an exhaustive list.
      Make the limitation visible, offer supported permitted results for selection and a supported retry
      where available. A confirmed zero matches only its actual search and access scope; no search match
      does not prove an empty account. Choosing a Repository does not by itself prove that a Project was
      saved or that all work was observed.
    setup: Support one default Project per eligible Repository while keeping Project and Repository distinct.
      A Project may contain more Repositories or share one with another Project under 0005; the exact
      setup mechanism is open. If a multi-Repository default selection is supported, its default corresponds
      to one Project per Repository, not an implicitly combined Project; this does not mandate multi-selection
      or a specific association.
    outcomes: Distinguish a supported successful Project save from failure or indeterminate result. Do
      not silently create a duplicate while an earlier possible creation effect remains unresolved; recovery
      depends on available evidence and is not guaranteed.
    initial_work: Once a valid Project is established, distinguish work still unobserved or loading from
      a confirmed empty list. A successfully saved, identifiable and permitted Project can be reached
      and opened into its work. An authorized account or selected Repository is not itself evidence that
      PR and Issue data has been obtained.
  scenarios:
    successful_setup: Given an eligible Repository, supported authorization and successful required operations,
      the operator can complete default setup, obtain a saved identifiable Project for that Repository
      and open its permitted work; work may still be unobserved.
    cancelled: The operator cancels authorization from the setup path. No account success or empty GitHub
      source is inferred; an available route to continue remains.
    partial: Discovery has returned some Repositories but is incomplete. Supported choices remain distinguishable
      from a complete inventory; no unobserved Repository is declared absent.
    uncertain_save: A Project creation outcome is indeterminate. Do not announce success or issue a potentially
      duplicating retry without reconciling evidence; preserve uncertainty when reconciliation is unavailable.
    partial_save: A supported first Project save succeeds but another outcome is unresolved. Retain the
      confirmed configuration, make it available when permitted and distinguish the other unresolved outcome
      without claiming recovery is guaranteed.
  open_questions:
  - Exact cold-launch, authorization and repository-selection controls, and default-association or alternative
    setup design.
  - Recovery after interrupted setup and save outcomes, accessible feedback and disclosure for restricted
    source data.
  - Loading order and the threshold for a complete current local collection.
  ontology_status: User, GitHub, Project and Repository use the selected ontology vocabulary; setup does
    not establish ontology approval.
acceptance:
- With an eligible selected Repository and successful required operations, the operator can complete default
  setup and open the saved identifiable Project's permitted work.
- A supported empty collection offers a path to connect and select Repositories without equating incomplete
  data with emptiness.
- Cancellation, failure and indeterminate save do not fabricate successful authorization or a saved Project.
- The selected default retains Project and Repository as distinct and does not imply work data is already
  loaded.
- A successfully saved, identifiable and permitted Project can be opened into its work; unobserved work
  remains distinct from empty.
- Existing accepted configuration is not erased by cancellation or failure; partial and uncertain outcomes
  remain distinguishable.

```

## GITVIEW-SPEC-0023: GitView - Project overview observation states

Источник `specs/nodes/GITVIEW-SPEC-0023.yaml`, SHA-256 `b74d8a52c0fae7ddc2a47461e53a6f007a94320401c6504c4d4ffcada82e7381`

```yaml
id: GITVIEW-SPEC-0023
title: GitView - Project overview observation states
kind: spec
created_at: '2026-11-16T07:08:00Z'
updated_at: '2026-11-16T19:55:33Z'
status: specified
refines:
- GITVIEW-SPEC-0004
depends_on:
- GITVIEW-SPEC-0003
- GITVIEW-SPEC-0012
- GITVIEW-SPEC-0017
- GITVIEW-SPEC-0019
sources:
  predecessor_draft: docs/drafts/GITVIEW-SPEC-0023.yaml
  predecessor_revision: 9bbf79f
  root_intent: .specgraph/root_intent.md
  visibility_rationale: conversation_memory/sketches/gitview/revisions/ef1c2f72ef08420980a423cd63c6d34a/notes.hc
specification:
  ontology_refs:
  - gitview:Project
  - gitview:Repository
  objective: Help the operator understand what the Project overview knows, what remains unknown and when
    previously observed information was updated.
  authority_boundary: This node records product-visible distinctions and the selected local visibility
    behavior. It does not select a storage implementation, authorization method, exact native controls,
    backup design or source refresh schedule, and does not establish implementation readiness. When GitHub
    externally revokes access to a private Repository, the retained-data visibility and local access described
    here apply while the relevant account remains active. Independently of revocation, while account B
    is active, the account-switch boundary in 0019 applies. Behavior after returning to A is not selected.
  requirements:
    configuration: Distinguish a confirmed absence of locally configured Projects from an unreadable or
      not-yet-observed configuration. Neither alone establishes that GitHub has no repositories or work.
      Preserve saved configuration when its read fails and provide an appropriate recovery route.
    observations: Distinguish unobserved, incomplete, failed and last-known observations from confirmed
      empty results and supported zero values. Values retain their actual scope, supported observation
      time and coverage; do not promote one successful category to a complete Project observation.
    failure: When a source refresh fails, continue presenting available saved data with its supported
      observation time when known and a discoverable scoped failure or limitation. Do not claim successful
      refresh, a source denial or an empty collection solely because of a network failure.
    revoked_private: If GitHub explicitly confirms access revocation for a private Repository, previously
      saved local information remains visible with the revocation indication and supported last update
      time when known under 0019. Synchronization of that Repository stops while revocation applies. Keep
      a discoverable entry point to understand the limitation, pursue access recovery and explicitly delete
      local data; do not imply a restored GitHub grant.
    accessibility: Make meaningful values and loading, coverage, failure and access distinctions available
      to assistive technologies and without relying on color alone, including accessible paths to the
      applicable recovery or local action.
    source_boundary: A 404 or temporary network failure alone does not establish revocation or deletion.
      Other account and disclosure cases retain their separate open questions under 0019 and 0024.
  scenarios:
    no_projects: A successful local configuration read establishes no Projects. Offer a way to begin setup
      without claiming GitHub contains no repositories.
    refresh_failed: A Project has saved observations and refresh fails. Keep the supported last-known
      data visible with its observation time when known and a discoverable failure; the failed attempt
      does not advance the successful-update time.
    revoked_with_saved_data: The relevant account remains active throughout this scenario. A private Repository
      has previously saved data and its access revocation is confirmed. Keep the saved data and Project
      visible with the revoked indication and supported time when known; stop synchronization and offer
      accessible routes to both recovery and explicit local deletion.
    unknown_time: Saved data remains readable after confirmed revocation but no reliable update time is
      available. Show the data and revocation indication without inventing a time; exact wording is open.
  open_questions:
  - Native presentation, wording and persistence of overview status and recovery actions.
  - Source evidence sufficient to establish revocation and the supported recovery flow.
  - Account isolation, incomplete local recovery and exact behavior for other access cases.
  ontology_status: Project and Repository use the selected ontology vocabulary; observation and presentation
    status do not introduce a new domain entity.
acceptance:
- A confirmed empty local Project collection is distinguishable from unreadable configuration, unobserved
  work and incomplete or failed source observation.
- Available saved observations remain visible with their supported scope and time when known, and a refresh
  failure does not silently turn them into a confirmed empty result or a fresh observation.
- Confirmed private Repository revocation keeps saved local data visible with its indication and supported
  update time when known, stops synchronization and preserves accessible recovery and explicit local deletion
  entry points under 0019. Visibility and local access follow the active-account and A-to-B boundary in
  0019.
- Meaningful observation and access distinctions and the applicable actions are available without relying
  on color alone.

```

## GITVIEW-SPEC-0024: GitView - Navigation context and restoration

Источник `specs/nodes/GITVIEW-SPEC-0024.yaml`, SHA-256 `228fd3d0adef644081cfdbe1069e11cacc10332a9e009dc8ca794a68b8da7db6`

```yaml
id: GITVIEW-SPEC-0024
title: GitView - Navigation context and restoration
kind: spec
created_at: '2026-11-15T22:00:00Z'
updated_at: '2026-11-16T19:55:33Z'
status: specified
refines:
- GITVIEW-SPEC-0006
depends_on:
- GITVIEW-SPEC-0005
- GITVIEW-SPEC-0007
- GITVIEW-SPEC-0014
relates_to:
- GITVIEW-SPEC-0015
sources:
  predecessor_draft: docs/drafts/GITVIEW-SPEC-0024.yaml
  predecessor_revision: c40ba68
  ontology_context: ontology/packages/gitview/versions/0.2.0/composition-context.yaml
  pinch_scope_decision: conversation_memory/sketches/gitview/revisions/408e46cab5da424d829e0ce07503fd28/metadata.json
specification:
  ontology_refs:
  - gitview:Project
  - gitview:Repository
  - gitview:PullRequest
  - gitview:Issue
  objective: Preserve understandable navigation context while moving among Projects, work collections
    and object overviews.
  authority_boundary: This node refines context and return outcomes without selecting a cold-launch destination,
    specific default-association model, retention mechanism, anchor algorithm or private-data policy beyond
    the selected revocation and A-to-B decisions in 0019. It does not claim implementation readiness.
    When GitHub externally revokes access to a private Repository, the retained-data visibility and local
    access described here apply while the relevant account remains active. Independently of revocation,
    while account B is active, the account-switch boundary in 0019 applies. Behavior after returning to
    A is not selected.
  requirements:
    context: Applicable navigation context includes Project identity, Repository scope, period, filters,
      density and position or focused object when available. These are presentation state, not new domain
      entities.
    return: Returning from a PR or Issue retains valid originating Project, scope, applicable period,
      filters and density and restores a permitted position or focused object by identity where possible.
      A saved index or matching display name alone does not establish the same object.
    changed_origin: If the original object, Repository or Project is unavailable, removed, restricted
      or unverifiable, do not silently substitute another object or scope as the original. Distinguish
      a confirmed change from an unobserved or incomplete result; provide an available access-safe fallback
      or recovery path appropriate to the supported facts.
    density: Changing density within a scope does not itself change the selected Project, Repository scope,
      period or filters. Independent updates may change the supported collection and retain their own
      observation context. At the maximum cell-size boundary an intentional pinch transition to the next
      level follows 0014 while retaining the intended target and applicable context.
    filters: Explicitly selected lifecycle filters persist and restore when applicable under 0007. The
      selected historical merged counter exception under 0047 is a temporary transition override and does
      not itself rewrite the saved preference. Other signal-origin transitions retain the actual applicable
      source filter context under 0092 without rewriting saved preferences; unrelated filters do not narrow
      a signal produced outside their scope.
    access: Revalidate current applicability and independently applicable disclosure restrictions before
      showing retained content; a saved navigation context is not a GitHub access grant. For confirmed
      revocation of a private Repository, saved data remains visible under 0019 with revocation and last-update
      context when known; source access is not required for that local display. Other private-data policies
      remain open.
  scenarios:
    return_same: The operator opens PR B from a filtered Project selection. On return, if the Project,
      scope and B remain valid and permitted, the context and prior location can be restored without substituting
      an unrelated item.
    partial_anchor: On return the anchor is absent from a partial response. Its omission alone does not
      prove deletion or that it no longer matches; retain uncertainty and an access-safe fallback where
      available.
    removed_project: An opened object's original Project was confirmed removed while another Project contains
      the same Repository. Do not silently relabel the original context as the other Project; offer an
      available route to another scope.
  open_questions:
  - Cold-launch and retained-session behavior, position and focus fallback, and time-zone-change interaction.
  - Exact filter hierarchy, persistence scope, reset, presentation and return behavior beyond the selected
    signal-origin rule in 0092.
  - Access and disclosure policy after disconnect or other account changes beyond 0019, exact revocation
    evidence and recovery, and behavior of an open overview in other access cases remain to be decided.
  ontology_status: Project, Repository, PullRequest and Issue use selected ontology vocabulary; navigation
    context is not a domain entity.
acceptance:
- Returning from an object retains its valid permitted originating scope, applicable period, filter and
  density when available.
- Missing or inaccessible context is not silently replaced with a different object or treated as a confirmed
  empty collection.
- Before the maximum-size boundary, pinch density changes preserve scope, period and filters; an intentional
  boundary transition follows 0014, and independent source changes remain distinguishable.
- Saved filters and the limited historical merged-counter override follow 0007 and 0047 without silently
  rewriting preferences.

```

## GITVIEW-SPEC-0025: GitView - Project lifecycle and membership

Источник `specs/nodes/GITVIEW-SPEC-0025.yaml`, SHA-256 `6f63d3d0fb66b436982a3446f9dbea48aabe8c840d256a331cff63532cb8b87a`

```yaml
id: GITVIEW-SPEC-0025
title: GitView - Project lifecycle and membership
kind: spec
created_at: '2026-11-16T08:22:00Z'
updated_at: '2026-11-16T19:51:27Z'
status: specified
refines:
- GITVIEW-SPEC-0005
depends_on:
- GITVIEW-SPEC-0002
- GITVIEW-SPEC-0019
- GITVIEW-SPEC-0023
- GITVIEW-SPEC-0024
relates_to:
- GITVIEW-SPEC-0029
- GITVIEW-SPEC-0047
sources:
  predecessor_draft: docs/drafts/GITVIEW-SPEC-0025.yaml
  predecessor_revision: 9bbf79f
  owner_selection: docs/drafts/project-summary-proposal.md
  default_mechanism_review: docs/drafts/project-default-association-review-20261115.md
specification:
  ontology_refs:
  - gitview:Project
  - gitview:Repository
  - gitview:GitHubRepository
  - gitview:User
  - gitview:projectIncludesRepository
  - gitview:AddRepository
  - gitview:addsRepositoryTo
  - gitview:RemoveRepository
  - gitview:removesRepositoryFrom
  objective: Let the operator create and manage local Projects without confusing their identities or changing
    the source Repositories.
  authority_boundary: The owner selected Project composition, shared Repository membership and the default
    of one Project per Repository. Persistent default association, its reuse and exact setup or deletion
    interactions remain agent-authored candidates; this node does not choose a storage mechanism or establish
    implementation readiness. When GitHub externally revokes access to a private Repository, the retained-data
    visibility and local access described here apply while the relevant account remains active. Independently
    of revocation, while account B is active, the account-switch boundary in 0019 applies. Behavior after
    returning to A is not selected.
  requirements:
    identity: A saved Project has a stable local identity, name, optional description and one or more
      source-identified GitHub Repositories. Project identity is distinct from its name, a Repository
      address and GitHub organization metadata.
    shared_membership: A Repository can belong to several Projects, and a Project can contain Repositories
      from different GitHub organizations. A membership change in one Project does not itself alter another
      Project or mutate the GitHub Repository.
    default: By default there is one Project per Repository under 0005. How an existing default is identified,
      reused or recovered remains open; do not assume an arbitrary Project containing that Repository
      is its default.
    edit: The operator can create, rename and edit a Project and select its members. A valid saved Project
      contains at least one Repository; an invalid attempt to remove the final member does not become
      a confirmed empty Project. Exact controls, name validation and intermediate editing behavior remain
      open.
    description: The optional local Project description can be inspected and explicitly changed or cleared
      without changing the Project identity or the GitHub Repository description. An unavailable description
      is not automatically a confirmed absent one.
    deletion: An intentional local Project removal affects the selected local Project. It does not imply
      deletion of the GitHub Repository or remove another Project's membership. Details of confirmation,
      retained observations and recovery require refinement.
    continuity: When GitHub confirms the same Repository after rename or transfer, preserve the Repository
      identity, prior history and its Project memberships under 0002. A name or address alone is not identity
      evidence.
    uncertainty: An unavailable configuration read or indeterminate save does not prove a Project or membership
      absent, a save successful or a duplicate safe. Preserve and reconcile supported local information
      where possible, and make unresolved outcomes discoverable without inventing an old or new complete
      state. If a saved configuration is inconsistent and its validity cannot be established, do not present
      its membership as confirmed.
    revoked_private: Confirmed GitHub revocation alone does not hide an already saved local Project or
      its saved Repository information under 0019; show the applicable indication and supported time when
      known. Local visibility does not grant source access or authorize a new Project admission. Revocation
      alone does not remove saved Project membership.
  scenarios:
    shared_repository: Repository R belongs to Projects A and B. Removing R from A leaves R in B and does
      not delete R from GitHub; A must remain valid under the one-or-more rule.
    invalid_last_member: The operator attempts to remove the only Repository from an existing Project.
      Do not claim the Project was saved with no members; keep the last supported saved configuration
      unless an independent change occurred.
    repository_renamed: GitHub confirms R is the same Repository after transfer. Preserve its existing
      Project memberships and history rather than creating another identity from the changed address.
    uncertain_save: A Project edit's outcome cannot be determined. Do not claim the new composition saved
      or blindly repeat an operation whose previous effect may still have succeeded; make the limitation
      discoverable.
  open_questions:
  - Default association or alternative reuse behavior, including recovery when a Repository belongs to
    several Projects.
  - Exact creation, editing, name validation, deletion confirmation and local observation-retention behavior.
  - Account and access evidence required for admitting a new Repository and handling an indeterminate
    operation.
  ontology_status: Project, Repository and membership use selected ontology vocabulary; the existence
    of a membership does not prove a particular action, actor or motive.
acceptance:
- A saved Project has a stable local identity, name and at least one Repository, and is distinct from
  its members and GitHub organizations.
- A Repository may belong to multiple Projects; a valid edit to one does not change another Project or
  the GitHub Repository.
- The default of one Project per Repository does not by itself select a persistent default-association
  mechanism.
- Rename or transfer with confirmed same Repository identity preserves history and Project memberships.
- Unavailable configuration or an indeterminate save is not treated as confirmed absence, success or a
  safe duplicate.
- Confirmed GitHub revocation alone does not hide already saved local Project information under 0019.
- The optional local Project description can be explicitly changed or cleared without changing Project
  identity or the GitHub Repository description.
- Intentional local Project removal does not delete the GitHub Repository or alter membership in other
  Projects.

```

## GITVIEW-SPEC-0026: GitView - Scoped observations and incomplete refresh

Источник `specs/nodes/GITVIEW-SPEC-0026.yaml`, SHA-256 `0cc9ee7726d8e19c3da7fb2470798906ac98701eff678ef9411f642b2092bf38`

```yaml
id: GITVIEW-SPEC-0026
title: GitView - Scoped observations and incomplete refresh
kind: spec
created_at: '2026-11-16T07:15:00Z'
updated_at: '2026-11-16T19:55:33Z'
status: specified
refines:
- GITVIEW-SPEC-0003
depends_on:
- GITVIEW-SPEC-0002
- GITVIEW-SPEC-0019
- GITVIEW-SPEC-0023
sources:
  predecessor_draft: docs/drafts/GITVIEW-SPEC-0026.yaml
  predecessor_revision: 33fb739
  root_intent: .specgraph/root_intent.md
specification:
  ontology_refs:
  - gitview:GitHub
  - gitview:Project
  - gitview:Repository
  objective: Preserve the meaning and scope of observed information when GitHub refresh succeeds, partially
    succeeds or fails.
  authority_boundary: This node specifies user-visible data and freshness outcomes. It does not choose
    GitHub endpoints, pagination size, a local schema, background timing, exact retry policy or implementation
    readiness. When GitHub externally revokes access to a private Repository, the retained-data visibility
    and local access described here apply while the relevant account remains active. Independently of
    revocation, while account B is active, the account-switch boundary in 0019 applies. Behavior after
    returning to A is not selected.
  requirements:
    scope: Associate each supported observation with its actual Repository or Project scope, category
      and observation time where known. A successful observation in one scope or category does not make
      another current or complete.
    complete: Present a collection as fully observed or a supported zero only when the available evidence
      establishes that result for its actual scope. A successful request or one successful category alone
      does not prove complete Project or account coverage.
    partial: When only part of the requested information is supported, preserve independently known results
      and make incomplete coverage discoverable. A partial response does not turn missing items into zero,
      silently erase earlier observations or claim a complete refreshed collection.
    failure: After a failed refresh, retain available previously saved data with its supported observation
      time when known and a discoverable scoped failure. Do not invent an unknown time. A failed attempt
      does not advance the last successful observation time or establish source deletion, denial or emptiness
      by itself.
    freshness: Request a refresh of displayed information from GitHub when applicable; do not present
      older saved information as a successful new update when the latest refresh could not establish it.
    revoked_private: Confirmed GitHub revocation of a private Repository retains the saved local data
      and shows its revocation indication and supported time when known under 0019. Stop synchronization
      for the affected Repository while revocation applies; a late in-flight response is not presented
      as a fresh accepted update merely because it arrives afterward.
    accessibility: The operator can discover a refresh failure or incomplete coverage and understand the
      available time and scope without relying solely on color or a transient notice.
  scenarios:
    partial_repository: A Project contains two Repositories and only one refresh completes. Keep supported
      results for each actual scope and identify incomplete Project coverage; do not turn the other Repository
      into an empty collection.
    failed_refresh: A Repository has a supported prior observation and a later refresh fails. Show the
      prior data with its supported time when known and identify the failure without presenting it as
      a new successful observation.
    revoked_during_refresh: The relevant account remains active throughout this scenario. A private Repository
      has saved data when revocation is confirmed while a refresh is in flight. Keep the saved data visible
      with its indication and supported time when known; the late response does not become a new successful
      update.
  open_questions:
  - Evidence sufficient to establish completeness, ordering and scope for each selected GitHub operation.
  - Exact refresh prioritization, retry behavior, source budgets and native presentation of coverage.
  - Recovery, account isolation and treatment of source data when access evidence is incomplete.
  ontology_status: Project and Repository use selected ontology vocabulary; observation scope and refresh
    outcome are specification concepts rather than newly asserted domain entities.
acceptance:
- Observation scope, supported time, coverage and latest refresh outcome remain distinguishable.
- A failed refresh alone does not advance a successful observation time. A partial refresh does not prove
  a complete or empty collection, erase earlier saved data or advance the last complete observation time
  for the wider scope; an independently supported successful part retains its own actual scope and time.
- The operator can distinguish a successful update from last-known data after a failed refresh.
- Confirmed private Repository revocation preserves available saved local data with its indication and
  supported time when known, while synchronization stops under 0019. Visibility and local access follow
  the active-account and A-to-B boundary in 0019.
- Failure and incomplete coverage are discoverable without relying solely on color or transient feedback.

```

## GITVIEW-SPEC-0027: GitView - Today selection and uncertain observations

Источник `specs/nodes/GITVIEW-SPEC-0027.yaml`, SHA-256 `2c7d79ce6be87e4a6e0c51f09ce4eed5f2d872fa961c72ce0a7ccf8112520af3`

```yaml
id: GITVIEW-SPEC-0027
title: GitView - Today selection and uncertain observations
kind: spec
created_at: '2026-11-16T07:16:00Z'
updated_at: '2026-11-16T19:43:05Z'
status: specified
refines:
- GITVIEW-SPEC-0007
depends_on:
- GITVIEW-SPEC-0002
- GITVIEW-SPEC-0019
- GITVIEW-SPEC-0023
- GITVIEW-SPEC-0026
relates_to:
- GITVIEW-SPEC-0047
sources:
  predecessor_draft: docs/drafts/GITVIEW-SPEC-0027.yaml
  predecessor_revision: fef38bd
  owner_today_and_filters: conversation_memory/sketches/gitview/revisions/ed322706b55a4798a4328a69982fcbae/notes.hc
  owner_local_day: conversation_memory/sketches/gitview/revisions/3077fdcd9a8247769def8d6403c2e61c/notes.hc
specification:
  ontology_refs:
  - gitview:Project
  - gitview:Repository
  - gitview:PullRequest
  - gitview:Issue
  objective: Preserve the selected Today and filter behavior when the application has incomplete or uncertain
    work observations.
  authority_boundary: This node refines product-visible selection and uncertainty. It does not select
    GitHub queries, source history limits, filter control design, exact native presentation or implementation
    readiness. When GitHub externally revokes access to a private Repository, the retained-data visibility
    and local access described here apply while the relevant account remains active. Independently of
    revocation, while account B is active, the account-switch boundary in 0019 applies. Behavior after
    returning to A is not selected.
  requirements:
    today: Apply the owner-selected Today meaning under 0007 in the selected Project and user local calendar
      day; earlier unfinished work remains eligible and work completed today remains eligible. Completion
      yesterday alone does not qualify an object today; other applicable conditions may do so.
    all_states: Without an applicable saved exclusion, show eligible PRs and Issues across their lifecycle
      states, including merged and closed. A PR merged today remains the same object and stays visible
      in unfiltered Today while eligible; it leaves an explicitly selected unfinished-only view.
    saved_filters: Explicit lifecycle filters can hide applicable states and persist between launches
      when saved. Restore a valid saved selection in the ordinary view; an unavailable or uncertain save
      is not reported as confirmed. The limited historical merged-counter override follows 0047 and does
      not rewrite the saved preference.
    identity: A source-confirmed PR or Issue is represented once in a selection even when several conditions
      apply. PR and Issue remain separate objects, and equal local numbers in different Repositories do
      not establish identical identity. Do not assert confirmed uniqueness when identity evidence is unresolved.
    unknown: Missing data or an incomplete refresh alone does not establish that an object matches, does
      not match, is completed or was deleted. A known object with an unresolved selection condition remains
      distinguishable from a confirmed match or exclusion; do not invent an unobserved object or an exact
      count from incomplete coverage.
    independent_evidence: An independently supported inclusion alternative can contribute to a confirmed
      match even if another inclusion alternative is unknown, provided all applicable required conditions
      and active filters are supported as satisfied or do not apply. An unknown required filter keeps
      the selection outcome uncertain; a supported false required filter can exclude the object without
      making unrelated unknown facts known.
    observations: Preserve the actual time, scope and coverage of saved observations under 0026. An unfiltered
      grid is not evidence that all GitHub work has been observed. On confirmed private Repository revocation,
      already saved local data remains accessible with the revocation indication and supported time when
      known under 0019; synchronization stops for that Repository.
    accessibility: The operator can discover applicable filter state, uncertain data and incomplete coverage
      without relying solely on color or a transient message. Exact controls remain open.
  scenarios:
    merged_today: A PR that was already in Today is confirmed merged during the current local day. Keep
      the same object in unfiltered Today; an explicit unfinished-only filter may hide it without deleting
      it.
    prior_open: A PR began before today and remains unfinished. It remains eligible today even though
      its creation is older than the current local day.
    incomplete_filter_evidence: A previously observed PR lacks enough supported information to decide
      an active filter. Do not present the missing information as a confirmed match or non-match, or treat
      the Project as confirmed empty.
    independent_alternative: One supported inclusion alternative qualifies an object, another inclusion
      alternative is unknown, and every applicable required condition and active filter is supported as
      satisfied or does not apply. The known alternative can establish the match without claiming the
      unknown alternative is known.
    revoked_repository: The relevant account remains active throughout this scenario. Previously saved
      private work is available locally when GitHub revocation is confirmed. Preserve its local visibility
      and applicable selection context with the revocation indication and supported time when known; do
      not claim current source access.
  open_questions:
  - Other possible Today inclusion conditions and the source history needed to evaluate them.
  - Exact treatment and native presentation of individually uncertain candidates and incomplete population
    coverage.
  - Filter storage scope, reset, cross-device synchronization and behavior when local time zone changes
    during interaction.
  ontology_status: Project, Repository, PullRequest and Issue use selected ontology vocabulary; selection
    and uncertainty are not newly asserted domain entities.
acceptance:
- Applicable earlier unfinished work and work completed during the current user local calendar day remain
  eligible under 0007.
- Without an applicable saved exclusion, eligible PRs and Issues appear across lifecycle states; explicit
  lifecycle filters persist when saved and do not change source objects.
- An incomplete observation does not by itself establish a confirmed match, non-match, deletion or empty
  source, and supported independent evidence retains its own meaning.
- Each included confirmed object has one cell per selection even if multiple conditions apply; linked
  PR and Issue and same-number objects in different Repositories are not conflated.
- Confirmed private Repository revocation does not hide saved local work under 0019 or turn it into newly
  current source data.

```

## GITVIEW-SPEC-0028: GitView - PR check counters and independent review signals

Источник `specs/nodes/GITVIEW-SPEC-0028.yaml`, SHA-256 `f50f3e49e693b15ce8fd404c24f33ab68e015999c16dbd3e6ddd73a364a95985`

```yaml
id: GITVIEW-SPEC-0028
title: GitView - PR check counters and independent review signals
kind: spec
created_at: '2026-11-16T08:18:00Z'
updated_at: '2026-11-16T19:49:26Z'
status: specified
refines:
- GITVIEW-SPEC-0011
depends_on:
- GITVIEW-SPEC-0008
- GITVIEW-SPEC-0019
- GITVIEW-SPEC-0026
relates_to:
- GITVIEW-SPEC-0012
- GITVIEW-SPEC-0029
sources:
  predecessor_draft: docs/drafts/GITVIEW-SPEC-0028.yaml
  predecessor_revision: 9c598dd
  owner_selection: docs/drafts/pull-request-ontology-options.md
specification:
  ontology_refs:
  - gitview:Repository
  - gitview:pullRequestRepository
  - gitview:PullRequest
  - gitview:ReviewThread
  - gitview:CIStatus
  - gitview:Metric
  objective: Let the operator interpret check counts, review assessment and review-thread counts for a
    PR without mistaking one signal for another.
  authority_boundary: The owner selected counters and GitHub-like behavior as the direction. Actual source
    mapping, check equivalence and special conclusions require verification; this node does not establish
    GitHub API behavior, merge readiness or implementation readiness.
  requirements:
    checks: Show supported current individual check counts as red, yellow, green and total for the applicable
      PR, preserving observed revision when known, time and coverage. A workflow run or historical attempt
      is not automatically another current check; identify current equivalence only where supported by
      source evidence.
    unknown: Distinguish a supported zero checks from an unobserved or incomplete collection. Partial
      observations may support partial counts with visible limitations; an unknown, pending, special or
      unmapped result is not silently treated as success. The three colored counts are not assumed to
      sum to total until the applicable mapping supports it.
    revision: Keep each check result and review observation associated with its supported revision and
      observation time when known. An earlier result is not silently presented as current for a newer
      revision without evidence; unavailable revision or time remains uncertain and is not invented.
    review: Keep the supported source review assessment, review requests, total review threads and unresolved
      review-thread count independently interpretable. Where supported, distinguish unavailable assessment,
      absence of reviews and a source-reported review requirement. A request for changes may coexist with
      zero unresolved threads; zero unresolved threads alone is not approval or merge readiness.
    incomplete_evidence: A confirmed current failed check or unresolved thread can support its corresponding
      positive signal even if the remaining collection is incomplete. Absence of failures or unresolved
      threads requires adequate evidence for the applicable scope; no observed item alone is not proof
      of absence.
    unit: Count check entries, affected PRs and affected Repositories as different units under 0012 and
      0029. Overlapping checks, review and thread signals do not create additional PR identities or independent
      tasks.
    saved_data: When GitHub revocation of a private Repository is confirmed, previously saved supported
      observations remain locally accessible with the revocation indication and supported time when known
      under 0019. Do not represent them as newly refreshed or current for a newer revision without evidence.
    scope: This is a compact overview of counters and signals. It does not require showing individual
      CI runs or review-thread content inside GitView.
  scenarios:
    current_retry: A failed check has a later result that source evidence confirms as its current equivalent
      for the applicable revision. Count the current check once; without supported equivalence do not
      claim a complete distinct total.
    no_open_threads: The source reports changes requested and sufficiently covered thread evidence reports
      zero unresolved threads. Present the two supported facts independently; do not infer approval or
      readiness.
    partial_failure: One confirmed current check failed but other checks have not been fully observed.
      The failure signal is supported, while total coverage remains incomplete and absence of other failures
      is not asserted.
    prior_revision: An earlier revision had green CI or approval and the current revision lacks corresponding
      evidence. Keep the old observation in its context rather than reporting a current green or approved
      result.
  open_questions:
  - GitHub source representations, revision linkage, current check identity, retry equivalence and special
    conclusions.
  - Exact native presentation for incomplete coverage, review requests and independently reported signals.
  - Any applicable higher-level readiness predicate and its source evidence.
  ontology_status: PullRequest, ReviewThread and CIStatus use selected ontology vocabulary; counters and
    assessments do not establish actor actions or a new domain entity.
acceptance:
- Supported current check counts retain the applicable PR, revision when known, observation time when
  known and collection coverage.
- Known zero checks, unobserved checks and incomplete observations remain distinguishable; unknown or
  special conclusions do not silently become successful checks.
- Review assessment, requests and total and unresolved thread counts remain independently interpretable;
  one does not imply another.
- Check counts, affected PR counts and affected Repository counts are not conflated.
- No isolated check, review or thread count is presented as a confirmed merge decision.

```

## GITVIEW-SPEC-0029: GitView - Scope and uniqueness of work summaries

Источник `specs/nodes/GITVIEW-SPEC-0029.yaml`, SHA-256 `b16dc1180fbc4a58ec36f5d5fd21214c9895f1c78327ba769ade4ba2fda77d27`

```yaml
id: GITVIEW-SPEC-0029
title: GitView - Scope and uniqueness of work summaries
kind: spec
created_at: '2026-11-16T08:17:00Z'
updated_at: '2026-11-16T19:55:33Z'
status: specified
refines:
- GITVIEW-SPEC-0012
depends_on:
- GITVIEW-SPEC-0002
- GITVIEW-SPEC-0005
- GITVIEW-SPEC-0007
- GITVIEW-SPEC-0019
- GITVIEW-SPEC-0026
relates_to:
- GITVIEW-SPEC-0047
sources:
  predecessor_draft: docs/drafts/GITVIEW-SPEC-0029.yaml
  predecessor_revision: 9bbf79f
  project_summary: docs/drafts/project-summary-proposal.md
  repository_summary: docs/drafts/repository-summary-proposal.md
specification:
  ontology_refs:
  - gitview:pullRequestRepository
  - gitview:issueRepository
  - gitview:pullRequestIssueLink
  - gitview:CIStatus
  - gitview:ReviewThread
  - gitview:Project
  - gitview:Repository
  - gitview:PullRequest
  - gitview:Issue
  - gitview:Metric
  - gitview:projectIncludesRepository
  objective: Keep Repository, Project and unique portfolio work summaries interpretable when Repositories
    and attention signals overlap.
  authority_boundary: This node refines scope, identity and units of supported summaries. It does not
    select every metric predicate, exact visual layout, GitHub query or implementation, and it does not
    establish readiness for implementation. When GitHub externally revokes access to a private Repository,
    the retained-data visibility and local access described here apply while the relevant account remains
    active. Independently of revocation, while account B is active, the account-switch boundary in 0019
    applies. Behavior after returning to A is not selected.
  requirements:
    repository: A Repository summary concerns its own supported source objects for the specified category
      and period where applicable. Rename or transfer does not create a second Repository when the source
      confirms the same identity under 0002.
    project: A Project summary uses its applicable member Repositories. A Repository shared by two Projects
      contributes to each Project in its own scope; one Project's membership is not another's.
    portfolio: When a unique portfolio-wide count is presented, count confirmed Repository and source
      object identities once across overlapping Projects. A linked PR and Issue remain distinct object
      types; equal local numbers in different Repositories do not prove the same object.
    units: Distinguish individual failed checks from affected PRs and affected Repositories, and distinguish
      current work from outcomes over a stated period. A single PR may contribute to several independently
      supported attention signals without becoming several PRs or independent tasks.
    coverage: Preserve each summary's supported scope, coverage and observation time when known under
      0026. Partial coverage may support an explicitly partial result; it is not a confirmed full total
      and unavailable inputs are not automatically zero. If membership changes, reassess the new scope
      without rewriting the provenance of an earlier observation.
    access: Confirmed GitHub revocation alone does not hide an already saved supported local summary under
      0019; retain its actual scope, coverage, supported time when known and revocation indication. Do
      not treat it as a newly refreshed source result.
    navigation: If a summary signal opens a work selection, preserve the originating Project and applicable
      Repository, condition and period under 0047. A count of checks, threads or events is not automatically
      the count of resulting PR or Issue cards. If observations changed or coverage is incomplete, keep
      that limitation visible rather than forcing equality.
    historical_boundary: Project historical graphs use the current Project composition for the selected
      period under 0047 and identify that current-membership basis to the operator with applicable coverage.
      This does not assert which Repositories belonged to the Project in the past; exact historical counter
      and event semantics remain subject to their own specifications.
  scenarios:
    shared_repository: Repository R belongs to Projects A and B. R contributes within each Project; a
      unique portfolio total counts R and each confirmed source object once.
    overlapping_signals: One PR has a supported failed check and an unresolved review thread. It can contribute
      to each applicable signal without becoming two distinct PRs.
    missing_observation: A Project contains five Repositories, but one lacks the needed observation. Show
      supported values only with their incomplete coverage; do not silently count the missing Repository
      as zero.
    identity_scope: Two distinct Repositories each contain an Issue numbered 42. They remain distinct
      objects; an Issue and a linked PR also remain separate source objects.
  open_questions:
  - Exact predicates and source evidence for individual summary measurements and their current or period
    scope.
  - Native presentation of incomplete coverage and differences between a signal and its destination selection.
  - Counting of historical events, reopened objects and unknown identity when source evidence is incomplete.
  ontology_status: Project, Repository, PullRequest, Issue and Metric use the selected ontology vocabulary;
    a summary or counter is not a new ontology entity.
acceptance:
- Supported summaries identify their actual Repository, Project or portfolio scope, unit, applicable period
  and coverage.
- Shared Repositories contribute within each applicable Project, while any asserted unique portfolio total
  counts confirmed Repository and source object identities once.
- Distinct units and overlapping attention signals are not silently added as separate work items or substituted
  for destination card counts.
- Incomplete source coverage remains identifiable and is not silently treated as zero or as a complete
  total.
- An available saved summary remains local and visible after confirmed GitHub revocation with its supported
  time when known and applicable limitation under 0019. Visibility and local access follow the active-account
  and A-to-B boundary in 0019.

```

## GITVIEW-SPEC-0030: GitView - Time series, coverage and observed outcomes

Источник `specs/nodes/GITVIEW-SPEC-0030.yaml`, SHA-256 `a7d1d2768604482f113306b4ebc0f0743b280886304366dfdeb38870c3df026d`

```yaml
id: GITVIEW-SPEC-0030
title: GitView - Time series, coverage and observed outcomes
kind: spec
created_at: '2026-11-16T08:26:00Z'
updated_at: '2026-11-16T19:55:33Z'
status: specified
refines:
- GITVIEW-SPEC-0013
depends_on:
- GITVIEW-SPEC-0012
- GITVIEW-SPEC-0019
- GITVIEW-SPEC-0026
- GITVIEW-SPEC-0029
relates_to:
- GITVIEW-SPEC-0047
sources:
  predecessor_draft: docs/drafts/GITVIEW-SPEC-0030.yaml
  predecessor_revision: 9c598dd
  project_summary: docs/drafts/project-summary-proposal.md
  history_membership_decision: conversation_memory/sketches/gitview/revisions/a55f271ca16f4283bfaf67095616ee7a/notes.hc
specification:
  ontology_refs:
  - gitview:pullRequestRepository
  - gitview:issueRepository
  - gitview:pullRequestIssueLink
  - gitview:Metric
  - gitview:Project
  - gitview:Repository
  - gitview:PullRequest
  - gitview:Issue
  - gitview:projectIncludesRepository
  objective: Present historical work measurements with enough scope and evidence to distinguish progress
    from missing information.
  authority_boundary: The owner chose historical graphs and current Project composition as their membership
    basis. This node does not select every metric, source operation, bucket layout, burn-down formula
    or implementation, and does not establish that history is available from GitHub. When GitHub externally
    revokes access to a private Repository, the retained-data visibility and local access described here
    apply while the relevant account remains active. Independently of revocation, while account B is active,
    the account-switch boundary in 0019 applies. Behavior after returning to A is not selected.
  requirements:
    measurement: Identify a series by its supported subject, unit, source or observation basis, selected
      scope, time period and coverage. When values are aggregated into buckets, identify the applicable
      bucket boundaries. Repository and portfolio identity rules follow 0029.
    membership: Project historical graphs are recalculated over the Project's current Repository composition
      for the selected period under 0047. Identify this basis and applicable coverage to the operator;
      it is not evidence of which Repositories belonged to the Project at a past time.
    snapshots: A count of open work at a past time requires sufficient observation or reliably reconstructible
      state for that scope and time. A later snapshot alone does not establish earlier values or all intervening
      transitions.
    outcomes: Keep PR merge outcomes and Issue closure outcomes distinct from open-work snapshots and
      from each other. Distinguish supported Issue closure reasons and unknown reason; a closed Issue
      is not automatically a completed task. Do not attribute a current reason to a past closure event
      without evidence. A link between a PR and Issue does not establish a single measured object or two
      independent tasks. When the type of a closed object is unknown, do not count it as an Issue or PR,
      or dismiss it as irrelevant while claiming an exact type-specific total.
    unit: Distinguish a count of events in a period from a count of distinct objects with at least one
      qualifying event. A repeated observation of the same event must not become another event; a distinct-event
      count requires sufficient identity and source evidence. Match label, time buckets when used and
      evidence to the stated unit; do not silently substitute one series for another.
    event_time: Attribute an observed outcome to its supported source event time rather than the time
      GitView fetched it. A current state or a latest available timestamp alone does not prove complete
      earlier event history.
    gaps: Show a supported zero only when evidence and coverage support zero for that bucket and scope.
      An unobserved period remains a gap or unknown; a partially observed scope remains explicitly incomplete
      rather than a confirmed full total.
    saved_data: A previously saved supported series remains locally accessible after confirmed private
      Repository revocation under 0019, retaining its actual time, scope, coverage and applicable revocation
      indication. It is not represented as newly refreshed or complete without supporting evidence.
    burn_down: The operator can understand supported unfinished and completed work without waiting for
      a formal burn-down formula. A specifically labeled burn-down metric requires a separately specified
      cohort, measurement unit, starting population and transition rules; do not derive that claim by
      simply adding PR and Issue counts without the definition and sufficient evidence.
  scenarios:
    current_membership: A Repository is added to a Project today and has earlier source activity. Recalculate
      the selected historical graph using the current composition and identify that basis; do not claim
      the Repository belonged to the Project at the earlier time.
    unknown_bucket: One month has insufficient source coverage. Preserve the gap or incomplete indication
      rather than drawing a confirmed zero for that month.
    repeated_closure: An Issue has two separately supported closure events in the same period. An event-count
      series can represent two events while a distinct-Issue series counts the Issue at most once for
      that period; do not conflate the units.
    revoked_repository: The relevant account remains active throughout this scenario. A previously saved
      supported series includes a private Repository whose GitHub access is confirmed revoked. Keep the
      supported local series accessible with its original scope, time and revocation indication, without
      implying a new successful refresh.
  open_questions:
  - Exact selected metrics, event and object units, source evidence, time-zone and bucket rules.
  - Treatment and native presentation of partial coverage, gaps and changed composition.
  - Whether and how a separately defined burn-down view belongs in a later product increment.
  ontology_status: Project, Repository and Metric use selected ontology vocabulary; graph buckets and
    chart styles are presentation and measurement concepts rather than new domain entities.
acceptance:
- A historical series identifies its supported scope, measurement unit, period and coverage.
- A Project historical graph identifies current Project composition as its basis and does not present
  that basis as historical membership.
- Unknown or incomplete coverage is not presented as a confirmed zero or complete total.
- Open-work snapshots, PR merge outcomes, Issue closure outcomes and event-versus-distinct-object counts
  are not silently conflated.
- Previously saved supported history remains locally accessible after confirmed private Repository revocation
  under 0019 with its applicable limitation and supported time when known. Visibility and local access
  follow the active-account and A-to-B boundary in 0019.

```

## GITVIEW-SPEC-0031: GitView - Static preview and object identity

Источник `specs/nodes/GITVIEW-SPEC-0031.yaml`, SHA-256 `2db124c8bdc4edfb9dfe194b985f2682f13e9580a9e64448bd9c6a384ac48799`

```yaml
id: GITVIEW-SPEC-0031
title: GitView - Static preview and object identity
kind: spec
created_at: '2026-11-16T07:11:00Z'
updated_at: '2026-11-16T19:57:34Z'
status: specified
refines:
- GITVIEW-SPEC-0015
depends_on:
- GITVIEW-SPEC-0017
- GITVIEW-SPEC-0019
- GITVIEW-SPEC-0023
- GITVIEW-SPEC-0024
- GITVIEW-SPEC-0032
sources:
  predecessor_draft: docs/drafts/GITVIEW-SPEC-0031.yaml
  predecessor_revision: fef38bd
  root_intent: .specgraph/root_intent.md
  visibility_rationale: conversation_memory/sketches/gitview/revisions/ef1c2f72ef08420980a423cd63c6d34a/notes.hc
specification:
  ontology_refs:
  - gitview:Project
  - gitview:Repository
  - gitview:PullRequest
  - gitview:Issue
  objective: Let the operator inspect a selected object without losing its identity or the originating
    overview.
  authority_boundary: This node refines the selected first-version static preview. It does not select
    a native menu implementation, gesture timing, exact transition animation, source-access recovery mechanism
    or later sliding-preview behavior, and does not establish implementation readiness. When GitHub externally
    revokes access to a private Repository, the retained-data visibility and local access described here
    apply while the relevant account remains active. Independently of revocation, while account B is active,
    the account-switch boundary in 0019 applies. Behavior after returning to A is not selected.
  requirements:
    preview: A recognized long press previews the selected eligible Project, Repository, PR or Issue without
      leaving the overview. It provides readable additional available details beyond the cell and offers
      explicit local open or dismissal. Details retain their supported source context and limitations;
      unavailable values are not invented.
    identity: The preview and an explicit local open remain bound to the selected object's supported identity
      and originating context. A reordered cell or another object with the same number or name is not
      substituted. Refresh or filter changes do not silently retarget an already open preview.
    return: Dismissal or return preserves the valid origin, Project, applicable period, filters and density
      under 0024, with meaningful position or focus where possible. If the origin cannot be restored,
      expose an appropriate supported fallback rather than implying a different scope is the original.
    revoked_private: When GitHub explicitly confirms access revocation for a private Repository, already
      saved local preview details remain available with the revocation indication and supported last update
      time when known under 0019. A local open of the same saved object does not establish restored GitHub
      access. Synchronization stops and applicable recovery or explicit local deletion remains reachable.
    accessibility: Preview, dismissal, explicit opening and return have accessible paths without requiring
      long press or color alone, with object identity and observation limitations available to assistive
      technologies under 0032.
    future: Sliding inspection across cells remains a later product direction; its activation and gesture
      arbitration are not required by this node.
  scenarios:
    same_object: The operator previews PR 42 in Repository A. If the grid reorders while preview remains
      open, it continues to describe that same PR; opening does not select PR 42 from another Repository.
    filter_change: An open previewed object no longer matches the active filter. It is not silently replaced
      by a different card; dismissal returns to the current valid selection.
    revocation_while_open: The relevant account remains active throughout this scenario. A saved private
      PR preview is open when Repository access revocation is confirmed. Keep available local details
      accessible with the indication and supported time when known, stop synchronization and retain a
      local route to recovery or explicit deletion; do not claim a new source grant.
  open_questions:
  - Exact native preview and menu behavior, gesture arbitration and cancellation.
  - Fallback position and focus after changes to the original scope.
  - Source evidence for revocation and the mechanics of access recovery.
  ontology_status: Project, Repository, PullRequest and Issue use selected ontology vocabulary; preview
    and presentation identity are interaction concepts.
acceptance:
- First-version preview provides readable additional available details for the selected object without
  navigating away and offers explicit local open and dismissal; opening preserves its identity and origin.
- Grid reordering, refresh or filter change does not silently retarget an open preview or substitute an
  unrelated object.
- Dismissal and return retain valid origin and selection context or provide a supported fallback without
  presenting a different object as the original.
- Available saved preview details remain locally accessible after confirmed private Repository revocation
  with the applicable indication and supported time when known under 0019. Visibility and local access
  follow the active-account and A-to-B boundary in 0019.
- Preview, dismissal, opening and return have accessible paths that do not require long press or color
  alone.

```

## GITVIEW-SPEC-0032: GitView - Accessible grid and navigation

Источник `specs/nodes/GITVIEW-SPEC-0032.yaml`, SHA-256 `f3d39dbcc59eb881892f4adeb6a653d0f31760217644aea688dbfe75c428391b`

```yaml
id: GITVIEW-SPEC-0032
title: GitView - Accessible grid and navigation
kind: spec
created_at: '2026-11-16T07:10:00Z'
updated_at: '2026-11-16T19:49:26Z'
status: specified
refines:
- GITVIEW-SPEC-0017
depends_on:
- GITVIEW-SPEC-0014
- GITVIEW-SPEC-0015
- GITVIEW-SPEC-0019
- GITVIEW-SPEC-0023
- GITVIEW-SPEC-0024
sources:
  predecessor_draft: docs/drafts/GITVIEW-SPEC-0032.yaml
  predecessor_revision: 33fb739
  root_intent: .specgraph/root_intent.md
  visibility_rationale: conversation_memory/sketches/gitview/revisions/ef1c2f72ef08420980a423cd63c6d34a/notes.hc
specification:
  ontology_refs:
  - gitview:User
  - gitview:Project
  - gitview:Repository
  - gitview:PullRequest
  - gitview:Issue
  objective: Keep the scalable overview, inspection and navigation understandable and operable without
    relying on sight, color or a particular gesture.
  authority_boundary: This node describes product outcomes for accessibility. It does not select a native
    layout, focus algorithm, platform API, exact announcement timing or supported OS range, and is not
    evidence of implementation or device validation. When GitHub externally revokes access to a private
    Repository, the retained-data visibility and local access described here apply while the relevant
    account remains active. Independently of revocation, while account B is active, the account-switch
    boundary in 0019 applies. Behavior after returning to A is not selected.
  requirements:
    identity: An accessible representation identifies an object's type and enough supported identity and
      source context to distinguish it in the current scope. It communicates available relevant status
      without converting unknown or stale information into a current success.
    actions: Provide accessible paths to connect or recover access, select Repositories, manage and navigate
      Projects, inspect and open work, change grid density, reach filters and available refresh, source
      or sharing actions, and dismiss or return from preview. These paths do not depend solely on pinch,
      long press, hover, a particular visual position or color.
    focus: When preview is dismissed or an object is closed, restore meaningful focus to the same available
      object or an appropriate valid context. Do not identify a different object as the original when
      the selection changed; exact fallback mechanics remain open under 0024.
    observations: Make meaningful values, loading, incomplete coverage, failure and source-access state
      available to assistive technologies and without reliance on color alone. Preserve each supported
      observation time and scope; do not claim a category refreshed simply because another did.
    revoked_private: After confirmed GitHub access revocation for a private Repository, already saved
      local content remains accessible with the revocation indication and supported last update time when
      known under 0019. Applicable recovery or explicit local deletion remains accessible; retained local
      visibility does not imply a GitHub grant.
    adaptation: Larger text, display preferences and reduced motion retain access to essential content
      and navigation. Exact density and visual transition may adapt; example grid column counts are not
      accessibility requirements.
  scenarios:
    dense_inspection: The operator uses an accessible path to identify and preview a PR in a dense grid
      without a long press, then returns to meaningful context without silently selecting another PR.
    unavailable_signal: A CI value is unobserved or stale. Its accessible representation communicates
      the supported limitation rather than announcing an unqualified successful current check.
    revocation_during_preview: The relevant account remains active throughout this scenario. A saved private
      PR preview is being inspected when GitHub revocation is confirmed. Keep its available local details
      accessible with revocation indication and supported time when known; stop synchronization and expose
      the applicable recovery or local deletion path.
    larger_text: A larger text setting changes the layout or number of columns while the operator can
      still reach the same available objects and essential actions.
  open_questions:
  - Native traversal, grouping, focus fallback and announcement behavior, subject to device evaluation.
  - Exact controls and visual adaptations across supported devices and display preferences.
  ontology_status: Project, Repository, PullRequest and Issue use selected ontology vocabulary; accessibility
    representations and focus are interaction concepts, not new domain entities.
acceptance:
- Essential overview navigation, density changes, inspection, preview and available refresh or recovery
  actions have accessible paths without requiring a particular gesture or color.
- Accessible representations distinguish object identity and source context and do not present unknown
  or stale values as confirmed current success.
- Dismissal and return preserve meaningful context without silently identifying a different object as
  the original.
- Saved local content remains accessible with the applicable indication and known observation time after
  confirmed private Repository revocation under 0019. Visibility and local access follow the active-account
  and A-to-B boundary in 0019.
- Larger text and reduced motion preserve access to essential information and navigation without a fixed
  grid density.

```

## GITVIEW-SPEC-0033: GitView - Open and share the original source

Источник `specs/nodes/GITVIEW-SPEC-0033.yaml`, SHA-256 `f4a9b4088fc1af8036ee242cb1bc610c4df18994e3e6c9c7b1fa9b174321ff82`

```yaml
id: GITVIEW-SPEC-0033
title: GitView - Open and share the original source
kind: spec
created_at: '2026-11-16T08:28:00Z'
updated_at: '2026-11-16T20:05:42Z'
status: specified
refines:
- GITVIEW-SPEC-0016
depends_on:
- GITVIEW-SPEC-0002
- GITVIEW-SPEC-0019
- GITVIEW-SPEC-0024
- GITVIEW-SPEC-0038
sources:
  predecessor_draft: docs/drafts/GITVIEW-SPEC-0033.yaml
  predecessor_revision: 9c598dd
  owner_direction: docs/drafts/product-foundation.md
specification:
  ontology_refs:
  - gitview:User
  - gitview:Repository
  - gitview:PullRequest
  - gitview:Issue
  objective: Let the operator reach a selected object's original GitHub source and share useful context
    without confusing the object or implying external access.
  authority_boundary: Source navigation and lightweight sharing are selected. The default sharing payload,
    private-data handoff policy, exact native controls and delivery semantics remain open; no external
    delivery or implementation is established. When GitHub externally revokes access to a private Repository,
    the retained-data visibility and local access described here apply while the relevant account remains
    active. Independently of revocation, while account B is active, the account-switch boundary in 0019
    applies. Behavior after returning to A is not selected.
  requirements:
    association: Associate an offered source link with the selected Repository, PR or Issue and its supported
      source context. Equal local object numbers in different Repositories do not establish identical
      objects; do not substitute a link belonging to another object.
    observed_link: A previously observed address may remain available as last known where applicable and
      no contradicting identity evidence exists, with its actual observation context and uncertainty.
      An old association alone does not establish that the address still resolves to the same object.
      If source evidence confirms that the address now identifies another object, do not offer it for
      source opening or sharing as the earlier object; rename, transfer and address reuse are evaluated
      under 0002 and 0038.
    unavailable: If no eligible association for a source action is supported, provide an understandable
      unavailable or uncertain state rather than inventing a URL from a name or number or silently navigating
      to another object.
    open: When an eligible source link is known, offer an action to request opening the source through
      the platform. Starting or accepting a handoff does not by itself prove the external application
      loaded the intended object or that GitHub granted access.
    share: Offer lightweight platform sharing when applicable, subject to the separately selected content
      and disclosure policy. A link-only default is an agent-authored candidate rather than a selected
      owner requirement; do not assume private text, screenshots or another payload are included or excluded
      without the applicable decision.
    external_boundary: Sharing does not grant a recipient GitHub access, prove delivery or prove that
      the recipient opened the object. Credentials must not be included in shared material or ordinary
      diagnostics, including credentials already embedded in an observed URL. Information already handed
      outside GitView cannot be assumed retractable.
    handoff: Apply the currently supported object identity, link eligibility and independently applicable
      disclosure evidence when GitView actually hands the source link or payload to the platform, including
      a later app-controlled provision if used. Do not claim an earlier render alone proves current eligibility;
      a previously completed external handoff cannot be assumed retractable.
    revocation: Confirmed private Repository revocation does not hide an already saved local object or
      its supported last-known information under 0019. Local visibility does not by itself establish that
      an external source action or share is eligible; that handoff follows its own policy and must not
      be reported as successful without evidence.
    return: A failed or cancelled source action does not itself establish source deletion. Preserve an
      available way back to valid GitView context under 0024.
  scenarios:
    unknown_link: A saved Issue is visible but no eligible source-associated URL is supported. Keep the
      object accessible and indicate the source-link action is unavailable or uncertain rather than inventing
      a URL.
    reused_address: An earlier address is confirmed to identify a different Repository. Do not offer that
      address for source opening or sharing as the earlier Repository, including as a last-known link;
      keep the earlier object accessible locally when supported.
    private_source: The operator initiates sharing for an eligible PR in a private Repository. The share
      flow does not by itself grant a recipient access or prove delivery.
    revoked_local: The relevant account remains active throughout this scenario. A private Repository's
      access is confirmed revoked while its saved PR remains visible. Local inspection remains possible
      under 0019; do not claim a successful external open or restored GitHub grant.
  open_questions:
  - Sharing payload, optional added context and disclosure policy for private data.
  - Supported evidence and native behavior for current and last-known source links, handoff and cancellation.
  - Exact link eligibility and source access recovery after a confirmed revocation.
  ontology_status: Repository, PullRequest and Issue use selected ontology vocabulary; a source link or
    handoff does not establish an actor motive or a new domain entity.
acceptance:
- An offered source link remains associated with the correct selected object and Repository context.
- A source-opening action and lightweight platform sharing are available when their applicable eligibility
  is supported, without asserting external success or delivery.
- Missing or conflicting link evidence is not replaced by a fabricated or misdirected source URL.
- Local visibility after confirmed private Repository revocation remains distinct from eligibility and
  outcome of an external handoff. Visibility and local access follow the active-account and A-to-B boundary
  in 0019.
- Sharing does not itself grant a recipient GitHub access or establish delivery. Credentials, including
  those already embedded in an observed URL, are not included in shared material or ordinary diagnostics.

```

## GITVIEW-SPEC-0034: GitView - Authored description sections and source text

Источник `specs/nodes/GITVIEW-SPEC-0034.yaml`, SHA-256 `29eb749f8f1fabd6835ca02aab51e1217b3c2ffa0fc6818e896c6bcee900c210`

```yaml
id: GITVIEW-SPEC-0034
title: GitView - Authored description sections and source text
kind: spec
created_at: '2026-11-16T08:22:00Z'
updated_at: '2026-11-16T19:49:26Z'
status: specified
refines:
- GITVIEW-SPEC-0010
depends_on:
- GITVIEW-SPEC-0008
- GITVIEW-SPEC-0009
- GITVIEW-SPEC-0019
- GITVIEW-SPEC-0026
sources:
  predecessor_draft: docs/drafts/GITVIEW-SPEC-0034.yaml
  predecessor_revision: 9c598dd
  owner_selection: docs/drafts/github-templates/README.md
specification:
  ontology_refs:
  - gitview:Issue
  - gitview:PullRequest
  objective: Preserve what an Issue or PR author wrote while making reliably identified sections understandable
    as authored statements.
  authority_boundary: The owner selected description formats for the participating process. Exact parsing
    syntax, rendering, deployment and enforcement require further refinement; this node does not claim
    that a template is installed or that an authored statement is true. When GitHub externally revokes
    access to a private Repository, the retained-data visibility and local access described here apply
    while the relevant account remains active. Independently of revocation, while account B is active,
    the account-switch boundary in 0019 applies. Behavior after returning to A is not selected.
  requirements:
    formats: The selected Issue format contains Problem, Motivation, Expected outcome and References.
      The selected PR format contains those sections plus Changes and Validation under 0010.
    original: Keep the available original source description accessible with its source context, including
      unstructured or external text. A confirmed empty body is distinct from an unavailable or unobserved
      body.
    extraction: Present a section as extracted only when its authored text can be reliably identified
      in the source. Preserve the original wording and attribution when available; do not infer missing
      content from a title, link, review or label.
    ambiguous: Missing, empty, duplicated or unsupported headings are not automatically equivalent. When
      evidence is sufficient to establish a selected section is missing, indicate that absence. If extraction
      is ambiguous, do not assert confirmed absence; retain the available original body and communicate
      its limitation rather than inventing sections or hiding the object. Exact extraction and ambiguity
      rules remain open.
    authored_claim: Motivation, expected outcome and validation are statements in an authored description.
      They do not independently establish an actor's actual motive, achievement of an outcome, successful
      CI or independent test evidence. Present independently observed source facts according to their
      own evidence.
    freshness: A refreshed or newly observed body and an extracted section retain their actual observation
      context. A section from an earlier body is not presented as though reliably extracted from a later
      body when source or extraction evidence is unavailable.
    saved_data: After confirmed GitHub revocation of a private Repository, previously saved local description
      text remains accessible with the revocation indication and supported observation time when known
      under 0019; do not imply the source is currently reachable.
  scenarios:
    legacy: An existing PR contains an unstructured body without the selected headings. Keep the available
      authored body accessible and do not fabricate missing sections or suppress the PR.
    conflicting_validation: An author writes that validation passed, while supported CI evidence reports
      failure. Preserve the authored statement and the independently observed CI status without silently
      converting either into the other.
    unavailable_body: The source body cannot be observed. Represent it as unavailable or unknown rather
      than asserting the author wrote an empty description.
    source_link_and_motivation: A PR has an authored Motivation section and a supported link to an Issue.
      Preserve the attributed statement and the independently supported link in their respective contexts;
      neither alone proves a particular actor motive or causal history.
  open_questions:
  - Supported heading formats, extraction boundaries, duplicate headings and display of ambiguous sections.
  - Source coverage, attribution and exact handling of unavailable or differently formatted descriptions.
  - Which repositories and authoring paths participate in the selected mandatory format and how conformance
    is checked.
  ontology_status: PullRequest and Issue use selected ontology vocabulary; description fields are authored
    content, not proof of an actor's motive or new ontology entities.
acceptance:
- Available original Issue and PR descriptions remain accessible even when structured extraction is absent
  or unreliable.
- Reliably extracted sections retain their authored text and are distinguished from independently observed
  state and evidence.
- Empty, unavailable, missing and ambiguous content are not silently conflated or fabricated.
- A differently formatted legacy or external description is not sufficient reason to hide its PR or Issue.
- Previously saved local text remains accessible after confirmed private Repository revocation under 0019
  with its applicable indication and supported time when known. Visibility and local access follow the
  active-account and A-to-B boundary in 0019.

```

## GITVIEW-SPEC-0035: GitView - Density changes within an overview

Источник `specs/nodes/GITVIEW-SPEC-0035.yaml`, SHA-256 `5eaa48a7749085944faf548d5cf2eba7c72af4e3651356c6ec0645a29bde77c4`

```yaml
id: GITVIEW-SPEC-0035
title: GitView - Density changes within an overview
kind: spec
created_at: '2026-11-16T08:17:00Z'
updated_at: '2026-11-16T19:45:17Z'
status: specified
refines:
- GITVIEW-SPEC-0014
depends_on:
- GITVIEW-SPEC-0007
- GITVIEW-SPEC-0024
- GITVIEW-SPEC-0031
- GITVIEW-SPEC-0032
- GITVIEW-SPEC-0047
sources:
  predecessor_draft: docs/drafts/GITVIEW-SPEC-0035.yaml
  predecessor_revision: 9c598dd
  dense_prototype: docs/drafts/dense-overview-prototype.md
  pinch_scope_decision: conversation_memory/sketches/gitview/revisions/408e46cab5da424d829e0ce07503fd28/metadata.json
specification:
  ontology_refs:
  - gitview:Project
  - gitview:Repository
  - gitview:PullRequest
  - gitview:Issue
  objective: Let the operator move between a dense overview and more detailed cards without losing the
    meaning or scope of the selected work.
  authority_boundary: This node refines the selected Photos-inspired in-scope density change. Exact column
    counts, animation, gesture arbitration, visual cues and native performance remain to be evaluated;
    this node does not establish implementation readiness.
  requirements:
    scale: Pinch changes grid detail through discrete density steps, with visual feedback as the operator
      moves between them. At maximum cell size, the gesture transitions to the intended next level under
      0014; the boundary depends on grid width and the maximum cell size in points. Approximate examples
      of eight columns and a hundred objects illustrate desired scale, not fixed counts or a performance
      guarantee.
    selection: Changing density alone does not change the selected Project or Repository, period, explicit
      filters, object identity, lifecycle state, source observation or collection coverage. An independent
      refresh or membership change may still alter the collection and retains its own explanation.
    detail: Smaller cells can display less detail while preserving an accessible way to distinguish PR
      from Issue, identify and inspect objects without relying on color alone. Larger cells can reveal
      more supported information. A detail omitted for lack of space is not an assertion that it is zero,
      current, complete or healthy.
    project_overview: At the Projects overview, changing density does not change a Project or its actual
      summary scope. Preserve an available route to the applicable Project summary even when not all values
      fit in a compact cell.
    focus: Preserve the identity of an available focused or anchored object and a meaningful position
      where possible as density changes. If an independent data or scope change makes it unavailable,
      use a supported fallback under 0024 without presenting another object as the original.
    navigation: Before the maximum cell-size boundary, density changes keep the current scope. At the
      boundary an intentional transition enters the corresponding next level under 0014; ambiguous target
      selection must not silently open another object. Exact anchoring and reverse behavior remain open.
    accessibility: Provide an accessible alternative to pinch and a way to identify and inspect objects
      without relying on color or tiny targets alone under 0032. Large text or screen size can change
      the layout rather than forcing an illustrative column count.
    preview: The first-version static preview remains available for an eligible object under 0031. Sliding
      inspection is a later direction and its activation is not selected here.
  scenarios:
    stable_selection: A Project grid contains 100 identified objects and no independent data change occurs.
      Before the maximum-size boundary is reached, changing density retains the same selected objects,
      Project, period and filters.
    focused_object: A PR remains in the selection while the number of visible columns changes. Preserve
      its supported identity and a meaningful position where possible rather than selecting the object
      now occupying its former cell.
    larger_text: A larger system text setting makes the illustrative eight-column layout unsuitable. Adapt
      the layout while retaining access to objects and essential actions.
    concurrent_refresh: A source refresh changes the selection during a density gesture. Attribute the
      new data to the refresh, not to pinch; do not silently clear saved filters or claim complete coverage
      without evidence.
  open_questions:
  - Native collection layout, animation, anchoring and gesture coordination across density levels.
  - Exact visual and accessible cues at each scale and the treatment of independent changes during interaction.
  - How the intended target and return or reverse transition are established at a level boundary.
  ontology_status: Project, Repository, PullRequest and Issue use selected ontology vocabulary; density
    and visual position are presentation concepts rather than new domain entities.
acceptance:
- Before the boundary, changing density preserves the applicable collection scope, period, filters and
  object identities; at the boundary the intended next-level transition follows 0014.
- Dense and spacious presentations retain accessible identification and inspection of available objects
  without relying solely on color or pinch.
- A focused object remains the same object where it is available; an unavailable origin is not silently
  replaced by another object.
- Larger text can alter the number of columns without removing access to essential content and actions.
- Independently observed data changes remain distinguishable from the effect of changing density.

```

## GITVIEW-SPEC-0036: GitView - Connection state and stored observations

Источник `specs/nodes/GITVIEW-SPEC-0036.yaml`, SHA-256 `ed4342b2ed5a0af98ee7bb9476cfefce0239aa305afda8b9716f38883972279a`

```yaml
id: GITVIEW-SPEC-0036
title: GitView - Connection state and stored observations
kind: spec
created_at: '2026-11-16T07:13:00Z'
updated_at: '2026-11-16T19:45:17Z'
status: specified
refines:
- GITVIEW-SPEC-0019
depends_on:
- GITVIEW-SPEC-0002
- GITVIEW-SPEC-0003
- GITVIEW-SPEC-0023
sources:
  predecessor_draft: docs/drafts/GITVIEW-SPEC-0036.yaml
  predecessor_revision: fef38bd
  visibility_rationale: conversation_memory/sketches/gitview/revisions/ef1c2f72ef08420980a423cd63c6d34a/notes.hc
  account_switch_decision: conversation_memory/sketches/gitview/revisions/3bb8ef35b11a499091c40333c03d2566/metadata.json
specification:
  ontology_refs:
  - gitview:User
  - gitview:GitHub
  - gitview:Repository
  objective: Help the operator understand connection problems while retaining access to information already
    saved locally.
  authority_boundary: This node describes product outcomes and does not choose an authorization mechanism,
    account model, credential storage, source error mapping, exact native presentation or the remaining
    cross-account disclosure policies beyond the selected A-to-B rule under 0019. It does not claim source
    access or implementation readiness.
  requirements:
    distinguish: Distinguish a temporary network failure, a connection or credential problem, an explicitly
      confirmed Repository access revocation and an intentional disconnect when supported by evidence.
      A 404 or generic network failure alone does not prove deletion or revocation, and an uncertain cause
      is not presented as confirmed.
    last_known: Keep available previously saved local observations accessible where their applicable disclosure
      is supported, with their supported scope and observation time when known, and make the relevant
      connection limitation discoverable. For confirmed private Repository revocation the owner-selected
      visibility rule below applies. Locally readable data is not itself evidence of a current GitHub
      grant or a successful new refresh.
    revoked: On confirmed GitHub access revocation for a private Repository, retain its saved local data;
      while its account remains active show it with the revocation indication and supported last update
      time when known under 0019. While B is active, the A-to-B visibility boundary applies; stop synchronization
      for that Repository while revocation applies. Do not accept an earlier in-flight response as a fresh
      successful update merely because it arrives later.
    operator_control: Retain a discoverable route to understand the connection problem, pursue recovery
      and intentionally delete local data under 0019, subject to its account-change visibility boundary.
      Recovery does not guarantee the source grants access, and local deletion does not assert deletion
      of GitHub objects.
    disconnect: An intentional local disconnect stops new refresh for the affected connection and does
      not by itself delete saved local information. Handling and disclosure of retained private data after
      disconnect remain separately open under 0019. Indicate an unresolved credential-removal outcome
      when known; do not equate a local disconnect with source deletion or provider-side revocation.
    isolation: Keep observation and operation context attributable to the account and Repository that
      produced it. While account B is active, previously saved private data from account A is not shown
      under 0019; switching accounts does not itself delete A’s data. For external GitHub revocation of
      A’s access while A remains active, saved data remains visible with the selected indication under
      0019. Other account isolation and disclosure details remain open.
    accessibility: Make the applicable connection limitation and available recovery or local action discoverable
      without relying only on color or a transient notice.
  scenarios:
    offline: A Repository has saved observations and a refresh fails because the network is unavailable.
      Show eligible available last-known information with its supported time when known and an applicable
      failure; do not assert a new source denial or empty Repository.
    revoked: GitHub explicitly confirms revocation for a private Repository with saved observations while
      its account remains active. Keep those observations visible with the revoked indication and supported
      time when known; stop synchronization and keep the local recovery or deletion entry point available.
    disconnect: The operator intentionally disconnects an account. Stop new refresh for that connection
      and do not treat disconnect itself as local or source deletion. Retained private-data disclosure
      remains subject to its separately unresolved policy; do not report uncertain credential removal
      as completed.
    unknown_time: Saved local data remains available after revocation while its account remains active,
      but its update time is not reliably known. Do not invent a time or hide the data solely for that
      reason.
  open_questions:
  - Source evidence sufficient to establish Repository revocation and restore access; behavior when evidence
    is unavailable after interruption.
  - Account identity, other cross-account isolation beyond 0019, credential lifecycle and exact disconnect
    recovery flow.
  - Native presentation and supported recovery controls for each connection state.
  ontology_status: Repository and User use selected ontology vocabulary; connection and observation states
    are product behavior rather than newly asserted domain entities.
acceptance:
- A temporary failure is not presented as a confirmed Repository deletion, revocation, empty result or
  successful refresh without supporting evidence.
- Available previously saved observations remain accessible where their applicable disclosure is supported,
  with time when known and a discoverable connection limitation; confirmed private Repository revocation
  follows the selected visibility rule. Local visibility does not establish live GitHub access.
- Confirmed private Repository revocation preserves saved local data and stops synchronization; while
  its account remains active, show its indication and supported time when known and retain access both
  to recovery and to explicit local deletion under 0019.
- An intentional disconnect stops new refresh without silently deleting saved local information or claiming
  that GitHub objects were deleted.
- Connection problems and applicable recovery paths are available without relying solely on color or transient
  feedback.

```

## GITVIEW-SPEC-0037: GitView - Overview refresh and access changes

Источник `specs/nodes/GITVIEW-SPEC-0037.yaml`, SHA-256 `0dbb816629e9986ee6d2daa762062d4f14f5a57c13664bf24a30fc63c763385e`

```yaml
id: GITVIEW-SPEC-0037
title: GitView - Overview refresh and access changes
kind: spec
created_at: '2026-11-16T08:26:00Z'
updated_at: '2026-11-16T19:55:33Z'
status: specified
refines:
- GITVIEW-SPEC-0026
depends_on:
- GITVIEW-SPEC-0002
- GITVIEW-SPEC-0019
- GITVIEW-SPEC-0036
sources:
  predecessor_draft: docs/drafts/GITVIEW-SPEC-0037.yaml
  predecessor_revision: fef38bd
  visibility_rationale: conversation_memory/sketches/gitview/revisions/ef1c2f72ef08420980a423cd63c6d34a/notes.hc
specification:
  ontology_refs:
  - gitview:Project
  - gitview:Repository
  - gitview:PullRequest
  - gitview:Issue
  objective: Keep the operator oriented when an overview refreshes or access changes while it is open.
  authority_boundary: This node specifies the experience of refresh and access changes. Synchronization
    ordering, API mapping, account isolation and native controls remain technical or product questions
    for later refinement. When GitHub externally revokes access to a private Repository, the retained-data
    visibility and local access described here apply while the relevant account remains active. Independently
    of revocation, while account B is active, the account-switch boundary in 0019 applies. Behavior after
    returning to A is not selected.
  requirements:
    refresh: Request an update of the available overview from GitHub while keeping its Project and Repository
      context. Make the supported update time and any failed or incomplete update discoverable. Preserve
      available last-known data rather than presenting an unsuccessful update as current.
    partial: If only part of a Project refreshes, show available information with its actual scope and
      indicate the limitation; an unavailable part is not presented as an empty repository.
    revocation: When GitHub confirms private Repository access revocation, retain saved data visibly with
      the access-revoked indication and supported last update time when known under 0019; stop synchronization
      for the affected Repository. Provide both recovery and explicit local deletion entry points under
      0019.
    account_change: Do not present one GitHub account's observations as proof of another account's access.
      Other disclosure and recovery after account changes beyond the selected A-to-B rule in 0019 remain
      open.
    cancellation: Do not present an intentionally cancelled update as a successful refresh or automatically
      label the user's cancellation as a failure.
  scenarios:
    partial_refresh: One Repository updates while another cannot be refreshed. Keep the available overview
      and make the partial result understandable.
    revoked_during_refresh: The relevant account remains active throughout this scenario. GitHub confirms
      private Repository revocation while the overview is open. Saved information remains visible as last
      known with its indication and supported time when known; synchronization stops and the operator
      can reach both recovery and explicit local deletion under 0019.
  open_questions:
  - Source coverage, other account-change disclosure beyond 0019, recovery and exact native presentation.
  - Synchronization ordering, in-flight updates and source comparison belong to later technical refinement.
  ontology_status: Repository, Project, PullRequest and Issue use selected ontology vocabulary; refresh
    is a user operation, not a new domain entity.
acceptance:
- The overview retains its Project and Repository context and shows supported update information.
- Failure or partial refresh does not silently erase saved information or present unavailable work as
  empty.
- Confirmed private Repository revocation keeps saved data visible with its indication and supported time
  when known, stops synchronization and retains access to both recovery and explicit local deletion under
  0019. Visibility and local access follow the active-account and A-to-B boundary in 0019.
- Observations are not attributed as proof of a different account's GitHub access.

```

## GITVIEW-SPEC-0038: GitView - Repository identity under incomplete observations

Источник `specs/nodes/GITVIEW-SPEC-0038.yaml`, SHA-256 `b5a41a0e188b9e5071c498e4f68ea0632d308484ed18edbc6a0f80ba8ed1c937`

```yaml
id: GITVIEW-SPEC-0038
title: GitView - Repository identity under incomplete observations
kind: spec
created_at: '2026-11-16T08:27:00Z'
updated_at: '2026-11-16T19:42:49Z'
status: specified
refines:
- GITVIEW-SPEC-0002
depends_on:
- GITVIEW-SPEC-0005
- GITVIEW-SPEC-0019
- GITVIEW-SPEC-0037
sources:
  predecessor_draft: docs/drafts/GITVIEW-SPEC-0038.yaml
  predecessor_revision: 9c598dd
  owner_decision: ontology/review/repository-identity.md
  owner_source_identity_decision: conversation:gitview/excerpt-60-reply
  ontology_owner_acceptance: ontology/review/owner-acceptance-20261116.md
  identity_evidence_review: ontology/review/repository-identity-ontology-tension-20261116.md
specification:
  ontology_refs:
  - gitview:GitHub
  - gitview:GitHubRepository
  - gitview:Repository
  - gitview:Project
  - gitview:projectIncludesRepository
  objective: Preserve Repository identity, history and Project memberships without guessing when source
    observations are incomplete.
  authority_boundary: The owner selected continuity for a source-confirmed same object and accepted numeric
    ID examples; the later owner-approved GitView ontology 0.2.0 selects the numeric REST repository ID
    as a same-instance comparison key. This is not evidence that a particular transfer, source response,
    integration or storage implementation was observed. Source coverage, identifier availability and cross-instance
    identity remain separately constrained.
  requirements:
    selected_identity: 'Under the owner-approved ontology policy and 0002, compare confirmed numeric REST
      repository IDs within one GitHub instance: the same ID identifies the same Repository and a different
      ID a different Repository. The earlier numeric examples and later ontology approval are distinct
      decision evidence. An ID match does not by itself prove a transfer or current source access.'
    attributes: Repository owner, name and address are observed attributes, not identity by themselves.
      When sufficiently supported evidence establishes a current changed address for the same Repository,
      retain its identity, history and all Project memberships.
    incomplete: An observation missing the identity evidence needed to apply the selected rule does not
      by itself merge records, transfer memberships, establish deletion or prove a new Repository. Preserve
      the supported prior context and identify the unresolved state rather than guessing from name or
      address.
    address_reuse: If supported source evidence establishes that an old address now identifies a different
      Repository, do not transfer the earlier Repository's history or Project memberships to the new identity
      merely because of that address.
    unavailable: A 404, failed request or incomplete discovery alone does not establish deletion or access
      revocation. Keep supported last-known identity and membership information; confirmed private Repository
      revocation alone does not hide already saved local information; visibility follows the active-account
      boundary under 0019.
    continuity_limit: Retaining existing history does not imply that GitView has a complete source history
      or can reconstruct information it never observed.
  scenarios:
    numeric_examples: On the same GitHub, supported id 42 continues to identify the prior Repository after
      an address change; a different id 99 at the old address identifies a different Repository and does
      not inherit the prior history or memberships.
    rename_and_transfer: GitHub confirms that a Repository in Projects P and Q is the same object after
      rename and transfer. Retain one Repository, its existing history and both memberships while associating
      a newly supported current address.
    reused_address: A previously used address is confirmed to identify a different Repository in the same
      source instance. Do not assign the earlier Repository's history or memberships to that different
      identity.
    missing_id: A new observation has a familiar name but lacks sufficient identity evidence. Keep the
      possible association unresolved; do not silently merge records or move memberships.
  open_questions:
  - Availability and reliability of identity evidence for each selected source operation, including transfer
    observations and identifier representation changes.
  - Cross-instance identity, address and alias retention, and exact reconciliation presentation.
  - Source deletion and access recovery rules beyond the selected 404 and revocation behavior.
  ontology_status: Repository, GitHubRepository and Project use selected ontology vocabulary; identity
    continuity alone does not establish an actor action, motive or uninterrupted management interval.
acceptance:
- Source-confirmed same Repository identity across rename or transfer preserves existing history and Project
  memberships.
- A changed or reused address alone does not merge identities or transfer an earlier Repository's history
  and memberships.
- Insufficient evidence remains uncertain and does not itself prove deletion or a current address.
- A 404 or incomplete discovery alone is not treated as confirmed deletion or revocation.
- Confirmed private Repository revocation alone does not hide already saved local information; visibility
  follows the active-account boundary under 0019.
- Same-instance numeric REST repository ID comparison follows the selected ontology policy without inferring
  an unobserved transfer or current access.

```

## GITVIEW-SPEC-0039: GitView - Issue state, links and discussion counters

Источник `specs/nodes/GITVIEW-SPEC-0039.yaml`, SHA-256 `7ca8e989fee361944bed0cccdc512148bce5669c0c7cce62f35fea43746e181a`

```yaml
id: GITVIEW-SPEC-0039
title: GitView - Issue state, links and discussion counters
kind: spec
created_at: '2026-11-16T08:32:00Z'
updated_at: '2026-11-16T19:59:36Z'
status: specified
refines:
- GITVIEW-SPEC-0009
depends_on:
- GITVIEW-SPEC-0002
- GITVIEW-SPEC-0010
- GITVIEW-SPEC-0019
- GITVIEW-SPEC-0026
- GITVIEW-SPEC-0033
- GITVIEW-SPEC-0034
sources:
  predecessor_draft: docs/drafts/GITVIEW-SPEC-0039.yaml
  predecessor_revision: 9c598dd
  owner_selection: docs/drafts/issue-ontology-options.md
specification:
  ontology_refs:
  - gitview:Issue
  - gitview:Repository
  - gitview:PullRequest
  - gitview:issueRepository
  - gitview:issueClosingPullRequest
  - gitview:issueMentionedPullRequest
  - gitview:issueParent
  - gitview:issueSubIssue
  - gitview:issueBlockedBy
  - gitview:issueBlocks
  objective: Make the selected Issue facts and relationships inspectable without conflating source state,
    discussion and inferred intent.
  authority_boundary: The owner selected the Issue field categories and a compact source-linked overview.
    Exact source mappings, field priority, native presentation and data availability remain to be verified;
    this node does not establish implementation readiness or an actor's motive. When GitHub externally
    revokes access to a private Repository, the retained-data visibility and local access described here
    apply while the relevant account remains active. Independently of revocation, while account B is active,
    the account-switch boundary in 0019 applies. Behavior after returning to A is not selected.
  requirements:
    identity: Keep the selected Issue associated with its supported source identity, Repository context
      and repository-local number. Same-number Issues in different Repositories remain distinct. Present
      available title, original description and source link without inventing missing values.
    state: Distinguish the source open or closed state, supported closure reason, labels and Issue type.
      A closed Issue is not automatically completed; an unavailable reason remains unknown. A GitView
      Project is not a GitHub Projects status.
    roles: Present supported author, assignees and milestone as source context. An assignee does not by
      itself establish that work began; author or assignee does not automatically identify the GitView
      operator or the actor behind a change.
    relationships: Preserve supported meanings and direction of linked PRs, mentions, closing references,
      parent and direct sub-Issues, blocked-by and blocking relationships. A mention is not automatically
      a closing reference; a relationship alone does not prove completion, an actor's motive or causal
      history. Incomplete relationship coverage is not a confirmed absence.
    dual_link: If the same source-confirmed PR has both a mention and a closing-reference meaning, identify
      it once in its Repository context while retaining both supported meanings.
    source_representation: A source-confirmed PR represented in an Issue collection is not presented or
      counted as an independent Issue even if its correspondence to a separately observed PR remains unresolved.
      Where source evidence identifies both representations as the same PR, do not double count it. If
      type or identity correspondence is insufficiently supported, preserve uncertainty rather than guessing
      from IDs. A genuinely separate Issue linked to a PR remains distinct.
    discussion: Show supported comment and discussion-participant counts as distinct units and distinguish
      a known zero from unavailable or partial data. Issue comments are not PR review threads; individual
      comments and participant lists are not required by this overview. Exact source mapping for the selected
      participant meaning remains open.
    direct_children: Show supported counts of total and closed direct sub-Issues separately. Do not treat
      those counts as all transitive descendants or as a percentage of completed work; a closed child
      may have an unknown or non-completion reason.
    times: Distinguish supported source creation, update, closure and last-comment times from the time
      GitView observed them, retaining the observation source when supported. A fresh observation of one
      field does not automatically refresh another.
    inspection: Make the selected available Issue facts and relationships inspectable in the Issue overview
      without requiring every field to fit in a grid cell or preview. Where an excerpt is presented, retain
      access to the available original authored body under 0034; source opening and sharing follow 0033.
    saved_data: After confirmed GitHub revocation of a private Repository, keep previously saved supported
      Issue information locally accessible under 0019 with the indication and supported update time when
      known; do not present it as a newly refreshed result or a source grant.
  scenarios:
    closure_reason: An Issue is closed with an unknown or non-completion reason. Present the supported
      state and reason without automatically calling it completed.
    link_meanings: One PR is both mentioned and identified by a supported closing reference. Show one
      source-confirmed target while preserving both meanings; do not infer that it merged or motivated
      a particular actor.
    directed_dependencies: An Issue is blocked by A and blocks B. Preserve the supported direction and
      any incomplete relationship coverage rather than reversing or assuming missing links.
    partial_counts: One supported comment count is known, while participant coverage is unavailable. Present
      the known count with its context and the other as unknown, not zero.
  open_questions:
  - Source evidence and mapping for Issue types, closure reasons, selected participant counts, direct
    sub-Issues and relationship directions.
  - Exact field priority, truncation, native presentation and behavior of partial or unavailable source
    facts.
  - Source and access handling for linked objects outside the originating Project and historical event
    coverage.
  ontology_status: Issue, PullRequest and Repository use selected ontology vocabulary; source links and
    author text do not establish actor motives or additional domain entities.
acceptance:
- The selected Issue retains its supported identity and Repository context; state, closure reason, type
  and labels are not silently conflated.
- Supported closing references, mentions, hierarchy and dependency directions remain distinguishable,
  and links do not prove an actor's motive or completion.
- Comment, discussion-participant and direct-sub-Issue counts retain distinct units; unknown or partial
  values are not presented as zero or completion percentage.
- Selected available Issue fields and relationships are inspectable without requiring them all to fit
  in the cell or preview.
- Previously saved supported Issue information remains locally accessible after confirmed private Repository
  revocation under 0019 with the applicable limitation. Visibility and local access follow the active-account
  and A-to-B boundary in 0019.

```

## GITVIEW-SPEC-0040: GitView - Testable behavior and injected dependencies

Источник `specs/nodes/GITVIEW-SPEC-0040.yaml`, SHA-256 `9b4085786ef6c4ebdf0a2a7776e3d021c2b2efba06abaf567e2238812797982b`

```yaml
id: GITVIEW-SPEC-0040
title: GitView - Testable behavior and injected dependencies
kind: spec
created_at: '2026-11-16T08:57:00Z'
updated_at: '2026-11-16T20:02:31Z'
status: specified
refines:
- GITVIEW-SPEC-0021
depends_on:
- GITVIEW-SPEC-0007
- GITVIEW-SPEC-0026
- GITVIEW-SPEC-0036
sources:
  predecessor_draft: docs/drafts/GITVIEW-SPEC-0040.yaml
  owner_requirements: conversation:gitview/excerpt-74
specification:
  ontology_refs:
  - gitview:PullRequest
  objective: Make product behavior independently testable while preserving evidence of real integration.
  authority_boundary: The owner requested testability, DI, TDD and network and data mocks. Boundary placement,
    representative scenarios and the distinction between kinds of evidence are refinements, not evidence
    of implementation. Exact frameworks, wiring and verification infrastructure remain open.
  requirements:
    replaceable_dependencies: Supply network and persistence dependencies at replaceable boundaries; control
      time, scheduling and other nondeterministic inputs where they affect the scenario. This does not
      require a DI framework or a protocol for every value.
    isolated_decisions: Exercise suitable named domain decisions with supplied facts, source evidence
      and time without a live GitHub request or mutation of personal data. Evaluation itself does not
      read the network or persistence, or perform UI actions. Preserve unknown as distinct from confirmed
      positive and negative results where the product contract requires it, under 0021.
    doubles: Use scenario-appropriate network and data fakes, stubs or mocks for reproducible success,
      partial results, failures and relevant ordering. Verify interactions where they are part of behavior;
      a single kind of double is not mandatory for every test.
    tdd: For a behavioral change, first express the intended observable behavior in a failing automated
      test, implement the minimum to pass, then refactor while retaining passing tests. A behavioral failure
      is distinct from an unavailable environment or compiler error. Tests should verify meaningful outcomes
      rather than reproduce every private helper.
    integration_evidence: Isolated tests establish only behavior under their supplied conditions. Verify
      real adapter, source, system and native interaction boundaries separately when their contracts need
      such evidence; do not present an unperformed integration or device check as passed.
    test_data: Test fixtures and logs exclude credentials and unapproved private source content. Isolated
      tests do not change the user's actual GitHub state.
    evidence: Identify the tested specification, scenario, conditions and observed result; distinguish
      proposed tests from executed tests and behavioral failures from environment failures. A separate
      draft 0079 proposes further TDD review detail but is not established by this node.
  scenarios:
    offline_refresh: Given a saved PR observation and known successful time, a deterministic network failure
      leaves the supported saved observation and time visible with a scoped failure, without a live GitHub
      request, when no independent observation or access change occurs.
    uncertainty: A named filter decision with unavailable CI input and no independently false condition
      retains uncertainty rather than inventing a confirmed match or non-match.
    integration: Passing network-double tests without a real adapter check does not prove GitHub compatibility.
  open_questions:
  - Concrete Swift test tools, dependency composition and continuous-integration topology.
  - Appropriate real integration and device evidence for each implemented behavior.
  - Any further TDD trace format and retention, including the separate 0079 proposal.
  ontology_status: The selected local ontology is owner-approved; test boundaries do not add domain entities.
acceptance:
- Relevant external effects are replaceable for deterministic behavior tests without live GitHub or personal
  data mutation.
- TDD starts with a behavioral failure, implements the minimum to pass, and refactors with tests passing;
  an environment failure is not substituted for the initial behavioral failure.
- Appropriate doubles exercise supported failure and uncertainty without claiming real integration works.
- Verification reports distinguish performed observations from proposed or unperformed checks.

```

## GITVIEW-SPEC-0041: GitView - PR overview facts and change counters

Источник `specs/nodes/GITVIEW-SPEC-0041.yaml`, SHA-256 `75375c103e594f480a1345db83768583060b48835d86569e605dc4d45ca0fdb4`

```yaml
id: GITVIEW-SPEC-0041
title: GitView - PR overview facts and change counters
kind: spec
created_at: '2026-11-16T08:33:00Z'
updated_at: '2026-11-16T19:45:25Z'
status: specified
refines:
- GITVIEW-SPEC-0008
depends_on:
- GITVIEW-SPEC-0002
- GITVIEW-SPEC-0010
- GITVIEW-SPEC-0019
- GITVIEW-SPEC-0026
- GITVIEW-SPEC-0028
- GITVIEW-SPEC-0033
- GITVIEW-SPEC-0034
sources:
  predecessor_draft: docs/drafts/GITVIEW-SPEC-0041.yaml
  predecessor_revision: 9c598dd
  owner_selection: docs/drafts/pull-request-ontology-options.md
specification:
  ontology_refs:
  - gitview:issueClosingPullRequest
  - gitview:issueMentionedPullRequest
  - gitview:PullRequest
  - gitview:Issue
  - gitview:Repository
  - gitview:ReviewThread
  - gitview:CIStatus
  - gitview:pullRequestRepository
  - gitview:pullRequestIssueLink
  objective: Make the selected PR's compact facts, change counters and independent signals inspectable
    in the correct source context.
  authority_boundary: The owner selected the field categories and compact source-linked overview. Exact
    source mapping, check equivalence, field priority, native presentation and data availability require
    refinement; this node does not establish implementation readiness, complete source coverage or an
    actor's motive. When GitHub externally revokes access to a private Repository, the retained-data visibility
    and local access described here apply while the relevant account remains active. Independently of
    revocation, while account B is active, the account-switch boundary in 0019 applies. Behavior after
    returning to A is not selected.
  requirements:
    identity: Retain the selected PR's supported source identity, Repository context and repository-local
      number. Present available title, original description and source link without replacing missing
      values or selecting another same-number PR in a different Repository.
    state: Distinguish open, closed without merge and merged from the separately supported draft flag,
      labels, review assessment and CI. An unavailable lifecycle or signal remains unknown rather than
      being inferred from another field.
    context: Present supported source and target branches, the PR-associated Repository, separately supported
      base or target and head or source Repositories, observed revision, author, requested reviewers and
      related Issues in their actual source contexts. An unavailable base or head Repository is not automatically
      replaced with the PR-associated Repository. Preserve supported mention and closing-reference meanings
      independently; a related Issue alone does not prove an actor motive or causal history.
    changes: Present supported additions and deletions separately, changed-file count and commit count
      with their applicable observation context. Unavailable counts are not zero; these counts do not
      require a diff, file browser or commit-by-commit view inside GitView.
    checks_and_review: Present current check counters under 0028 and independently supported review assessment,
      requested-review information and total and unresolved review-thread counts. Incomplete or stale
      observations retain their limitations; individual run or review-thread content is not required by
      this overview.
    revision: Attribute values to their supported source revision, scope, observation time and observation
      source when known. Distinguish supported PR creation, update, closure and merge times from the time
      GitView observed them; unavailable values are not invented. A newly observed title, branch or revision
      does not automatically refresh omitted review, CI, thread or change-count facts; an earlier value
      is not silently represented as current for a newer revision.
    authored_text: Preserve available original authored text and reliably supported sections under 0034.
      An authored validation statement is distinct from independently observed CI and test evidence.
    inspection: Make the selected available PR facts and their limitations inspectable in the PR overview
      without requiring all fields to fit simultaneously in a cell or preview. The source route and lightweight
      sharing follow 0033.
    saved_data: After confirmed GitHub revocation of a private Repository, previously saved supported
      PR information remains locally accessible under 0019 with the revocation indication and supported
      update time when known; it is not thereby newly current or evidence of restored source access.
  scenarios:
    same_number: Repositories A and B each have PR 42. Opening B’s PR retains its own Repository context,
      supported facts and source link rather than substituting A’s PR.
    independent_signals: An open draft PR has a failed check and unavailable review assessment. Present
      those supported facts independently; unavailable review is not approval.
    partial_refresh: A new observation provides the PR title but no usable CI or review fact. Do not advance
      the observation time of those omitted facts or announce them as current merely because the title
      changed.
    saved_after_revocation: The relevant account remains active throughout this scenario. GitHub confirms
      private Repository revocation while saved PR data exists locally. Keep those supported details available
      with their indication and time when known; do not claim a new source grant.
  open_questions:
  - Source evidence and mapping for PR counts, branches, revisions, requested reviewers and related Issues.
  - Exact field priority, truncation, native presentation and behavior of partial or stale observations.
  - Current-check identity, retries, special conclusions and source permissions needed by selected operations.
  ontology_status: PullRequest, Issue and Repository use selected ontology vocabulary; observed links
    and authored text do not establish an actor's motive or a new domain entity.
acceptance:
- The selected PR retains its supported identity, PR-associated Repository and separately supported base
  or head Repository context, including when another Repository contains a same-number PR.
- Lifecycle, draft status, review assessment, requested review, check counts, thread counts and change
  counts remain independently interpretable and unknowns are not presented as zero or approval.
- Selected available facts, source event times, observation context and limitations are inspectable without
  requiring every field to fit in a grid cell or preview; unavailable values are not invented.
- Supported additions, deletions, changed-file count and commit count do not require in-app diff, file,
  commit or run details.
- Previously saved supported PR information remains locally accessible after confirmed private Repository
  revocation under 0019 with its applicable limitation. Visibility and local access follow the active-account
  and A-to-B boundary in 0019.

```

## GITVIEW-SPEC-0042: GitView - Uncertain work selection presentation

Источник `specs/nodes/GITVIEW-SPEC-0042.yaml`, SHA-256 `b9bd5b0a05e3e401389491ee29b01f5868e5b793294e6a57c63906fb6c048700`

```yaml
id: GITVIEW-SPEC-0042
title: GitView - Uncertain work selection presentation
kind: spec
created_at: '2026-11-16T07:18:00Z'
updated_at: '2026-11-16T19:57:34Z'
status: specified
refines:
- GITVIEW-SPEC-0027
depends_on:
- GITVIEW-SPEC-0019
- GITVIEW-SPEC-0023
- GITVIEW-SPEC-0024
- GITVIEW-SPEC-0032
sources:
  predecessor_draft: docs/drafts/GITVIEW-SPEC-0042.yaml
  predecessor_revision: 33fb739
  root_intent: .specgraph/root_intent.md
specification:
  ontology_refs:
  - gitview:Issue
  - gitview:PullRequest
  - gitview:Repository
  - gitview:Project
  objective: Make incomplete work selection understandable while preserving the operator's context and
    access to already observed work.
  authority_boundary: This node specifies product-visible outcomes. It does not select a separate uncertainty
    section, ordering algorithm, exact label or native component, and does not establish implementation
    readiness. When GitHub externally revokes access to a private Repository, the retained-data visibility
    and local access described here apply while the relevant account remains active. Independently of
    revocation, while account B is active, the account-switch boundary in 0019 applies. Behavior after
    returning to A is not selected.
  requirements:
    distinction: Distinguish a confirmed match from an available identified object whose applicable selection
      condition remains uncertain, whether its observation is already durably saved or only available
      from a current partial response. Do not imply persistence without evidence. Unknown source information
      is not presented as a confirmed match, non-match, deletion, empty collection or successful current
      result.
    inspect: Provide a way to inspect an available identified uncertain object and the relevant limitation
      without inventing an unobserved object or an exact missing count. The treatment preserves actual
      Project and Repository scope, explicit filters and object identity.
    coverage: Make incomplete or unobserved collection coverage and the applicable supported observation
      time when known discoverable even when no individual uncertain object is known. Do not invent an
      unknown time. A transient message alone is not the only route to that information; exact presentation
      remains open.
    focus: Updates, grouping or ordering changes must not silently substitute another object for one being
      inspected. Preserve valid focus or an appropriate meaningful fallback under 0024 and 0032.
    revoked_private: Confirmed GitHub revocation alone does not hide an already saved local object under
      0019. Keep its revocation indication and supported time when known accessible, stop synchronization
      for the affected Repository and do not claim current source access.
    accessibility: Selection uncertainty, coverage and available inspection or recovery actions are understandable
      without reliance on color alone or a specific gesture.
  scenarios:
    uncertain_filter: A saved PR has an unknown value for an active required filter. Keep it distinguishable
      from a confirmed match or exclusion and provide an available inspection path without clearing the
      filter.
    no_individual_candidate: A source observation is incomplete but no additional object is identified.
      Make incomplete coverage discoverable without fabricating a cell or count.
    revocation_while_inspecting: The relevant account remains active throughout this scenario. A saved
      private PR is being inspected when GitHub revocation is confirmed. Keep available local details
      and their identity accessible with the revocation indication and supported time when known; a later
      response does not establish a fresh successful update.
  open_questions:
  - Exact native treatment and ordering for individually uncertain objects, including behavior at different
    grid densities.
  - Scope and persistence of collection status and focus fallback during concurrent changes.
  - Source evidence required for coverage and exact refresh controls.
  ontology_status: PullRequest, Repository and Project use selected ontology vocabulary; uncertainty and
    presentation are interaction and specification concepts.
acceptance:
- A supported confirmed match is distinguishable from an identified object whose applicable selection
  condition is unknown.
- An available uncertain object remains inspectable without inventing unobserved objects, exact missing
  counts or a confirmed empty collection.
- Incomplete coverage and supported observation time when known are discoverable even if no individual
  missing object is identified; an unknown time is not invented.
- Updates and reordering do not silently retarget inspection to a different object.
- Saved local private content remains accessible after confirmed GitHub revocation with its indication
  and supported time when known under 0019. Visibility and local access follow the active-account and
  A-to-B boundary in 0019.
- Uncertainty, coverage and applicable actions are understandable without relying solely on color or a
  specific gesture.

```

## GITVIEW-SPEC-0044: GitView - Understand freshness and incomplete overview

Источник `specs/nodes/GITVIEW-SPEC-0044.yaml`, SHA-256 `935a1e18bb0896c12796703d6e68e74602dcfefde4c710a220fd7d0abcd1d1fe`

```yaml
id: GITVIEW-SPEC-0044
title: GitView - Understand freshness and incomplete overview
kind: spec
created_at: '2026-11-16T08:36:00Z'
updated_at: '2026-11-16T19:57:34Z'
status: specified
refines:
- GITVIEW-SPEC-0026
depends_on:
- GITVIEW-SPEC-0012
- GITVIEW-SPEC-0019
- GITVIEW-SPEC-0023
- GITVIEW-SPEC-0029
- GITVIEW-SPEC-0036
- GITVIEW-SPEC-0037
sources:
  predecessor_draft: docs/drafts/GITVIEW-SPEC-0044.yaml
  predecessor_revision: 33fb739
  root_intent: .specgraph/root_intent.md
specification:
  ontology_refs:
  - gitview:Project
  - gitview:Repository
  - gitview:PullRequest
  - gitview:Issue
  objective: Help the operator understand whether the available Project overview is current and complete
    enough to use.
  authority_boundary: This node describes the visible meaning of freshness, missing information and counts.
    Exact native presentation, source acquisition, storage and synchronization design remain open. When
    GitHub externally revokes access to a private Repository, the retained-data visibility and local access
    described here apply while the relevant account remains active. Independently of revocation, while
    account B is active, the account-switch boundary in 0019 applies. Behavior after returning to A is
    not selected.
  requirements:
    freshness: Show available information with its supported update time when known. When an update fails,
      retain saved data and make the failure discoverable; do not present the failed attempt as a successful
      update.
    partial: When only part of a Project can be updated, keep available results and indicate the relevant
      limitation. A successful update for one Repository or category does not make all other information
      current or complete.
    empty: Distinguish confirmed empty work or a supported zero from information that has not been obtained
      or could not be updated. Do not invent an update time or missing objects.
    counts_and_cards: Make the meaning and applicable scope of supported counts and visible work understandable.
      A count and the number of visible cards can differ because their scope, filters, time or coverage
      differ; do not invent cards or imply the visible list is complete when it is not known to be. A
      count alone, even when equal to the number of visible cards, does not establish that every matching
      object is shown.
    private_access: After GitHub confirms access revocation for a private Repository, keep saved data
      visible as last known with the revocation indication and supported update time when known; stop
      synchronization and retain discoverable routes to both recovery and explicit local deletion under
      0019.
    accessibility: Make update status, relevant limitations and available actions understandable without
      relying on color or transient feedback alone.
    selected_context: When the operator changes Project, day or filters, show results in their actual
      selected context; an earlier result does not silently replace the newly selected view.
  scenarios:
    failed_first_update: No previous PR data is available and the first update fails. Show that work could
      not be loaded rather than claiming that there are no PRs.
    partial_project: A Project contains two Repositories but only one updates. Show the available information
      and indicate that the Project overview is incomplete.
    count_and_cards: A supported count and the visible cards differ because a saved filter applies or
      work is not fully loaded. Preserve their meaning and make the applicable limitation or filter discoverable
      rather than inventing missing cards.
    revoked_private: The relevant account remains active throughout this scenario. GitHub confirms private
      Repository access revocation while saved work exists. Keep that work accessible with the revocation
      indication and supported time when known; stop synchronization and preserve both recovery and local
      deletion under 0019.
  open_questions:
  - How native UI presents freshness, partial coverage and recovery without overwhelming the overview.
  - Source coverage and technical approach to synchronization, ordering, persistence and account isolation.
  ontology_status: Project, Repository, PullRequest and Issue use selected ontology vocabulary; freshness
    and coverage describe the overview, not new domain entities.
acceptance:
- Available saved information remains visible after an unsuccessful refresh with a discoverable failure
  and supported update time when known.
- Incomplete or unavailable information is distinguishable from a confirmed empty result or zero.
- Displayed counts and visible cards retain their actual meaning, applicable scope and relevant limitations.
- Confirmed private Repository revocation preserves saved data and its indication, stops synchronization
  and retains both recovery and explicit local deletion under 0019. Visibility and local access follow
  the active-account and A-to-B boundary in 0019.
- Status, limitations and available actions are understandable without relying solely on color or transient
  feedback.

```

## GITVIEW-SPEC-0045: GitView - Repository selection and setup outcomes

Источник `specs/nodes/GITVIEW-SPEC-0045.yaml`, SHA-256 `9557f2f67fa930f68bafd9d980fb018047475a5bb4475b50f13b76672a1934e3`

```yaml
id: GITVIEW-SPEC-0045
title: GitView - Repository selection and setup outcomes
kind: spec
created_at: '2026-11-16T08:41:00Z'
updated_at: '2026-11-16T19:51:27Z'
status: specified
refines:
- GITVIEW-SPEC-0022
depends_on:
- GITVIEW-SPEC-0002
- GITVIEW-SPEC-0005
- GITVIEW-SPEC-0019
- GITVIEW-SPEC-0023
- GITVIEW-SPEC-0025
- GITVIEW-SPEC-0036
- GITVIEW-SPEC-0038
sources:
  predecessor_draft: docs/drafts/GITVIEW-SPEC-0045.yaml
  predecessor_revision: 9c598dd
  default_mechanism_review: docs/drafts/project-default-association-review-20261115.md
specification:
  ontology_refs:
  - gitview:User
  - gitview:Project
  - gitview:Repository
  - gitview:GitHub
  - gitview:GitHubRepository
  - gitview:projectIncludesRepository
  objective: Keep Repository selection and the outcome of creating or reusing Project configuration understandable
    when source or save evidence is incomplete.
  authority_boundary: The owner selected one Project per Repository as the default and allowed a Project
    to contain multiple Repositories and a Repository to belong to multiple Projects. Explicit-confirmation
    batch setup, persistent default association and detailed reuse behavior are agent-authored candidates
    rather than selected mechanisms. This node does not require multi-selection or choose exact native
    setup controls, transaction architecture or implementation readiness. When GitHub externally revokes
    access to a private Repository, the retained-data visibility and local access described here apply
    while the relevant account remains active. Independently of revocation, while account B is active,
    the account-switch boundary in 0019 applies. Behavior after returning to A is not selected.
  requirements:
    pending: A selection or intended setup is distinct from a successfully saved Project and does not
      by itself establish source access or observed PR and Issue work. An empty selection does not become
      a confirmed saved Project with no members.
    identity: Interpret a selected entry using supported Repository identity under 0002 and 0038. Equal
      names or positions alone do not prove two Repositories identical; an unresolved identity remains
      unresolved instead of silently being matched to another Project.
    default: Support a default of one Project per eligible Repository under 0005 and 0022; this does not
      limit the later composition of a Project. If a multi-Repository default selection is supported,
      its default is a separate Project for each Repository rather than one silently combined Project;
      this does not require multi-selection. How an existing default is recognized, offered or reused
      when the Repository appears in several Projects remains open; do not silently treat an arbitrary
      containing Project as the selected default.
    outcome: Distinguish a supported successful local save from confirmed non-application, pending work
      and an indeterminate outcome. When multiple setup effects are supported, keep their actual outcomes
      and Repository identities attributable rather than claiming all succeeded or treating one result
      as another.
    uncertainty: An uncertain save does not prove that no Project was created or that retry is safe. Reconcile
      against available evidence before repeating a potentially duplicating effect; when the necessary
      evidence is unavailable, keep the outcome uncertain and offer an applicable recovery path without
      promising recovery.
    cancellation: Cancellation or failure does not by itself erase previously saved Projects or establish
      successful source authorization. An unsubmitted selection cancelled by the operator is not subsequently
      submitted as an effect of that cancelled attempt. Already submitted or independently completed effects
      retain their supported outcomes and are not claimed undone merely by cancellation.
    discovery: A partial or failed Repository discovery remains incomplete or failed rather than a confirmed
      empty source. Keep available supported choices distinguishable from a complete inventory and offer
      an applicable retry where available.
    access: Confirmed GitHub revocation alone does not hide previously saved local Projects or Repository
      information under 0019, but local visibility is not a source grant or sufficient evidence to admit
      a new Project operation.
    accessibility: Provide a way to understand available selection, incomplete discovery and supported
      save or recovery outcomes without relying solely on color or a transient notification. Exact controls
      and grouping remain open.
  scenarios:
    selected_not_saved: The operator selects a Repository but no Project save is supported yet. Do not
      announce a saved Project or a loaded PR and Issue collection merely from selection.
    partial_outcome: A setup path has one confirmed saved Project and another outcome remains indeterminate.
      Keep the confirmed Project available and the other outcome uncertain; do not silently repeat a potentially
      duplicating effect or claim that cancellation undid the confirmed save.
    unresolved_identity: A source entry has a familiar name but insufficient identity evidence. Do not
      attach it to an existing Project merely from that name; preserve the unresolved state.
    shared_membership: One Repository already belongs to two Projects. Its presence in either Project
      alone does not establish which one is a default association.
  open_questions:
  - Setup and confirmation interaction, whether multi-selection is supported, and default-association
    or alternative reuse design.
  - Evidence and recovery for a submitted operation whose outcome cannot be confirmed.
  - Native feedback and accessibility details for partial discovery, cancellation and per-effect outcomes.
  ontology_status: Project, Repository and User use selected ontology vocabulary; a selection or saved
    membership does not itself prove an actor's motive or a particular ontology action.
acceptance:
- Repository selection is distinguishable from a successfully saved Project and from a loaded work collection.
- The default of one Project per Repository remains distinct from the unselected persistent-association
  mechanism.
- Confirmed saved, failed or indeterminate setup effects are not silently conflated; an uncertain effect
  is not blindly duplicated.
- Partial source discovery is not reported as a confirmed empty inventory, and cancellation or failure
  does not erase already saved Projects.
- Saved local Project and Repository information remains accessible after confirmed GitHub revocation
  under 0019, without implying a source grant for a new operation. Visibility and local access follow
  the active-account and A-to-B boundary in 0019.

```

## GITVIEW-SPEC-0046: GitView - Aggregate counts with incomplete observations

Источник `specs/nodes/GITVIEW-SPEC-0046.yaml`, SHA-256 `e1f23ae221b9e2e1e7a02d56c71b2d242e3eaa654be0ea0797489bb83ab71857`

```yaml
id: GITVIEW-SPEC-0046
title: GitView - Aggregate counts with incomplete observations
kind: spec
created_at: '2026-11-16T11:10:00Z'
updated_at: '2026-11-16T20:05:42Z'
status: specified
refines:
- GITVIEW-SPEC-0029
depends_on:
- GITVIEW-SPEC-0019
- GITVIEW-SPEC-0023
- GITVIEW-SPEC-0025
- GITVIEW-SPEC-0026
- GITVIEW-SPEC-0030
- GITVIEW-SPEC-0036
- GITVIEW-SPEC-0044
sources:
  predecessor_draft: docs/drafts/GITVIEW-SPEC-0046.yaml
  revoked_private_visibility: specs/nodes/GITVIEW-SPEC-0019.yaml
specification:
  ontology_refs:
  - gitview:pullRequestRepository
  - gitview:issueRepository
  - gitview:Project
  - gitview:Repository
  - gitview:PullRequest
  - gitview:Issue
  - gitview:Metric
  - gitview:projectIncludesRepository
  objective: Preserve the meaning and limits of counts derived from observations with differing coverage,
    time or Project membership.
  authority_boundary: Project summaries, current membership for historical Project graphs and retained
    local data after confirmed revocation are selected. Detailed evidence and calculation rules are refinements;
    exact source mappings, representation and other account disclosure cases remain open. When GitHub
    externally revokes access to a private Repository, the retained-data visibility and local access described
    here apply while the relevant account remains active. Independently of revocation, while account B
    is active, the account-switch boundary in 0019 applies. Behavior after returning to A is not selected.
  requirements:
    context: Attribute a displayed aggregate to its supported metric, unit, object type, source scope,
      membership basis, period where applicable, relevant observation times and coverage. Different observation
      times do not establish an invented simultaneous snapshot.
    membership: Evaluate a current Project claim against its actual saved membership. A late result for
      a previous member set remains attributable to that set; adding an unobserved member can make the
      new aggregate incomplete, and removal does not imply source deletion. Historical Project graphs
      use the current Project membership under 0030, not a claim of past membership.
    partial: Missing or incomplete input is not zero. A supported partial observation may be shown with
      its scope and coverage, but does not establish a complete current total. Do not blindly add overlapping
      observations or assume uniqueness without identity evidence.
    stale: A previous observation is not proof of the current population. A stale count of open PRs is
      not automatically a current lower bound; the earlier value may remain last known with its own context.
    changes: A partial later observation does not advance an earlier complete count to a new complete
      reference or establish an exact later difference without sufficient compatible evidence.
    attention: A confirmed positive signal on an identified PR may contribute once to an observed subset
      with its actual context, even if coverage is incomplete. Absence of a known positive is not proof
      of a negative when the relevant input is unknown.
    combined_inputs: When a metric combines separately observed lifecycle, CI or review facts, retain
      each fact's supported time and revision. Facts observed at different times do not by themselves
      establish that their combination held simultaneously.
    deduplication: A Repository shared by Projects contributes to each applicable Project; a unique portfolio
      count deduplicates confirmed identities under 0029. Uncertain identity does not silently become
      a confirmed unique count.
    revoked_private: Confirmed private Repository access revocation preserves saved local observations
      and supported derived counts as last known, with revocation indication and supported update time
      when known under 0019; synchronization stops. Do not label the retained data freshly observed, invent
      a time or replace an unavailable input with zero. Other account-change disclosure beyond the selected
      A-to-B rule in 0019 remains open.
    snapshot_and_period: A present snapshot alone does not prove a historical event count or fill a missing
      historical bucket; maintain the actual period and coverage under 0030.
  scenarios:
    missing_member: A Project has three observed open Issues in Repository A; Repository B has never been
      observed. Three may be shown as A's supported contribution with incomplete Project coverage, not
      as a complete Project total.
    stale_count: Three PRs were observed open yesterday and have not been refreshed. Keep the supported
      time and do not claim at least three PRs are open now.
    revoked_member: The relevant account remains active throughout this scenario. An aggregate includes
      supported saved data from private Repository B. After explicit revocation, keep its supported saved
      value visible with the indication and known time, without claiming it is freshly observed or treating
      B as zero.
    revoked_without_time: The relevant account remains active throughout this scenario. A saved private
      count has no reliable update time when access is explicitly revoked. It remains visible with the
      revocation indication and no fabricated timestamp.
    mixed_time_attention: CI failed at T1 and lifecycle was observed open at T2; no evidence establishes
      that the CI result still applied at T2. Do not claim the combined open-and-failed predicate at T2.
    changed_members: An A-and-B calculation completes after the Project changes to A and unobserved C.
      Attribute the result to A and B, not to a complete current A-and-C scope.
    shared_repository: One Repository with one observed PR belongs to two Projects. Each Project can count
      it; a supported unique portfolio total counts the Repository and PR once.
  open_questions:
  - Per-metric source evidence for coverage, comparable times and identity.
  - Native representation of partial, mixed-time and last-known aggregates.
  - Other account-change and disclosure conditions beyond the selected A-to-B rule and confirmed private
    Repository revocation in 0019.
  ontology_status: Project, Repository, PullRequest, Issue and Metric use selected ontology vocabulary;
    coverage and aggregation are observation properties rather than new domain entities.
acceptance:
- Displayed counts retain supported metric, scope, membership basis, time and coverage without inventing
  a simultaneous snapshot.
- Missing or stale observations are not silently treated as zero, an exact current total or a current
  lower bound.
- A late count for prior Project membership is not represented as a complete count for changed membership.
- Saved private observations and supported derived counts remain visible after confirmed revocation with
  an indication and supported update time when known; an unknown time is not invented. Visibility and
  local access follow the active-account and A-to-B boundary in 0019.
- Shared Repository membership is preserved per Project while supported unique portfolio totals deduplicate
  confirmed identities.

```

## GITVIEW-SPEC-0047: GitView - Project overview and summary

Источник `specs/nodes/GITVIEW-SPEC-0047.yaml`, SHA-256 `f9d013cd63e08f76bbee1cfa6dbfad4ddd7f5c60066a441b89140dd27a8c08e8`

```yaml
id: GITVIEW-SPEC-0047
title: GitView - Project overview and summary
kind: spec
created_at: '2026-11-15T21:06:00Z'
updated_at: '2026-11-16T19:51:49Z'
status: specified
refines:
- GITVIEW-SPEC-0001
depends_on:
- GITVIEW-SPEC-0005
- GITVIEW-SPEC-0006
- GITVIEW-SPEC-0019
relates_to:
- GITVIEW-SPEC-0007
sources:
  predecessor_draft: docs/drafts/GITVIEW-SPEC-0047.yaml
  predecessor_revision: 05c27259cd47f1967ec871802579414dac47301e
  owner_selection: docs/drafts/project-summary-proposal.md
  historical_signal_filter_override: conversation_memory/sketches/gitview/revisions/32213bd5294945d0ba9f0a63c37298de/notes.hc
  historical_membership_decision: conversation_memory/sketches/gitview/revisions/a55f271ca16f4283bfaf67095616ee7a/notes.hc
  metric_candidate: docs/drafts/GITVIEW-SPEC-0057.yaml
  ontology_context: ontology/packages/gitview/versions/0.2.0/composition-context.yaml
  signal_filter_context_decision: conversation_memory/sketches/gitview/revisions/9544eaa87e5b4afcb48910299d60c520/metadata.json
  ready_meaning_decision: conversation_memory/sketches/gitview/revisions/23fe1cc490924a219f38c4bee721511f/metadata.json
specification:
  ontology_refs:
  - gitview:pullRequestRepository
  - gitview:issueRepository
  - gitview:pullRequestIssueLink
  - gitview:CIStatus
  - gitview:ReviewThread
  - gitview:User
  - gitview:Project
  - gitview:Repository
  - gitview:PullRequest
  - gitview:Issue
  - gitview:Metric
  - gitview:projectIncludesRepository
  objective: Let the operator survey Projects, understand their work and attention, and enter an applicable
    selection.
  authority_boundary: The Project summary and its broad categories are selected. Exact source mappings,
    metric predicates, visual arrangement, disclosure policy and the full predecessor draft require separate
    refinement. This node does not establish a running app, ontology approval or implementation readiness.
    When GitHub externally revokes access to a private Repository, the retained-data visibility and local
    access described here apply while the relevant account remains active. Independently of revocation,
    while account B is active, the account-switch boundary in 0019 applies. Behavior after returning to
    A is not selected.
  requirements:
    projects: The overview represents saved GitView Projects whose representation is permitted and identifies
      them where permitted. A GitHub organization is source metadata, not a GitView Project boundary.
      A Repository may contribute to each Project containing it.
    summary: A Project summary makes available its member Repository count and observation coverage, open
      PRs with draft as a subset, open Issues, and attention signals for failed CI, waiting for review,
      changes requested, unresolved thread count and affected PR count, and blocked Issues. It distinguishes
      merged PR outcomes and Issue closures by reason for a selected period. Show charts of these measurements
      when sufficient history is available; exact predicates, time ranges and placement remain to be specified.
      The primary PR «Done» indicator means merged PRs; readiness to merge is a separate desired indicator
      whose applicable predicate and evidence remain to be defined.
    units: Preserve the meaning and unit of each value. Counts of checks, affected PRs, review threads,
      Issues and affected Repositories are different measurements; do not add linked PRs and Issues as
      independent tasks. Affected object and Repository counts may be separately available for the same
      signal.
    conditional_ready: Provide the preliminary checks-and-review-passed selection if the corresponding
      Repository rule is separately defined, accepted and applicable; it is not automatically a guarantee
      of merge eligibility or an established count before that rule exists.
    comparability: Parts of the summary presented as comparable use the same applicable period and filters;
      explicitly distinguish their actual observation contexts and avoid suggesting incompatible values
      are directly comparable.
    coverage: A missing or inaccessible observation is not a confirmed zero or healthy result. A Project
      remains represented when one of its members is unobserved if the representation itself is permitted;
      otherwise convey an access-safe limitation at a permitted scope when one can be disclosed without
      revealing restricted existence; non-disclosure alone does not establish an empty or complete scope.
      Supported partial information retains its limitations, observation context and applicable access
      restrictions. Do not infer one category's freshness from another category's refresh.
    history: Distinguish current observations from outcomes over a selected period. A graph needs sufficient
      evidence for its own metric and time scope; unavailable history is not a fabricated zero or a copy
      of the current value.
    project_history_membership: Project historical graphs use current Project Repository membership over
      the selected period as described in 0013. Identify that basis and preserve incomplete history and
      access limitations; do not present it as the actual Project composition at earlier dates.
    navigation: An actionable Project signal opens its corresponding selection across the applicable Project
      member scope as described by 0006, retaining the condition and permitted source context. A selection
      and its earlier summary need not have equal counts after facts change; preserve their respective
      observation context and coverage. On an explicit historical merged-PR counter transition, temporarily
      override a saved exclusion of merged PRs, so the supported result can be shown. This transition
      does not itself rewrite the saved filter; source coverage, access and the counter's historical period
      remain applicable. Filter hierarchy and exact return behavior require refinement. A signal originating
      within a filtered scope retains that scope when opened; a signal originating outside an unrelated
      filter context is not narrowed by it under 0092. The previously selected historical merged-counter
      case concerns a counter whose originating scope includes merged PRs; a saved exclusion outside that
      origin does not narrow its destination. A counter defined inside a merged-excluding scope instead
      retains that origin scope.
    portfolio: A Repository shared by two Projects contributes to each applicable Project summary. Any
      combined portfolio total of unique Repositories or source objects counts each supported identity
      once rather than simply summing Project totals.
    presentation: The overview uses a zoomable Project grid and makes summary information inspectable
      without requiring all details to fit a compact cell. Exact density, accessible controls and arrangement
      remain open.
    revoked_private: When GitHub confirms private Repository access revocation, keep the saved Project
      and available local summary information for the affected Repository visible as last known with the
      revocation indication and supported update time when known. Stop synchronization for the affected
      Repository and preserve a discoverable path to recovery or explicit local deletion under 0019. Other
      account-change disclosure cases remain open.
  scenarios:
    historical_filter_override: In the selected counter case, its originating scope includes merged PRs
      and the saved merged exclusion is outside that scope. A saved filter hides merged PRs; the operator
      opens a supported historical merged-PR counter for last week. Temporarily override that conflicting
      exclusion for the destination, retain the counter's historical period and scope, and show supported
      permitted results without rewriting the saved filter or claiming completeness without evidence.
    shared_repository: Projects P and Q share Repository R. R's permitted work contributes to each Project
      summary, while a supported unique portfolio total does not count R or the same source object twice.
    partial_coverage: A Project contains two members; Issue observations are available for one and unavailable
      for the other. The observed information retains its incomplete scope; the second member is not reported
      as zero or the Project as complete.
    actionable_signal: A failed-CI signal concerns PRs in two Project members. Opening it retains the
      Project and condition, distinguishes permitted source repositories and conveys any limitations of
      the resulting selection.
    missing_history: A current open-PR count is available but an earlier graph point has insufficient
      evidence. The historical point is shown as unavailable or incomplete, not as zero or as the current
      count.
    revoked_member: The relevant account remains active throughout this scenario. A Project summary includes
      saved information from a private Repository whose access is confirmed revoked. Keep the Project
      and saved information visible with the revocation indication and supported time when known; do not
      present the data as newly refreshed or replace it with zero.
  open_questions:
  - Exact definitions, source mappings, freshness and coverage requirements for each metric and attention
    signal.
  - Period selection, event versus object units and evidence for historical values, including uncertain
    current membership.
  - Disclosure of restricted identities and aggregates, compact layout and accessible signal controls.
  - Predicate and applicability of the conditional checks-and-review-passed selection.
  ontology_status: Project, Repository, PullRequest, Issue and Metric use selected ontology vocabulary.
    A summary is a presentation, not a new domain entity or evidence that an actor performed an action.
acceptance:
- 'For the selected counter whose originating scope includes merged PRs and whose saved merged exclusion
  is outside that scope: A historical merged-PR counter transition temporarily overrides a saved exclusion
  of merged PRs without itself rewriting the saved preference; supported period, scope and coverage remain
  distinct.'
- A permitted Project summary distinguishes membership and coverage, current work, attention and period
  outcomes by their meanings.
- Draft PRs are a subset of open PRs, and unlike units are not presented as the same count or as independent
  tasks.
- Missing observations and missing historical evidence remain distinguishable from confirmed zeros.
- Shared Repository contributions are correct in each Project and any claimed unique portfolio total.
- An actionable signal reaches its corresponding scoped selection without assuming unchanged observations
  or full coverage.
- Confirmed private Repository revocation keeps the saved Project and available local summary information
  for the affected Repository visible with its indication and supported time when known under 0019. Visibility
  and local access follow the active-account and A-to-B boundary in 0019.

```

## GITVIEW-SPEC-0048: GitView - Refresh triggers and visible outcomes

Источник `specs/nodes/GITVIEW-SPEC-0048.yaml`, SHA-256 `10ccc0499cef6588dce8febd45e3473e96302eff5578127331dce3ba405c8a30`

```yaml
id: GITVIEW-SPEC-0048
title: GitView - Refresh triggers and visible outcomes
kind: spec
created_at: '2026-11-16T08:36:00Z'
updated_at: '2026-11-16T19:57:34Z'
status: specified
refines:
- GITVIEW-SPEC-0003
depends_on:
- GITVIEW-SPEC-0017
- GITVIEW-SPEC-0019
- GITVIEW-SPEC-0023
- GITVIEW-SPEC-0026
- GITVIEW-SPEC-0036
- GITVIEW-SPEC-0037
sources:
  predecessor_draft: docs/drafts/GITVIEW-SPEC-0048.yaml
  predecessor_revision: 33fb739
  root_intent: .specgraph/root_intent.md
specification:
  ontology_refs:
  - gitview:User
  - gitview:Project
  - gitview:Repository
  - gitview:PullRequest
  - gitview:Issue
  objective: Let the operator request or benefit from bounded refresh while understanding what has actually
    updated.
  authority_boundary: Manual refresh, stale-on-open and opportunistic background updates follow the owner
    direction. This node does not select a numerical staleness threshold, GitHub endpoint, request budget,
    polling frequency, background schedule, native control or implementation readiness. When GitHub externally
    revokes access to a private Repository, the retained-data visibility and local access described here
    apply while the relevant account remains active. Independently of revocation, while account B is active,
    the account-switch boundary in 0019 applies. Behavior after returning to A is not selected.
  requirements:
    manual: Offer pull-to-refresh where appropriate or an equivalent explicit and accessible action for
      the current view or selected scope. A manual request is not rejected solely because the observation
      is younger than an eventual staleness threshold; applicable access, source-directed waits and execution
      constraints still apply. Requesting refresh does not itself establish that it started, completed
      or succeeded.
    foreground: Make recoverable saved data available where eligible for local display under 0019 without
      waiting for a GitHub response. When a relevant scope is opened with stale data, request a bounded
      update when the applicable access and source constraints permit. Exact staleness, prioritization
      and scheduling remain open.
    background: The app can request or use a system-granted background opportunity for bounded refresh.
      iOS controls whether and when the opportunity is granted; no fixed frequency or successful refresh
      is implied by requesting it.
    scope: Preserve the scope and observation context of each actual refresh outcome. A successful Repository
      metadata or Issue observation does not refresh an unrelated PR scope; a partial response does not
      establish complete Project coverage.
    outcomes: Make loading, deferred, partial, successful and failed outcomes distinguishable when supported
      for the affected scope. A request deferred before any source attempt is not described as a completed
      refresh or a fabricated GitHub failure. For an actual GitHub failure, make the supported error or
      reason discoverable with the scope and last supported successful time when known; do not invent
      a source cause or describe a local failure as a GitHub error. Observation and attempt retain their
      own supported times and scope.
    saved_data: During refresh or failure, previously saved supported data remains available where eligible
      for local display, with its own observation time when known and applicable limitation under 0003
      and 0019. An unobserved collection does not become a confirmed empty result or an invented success
      time.
    source_limits: Account for shared applicable GitHub rate limits and request cost across manual, foreground
      and background work; apply supported source retry constraints and avoid unbounded retry loops. An
      explicit manual request does not bypass an applicable source-directed wait. Exact cost, pagination,
      concurrency and retry timing remain open.
    revoked_private: After confirmed GitHub revocation of a private Repository, keep its saved local data
      visible with the revocation indication and supported time when known under 0019; do not dispatch
      ordinary synchronization for that Repository while revocation applies. Other eligible scopes retain
      their own context.
    accessibility: The operator can discover applicable refresh state, failure or limitation and available
      recovery without relying solely on color or transient feedback.
  scenarios:
    manual_refresh: The operator requests an update from a Project view. The request remains attributed
      to its actual selected scope, and the UI does not claim success merely because the action was activated.
    deferred_request: A source-supported retry constraint prevents a requested update from starting. Show
      the applicable deferred state without inventing a new success time or reporting an unattempted source
      request as a GitHub failure.
    partial_project: An Issue portion is successfully observed while the corresponding PR portion fails
      or remains unobserved. Update only supported facts with their own times and retain the Project's
      incomplete coverage.
    background_not_granted: No background opportunity is granted by iOS. Do not present a successful refresh
      or an application failure solely because the opportunity did not occur.
    revoked_repository: The relevant account remains active throughout this scenario. A Project contains
      a Repository with confirmed GitHub revocation and saved local data. Keep the saved data visible
      with the applicable indication and supported time when known, and do not dispatch ordinary refresh
      for that Repository while revocation applies.
  open_questions:
  - Staleness thresholds, prioritization, exact refresh scope, coalescing and outcome presentation.
  - GitHub operations, rate-limit interpretation, request budgets, retry and background scheduling appropriate
    to the implementation.
  - Source evidence and explicit recovery path after access revocation or uncertain local retention.
  ontology_status: Project, Repository, PullRequest and Issue use selected ontology vocabulary; refresh
    triggers and request outcomes are interaction and specification concepts, not new domain entities.
acceptance:
- The operator can request refresh using pull-to-refresh where appropriate or an equivalent accessible
  action.
- Saved supported data can remain visible while refresh is requested or in progress; stale-on-open and
  system-granted background refresh do not imply guaranteed source access or execution frequency.
- Partial, deferred and failed outcomes remain distinct from a successful complete observation and are
  attributed to their actual scopes.
- A failed or unattempted request does not invent a successful observation time, confirmed empty source
  or unsupported GitHub error.
- Confirmed private Repository revocation retains previously saved local data under 0019 and prevents
  ordinary synchronization for that Repository while the revocation applies.

```

## GITVIEW-SPEC-0049: GitView - Today boundary and active navigation

Источник `specs/nodes/GITVIEW-SPEC-0049.yaml`, SHA-256 `42ecfe4c2a034e311c4e1284adade59c1e38f9885721258254c9aa71ec59933d`

```yaml
id: GITVIEW-SPEC-0049
title: GitView - Today boundary and active navigation
kind: spec
created_at: '2026-11-16T08:39:00Z'
updated_at: '2026-11-16T20:05:42Z'
status: specified
refines:
- GITVIEW-SPEC-0027
depends_on:
- GITVIEW-SPEC-0007
- GITVIEW-SPEC-0019
- GITVIEW-SPEC-0024
- GITVIEW-SPEC-0026
- GITVIEW-SPEC-0031
- GITVIEW-SPEC-0042
sources:
  predecessor_draft: docs/drafts/GITVIEW-SPEC-0049.yaml
  predecessor_revision: 33fb739
  owner_day_decision: conversation_memory/sketches/gitview/revisions/cc419cb9283f471b88b6f4b66e56c5ad/notes.hc
  owner_timezone_decision: conversation_memory/sketches/gitview/revisions/3077fdcd9a8247769def8d6403c2e61c/notes.hc
specification:
  ontology_refs:
  - gitview:Project
  - gitview:Repository
  - gitview:PullRequest
  - gitview:Issue
  objective: Keep the selected Today view understandable when the user's local calendar day changes while
    preserving navigation and filter context.
  authority_boundary: The owner selected the user's local time zone for the day and approved retaining
    earlier unfinished work and results completed today. The precise time-zone source, interval mechanics,
    native reordering and background timing remain open; this node does not establish implementation readiness.
  requirements:
    local_day: Interpret the current Today calendar day in the user's local time zone under 0007. Earlier
      unfinished PRs and Issues remain eligible; work completed during that day remains eligible. Completion
      on the previous day alone does not establish eligibility for the new Today.
    context: A change in the evaluated Today day or applicable local time-zone context does not by itself
      change the selected Project, Repository scope, object type or explicit filters. Source event and
      observation times are not rewritten to fit a new view.
    coverage: Reevaluate supported selection and coverage for the applicable day, membership and filters.
      Missing evidence for the new scope remains unknown or incomplete rather than a confirmed empty selection;
      do not attribute an older day's result to the new day as a fresh observation.
    interaction: If the applicable Today context changes during an active gesture or while a filter control
      is open, avoid silently switching the inspected object or clearing the operator's explicit selections.
      Exact visual reordering, focus and gesture coordination remain to be specified and evaluated.
    open_object: A preview or overview already open for a PR or Issue remains associated with that same
      source object when Today changes. If its prior cell no longer belongs to the selection, returning
      uses a supported current-context fallback under 0024 rather than substituting another object.
    private_data: Confirmed private Repository revocation alone does not hide already saved local data;
      visibility follows the active-account and A-to-B boundary under 0019; keep the indication and supported
      time when known and stop synchronization for that Repository. A day change does not itself prove
      revocation or restoration of GitHub access.
    historical_period: Do not silently relabel a separately selected historical period as the new dynamic
      Today. Exact historical-period boundaries and behavior after a time-zone change remain open.
    accessibility: Make an applicable changed day, incomplete coverage or recovery limitation discoverable
      without relying solely on color or a transient visual cue.
  scenarios:
    new_day: An older PR is still unfinished and another PR was merged yesterday with no other supported
      inclusion condition. In the new local day the unfinished PR remains eligible; yesterday's merge
      alone does not keep the other PR in Today.
    open_preview: A saved PR preview is open as the applicable local day changes and its cell no longer
      qualifies for Today. Keep the preview associated with that PR; on dismissal return to a supported
      current selection or fallback without opening a different object.
    incomplete_new_day: The day changes but source evidence for the newly applicable scope is incomplete.
      Preserve supported observations with their times and identify incomplete coverage rather than claiming
      a complete empty day.
    filter_preserved: The operator has saved a filter that excludes merged PRs when Today changes to the
      next local day. Reevaluate the current selection without silently clearing that preference; a separate
      unsaved change is not represented as a confirmed saved preference.
  open_questions:
  - Source of the user's local time zone, exact calendar boundaries, daylight-saving and clock-change
    mechanics.
  - Native timing, focus and reordering while a gesture, preview or filter control is active.
  - Historical-period interpretation across time-zone changes and evidence needed to claim complete Today
    coverage.
  ontology_status: Project, Repository, PullRequest and Issue use selected ontology vocabulary; day boundaries
    and navigation state are specification and interaction concepts.
acceptance:
- Today uses the user's local calendar day, retaining earlier unfinished work and work completed on that
  day under 0007.
- A new day does not make a prior-day completion alone qualify or delete the object from source history.
- A changed day does not silently change Project or Repository scope or clear an explicit filter.
- An open PR or Issue preview remains associated with the same object; missing new-day evidence does not
  become a confirmed empty selection.
- Confirmed private Repository revocation preserves saved local information and its applicable limitation
  under 0019.

```

## GITVIEW-SPEC-0050: GitView - Compact preview content by object type

Источник `specs/nodes/GITVIEW-SPEC-0050.yaml`, SHA-256 `69e505a8d13ec551d4dc55128c46268c4f01571f946d17974fa372f73b3cdaf0`

```yaml
id: GITVIEW-SPEC-0050
title: GitView - Compact preview content by object type
kind: spec
created_at: '2026-11-16T11:07:00Z'
updated_at: '2026-11-16T19:57:34Z'
status: specified
refines:
- GITVIEW-SPEC-0031
depends_on:
- GITVIEW-SPEC-0019
- GITVIEW-SPEC-0023
- GITVIEW-SPEC-0028
- GITVIEW-SPEC-0032
- GITVIEW-SPEC-0033
- GITVIEW-SPEC-0039
- GITVIEW-SPEC-0041
- GITVIEW-SPEC-0047
- GITVIEW-SPEC-0062
- GITVIEW-SPEC-0063
sources:
  predecessor_draft: docs/drafts/GITVIEW-SPEC-0050.yaml
  discovery: docs/product-discovery.md
  revoked_private_visibility: specs/nodes/GITVIEW-SPEC-0019.yaml
specification:
  ontology_refs:
  - gitview:CIStatus
  - gitview:Metric
  - gitview:Project
  - gitview:Repository
  - gitview:PullRequest
  - gitview:Issue
  objective: Support inspection of a selected object from the overview with a compact, type-aware preview.
  authority_boundary: The owner requested a minimal overview with examples including name, ID, badges
    and text, and selected a first-version long-press preview. Those examples are not an exhaustive field
    list. Type-specific content is a refinement; exact field priority, layout, source mapping and native
    presentation remain open. This node does not select a sliding-preview implementation. When GitHub
    externally revokes access to a private Repository, the retained-data visibility and local access described
    here apply while the relevant account remains active. Independently of revocation, while account B
    is active, the account-switch boundary in 0019 applies. Behavior after returning to A is not selected.
  requirements:
    common: Show the selected object's type and enough available identity and summary to distinguish it
      in its actual scope; include an available title or name, Repository context and source number where
      applicable. A short available source-text excerpt can assist identification; its absence does not
      establish that the source description is empty. Provide readable additional available detail beyond
      the originating cell under 0031. Opening and dismissal retain the same object's identity and origin.
    project: Show the local Project name and supported member count and summary signals with their actual
      scope and coverage where available. Membership and source observations are distinct; a Project can
      include more than one Repository.
    repository: Show the supported Repository identity and available PR and Issue summaries in their observation
      context. An unavailable or changed source address does not identify another Repository merely because
      it has the same name.
    pull_request: Show supported Repository context, PR number, title and lifecycle, with available draft,
      CI, review and unresolved-thread signals. Retain CI, review assessment, requested reviews and thread
      counts as distinct observations; zero or unknown threads alone do not prove approval or a completed
      review. Counters do not require displaying individual check or thread content.
    check_specials: When known special or unclassified check outcomes are present, make their presence
      and available meaning or limitation discoverable through a non-color accessible path, without representing
      them as success. Exact source classification and presentation remain open under 0028.
    issue: Show supported Repository context, Issue number, title and open or closed state, with source
      closure reason when available. Do not assign PR-only review or CI status to an Issue or equate a
      closed Issue with successful completion. A blocker indication follows 0063 and its actual evidence.
    observation_context: Unknown, stale or incomplete fields do not become confirmed empty, zero or successful.
      A recently observed title or lifecycle does not establish equally recent review, CI, thread, related-object
      or counter data; keep applicable limitations available in preview or the accessible path to object
      overview.
    revoked_private: After confirmed private Repository access revocation, saved local preview details,
      including saved source-derived names and counts, remain visible as last known with revocation indication
      and supported last update time when known. Preserve a local route to recovery or explicit deletion
      under 0019; local visibility does not restore source access and synchronization remains stopped.
      Do not invent a missing update time. Other account-change or offline disclosure cases remain open.
    actions: Offer an accessible way to open the same object locally and dismiss the preview under 0031;
      eligible source and sharing actions follow 0033. A source link does not guarantee renewed access.
    accessibility: Provide an accessible path to identify and open the selected object, inspect supported
      signals and their limitations, and distinguish them without color alone. Adapt presentation to available
      space and accessibility settings without making eight columns or an exact layout mandatory.
  scenarios:
    additional_detail: A dense cell shows a PR number and status; its preview supplies additional readable
      available information for the same PR rather than repeating only the cell's content.
    special_check: A complete observation contains one skipped check and no success, failure or pending
      entries. The total may be one while the three counts are zero; the skipped outcome is discoverable
      without color alone and is not described as an executed success.
    unavailable_review: A PR has a known title, failed CI and unavailable review assessment. The preview
      identifies it and distinguishes failed CI without presenting review as approved or known zero.
    revoked_project: The relevant account remains active throughout this scenario. A Project's saved default
      name and counts come from a private Repository whose access is explicitly revoked. They remain visible
      as last known with an indication and supported time if known; a local route to recovery or explicit
      deletion remains available.
    mixed_freshness: An Issue title is recently observed while related PR data is older. Do not imply
      that the related data was refreshed with the title; retain its applicable limitation.
    unknown_closure: A closed Issue has an unknown closure reason. Show closure without inventing a reason
      or describing it as successful completion.
  open_questions:
  - Exact field priorities at each density, layout, truncation and excerpt length.
  - Source-specific evidence for individual fields and other account-change disclosure beyond 0019.
  - Treatment of special or unclassified CI checks in compact representations, beyond the parent signal
    contract.
  ontology_status: Project, Repository, PullRequest and Issue use selected ontology vocabulary; preview
    is an interaction, not a new domain entity.
acceptance:
- Preview identifies the selected object in its supported scope, provides readable additional available
  detail beyond the cell and offers local open and dismissal without retargeting it.
- PR and Issue previews distinguish their supported state and type-specific signals without fabricating
  missing facts.
- Project and Repository summaries retain their supported scope, coverage and observation limitations.
- Saved preview details remain visible after confirmed private Repository access revocation with the indication
  and supported time when known. Visibility and local access follow the active-account and A-to-B boundary
  in 0019.
- The same object and applicable limitations are accessible without relying on color or long press alone.

```

## GITVIEW-SPEC-0054: GitView - Required Issue and PR description workflow

Источник `specs/nodes/GITVIEW-SPEC-0054.yaml`, SHA-256 `da7e5c8efb4e25ec91e0ea85d9b7396704c77e6b49e0a9e1c414dcb24b2721a2`

```yaml
id: GITVIEW-SPEC-0054
title: GitView - Required Issue and PR description workflow
kind: spec
created_at: '2026-11-16T08:23:00Z'
updated_at: '2026-11-16T19:49:26Z'
status: specified
refines:
- GITVIEW-SPEC-0010
depends_on:
- GITVIEW-SPEC-0008
- GITVIEW-SPEC-0009
- GITVIEW-SPEC-0034
- GITVIEW-SPEC-0019
sources:
  predecessor_draft: docs/drafts/GITVIEW-SPEC-0054.yaml
  predecessor_revision: 9c598dd
  owner_selection: docs/drafts/github-templates/README.md
specification:
  ontology_refs:
  - gitview:Issue
  - gitview:PullRequest
  objective: Make the selected Issue and PR description structure a requirement of the participating repository
    authoring process while keeping GitView usable for other source material.
  authority_boundary: The owner chose the mandatory section sets. Which repositories and authoring paths
    participate, how conformance is enforced, how exceptions are handled and who configures each path
    remain open. This node does not assert that templates, checks or creation-path enforcement are already
    installed or implemented.
  requirements:
    issue_format: A new Issue description in the participating process requires Problem, Motivation, Expected
      outcome and References.
    pr_format: A new PR description in the participating process requires Problem, Motivation, Expected
      outcome, Changes, Validation and References.
    templates: Provide the agreed templates as inputs to the participating authoring process. The presence
      of a prefilled template or an agent instruction alone does not prove that the required sections
      were supplied, are meaningful or have been checked.
    creation_paths: The participating process accounts for its supported creation paths, including person
      or agent paths that do not show the repository's web template. Exact coverage and the mechanism
      for detecting or correcting incomplete descriptions remain to be specified.
    conformance: The process distinguishes a supported conforming new description from an incomplete or
      unverified one using an agreed rule. Structural conformance does not establish the truth of an authored
      motivation, outcome or validation claim. A source mechanism is not claimed to prevent or correct
      nonconformance until separately established.
    existing_content: GitView continues to show available existing, externally authored or differently
      structured Issues and PRs when eligible for display under 0019 and 0034. Preserve original text
      where available; inspection or compliance display does not rewrite the source description or fill
      sections automatically. Do not fabricate missing sections or hide an object solely because process
      compliance is missing or unknown. This does not decide a separately specified future editing flow.
    source_facts: An authored claim is distinct from independently observed source facts, review and CI.
      A linked Issue or a stated motivation does not prove the motive of a particular actor or the causal
      history of a change.
  scenarios:
    agent_path: A participating agent creates a PR through a path without a web template. The process
      still needs to account for the selected required sections; an agent instruction alone is not proof
      that they were supplied or checked.
    legacy: A previously created external PR has an unstructured description. GitView preserves its available
      original text and does not hide the PR merely because the selected process cannot be verified for
      it.
    validation_claim: A conforming PR description states validation succeeded while independently observed
      CI reports failure. Preserve the authored statement and source CI as separate claims; a section's
      presence does not prove validation.
  open_questions:
  - Participating repositories, authoring paths, ownership and rollout of the required format.
  - The conformance rule, enforcement or correction point, handling of exceptions and evidence of creation-path
    coverage.
  - Template versions, section syntax and exact semantics of incomplete or ambiguous authored content.
  ontology_status: Issue and PullRequest use selected ontology vocabulary; authored statements and process
    conformance do not establish an actor's actual motive or a new domain entity.
acceptance:
- The participating process requires the selected Issue and PR section sets for new descriptions across
  its supported authoring paths.
- A template or agent instruction alone is not treated as proof that sections were supplied or that every
  path is enforced.
- Existing or external objects with missing or differently structured descriptions remain visible with
  their available original text when eligible under 0019; format alone does not hide them.
- Structural conformance does not by itself establish an actor's motive, an achieved outcome, successful
  CI or independent validation.

```

## GITVIEW-SPEC-0056: GitView - Historical outcome selection

Источник `specs/nodes/GITVIEW-SPEC-0056.yaml`, SHA-256 `ea85edc8ccef5f08bdba1e9eed38e4a4d3948e406121a49208802a6f0c39e809`

```yaml
id: GITVIEW-SPEC-0056
title: GitView - Historical outcome selection
kind: spec
created_at: '2026-11-16T08:41:00Z'
updated_at: '2026-11-16T20:00:50Z'
status: specified
refines:
- GITVIEW-SPEC-0007
depends_on:
- GITVIEW-SPEC-0019
- GITVIEW-SPEC-0024
- GITVIEW-SPEC-0026
- GITVIEW-SPEC-0029
- GITVIEW-SPEC-0030
- GITVIEW-SPEC-0047
sources:
  predecessor_draft: docs/drafts/GITVIEW-SPEC-0056.yaml
  predecessor_revision: 9c598dd
  project_summary: docs/drafts/project-summary-proposal.md
  signal_filter_context_decision: conversation_memory/sketches/gitview/revisions/9544eaa87e5b4afcb48910299d60c520/metadata.json
specification:
  ontology_refs:
  - gitview:Metric
  - gitview:projectIncludesRepository
  - gitview:pullRequestRepository
  - gitview:issueRepository
  - gitview:pullRequestIssueLink
  - gitview:Project
  - gitview:Repository
  - gitview:PullRequest
  - gitview:Issue
  objective: Let the operator inspect work associated with a supported historical outcome without confusing
    that event with the object's current state.
  authority_boundary: Project historical graphs and the selected merged-counter transition follow 0047.
    This node refines interpretation of a historical outcome selection; it does not mandate a full historical
    timeline, calendar mode, a source API, historical membership reconstruction or implementation readiness.
  requirements:
    origin: Preserve the originating Project, supported event condition, object category, period and Repository
      basis when opening a historical outcome selection. Retain the supported period boundaries and time-zone
      interpretation when known; if unavailable, expose the limitation rather than inventing a different
      interval. Do not silently relabel that period as dynamic Today or replace it with an unrelated current-state
      filter.
    evidence: A supported matching historical event must belong to the selected object and period. An
      object's current closed or merged state without sufficient event-time evidence does not establish
      that the event occurred in that period; missing history or unknown identity does not prove a non-match
      or complete empty selection.
    identity: Represent each source-confirmed matching PR or Issue at most once in the destination selection,
      even if it has several qualifying events. An event count and a count of distinct object cards are
      different units; a linked PR and Issue remain distinct objects.
    current_state: When supported, display the object's latest observed lifecycle with its own observation
      context separately from the historical event condition. A reopened Issue can still match a prior
      supported closure event; its later current state alone does not reconstruct its earlier state or
      reason.
    filters: Keep explicit current-state filters distinct from the historical event condition. For the
      selected transition from a historical merged-PR counter, temporarily override a conflicting saved
      merged exclusion to show the counter result without rewriting the saved preference under 0047. Other
      transitions follow their signal origin and filter scope under 0092; exact filter hierarchy remains
      open. The previously selected historical merged-counter case concerns a counter whose originating
      scope includes merged PRs; a saved exclusion outside that origin does not narrow its destination.
      A counter defined inside a merged-excluding scope instead retains that origin scope.
    coverage: Preserve actual source scope, observation times and incomplete event coverage. A supported
      partial selection is not a complete total or a confirmed zero for unobserved work. The originating
      metric and destination can have different observation contexts; do not fabricate equality or infer
      unseen objects.
    membership: Project historical graphs use current Project composition at evaluation under 0030 and
      0047, with that basis identified. If Project membership changes while an existing historical selection
      is open, preserve its actual captured origin or disclose a limitation; do not silently claim an
      old captured scope is the new current composition.
    access: Confirmed private Repository revocation alone does not hide already saved supported local
      historical information under 0019. Preserve its supported scope, time and applicable indication;
      do not claim newly current source access or fabricate missing event history. Visibility follows
      the active-account and A-to-B boundary under 0019.
    navigation: Preserve valid originating context on return under 0024. If the originating Project or
      period cannot be supported, offer an appropriate limitation or fallback without silently substituting
      another Project or unrelated period.
  scenarios:
    reopened_issue: A source-supported Issue closure occurred in the selected period and the Issue was
      later reopened. It remains a historical closure match while its latest supported current state can
      be shown separately.
    merged_filter: In the selected counter case, its originating scope includes merged PRs and the saved
      merged exclusion is outside that scope. A saved lifecycle preference excludes merged PRs. Opening
      a supported historical merged counter temporarily shows its matching merged result without rewriting
      that saved preference.
    event_vs_object: A single Issue has two supported closure events within the period. A destination
      of distinct objects contains that Issue once even if the originating event counter measures two
      events.
    incomplete_history: The app lacks sufficient event evidence for part of the selected Repository scope.
      Make the limitation discoverable without presenting an exhaustive empty result or inventing missing
      objects.
  open_questions:
  - Exact source evidence, event-versus-object metric choice and handling of uncertain identity or event
    time.
  - Native presentation, supported historical ranges and behavior when Project membership changes during
    an active selection.
  - Exact filter hierarchy and scope for historical signals beyond the selected origin-context rule under
    0092.
  ontology_status: Project, Repository, PullRequest and Issue use selected ontology vocabulary; selection
    predicates and chart navigation are specification and interaction concepts.
acceptance:
- A historical outcome selection preserves its originating Project, supported condition, category, period,
  supported boundaries and time-zone interpretation when known, and Repository basis rather than silently
  becoming Today.
- A confirmed historical event remains distinct from the object's latest supported state; missing event
  evidence is not a confirmed non-match or complete zero.
- Event counts and distinct object-card counts remain separate; the same confirmed object appears at most
  once in the destination.
- 'For the selected counter whose originating scope includes merged PRs and whose saved merged exclusion
  is outside that scope: The selected historical merged-counter transition temporarily overrides a conflicting
  saved merged exclusion without rewriting the saved preference.'
- Incomplete coverage remains visible, and confirmed private Repository revocation alone does not hide
  saved supported local history under 0019.

```

## GITVIEW-SPEC-0057: GitView - Project metric catalog and coverage

Источник `specs/nodes/GITVIEW-SPEC-0057.yaml`, SHA-256 `4904b9b13943e48331603c4f0745abe0282bf3f372e1ba1797fa60d65448abcf`

```yaml
id: GITVIEW-SPEC-0057
title: GitView - Project metric catalog and coverage
kind: spec
created_at: '2026-11-16T08:46:00Z'
updated_at: '2026-11-16T20:00:50Z'
status: specified
refines:
- GITVIEW-SPEC-0013
depends_on:
- GITVIEW-SPEC-0007
- GITVIEW-SPEC-0011
- GITVIEW-SPEC-0012
- GITVIEW-SPEC-0019
- GITVIEW-SPEC-0028
- GITVIEW-SPEC-0029
- GITVIEW-SPEC-0030
- GITVIEW-SPEC-0039
- GITVIEW-SPEC-0041
- GITVIEW-SPEC-0047
- GITVIEW-SPEC-0056
sources:
  predecessor_draft: docs/drafts/GITVIEW-SPEC-0057.yaml
  predecessor_revision: 9c598dd
  owner_selection: docs/drafts/project-summary-proposal.md
  ready_meaning_decision: conversation_memory/sketches/gitview/revisions/23fe1cc490924a219f38c4bee721511f/metadata.json
specification:
  ontology_refs:
  - gitview:Project
  - gitview:Repository
  - gitview:PullRequest
  - gitview:Issue
  - gitview:ReviewThread
  - gitview:CIStatus
  - gitview:Metric
  - gitview:projectIncludesRepository
  - gitview:pullRequestRepository
  - gitview:issueRepository
  objective: Make selected Project work, attention and period outcomes available as interpretable measurements
    and graphs when evidence supports them.
  authority_boundary: The Project summary categories and graphs are owner-selected; exact predicates,
    source mappings, supported history, native chart design and implementation remain to be refined. This
    node does not define merge readiness or imply every metric has complete historical evidence.
  requirements:
    scope: A Project summary uses its applicable confirmed member Repositories; a shared Repository contributes
      within each Project while an asserted unique portfolio total follows 0029. Make the supported distinct
      member-Repository count and applicable category-specific coverage discoverable, such as an observed
      subset of a known member set; an unknown identity or denominator is not fabricated. Each value retains
      its actual scope, object category, unit, condition, supported observation time or period and coverage
      when available.
    current_work: Distinguish supported open PRs, draft PRs and open Issues. A known draft PR is a subset
      of open PRs rather than additional independent work; an unknown draft flag is not silently non-draft.
      Current PR and Issue counts do not prove the number of independent tasks.
    attention: Make supported attention signals separately discoverable for failed CI, work awaiting review,
      changes requested, unresolved review threads and PRs affected by them, and Issues with supported
      open blockers. Keep each signal's actual unit, predicate and coverage distinct; a PR can contribute
      to several signals without becoming several PRs. Individual failed checks, affected PRs, affected
      Repositories and review threads are different units. Exact source predicates remain open; a review
      requirement or assignment to the operator is not automatically equivalent to awaiting review.
    readiness: A green CI count, review assessment or zero visible unresolved threads does not alone establish
      merge readiness. A combined checks-and-review-passed selection requires a separately defined and
      accepted predicate; do not invent a ready count from unknown inputs.
    outcomes: Distinguish supported merged-PR outcomes and closed-Issue outcomes for an identified period.
      Make an Issue closure breakdown discoverable by source-supported reasons and retain unknown reason
      and incomplete coverage where applicable. A closure does not automatically establish a completed
      task; a current reason is not assigned to an earlier event without evidence. Distinguish event counts
      from distinct affected object counts, and do not assume reason groups sum to distinct Issues when
      one Issue can have multiple events. For PRs, the primary «Done» indicator denotes merged PRs; readiness
      to merge is a separate desired signal and must not be inferred from a merged count.
    current_vs_history: A confirmed merged PR can leave an unfinished-only current-work selection while
      remaining visible in unfiltered Today for the applicable local day under 0007. Its supported merge
      outcome can contribute to the applicable metric when subject, scope, period and evidence support
      it; one known outcome does not establish an exact total or complete coverage.
    graphs: Provide graphs of selected supported summary metrics where historical evidence is sufficient
      under 0030. Identify current Project composition as the basis for its historical graphs under 0047;
      do not present it as the Project's historical membership. Missing history is a gap or incomplete
      scope, not an invented zero.
    navigation: An actionable metric or signal retains its condition, actual Project or Repository scope,
      period and applicable coverage when opening a work selection. Event counts, check counts and distinct
      PR or Issue cards are not silently equated. The selected historical merged-counter transition uses
      the limited temporary filter override in 0047 and 0056 without rewriting saved preference.
    coverage: Unknown, partial or stale source evidence retains its limitations and supported observation
      time when known; do not invent an unknown time. Successful metadata or one Repository data does
      not establish complete PR, Issue, review, CI or historical coverage for the whole Project.
    saved_data: Confirmed GitHub revocation of a private Repository does not hide previously saved supported
      local measurements under 0019. Retain their actual scope, coverage, supported time when known and
      revocation indication; do not report them as newly refreshed. Visibility follows the active-account
      and A-to-B boundary under 0019.
  scenarios:
    overlapping_attention: One PR has a failed check and an unresolved review thread. It can contribute
      to each supported signal but is not represented as two PRs.
    incomplete_member: A Project has five Repositories but one lacks the observation needed for a metric.
      Preserve the supported observed portion with its incomplete coverage; do not count the missing member
      as zero.
    closure_reason: A closed Issue's closure reason is unavailable. Preserve the supported closure and
      unknown reason rather than silently counting it as a confirmed completed task.
    membership_change: A Repository with earlier activity is added to a Project. Recalculate its historical
      graph using the current composition and identify that basis without claiming it was a member at
      the earlier time.
  open_questions:
  - Exact metric predicates, source-specific mapping, history availability and aggregation units for each
    supported signal.
  - Predicates and evidence for the separate readiness-to-merge indicator and the selected long wait for
    a reply to the latest review-thread message, without conflating independent facts.
  - Native presentation, chart periods, partial coverage and any formal burn-down definition.
  ontology_status: Project, Repository, PullRequest, Issue, ReviewThread, CIStatus and Metric use the
    selected ontology vocabulary; a chart or counter does not establish an actor action or a new domain
    entity.
acceptance:
- Supported current work, attention and period outcomes remain distinguishable by Project or Repository
  scope, unit, condition, time and coverage.
- Overlapping signals and different units are not silently added as separate PRs, Issues or independent
  tasks.
- Graphs identify their current Project membership basis and do not turn missing historical evidence into
  a confirmed zero.
- A closed Issue with unknown or non-completion reason is not automatically a completed task.
- The selected merged-counter transition, whose origin includes merged PRs and whose saved exclusion is
  outside that origin, preserves its event scope and limited temporary filter override under 0047 and
  0056.
- Confirmed private Repository revocation alone does not hide saved supported local measurements under
  0019 or make them newly current.
- For the selected period, a discoverable Issue closure breakdown preserves supported reasons and the
  applicable unknown or incomplete coverage without inventing counts for unobserved work.

```

## GITVIEW-SPEC-0058: GitView - Connection and authorization outcomes

Источник `specs/nodes/GITVIEW-SPEC-0058.yaml`, SHA-256 `e0e2d9a072412f4900b3e8e9ab69b5b37aabb2296318a1e7bc83880227c3baf5`

```yaml
id: GITVIEW-SPEC-0058
title: GitView - Connection and authorization outcomes
kind: spec
created_at: '2026-11-16T12:51:00Z'
updated_at: '2026-11-16T19:51:27Z'
status: specified
refines:
- GITVIEW-SPEC-0019
depends_on:
- GITVIEW-SPEC-0022
- GITVIEW-SPEC-0023
- GITVIEW-SPEC-0036
- GITVIEW-SPEC-0037
- GITVIEW-SPEC-0045
- GITVIEW-SPEC-0059
sources:
  predecessor_draft: docs/drafts/GITVIEW-SPEC-0058.yaml
specification:
  ontology_refs:
  - gitview:User
  - gitview:GitHub
  - gitview:Repository
  objective: Let the operator understand whether a GitHub connection attempt succeeded, was cancelled,
    failed or remains unresolved without mistaking any one step for the whole outcome.
  authority_boundary: Connecting GitHub and protecting credentials are selected. Authorization method,
    account model, exact disconnect and credential-removal behavior, and other account-change disclosure
    rules remain open. Attempt and recovery distinctions are refinements, not evidence of an implementation.
    When GitHub externally revokes access to a private Repository, the retained-data visibility and local
    access described here apply while the relevant account remains active. Independently of revocation,
    while account B is active, the account-switch boundary in 0019 applies. Behavior after returning to
    A is not selected.
  requirements:
    attempt: Distinguish an in-progress authorization attempt, explicit cancellation, supported failure,
      confirmed connection and an indeterminate result. A callback, attempted authorization or locally
      supplied account label alone does not prove a connected source identity or current Repository access.
    confirmation: Report a new connection as confirmed only when supported successful authorization for
      that attempt and identity, the relevant source identity and locally required secure credential handling
      are established under 0019. If an outcome cannot be established, show the limitation and an applicable
      recovery route rather than inventing success or a definite failure.
    prior_state: Starting, cancelling or failing a new authorization does not by itself erase saved Projects
      or prior observations, prove source deletion, or replace an independently supported existing connection.
      A prior local connection does not alone prove current remote access.
    late_result: A result from a cancelled, superseded or disconnected attempt cannot establish a new
      local connection, regardless of the outcome of any newer attempt. A separately initiated active
      attempt can establish its own outcome. Keep source and attempt context; local cancellation does
      not prove an independently completed source effect was undone. Actual identity and access evidence
      remain separate under 0036.
    setup_boundary: A connected account does not by itself establish a selected Repository, a saved Project
      or observed PR and Issue work. Partial discovery and uncertain setup outcomes retain their independent
      scope and recovery under 0022, 0045 and 0059.
    revoked_private: Confirmed GitHub revocation of private Repository access for the relevant account
      leaves previously saved local data visible as last known with indication and supported update time
      when known under 0019. Stop synchronization for the affected Repository while revocation applies;
      the local view does not prove source access was restored.
    secrecy: Credentials and secret authorization-response material must not be exposed in ordinary diagnostics,
      sharing or user-facing errors. An error may describe an applicable recoverable outcome without displaying
      secret material.
    accessibility: Connection status, applicable failure or limitation and available continuation or recovery
      are understandable without relying on color or transient feedback alone.
  scenarios:
    cancelled_attempt: A supported existing connection and saved Projects exist; the operator cancels
      a new authorization attempt. Cancellation alone does not replace the prior connection or erase Projects,
      and a later result of that cancelled attempt does not reconnect or replace it.
    connection_without_work: Authorization succeeds and the source account is identified, but no Repository
      has been selected and no work observed. Do not present a saved Project or empty work result as a
      consequence of connection alone.
    indeterminate_local_result: The source response is received but the necessary local connection outcome
      cannot be established. Keep the outcome unresolved and offer an applicable recovery route; do not
      claim confirmed connection or definite failure solely from the incomplete result.
    confirmed_failure: A source identity is known but authorization for that attempt is confirmed rejected,
      or required secure credential storage is confirmed to fail. Do not report a new confirmed connection;
      provide an applicable understandable continuation or recovery route.
    superseded_attempt: Attempt A is superseded by B, which remains pending or fails. A's later result
      does not establish a local connection. Preserve any independently confirmed source outcome without
      claiming that superseding A necessarily undid it.
    revoked_repository: The relevant account remains active throughout this scenario. A connected account
      loses confirmed access to a private Repository with saved data. The supported local view stays available
      with indication and supported time when known, while ordinary synchronization for that Repository
      stops.
  open_questions:
  - Authorization method, permissions, account count and source identity evidence.
  - Exact disconnect, credential removal and recovery behavior, including other account-change disclosure.
  - Native presentation of connection outcomes and continuation or recovery.
  ontology_status: User, GitHub and Repository use selected ontology vocabulary; authorization attempts
    and presentation states do not establish an actor's motive or create new domain entities.
acceptance:
- Authorization attempt outcomes remain distinguishable without reporting a callback or unverified account
  label as a confirmed connection.
- Confirmed connection requires supported successful authorization for that attempt and identity, plus
  established required secure credential handling.
- A cancelled, superseded or disconnected attempt does not establish a new local connection, regardless
  of the later attempt's outcome; source effects are not claimed undone without evidence.
- Connection success does not by itself establish Project creation, Repository access or an observed work
  collection.
- Confirmed private Repository revocation retains previously saved local data with indication and supported
  time when known; synchronization stops. Visibility and local access follow the active-account and A-to-B
  boundary in 0019.
- Connection limitations and available recovery are understandable without color or transient feedback
  alone, and credentials are not exposed.

```

## GITVIEW-SPEC-0059: GitView - Repository discovery and selection continuity

Источник `specs/nodes/GITVIEW-SPEC-0059.yaml`, SHA-256 `fcdfc90686a12a858d90237870b093682f16152fd5553e59350b0ef8cf3b51ee`

```yaml
id: GITVIEW-SPEC-0059
title: GitView - Repository discovery and selection continuity
kind: spec
created_at: '2026-11-16T11:27:00Z'
updated_at: '2026-11-16T19:51:27Z'
status: specified
refines:
- GITVIEW-SPEC-0019
depends_on:
- GITVIEW-SPEC-0022
- GITVIEW-SPEC-0025
- GITVIEW-SPEC-0036
- GITVIEW-SPEC-0038
- GITVIEW-SPEC-0045
sources:
  predecessor_draft: docs/drafts/GITVIEW-SPEC-0059.yaml
specification:
  ontology_refs:
  - gitview:GitHubRepository
  - gitview:projectIncludesRepository
  - gitview:User
  - gitview:GitHub
  - gitview:Repository
  - gitview:Project
  objective: Let the operator find and choose Repositories without confusing incomplete discovery, pending
    choices or saved Project membership.
  authority_boundary: Selecting eligible Repositories and one Project per Repository as the default are
    selected; a Repository can belong to multiple Projects. If multiple Repositories are supported in
    default setup, it corresponds to a separate Project for each Repository under 0045. Search and continuity
    requirements are refinements; the default-association and reuse mechanisms, exact search controls,
    multi-selection, source pagination, authorization method and admission mechanism remain open. This
    node does not establish actual source permissions or a live GitHub integration. When GitHub externally
    revokes access to a private Repository, the retained-data visibility and local access described here
    apply while the relevant account remains active. Independently of revocation, while account B is active,
    the account-switch boundary in 0019 applies. Behavior after returning to A is not selected.
  requirements:
    scope: Attribute results to their supported source account, query or selection scope, access context
      and coverage. Independently available choices remain usable when the result is partial, with the
      limitation visible. A sufficiently covered empty result establishes no match only within its stated
      scope; a failed or partial result does not establish source-wide absence.
    search: Provide a way to find Repositories within available discovery and return to the broader available
      scope. A search over an incompletely observed subset does not prove there are no source matches.
      Matching, supported fields, ordering and whether search runs at the source remain open.
    identity: Use supported Repository identity under 0038 for selection and reconciliation. A name or
      address alone does not prove identity, and insufficient identity evidence remains unresolved rather
      than silently selecting or merging a different Repository.
    pending: A pending selection is distinct from a visible search subset and from saved Project membership.
      Search changes, refresh, pagination or temporary failure do not silently discard a confirmed pending
      choice. Provide a way to inspect and explicitly remove choices; selection alone neither creates
      a Project nor proves present source access under 0045. A choice retains its source account and intended
      operation; it is not silently relabeled or submitted under another account or setup intent. Exact
      retention and disclosure after an account change remain open.
    late_responses: Retain each response’s actual source, account and query context. A result for an earlier
      search is not presented as the current query’s complete result or as proof of access for a different
      connection. Make incomplete discovery and failures understandable; treatment of attempts for the
      same query remains a technical refinement.
    admission: Before a selected entry changes Project configuration, establish the identity and applicable
      access required by that operation. Missing evidence remains unresolved; a confirmed denial is not
      a valid prior grant. Keep independently supported outcomes distinct under 0045, without requiring
      batch selection or selecting a particular confirmation flow. Absence from partial discovery is not
      proof of denial, deletion or deselection; preserve a pending choice separately from its unresolved
      eligibility and offer an applicable retry or recovery when available.
    revoked_private: When GitHub explicitly confirms access revocation for a private Repository for the
      relevant account, already saved local Repository data remains visible as last known with a revocation
      indication and supported update time when known; synchronization stops under 0019. An earlier in-flight
      response cannot silently restart sync or become a newly accepted update. Retained local visibility
      is not renewed source access or sufficient admission for a new operation. Other account-change disclosure
      beyond 0019 and treatment of unsaved pending data in other circumstances remain open.
    accessibility: Make search scope, available choices, incomplete discovery and applicable errors understandable
      without relying solely on color or transient feedback.
  scenarios:
    partial_search: Discovery has returned only a partial subset and a local search finds no match. Explain
      the incomplete scope instead of claiming no Repository matches at the source; clearing search retains
      its own coverage and pending choices.
    selection_across_search: A supported Repository is selected and then omitted from a narrower query.
      It remains a pending choice until explicitly removed; no Project has been saved solely by selecting
      it.
    superseded_query: Search B is current after search A was issued. A's later response is not relabeled
      as B's result or evidence of B's coverage.
    same_query_retry: A retry for the same query yields incomplete eligibility evidence. Keep the incompleteness
      visible rather than presenting an unconfirmed list as complete.
    revoked_before_processing: The relevant account remains active throughout this scenario. If the chosen
      flow supports multiple pending choices, two independently selected Repositories have different access
      outcomes. GitHub confirms private access revocation for one relevant account. Its already saved
      local data remains visible as last known with indication and supported time when known, while its
      old grant does not authorize a new operation; the other entry retains its own supported outcome.
    partial_recheck: If multiple choices are supported, A is independently eligible while B is absent
      from a partial response. B remains selected and unresolved rather than denied or deleted; A may
      proceed where the selected operation supports it, with the limitation and available recovery visible.
    account_change: A choice made for an operation under account A is not silently relabeled or submitted
      under account B or a different operation after account change. Its local disclosure remains open.
    late_revocation: The relevant account remains active throughout this scenario. After explicit private
      Repository revocation for the relevant account, a response from an earlier discovery attempt arrives.
      It does not silently restart synchronization or become a fresh accepted update, while supported
      saved data remains visible under 0019.
  open_questions:
  - Discovery source, search and pagination semantics, permission scope and per-entry admission evidence.
  - Multi-selection, confirmation flow and pending-selection behavior after account changes.
  - Native presentation of coverage, failure, selection and recovery.
  ontology_status: User, GitHub, Repository and Project use selected ontology vocabulary; queries and
    pending choices are interaction state, not new domain entities.
acceptance:
- Discovery identifies its supported scope and distinguishes incomplete or failed results from confirmed
  empty results.
- Selection retains supported Repository identity and survives a changed visible search subset without
  silently saving a Project.
- Earlier responses are not presented as another query or connection, and insufficient identity or access
  remains unresolved.
- Pending choice and operation intent are not silently relabeled or submitted under another account or
  intent.
- Saved private data stays visible as last known after confirmed revocation with indication and supported
  time when known; sync stops, an earlier response does not silently restart it, and visibility does not
  authorize a new operation. Visibility and local access follow the active-account and A-to-B boundary
  in 0019.
- Search, available choices and discovery limitations are accessible without color or transient feedback
  alone.

```

## GITVIEW-SPEC-0062: GitView - Independent review attention conditions

Источник `specs/nodes/GITVIEW-SPEC-0062.yaml`, SHA-256 `3a175e706a48c5788194ad084c6d3df7c64df9ead793f498353fc1806bcc791d`

```yaml
id: GITVIEW-SPEC-0062
title: GitView - Independent review attention conditions
kind: spec
created_at: '2026-11-16T08:49:00Z'
updated_at: '2026-11-16T19:49:26Z'
status: specified
refines:
- GITVIEW-SPEC-0028
depends_on:
- GITVIEW-SPEC-0008
- GITVIEW-SPEC-0011
- GITVIEW-SPEC-0019
- GITVIEW-SPEC-0026
- GITVIEW-SPEC-0037
- GITVIEW-SPEC-0044
- GITVIEW-SPEC-0047
- GITVIEW-SPEC-0057
sources:
  predecessor_draft: docs/drafts/GITVIEW-SPEC-0062.yaml
  predecessor_revision: 9c598dd
  owner_selection: docs/drafts/pull-request-ontology-options.md
  review_wait_meaning_decision: conversation_memory/sketches/gitview/revisions/8cefadc82b764a64b09fd8c3123f2f28/metadata.json
specification:
  ontology_refs:
  - gitview:Metric
  - gitview:Project
  - gitview:Repository
  - gitview:PullRequest
  - gitview:ReviewThread
  objective: Make review-related attention understandable without collapsing review requests, assessment
    and discussion into a single invented state.
  authority_boundary: The owner selected supported review signals and counters. The exact definition of
    awaiting review, long discussion, source mapping and native badges remains open; this node does not
    define merge readiness, require individual thread content or establish implementation readiness.
  requirements:
    requests: Keep supported outstanding review requests distinct from a source review assessment and
      from review-thread counts, each with its applicable source context, observation time when known
      and coverage. An unavailable request collection is not automatically a known empty collection.
    assessment: Show a supported source review assessment without inferring approval from an absent request
      or zero unresolved threads. A source-reported review requirement, absence of reviews and unavailable
      assessment remain distinct where evidence supports them.
    threads: Preserve supported total and unresolved review-thread counts separately. A confirmed unresolved
      thread can support a positive attention signal even if remaining coverage is incomplete; zero observed
      unresolved threads does not establish absence when coverage or resolution evidence is incomplete.
      Outdated and resolved are separate source facts; a supported unresolved thread is not automatically
      treated as resolved or excluded from an all-unresolved count solely because it is outdated. Exact
      source mapping requires verification.
    changes_requested: A source-reported request for changes and the existence of unresolved review threads
      are independent facts. A changes-requested assessment may remain meaningful even if supported thread
      evidence reports zero unresolved threads; do not convert either into approval or merge readiness.
    summary_units: For an applicable Project or Repository signal, distinguish the count of unresolved
      threads from the count of affected PRs. If counts are presented as comparable, retain the same explicitly
      stated PR population and period while preserving their distinct units and coverage. A single PR
      with several unresolved threads is not several distinct PRs. This does not impose that Project population
      on an individual PR overview.
    time_and_revision: Attribute review facts to their supported source time, revision and observation
      context when known. A later PR revision or a recently refreshed unrelated field does not silently
      make an older approval, request or thread count current for that revision.
    uncertainty: Missing, partial, conflicting or stale evidence remains distinguishable from a confirmed
      healthy or zero result. A source-reported review requirement or assignment to the operator is not
      automatically the chosen definition of awaiting review.
    long_discussion: Help the operator notice a review thread that has waited a long time for a reply
      to its latest message. The threshold, how to establish that a reply is awaited, applicable actor
      and evidence remain open; do not treat an old thread, a comment count or missing information alone
      as proof.
    navigation: An actionable review or thread signal opens the corresponding supported work selection
      with its actual Project or Repository scope, condition, lifecycle population and applicable time
      or period under 0047. A count of threads is not automatically the count of resulting PR cards; incomplete
      selection coverage remains discoverable. Exact review or lifecycle predicates remain subject to
      their applicable specification.
    saved_data: Confirmed GitHub revocation of a private Repository does not hide previously saved supported
      review facts under 0019; retain the applicable indication and supported time when known without
      claiming a fresh source result.
    accessibility: Review state and its limitations are understandable without relying on color alone.
      Exact glyphs and native presentation remain open.
  scenarios:
    requested_changes_without_threads: Source review assessment reports changes requested while supported
      thread evidence reports zero unresolved threads. Preserve both facts rather than announcing approval
      or readiness.
    one_pr_many_threads: One PR has three supported unresolved threads. A thread count can be three and
      an affected-PR count one, with their actual scope and coverage.
    partial_thread_coverage: One unresolved thread is confirmed but the rest of the collection is unobserved.
      The positive signal is supported, but the total number and absence of additional unresolved threads
      are not established.
    newer_revision: A previous review approval is supported for an older PR revision, while its applicability
      to the newer revision is unknown. Do not silently present the earlier approval as current.
    waiting_meaning: A review thread has waited a long time for a reply to its latest message. The intended
      attention signal identifies that wait when the required predicate and evidence are established;
      its threshold and responsible actor are not selected here.
  open_questions:
  - Source evidence and exact predicates for awaiting review, review assessment applicability and requested-review
    scope.
  - Threshold and source evidence for establishing a long wait for a reply to the latest review-thread
    message, including applicable actor.
  - Native badges, summaries and incomplete-coverage presentation at each density.
  ontology_status: PullRequest and ReviewThread use selected ontology vocabulary; source review facts
    and presentation signals do not prove an actor's motive or add new domain entities.
acceptance:
- Review requests, assessment and total and unresolved thread counts remain distinct supported facts with
  their own applicable context and coverage.
- Zero visible unresolved threads or zero outstanding requests alone does not establish approval, completed
  review or merge readiness.
- A supported positive unresolved thread can be shown under incomplete coverage without claiming the full
  count or absence of others.
- Thread counts and affected-PR counts are distinct units, and their navigation preserves the supported
  scope and condition.
- Confirmed private Repository revocation does not hide previously saved supported review facts under
  0019.
- The intended long-wait signal concerns an awaited reply to the latest review-thread message; threshold
  and evidence are not silently invented.

```

## GITVIEW-SPEC-0063: GitView - Blocked Issue attention

Источник `specs/nodes/GITVIEW-SPEC-0063.yaml`, SHA-256 `22cdfddfbe32ca1f9abeeecf77594c832d5434de47dc2fdff5bad25467c902e4`

```yaml
id: GITVIEW-SPEC-0063
title: GitView - Blocked Issue attention
kind: spec
created_at: '2026-11-16T08:49:00Z'
updated_at: '2026-11-16T20:19:22Z'
status: specified
refines:
- GITVIEW-SPEC-0039
depends_on:
- GITVIEW-SPEC-0007
- GITVIEW-SPEC-0009
- GITVIEW-SPEC-0019
- GITVIEW-SPEC-0026
- GITVIEW-SPEC-0029
- GITVIEW-SPEC-0044
- GITVIEW-SPEC-0047
- GITVIEW-SPEC-0057
sources:
  predecessor_draft: docs/drafts/GITVIEW-SPEC-0063.yaml
  predecessor_revision: 9c598dd
  owner_selection: docs/drafts/project-summary-proposal.md
  owner_resolution: conversation_memory/sketches/gitview/revisions/6cd4b65fca2645afae721fafe3faba09/metadata.json
specification:
  ontology_refs:
  - gitview:Project
  - gitview:Repository
  - gitview:Issue
  - gitview:Metric
  - gitview:issueBlockedBy
  - gitview:issueBlocks
  objective: Make supported blocked-Issue attention visible without confusing blocker links, source state
    or counts.
  authority_boundary: The selected Project summary includes attention for Issues with open blockers. The
    direct-link interpretation is an agent-authored refinement; exact source mapping, current-state evidence,
    accessible presentation and incomplete-evidence treatment require further refinement. This node does
    not infer actor motives or establish implementation readiness. The owner clarified that a closed affected
    Issue is not included in this blocked-work signal even if its blocker remains open; the blocker is
    considered separately on its own merits. Closure alone does not establish successful completion.
  requirements:
    direction: Distinguish an Issue blocked by another Issue from an Issue that blocks another. A mention,
      parent-child relationship or ordinary link alone does not prove a blocking relationship.
    positive: A supported direct blocked-by relationship, open state of the affected Issue and open state
      of its blocker can establish a positive attention signal only when their observation contexts are
      sufficiently applicable to that claim. Differently timed or stale facts do not by themselves prove
      the relationship and both states were current together. Preserve supported last-known facts and
      their limitations without inventing a current positive.
    scope: Attribute the affected Issue to the selected Project or Repository scope. A supported blocker
      may be outside the originating Project without becoming a member of that Project merely through
      the relationship.
    units: A blocked-Issue summary counts distinct affected open Issues, not blocker links or the number
      of blocking Issues. An Issue with two supported open blockers is still one affected Issue for this
      measurement; one Issue may also contribute to other independent signals.
    uncertainty: Unobserved or incomplete blocker links, unavailable blocker state, uncertain identity
      or partial scope do not establish that an Issue is unblocked or that a Project has zero blocked
      Issues. Preserve the supported observation context and coverage and make the limitation discoverable.
    navigation: An actionable blocked-Issue signal opens the distinct affected open Issues in its supported
      selection, not the blocker Issues merely because they are linked. Preserve the originating Project
      or Repository, supported condition and actual scope under 0047. Do not claim that a count of blocker
      links equals the count of Issue cards or that an incomplete destination is exhaustive.
    saved_data: Confirmed GitHub revocation of a private Repository does not hide previously saved supported
      local facts under 0019; retain the indication and supported observation time when known. Local visibility
      does not prove a current source grant or current blocker state.
    accessibility: The applicable attention state, its uncertainty and available navigation remain understandable
      without relying solely on color.
  scenarios:
    two_blockers: Open Issue A is blocked by two separately supported open Issues. Count A once as an
      affected open Issue, not twice because it has two blockers.
    external_blocker: Open Issue A is in Project P and has a supported open blocker in Repository R outside
      P. The relationship does not make R a Project member; retain the supported source context and applicable
      access limitations.
    unknown_blocker: An Issue's blocked-by relationship is known but the blocker's current state is unavailable.
      Do not claim that the Issue has no open blocker or that the Project has zero blocked Issues.
    reverse_direction: An Issue is known to block another Issue. Do not label the first Issue itself as
      blocked solely from that outward relationship.
    closed_affected_issue: Issue A is closed while its linked blocker B remains open. Do not include A
      in the blocked-work attention count. Consider B separately according to its own state and the applicable
      scope and filters; do not assume it is itself blocked merely because it blocked A.
  open_questions:
  - GitHub source evidence, current-state timing and coverage sufficient for the selected direct-blocker
    predicate.
  - Native presentation of partial blocker evidence and navigation across Project or source boundaries.
  - Account isolation and source-access behavior for unavailable blocker details.
  ontology_status: Issue, Repository and Project use selected ontology vocabulary; a source dependency
    link does not by itself establish an actor's motive or a new domain entity.
acceptance:
- A supported blocked-Issue attention count uses distinct affected open Issues, not the number of blocker
  links.
- Supported blocked-by and blocking directions remain distinguishable, including when a blocker is outside
  the Project.
- Unknown blocker state or incomplete relationship coverage is not treated as a confirmed unblocked Issue
  or a known zero.
- An actionable signal preserves the originating scope and supported condition when opening its selection.
- Confirmed private Repository revocation does not hide previously saved supported local information under
  0019.
- A closed affected Issue does not contribute to the blocked-work attention count even when its blocker
  is open; the blocker is assessed separately.

```

## GITVIEW-SPEC-0064: GitView - Project membership basis for historical metrics

Источник `specs/nodes/GITVIEW-SPEC-0064.yaml`, SHA-256 `d6348dfcaa1d45a9c0d74d23104bb15021f42bce3d86d7448bef59fc84d053dd`

```yaml
id: GITVIEW-SPEC-0064
title: GitView - Project membership basis for historical metrics
kind: spec
created_at: '2026-11-16T11:35:00Z'
updated_at: '2026-11-16T19:55:33Z'
status: specified
refines:
- GITVIEW-SPEC-0030
depends_on:
- GITVIEW-SPEC-0019
- GITVIEW-SPEC-0025
- GITVIEW-SPEC-0044
- GITVIEW-SPEC-0046
- GITVIEW-SPEC-0026
- GITVIEW-SPEC-0068
sources:
  predecessor_draft: docs/drafts/GITVIEW-SPEC-0064.yaml
  membership_decision: conversation_memory/sketches/gitview/revisions/a55f271ca16f4283bfaf67095616ee7a/notes.hc
specification:
  ontology_refs:
  - gitview:Project
  - gitview:Repository
  - gitview:Metric
  - gitview:projectIncludesRepository
  objective: Keep historical Project graphs interpretable when Project Repository membership changes.
  authority_boundary: The owner selected current Project Repository composition as the basis for historical
    graphs over the selected period. Exact evaluation lifetime, chart behavior, buckets, source evidence
    and historical counters beyond that decision remain open. This does not establish past Project membership
    or a complete source history. When GitHub externally revokes access to a private Repository, the retained-data
    visibility and local access described here apply while the relevant account remains active. Independently
    of revocation, while account B is active, the account-switch boundary in 0019 applies. Behavior after
    returning to A is not selected.
  requirements:
    current_basis: Recalculate a Project historical graph over the selected period using its actual current
      saved Repository composition under 0030. If membership cannot be established, report that limitation
      rather than invent a complete set. Missing source history or revoked access for a current member
      does not silently remove it from the basis; identify coverage and do not describe current members
      as the actual Project membership at past event times.
    changed_membership: Keep each previously produced result attributable to the Repository set and observation
      context it actually used. When membership changes, do not relabel an earlier result as calculated
      for the new set. A current-member graph for the new composition must reassess its own input and
      coverage; missing history is incomplete or a gap, not zero.
    selected_result: A late result for an earlier membership basis cannot replace or be labeled as a separately
      selected new-basis result merely because it finished later. Retain each supported result's own metric,
      scope, period and observation context under 0026 and 0068.
    basis_comparison: A combined A-and-B value does not establish the A-only contribution without compatible
      per-member evidence. Values for A-and-B and A-and-C do not alone establish a same-scope trend or
      a change caused by source activity; keep the changed membership basis explicit.
    history_evidence: A series that claims Project membership at a past time needs independently sufficient
      evidence of that local historical membership. GitHub Repository activity or today's Project configuration
      alone does not establish it. No membership-history store is required by this node.
    bucket_evidence: A merge or closure event, historical state snapshot and distinct-object count have
      different evidence and units under 0030. A known event or current state alone does not prove a complete
      historical series; each bucket requires support for its stated metric and membership.
    saved_data: When GitHub explicitly confirms private Repository access revocation for the relevant
      account, supported previously saved graph values remain locally visible as last known with the revocation
      indication and supported observation times when known under 0019; synchronization stops. Missing
      attribution or lineage remains a visible limitation and does not justify inventing a scope, zero
      or current access. An in-flight response from before revocation is not accepted as a fresh update.
      Other account-change disclosure beyond 0019 and external sharing remain separate open questions.
    accessibility: Make membership basis, period, known coverage and changes understandable without color
      or transient feedback alone.
  scenarios:
    added_member: Project P includes A and B today; B was added today but has source activity last week.
      Last week's Project graph uses the current A-and-B composition and does not claim B was a member
      last week. If B's relevant history is unobserved, affected buckets remain incomplete.
    old_result: A graph for A and B is displayed; membership later changes to A and C. Keep the old graph
      attributed to A and B, and a recalculated current graph to A and C with its own coverage.
    different_basis: An A-and-B historical value is ten and a later A-and-C value is six. Do not describe
      the difference as a same-scope decline of four without independently comparable evidence.
    unknown_past_membership: No record establishes whether B belonged to P last week. A claim about last
      week's actual Project membership remains unknown; today's composition does not prove it.
    revoked_with_missing_lineage: The relevant account remains active throughout this scenario. A supported
      saved graph value remains readable but its retained lineage cannot establish whether it included
      the now-revoked private Repository. Keep the value locally visible as last known with its supported
      context and lineage limitation; do not invent an A-only scope or assert current source access.
  open_questions:
  - Metric-specific source history, periods, buckets, coverage and attribution evidence.
  - Native behavior for recalculation and membership changes while a graph is visible.
  - Other account-change disclosure beyond 0019 and external-sharing policy.
  ontology_status: Project, Repository and Metric use selected ontology vocabulary; graph scope and membership
    basis are measurement context, not new domain entities.
acceptance:
- Historical Project graphs identify actual current saved Repository composition as their basis without
  claiming past membership; unestablished membership and missing input coverage remain limitations.
- Membership changes do not silently relabel an earlier result or turn missing input history into zero.
- An earlier late result does not replace a separately selected result for a different membership basis.
- Saved supported graph values remain visible as last known after confirmed private Repository revocation
  with indication and supported time when known. Visibility and local access follow the active-account
  and A-to-B boundary in 0019.
- Basis, scope and limitations remain accessible without color or transient feedback alone.

```

## GITVIEW-SPEC-0068: GitView - Metric history presentation and navigation

Источник `specs/nodes/GITVIEW-SPEC-0068.yaml`, SHA-256 `e779f4e51a5f24a0efc82aa2dab7d09d70cacaf88de4ec618bdad45f2ad46555`

```yaml
id: GITVIEW-SPEC-0068
title: GitView - Metric history presentation and navigation
kind: spec
created_at: '2026-11-16T08:52:00Z'
updated_at: '2026-11-16T20:00:50Z'
status: specified
refines:
- GITVIEW-SPEC-0013
depends_on:
- GITVIEW-SPEC-0019
- GITVIEW-SPEC-0024
- GITVIEW-SPEC-0029
- GITVIEW-SPEC-0030
- GITVIEW-SPEC-0032
- GITVIEW-SPEC-0047
- GITVIEW-SPEC-0056
- GITVIEW-SPEC-0057
sources:
  predecessor_draft: docs/drafts/GITVIEW-SPEC-0068.yaml
  predecessor_revision: 9c598dd
  owner_selection: docs/drafts/project-summary-proposal.md
specification:
  ontology_refs:
  - gitview:User
  - gitview:Project
  - gitview:Repository
  - gitview:PullRequest
  - gitview:Issue
  - gitview:Metric
  - gitview:projectIncludesRepository
  objective: Let the operator inspect available Project metric history and move to supported related work
    without losing the measurement context.
  authority_boundary: Project graphs and supported signal navigation follow the owner-selected direction.
    Exact chart design, available historical ranges, gestures, source history and implementation remain
    open; this node does not establish implementation readiness or a formal burn-down metric.
  requirements:
    entry: Make available supported metric history from its actual Project context. Preserve the selected
      Project, measurement, period and source scope; do not silently substitute another Project that shares
      a Repository.
    measurement: Identify the supported series subject, unit, condition, period, observation context and
      coverage. When values are bucketed, make their supported boundaries and time-zone interpretation
      discoverable when known; unknown context remains a limitation. A Project historical graph identifies
      current Project membership as its basis under 0030 and 0047; it does not claim to reconstruct Project
      membership at the historical time.
    membership_change: If Project membership changes while a graph remains open, preserve and identify
      the basis of the existing graph without calling it the new current composition. Recalculate against
      the newly current membership when supported or expose the applicable limitation; exact timing remains
      open.
    gaps: Keep a confirmed zero distinguishable from unobserved history and incomplete coverage in both
      visual and accessible representations. Do not fabricate a complete total, an exact missing count
      or a source event from a gap.
    selected_point: If an available historical outcome offers navigation to related work, preserve its
      supported event condition, object type, period boundaries and time-zone interpretation when known,
      Repository basis and Project origin under 0056. When that selection cannot be supported, expose
      the limitation rather than silently switching to Today or a different period.
    units: Distinguish event counts, distinct PR or Issue counts, check counts and the number of resulting
      object cards. One object can correspond to more than one historical event; a point and destination
      observed at different times do not automatically have equal counts. A later selection with the same
      count is not the exact original contributor set unless identity evidence supports that claim; otherwise
      preserve its own observation context and coverage.
    filters: 'The selected historical merged-PR counter transition temporarily overrides a conflicting
      saved merged exclusion under 0047 and 0056 without rewriting the saved preference. Other signal
      transitions follow the actual origin filter context under 0092: filters within that scope apply;
      unrelated filters outside it do not narrow the result. Exact filter hierarchy, controls and return
      behavior remain open.'
    saved_data: Confirmed GitHub revocation of a private Repository does not hide a previously saved supported
      local series under 0019. Retain its actual scope, supported time when known, coverage and applicable
      indication; do not present it as newly current. Visibility follows the active-account and A-to-B
      boundary under 0019.
    return: Returning from metric history or its selection preserves valid originating Project context
      under 0024. Displaying or leaving history does not itself change source objects, membership or saved
      filter preferences.
    accessibility: Provide a way to inspect supported values, scope, period, coverage and available navigation
      without relying solely on color, chart position or a particular gesture under 0032.
  scenarios:
    partial_history: A selected Project metric has supported values for some periods and missing evidence
      for another. Distinguish the gap from confirmed zero and keep the applicable coverage discoverable.
    historical_transition: In the selected case, the counter’s originating scope includes merged PRs and
      the saved merged exclusion is outside that scope. The operator opens a supported merged-PR outcome
      for a period. Preserve the historical condition and temporarily override that unrelated exclusion
      without rewriting the preference.
    membership_basis: A Repository is added today with supported activity from an earlier month. The historical
      graph uses current Project composition and identifies that basis without claiming that Repository
      was a member in the earlier month.
    changed_result: A graph point and the subsequently opened object selection come from independently
      observed contexts with different supported coverage. Preserve both contexts rather than manufacturing
      equality or asserting that either is complete.
  open_questions:
  - Exact native chart presentation, period controls, accessible interaction and field priorities.
  - Supported source history, measurement predicates and evidence for each graph or outcome.
  - Handling of origin or membership changes during an already open historical selection beyond the supported
    captured context.
  ontology_status: Project, Repository, PullRequest, Issue and Metric use selected ontology vocabulary;
    graph, point and navigation are presentation and measurement concepts.
acceptance:
- Available metric history preserves its originating Project, supported measurement and selected period.
- Series scope, unit, current-membership basis and applicable coverage are distinguishable; an unobserved
  gap is not presented as a confirmed zero.
- An actionable historical outcome preserves its supported origin and event condition or exposes a limitation
  rather than silently becoming Today.
- Event or check counts are not silently equated with distinct PR or Issue card counts.
- For the selected merged counter whose origin includes merged PRs and whose saved exclusion is outside
  that origin, the transition preserves the limited temporary filter override without rewriting the saved
  preference.
- Supported history and limitations are accessible without reliance solely on color, chart position or
  a particular gesture.

```

## GITVIEW-SPEC-0072: GitView - Project overview order and position

Источник `specs/nodes/GITVIEW-SPEC-0072.yaml`, SHA-256 `da5ce60eae49c705081d852e6bcffde3e500471ab29fda3844dc4fd5a6297497`

```yaml
id: GITVIEW-SPEC-0072
title: GitView - Project overview order and position
kind: spec
created_at: '2026-11-16T11:18:00Z'
updated_at: '2026-11-16T20:00:50Z'
status: specified
refines:
- GITVIEW-SPEC-0047
depends_on:
- GITVIEW-SPEC-0019
- GITVIEW-SPEC-0023
- GITVIEW-SPEC-0024
- GITVIEW-SPEC-0025
- GITVIEW-SPEC-0032
- GITVIEW-SPEC-0036
- GITVIEW-SPEC-0073
sources:
  predecessor_draft: docs/drafts/GITVIEW-SPEC-0072.yaml
  ux_direction: docs/drafts/ux-zoom-levels-proposal.md
specification:
  ontology_refs:
  - gitview:projectIncludesRepository
  - gitview:User
  - gitview:Project
  - gitview:Repository
  objective: Keep Projects identifiable and the overview position understandable across updates and navigation.
  authority_boundary: Project overview and identity-preserving navigation are selected. Stable relative
    order across ordinary refresh and density changes is an agent-authored refinement; initial sort, insertion
    order, manual ordering and cross-device synchronization are not selected. When GitHub externally revokes
    access to a private Repository, the retained-data visibility and local access described here apply
    while the relevant account remains active. Independently of revocation, while account B is active,
    the account-switch boundary in 0019 applies. Behavior after returning to A is not selected.
  requirements:
    identity: Represent each supported saved Project by its identity, not a Repository name or cell position.
      A source refresh, Repository rename or membership edit does not by itself create a different Project.
      An unknown setup result does not itself prove that a Project was saved.
    continuity: Ordinary source refresh or density changes do not themselves reorder existing Projects;
      changing counts is not automatically an urgency sort. Adding or removing a Project does not duplicate
      or reidentify others. This does not establish an initial sort rule.
    return_position: On return from a Project, maintain its identity as a position or focus anchor when
      present and available under 0024 and 0073. The same Project may occupy a different cell or viewport
      coordinate after reflow.
    missing_anchor: If an anchor is unavailable, preserve the actual context and use a supported fallback
      without presenting a different Project as the original. An incomplete collection read does not prove
      the missing Project was deleted or that a proposed fallback is its definitive successor.
    ordering_unavailable: If Projects are readable but ordering information is unavailable or inconsistent,
      preserve access to supported Projects and make the ordering limitation discoverable. Do not claim
      the earlier order was restored or infer an empty collection solely from missing order information.
      The fallback ordering rule remains open.
    interaction: Preserve a coherent active gesture or accessible interaction where feasible as the collection
      changes. The exact native transition and timing remain open under 0073.
    revoked_private: On GitHub-confirmed access revocation for a private Repository for the relevant account,
      previously saved Project name and supported Repository data remain visible and accessible as last
      known with indication and supported update time when known under 0019; do not defer that indication
      until a gesture or reordering finishes. Synchronization of the affected Repository stops while revocation
      applies; a late response cannot silently restore access or become a newly accepted update. Other
      independently eligible Repositories may continue synchronizing.
  scenarios:
    refresh_on_return: Projects P, Q and R are in an overview; Q is opened. R's attention count changes
      on refresh. Returning retains Q as anchor where available and does not reorder Projects merely because
      R's count changed.
    partial_read: Q was opened from the overview, but only P is readable when returning and the collection
      read is incomplete. P may be navigable, while Q is not declared deleted or replaced by P; the limitation
      and recovery remain discoverable.
    revoked_during_gesture: The relevant account remains active throughout this scenario. A saved Project
      name derived from a private Repository is visible during a gesture when revocation is confirmed.
      Keep the name available with indication and supported time when known without claiming restored
      source access.
    shared_repository: Projects P and Q share private Repository R. A valid edit of P's membership does
      not reidentify or delete Q; if GitHub confirms revocation of access to R for the relevant account,
      the affected saved R data stays visible as last known and both Projects retain their own identities,
      while other eligible Repositories may continue synchronizing.
  open_questions:
  - Initial order, deterministic fallback policy, user-controlled sorting and cross-device ordering.
  - Platform-specific layout, focus and transition behavior.
  - Other account-change disclosure beyond the selected A-to-B rule in 0019.
  ontology_status: Project and Repository use selected ontology vocabulary; position and ordering are
    interface concepts, not new domain entities.
acceptance:
- Existing Projects retain supported identity and stable relative order through ordinary refresh or density
  changes.
- Returning to a present Project restores a meaningful identity anchor without treating its old position
  as identity.
- A missing anchor or unavailable order is communicated without fabricating deletion or substituting another
  Project.
- Saved Project and affected Repository details remain visible as last known after GitHub-confirmed private
  Repository revocation for the relevant account with indication and supported update time when known;
  synchronization stops while revocation applies. Visibility and local access follow the active-account
  and A-to-B boundary in 0019.
- Overview navigation and its limitations remain accessible without depending only on gesture or color.

```

## GITVIEW-SPEC-0073: GitView - Accessible focus during overview updates

Источник `specs/nodes/GITVIEW-SPEC-0073.yaml`, SHA-256 `f0fba40bb0f7c5eea1b4444da88793bdca7ce7ba9a9ea1bdc065dafac49f8dc0`

```yaml
id: GITVIEW-SPEC-0073
title: GitView - Accessible focus during overview updates
kind: spec
created_at: '2026-11-16T11:14:00Z'
updated_at: '2026-11-16T20:00:50Z'
status: specified
refines:
- GITVIEW-SPEC-0032
depends_on:
- GITVIEW-SPEC-0019
- GITVIEW-SPEC-0024
- GITVIEW-SPEC-0027
- GITVIEW-SPEC-0031
- GITVIEW-SPEC-0036
- GITVIEW-SPEC-0042
- GITVIEW-SPEC-0049
sources:
  predecessor_draft: docs/drafts/GITVIEW-SPEC-0073.yaml
specification:
  ontology_refs:
  - gitview:User
  - gitview:Project
  - gitview:Repository
  - gitview:PullRequest
  - gitview:Issue
  objective: Preserve meaningful accessible navigation when overview content, scope or data status changes.
  authority_boundary: Accessible navigation and saved-data visibility after confirmed private Repository
    revocation are selected. Specific focus APIs, ordering mechanics and announcement timing remain open;
    this node does not establish actual device accessibility. When GitHub externally revokes access to
    a private Repository, the retained-data visibility and local access described here apply while the
    relevant account remains active. Independently of revocation, while account B is active, the account-switch
    boundary in 0019 applies. Behavior after returning to A is not selected.
  requirements:
    identity: Keep the inspected object's supported identity and scope distinct from a cell position,
      reused name or Repository-local number. If it remains in the collection after reorder or density
      change, maintain or restore an accessible path to that same object where feasible.
    uncertainty: When selection evidence becomes uncertain, keep an available object inspectable through
      the uncertain selection or an equivalent path under 0042, subject to applicable disclosure context.
      Confirmed private Repository revocation does not hide saved data under 0019; other account-change
      disclosure beyond the selected A-to-B rule in 0019 remains open. Disclose uncertainty rather than
      announcing a confirmed match or exclusion solely from missing evidence.
    removal: If the object no longer belongs to the active collection, use an appropriate surviving anchor
      or collection-state fallback under 0024 without describing a different object as the original. An
      already open preview retains its identity under 0031; apply fallback on return.
    status: Make relevant refresh failure, incomplete coverage and Today period changes discoverable in
      the accessible context or a status route without relying only on transient feedback or color. A
      completed request is not proof of complete coverage.
    active_interaction: Avoid disruptive changes while the operator is actively inspecting or navigating
      when a coherent presentation is possible; subsequently reconcile the applicable collection without
      indefinite deferral. No exact animation or announcement timing is selected.
    revoked_private: On confirmed private Repository revocation, keep saved content accessible with a
      revocation indication and supported update time when known under 0019, without waiting for a reordered
      collection. Stop synchronization and keep recovery or explicit local deletion reachable.
    source_context: A retained focus anchor does not prove that a newly active source account has access.
      Do not silently attribute it to another object. Other local disclosure after account change beyond
      the selected A-to-B rule remains open under 0019; confirmed revocation retains its selected visibility.
  scenarios:
    reordered_pr: A user inspecting PR 42 in Repository B encounters a reorder while Repository A also
      contains PR 42. Preserve a route to B's same PR, not the item now occupying its old position.
    uncertain_filter: A focused PR's previously confirmed CI selection becomes uncertain. Keep its identity
      inspectable with the uncertainty, without claiming a confirmed inclusion or exclusion.
    revoked_during_interaction: The relevant account remains active throughout this scenario. A saved
      private PR is focused while collection rearrangement is deferred. When revocation is confirmed,
      retain saved content and make the indication and known time available without waiting for rearrangement;
      provide recovery or explicit local deletion.
    status_after_cue: After a transient refresh-error cue disappears, the affected scope, failure and
      supported last successful observation remain discoverable through the accessible status route.
  open_questions:
  - Platform focus restoration, announcement timing and behavior under assistive technologies.
  - Presentation and grouping of uncertain selections.
  - Other local disclosure after account changes beyond the selected A-to-B rule in 0019.
  ontology_status: Project, Repository, PullRequest and Issue use the selected ontology vocabulary; focus
    and announcements are interaction concerns rather than new domain entities.
acceptance:
- Reordering or reflow does not substitute an object for another at the previous position.
- Uncertain selection and incomplete coverage remain accessible without inventing exclusions or counts.
- When the focused object leaves the collection, a supported fallback does not misidentify another object
  as it.
- Confirmed revocation leaves saved content accessible with the indication and supported update time when
  known. Visibility and local access follow the active-account and A-to-B boundary in 0019.
- Relevant errors and period changes remain discoverable without requiring transient feedback or color.

```

## GITVIEW-SPEC-0074: GitView - Overview levels and scope transitions

Источник `specs/nodes/GITVIEW-SPEC-0074.yaml`, SHA-256 `61047b6870de8a5edc4ba080dbbdf6cb8397d7d6d3f6a5e120ab4cb55a09f652`

```yaml
id: GITVIEW-SPEC-0074
title: GitView - Overview levels and scope transitions
kind: spec
created_at: '2026-11-16T08:44:00Z'
updated_at: '2026-11-16T19:55:33Z'
status: specified
refines:
- GITVIEW-SPEC-0006
depends_on:
- GITVIEW-SPEC-0005
- GITVIEW-SPEC-0007
- GITVIEW-SPEC-0014
- GITVIEW-SPEC-0019
- GITVIEW-SPEC-0024
- GITVIEW-SPEC-0032
- GITVIEW-SPEC-0035
- GITVIEW-SPEC-0047
sources:
  predecessor_draft: docs/drafts/GITVIEW-SPEC-0074.yaml
  predecessor_revision: 9bbf79f
  owner_selection: docs/drafts/project-summary-proposal.md
  ux_candidate: docs/drafts/ux-zoom-levels-proposal.md
  multi_repository_entry_decision: conversation_memory/sketches/gitview/revisions/35c247299c0b447dbe280e0d9a3bfbd9/metadata.json
  pinch_scope_decision: conversation_memory/sketches/gitview/revisions/408e46cab5da424d829e0ce07503fd28/metadata.json
  signal_filter_context_decision: conversation_memory/sketches/gitview/revisions/9544eaa87e5b4afcb48910299d60c520/metadata.json
  calendar_farthest_zoom_direction: conversation_memory/sketches/gitview/revisions/a854ef50dc2a4548b9003227f731e31e/metadata.json
specification:
  ontology_refs:
  - gitview:User
  - gitview:Project
  - gitview:Repository
  - gitview:PullRequest
  - gitview:Issue
  - gitview:projectIncludesRepository
  objective: Let the operator move from an overview of Projects into the relevant Repository or work scope
    without losing identity or navigation context.
  authority_boundary: Single-Repository entry, Project-wide work entry for a multi-Repository Project,
    member list in Project settings and actionable signal navigation are selected. Exact native transitions,
    target anchoring and layout remain open; this node does not establish implementation readiness. When
    GitHub externally revokes access to a private Repository, the retained-data visibility and local access
    described here apply while the relevant account remains active. Independently of revocation, while
    account B is active, the account-switch boundary in 0019 applies. Behavior after returning to A is
    not selected.
  requirements:
    single_repository: A Project with one Repository reaches that Repository's work without a redundant
      intermediate Repository screen. Project and Repository remain distinct, with their supported identities
      and context available.
    multiple_repositories: A Project with several Repositories allows the operator to inspect its members
      and reach the work of each. Repositories can come from different GitHub organizations; organization
      is metadata, not an implicit Project boundary.
    signal: An actionable Project summary signal can open its corresponding work across the applicable
      member scope without requiring a Repository-by-Repository detour. Preserve the originating Project,
      signal condition, applicable period and each object supported Repository context; incomplete evidence
      does not establish an exhaustive selection. For the selected historical merged-PR counter transition,
      apply the temporary conflicting merged-filter override under 0047 without rewriting the saved preference;
      other signals follow their own originating filter context under 0092. The previously selected historical
      merged-counter case concerns a counter whose originating scope includes merged PRs; a saved exclusion
      outside that origin does not narrow its destination. A counter defined inside a merged-excluding
      scope instead retains that origin scope.
    ordinary_entry: Ordinary entry to a multi-Repository Project opens its Project-wide PR and Issue grid
      across the applicable member scope; the Repository list is available in Project settings. Preserve
      member inspection, per-Repository work and actionable signal routes.
    density: Pinch or an accessible equivalent changes density in discrete steps within the current scope
      under 0035. On reaching the maximum cell size, pinch enters the corresponding next level when the
      intended target is unambiguous under 0014; this intentional transition preserves the selected target
      and its context.
    identity: A Repository shared by several Projects retains the actual Project origin from which it
      was opened. The same name or position does not justify silently substituting another Project or
      Repository.
    saved_data: Confirmed GitHub revocation alone does not hide an already saved local Project, member
      or supported work under 0019. Present the applicable revocation indication and supported time when
      known without claiming restored source access; account isolation and external handoff remain separate
      questions.
    return: Preserve valid originating scope, applicable period, filters and density on return where possible
      under 0024. If an origin or selected object is no longer supported, provide a meaningful applicable
      fallback without silently representing a different Project as the original.
    accessibility: The operator can navigate and inspect applicable Projects, members and work without
      relying solely on pinch, color or a precise tiny target under 0032.
    calendar_direction: The owner envisages further pinch out from Today reaching the daily work-intensity
      calendar under 0018; this is an outward transition and does not alter the maximum-cell-size rule
      for zooming in. Exact interaction and first-version inclusion remain open.
  scenarios:
    single_member: A Project contains one Repository. The operator reaches its PR and Issue work without
      a duplicate intermediate Repository screen and can still identify both Project and source Repository.
    multi_member: A Project contains two Repositories from different organizations. Ordinary entry opens
      one grid with work across the Project; its member list is available in Project settings and each
      member remains inspectable.
    shared_repository: A Repository belongs to Projects A and B and is opened from A. Returning preserves
      A as the originating Project rather than silently switching to B.
    signal_selection: A supported Project failed-CI signal is opened. The destination covers its applicable
      member scope, identifies each supported source Repository and retains the actual condition and coverage
      limitation.
    revoked_member: The relevant account remains active throughout this scenario. GitHub confirms revocation
      for a private member with saved local information. The supported saved member remains accessible
      with its revocation indication and supported time when known; its local visibility is not a GitHub
      grant.
  open_questions:
  - Native scope transitions, focus or position restoration, and gesture interaction across levels.
  - Exact signal predicates, source coverage and response to Project membership changes during an open
    route.
  ontology_status: Project, Repository, PullRequest and Issue use selected ontology vocabulary; visual
    levels and navigation actions are interaction concepts, not newly asserted domain entities.
acceptance:
- A single-Repository Project reaches its work without a redundant intermediate Repository screen while
  retaining both identities.
- A multi-Repository Project permits member inspection and a route to each member's work; organizations
  do not silently redefine Project membership.
- An actionable Project signal reaches its corresponding work across the applicable scope without an individual
  Repository detour and retains its supported condition and source context.
- Before the boundary, density changes preserve scope and filters; an intentional boundary transition
  and return preserve the intended target and applicable context.
- Confirmed private Repository revocation does not hide already saved local Project or member information
  under 0019.
- Ordinary entry to a multi-Repository Project opens its Project-wide work grid, with its member list
  available in Project settings.

```

## GITVIEW-SPEC-0075: GitView - Grid interaction and interruption

Источник `specs/nodes/GITVIEW-SPEC-0075.yaml`, SHA-256 `5bda1edb8c206c9a954ca48854ace2d9d2180dcf24a847e79811cfeb174f9499`

```yaml
id: GITVIEW-SPEC-0075
title: GitView - Grid interaction and interruption
kind: spec
created_at: '2026-11-16T11:42:00Z'
updated_at: '2026-11-16T20:00:50Z'
status: specified
refines:
- GITVIEW-SPEC-0035
depends_on:
- GITVIEW-SPEC-0015
- GITVIEW-SPEC-0019
- GITVIEW-SPEC-0024
- GITVIEW-SPEC-0031
- GITVIEW-SPEC-0032
- GITVIEW-SPEC-0049
- GITVIEW-SPEC-0073
sources:
  predecessor_draft: docs/drafts/GITVIEW-SPEC-0075.yaml
  preview_proposal: docs/drafts/ux-preview-interactions.md
  pinch_scope_decision: conversation_memory/sketches/gitview/revisions/408e46cab5da424d829e0ce07503fd28/metadata.json
specification:
  ontology_refs:
  - gitview:User
  - gitview:Project
  - gitview:Repository
  - gitview:PullRequest
  - gitview:Issue
  objective: Keep scrolling, density changes, static preview and explicit navigation understandable and
    bound to the intended object.
  authority_boundary: Pinch-to-change density and first-version static long-press preview are selected.
    Gesture arbitration, anchoring and interruption are refinements; exact native gestures, timings, thresholds
    and animation remain open. Sliding preview is a later direction, not required here. When GitHub externally
    revokes access to a private Repository, the retained-data visibility and local access described here
    apply while the relevant account remains active. Independently of revocation, while account B is active,
    the account-switch boundary in 0019 applies. Behavior after returning to A is not selected.
  requirements:
    scroll: An ordinary recognized scroll moves the collection without also opening an object or activating
      its preview solely from that interaction.
    density: Pinch changes density through discrete steps within the current scope; on reaching the maximum
      cell-size boundary it triggers a transition to the intended next level under 0014. Grid width and
      maximum cell size in points determine the boundary. A pinch recognized while a press is pending
      does not also activate that pending preview; an ambiguous target is not silently substituted.
    anchor: Preserve a meaningful position or supported object identity through density reflow where feasible;
      an old cell coordinate or another object with the same local number is not identity. If no unambiguous
      object is available, do not invent a selection; use a supported fallback under 0024.
    preview: A recognized long press on an eligible object presents that same object's static preview
      under 0031. Movement over another cell does not alone retarget it or imply the future sliding mode.
      Explicit opening and dismissal retain the established object identity.
    interruption: Cancellation of an unfinished interaction leaves a coherent current overview without
      claiming that an object was opened or another action committed. An independently completed action
      is not retroactively undone solely by a later interruption.
    concurrent_changes: Refresh, day boundary or Project edit may independently alter the selection while
      an interaction is in progress. Do not attribute that change to pinch alone or silently retarget
      a pending action to a different object at the old coordinate. A touch begun without an eligible
      object does not select a newly appearing cell merely because reflow places it under that touch.
      On confirmed private Repository revocation, retain supported saved cells with indication and time
      when known and stop synchronization under 0019 without waiting for gesture completion.
    accessibility: Provide accessible paths to change density, invoke and dismiss preview, and open an
      object without requiring pinch, long press, a timed gesture or color alone under 0032 and 0073.
  scenarios:
    scroll_not_preview: Touching a cell and moving as ordinary scroll before preview activation scrolls
      the collection without opening the cell or presenting its preview.
    pinch_in_scope: Before the maximum-size boundary, a recognized density pinch in a filtered Project
      overview changes density while retaining the scope and filters; it does not open an object.
    competing_press: A press is pending when the same touch sequence is recognized as pinch. The pending
      preview does not activate; before the maximum-size boundary only density changes, and at the boundary
      the intended next-level transition follows 0014.
    empty_touch: A touch begins over empty space and a PR appears under it due to reflow. That existing
      touch does not select or preview the newly appearing PR.
    reordered_cell: A press begins on PR A and a refresh places PR B at A's earlier coordinate. The pending
      interaction may continue for A when valid or cancel; it does not preview B by position.
    interrupted: A density interaction is cancelled before an object-open action. The collection remains
      usable in its valid scope and no object is opened by cancellation.
    revoked_during_gesture: The relevant account remains active throughout this scenario. A saved private
      PR is visible while a density interaction is active. On confirmed GitHub revocation for the relevant
      account, retain the saved cell with indication and supported time when known, stop synchronization
      and retain a local route to recovery or deletion.
    boundary: An expanding cell reaches its maximum size and its intended target is available and unambiguous.
      The transition to the next level occurs; if the target becomes unavailable or ambiguous, the view
      uses a meaningful fallback without substituting another object.
  open_questions:
  - Platform gesture competition, cancellation, timing and anchor geometry.
  - Exact density levels, native animation and feasible accessible alternatives.
  - Target anchoring and reverse transition across scopes, and later sliding preview behavior.
  ontology_status: Project, Repository, PullRequest and Issue use selected ontology vocabulary; gesture
    and focus are interaction concepts, not new domain entities.
acceptance:
- Scroll, density change, static preview and explicit object opening have distinguishable outcomes without
  substituting another object.
- An in-scope pinch preserves the applicable Project, Repository scope, period and filters.
- Cancellation or independent collection changes do not silently open or retarget a different object.
- Saved cells remain visible after confirmed private Repository revocation with indication and supported
  time when known; synchronization stops. Visibility and local access follow the active-account and A-to-B
  boundary in 0019.
- Density changes, preview and object opening have accessible alternatives to pinch, long press and color
  alone.
- Pinch moves through discrete detail levels and enters the intended next level at the maximum cell-size
  boundary when the target is unambiguous under 0014.

```

## GITVIEW-SPEC-0077: GitView - Issue discussion counts and latest comment time

Источник `specs/nodes/GITVIEW-SPEC-0077.yaml`, SHA-256 `8d87837c9b784284ffcd4b75f035f78a6100462901fa4050421355a68a93c6ff`

```yaml
id: GITVIEW-SPEC-0077
title: GitView - Issue discussion counts and latest comment time
kind: spec
created_at: '2026-11-16T11:33:00Z'
updated_at: '2026-11-16T19:59:36Z'
status: specified
refines:
- GITVIEW-SPEC-0039
depends_on:
- GITVIEW-SPEC-0019
- GITVIEW-SPEC-0023
- GITVIEW-SPEC-0026
- GITVIEW-SPEC-0036
- GITVIEW-SPEC-0038
- GITVIEW-SPEC-0044
sources:
  predecessor_draft: docs/drafts/GITVIEW-SPEC-0077.yaml
  selected_fields: docs/drafts/issue-ontology-options.md
specification:
  ontology_refs:
  - gitview:Issue
  - gitview:Repository
  - gitview:Metric
  - gitview:issueRepository
  objective: Make Issue comment and participant counts and the time of the latest comment interpretable
    with their actual scope and evidence.
  authority_boundary: The owner selected comment and discussion-participant counts and the latest comment
    time when available. Exact source mapping and participant population, additional comment-author metrics,
    source permissions and native presentation remain open. This node does not require showing individual
    comments or participants or establish live GitHub behavior. When GitHub externally revokes access
    to a private Repository, the retained-data visibility and local access described here apply while
    the relevant account remains active. Independently of revocation, while account B is active, the account-switch
    boundary in 0019 applies. Behavior after returning to A is not selected.
  requirements:
    separate_units: Keep comment count, participant count and latest-comment time distinct with their
      supported Issue identity, source, population, scope and observation context. Issue comments are
      not PR review threads, and comment count does not by itself establish participant count.
    population: An observed current population is not automatically a complete history of deleted, hidden
      or otherwise unobserved discussion. A source-provided aggregate can support a count only when its
      documented population, scope, time and available evidence match that claim. A partial enumerated
      subset is not added to an aggregate as if independently disjoint.
    participant_semantics: Preserve the actual source-supported meaning of a participant count; do not
      present a narrower source population as every person, agent or actor without evidence of equivalence.
      Whether a separate distinct comment-author count is useful remains open.
    incomplete: Unknown, unavailable or incomplete discussion data is not a confirmed zero. Sufficient
      evidence for one count does not by itself establish the other count or a latest-comment time; retain
      each available observation and its own limitation.
    latest: An exact latest-comment time is the maximum supported comment creation instant in the stated
      sufficiently covered population, not the Issue's update time, GitView observation time or the time
      an older comment was edited. A maximum observed in an incomplete subset is not automatically the
      latest in the whole Issue and retains its subset limitation.
    freshness: A new title or unrelated Issue update does not refresh an earlier discussion count or latest-comment
      time. Retain each supported value's own time and context under 0044 and 0026.
    saved_data: When GitHub explicitly confirms private Repository access revocation for the relevant
      account, previously saved discussion values remain locally visible as last known with revocation
      indication and supported update time when known; synchronization stops under 0019. No live source
      access is implied, and an unknown time is not invented.
    accessibility: Make selected counts and latest-comment time, their distinct meanings, applicable limitations
      and known absence versus unknown understandable to assistive technology and without color or transient
      feedback alone.
  scenarios:
    separate_counts: A supported Issue comment count is three while participant data is unavailable. Show
      three with its context and the participant count as unknown, not three or zero.
    edited_comment: Comment A was created at T1 and edited at T3; comment B was created at T2 between
      them. A's edit does not become a new comment at T3; B establishes latest creation only if the applicable
      population and evidence are sufficient.
    partial_latest: One observed comment was created at T1 but remaining discussion is unobserved. T1
      may be described as latest within the observed subset, not confirmed latest for the whole Issue.
    known_empty: A sufficiently supported current comment population is empty. Comment count can be zero
      and latest-comment time known absent; this does not establish that no comments ever existed.
    revoked: The relevant account remains active throughout this scenario. Previously saved private Issue
      counts remain visible as last known after confirmed revocation with indication and supported time
      when known, without implying fresh synchronization.
  open_questions:
  - Participant population and exact GitHub source mapping, permissions, pagination and evidence of coverage.
  - Whether to show a separate count of distinct comment authors and its population.
  - Native representation of unavailable, partial and last-known values.
  ontology_status: Issue, Repository and Metric use selected ontology vocabulary; counts do not introduce
    a new domain entity or identify an actor's motive.
acceptance:
- Issue comments, participants and latest-comment time retain distinct units, supported context and limitations.
- Missing or incomplete evidence for one value is not silently turned into zero or inferred from another
  value.
- Exact latest-comment time is the supported maximum creation instant in its sufficiently covered population,
  distinguished from Issue update, observation and later comment edit times.
- Saved discussion values remain visible after confirmed private Repository revocation with indication
  and supported update time when known. Visibility and local access follow the active-account and A-to-B
  boundary in 0019.
- Counts, latest-comment time, known absence and uncertainty remain accessible without color or transient
  feedback alone.

```

## GITVIEW-SPEC-0078: GitView - Issue links, hierarchy and partial observations

Источник `specs/nodes/GITVIEW-SPEC-0078.yaml`, SHA-256 `f7285f3cf049dcff6dd35b15e6f4e1c76622921223f3fa85790be9dd24764f97`

```yaml
id: GITVIEW-SPEC-0078
title: GitView - Issue links, hierarchy and partial observations
kind: spec
created_at: '2026-11-16T11:30:00Z'
updated_at: '2026-11-16T19:59:36Z'
status: specified
refines:
- GITVIEW-SPEC-0039
depends_on:
- GITVIEW-SPEC-0019
- GITVIEW-SPEC-0024
- GITVIEW-SPEC-0033
- GITVIEW-SPEC-0036
- GITVIEW-SPEC-0038
- GITVIEW-SPEC-0044
- GITVIEW-SPEC-0026
- GITVIEW-SPEC-0063
sources:
  predecessor_draft: docs/drafts/GITVIEW-SPEC-0078.yaml
  selected_fields: docs/drafts/issue-ontology-options.md
  ontology_boundary: ontology/review/issue-pr-meaning-candidate.md
specification:
  ontology_refs:
  - gitview:Issue
  - gitview:PullRequest
  - gitview:Repository
  - gitview:Project
  - gitview:Metric
  - gitview:issueRepository
  - gitview:issueClosingPullRequest
  - gitview:issueMentionedPullRequest
  - gitview:issueParent
  - gitview:issueSubIssue
  - gitview:issueBlockedBy
  - gitview:issueBlocks
  objective: Preserve the meaning, direction and limitations of selected Issue links and direct-child
    counts without treating an observed link as an actor's motive.
  authority_boundary: The owner selected Issue relationship categories and an overview with source handoff.
    Exact GitHub mappings, coverage, presentation and broader relationship history require separate evidence.
    This node does not establish an actor action, motive or source implementation. When GitHub externally
    revokes access to a private Repository, the retained-data visibility and local access described here
    apply while the relevant account remains active. Independently of revocation, while account B is active,
    the account-switch boundary in 0019 applies. Behavior after returning to A is not selected.
  requirements:
    distinct_links: Preserve supported PR mentions, closing references, parent, direct child, blocked-by
      and blocking connections as distinct directional source facts. A mention does not alone prove a
      closing reference, completion, actor's motive or causal history. The same confirmed target can retain
      multiple supported link meanings without becoming multiple target identities under 0039.
    observed_context: Associate each link with supported source and target identity, type, direction,
      scope, observation time and coverage when known. Absence from a partial or inaccessible collection
      is not confirmed absence; a refreshed title does not automatically refresh previously observed links.
    children: Count supported distinct direct sub-Issues and their closed subset separately. A grandchild
      is not a direct child solely through its parent; a closed child is not necessarily completed work.
      Evaluate evidence for the total and closed subset separately. A complete list of distinct direct
      children can establish total even when one child's state is unknown, but cannot by itself establish
      an exact closed count. An independently supported source aggregate may establish a count only for
      the compatible population, state, access and time it actually covers. Incomplete evidence for a
      particular count is not an exact total or zero.
    dependency: A supported blocked-by link and the linked Issue's current lifecycle are separate facts.
      A link alone does not prove a blocker is currently open; preserve uncertain coverage under 0063.
    navigation: A supported linked object retains its own Repository identity and originating context.
      Opening it does not silently add its Repository to the originating Project or substitute a same-number
      object in another Repository. Returning preserves the valid origin under 0024; source handoff follows
      0033.
    changing_links: If an observed link changes or disappears, retain its supported observation context;
      do not present an earlier link as current without sufficient evidence. A link change does not by
      itself prove that either object was deleted or change Project membership.
    saved_data: Confirmed GitHub revocation of private Repository access for the relevant account does
      not hide already saved local Issue, linked-object or relationship data under 0019. Show supported
      saved information as last known with revocation indication and supported update time when known;
      stop syncing the affected Repository. Local visibility does not restore source access. Other account-change
      disclosure conditions remain open.
    accessible: Make supported link meaning, direction, partial coverage and available navigation understandable
      without relying only on color or a transient cue.
  scenarios:
    dual_meaning: The same confirmed PR is both mentioned and identified by a closing reference. Show
      one target with both supported meanings, without inferring an actor's motive or that it merged.
    incomplete_children: Two direct children are observed, one closed and one with unknown state, while
      relationship coverage is incomplete. The partial list alone does not establish two as the exact
      total; do not present the unknown state as open. Neither observed closure alone proves completion.
    complete_children_unknown_state: A complete identity-supported list contains two direct children,
      one closed and one with unknown state. Total may be two while the exact closed count remains unknown;
      an independently supported source aggregate may establish a closed count within its own scope.
    outside_project: An Issue in Project P has a supported link to an object in Repository B outside P.
      Retain B's identity and the origin when navigating; do not add B to P merely by following the link.
    revoked_target: The relevant account remains active throughout this scenario. A linked private target
      is already saved locally and GitHub confirms access revocation for its Repository and relevant account.
      The saved target remains locally available with indication and supported update time when known,
      without claiming a fresh grant or substituting another target.
    stale_links: A link was observed at T1; a later response at T2 updates only the Issue title. Retain
      the link's own T1 context rather than calling it refreshed or removed at T2.
  open_questions:
  - Source-specific link types, access, pagination and evidence for direction and current coverage.
  - Native presentation and navigation for partial links and linked objects outside a Project.
  - Other disclosure after account change beyond the selected A-to-B rule in 0019.
  ontology_status: Issue, PullRequest, Repository and Project use selected ontology vocabulary. Source
    links do not establish the actor-action-derived relation or motivation without supporting evidence.
acceptance:
- Supported Issue links retain type, direction, identities and their observation limitations without asserting
  motive or completion.
- Direct-child totals do not include grandchildren by implication or convert closed counts into completion.
- Partial coverage is not treated as a confirmed empty or complete relationship set.
- Navigating to a supported linked target does not silently change Project membership or substitute another
  object.
- Saved supported linked data stays visible after confirmed private Repository revocation with indication
  and supported time when known. Visibility and local access follow the active-account and A-to-B boundary
  in 0019.

```

## GITVIEW-SPEC-0089: GitView - Temporal context of Today and filter evidence

Источник `specs/nodes/GITVIEW-SPEC-0089.yaml`, SHA-256 `b14715891d022f15eabc3e3cef402374bbc3397e11710f8d1f37ad7e3f6c3405`

```yaml
id: GITVIEW-SPEC-0089
title: GitView - Temporal context of Today and filter evidence
kind: spec
created_at: '2026-11-16T11:44:00Z'
updated_at: '2026-11-16T20:05:42Z'
status: specified
refines:
- GITVIEW-SPEC-0027
depends_on:
- GITVIEW-SPEC-0019
- GITVIEW-SPEC-0024
- GITVIEW-SPEC-0028
- GITVIEW-SPEC-0037
- GITVIEW-SPEC-0042
- GITVIEW-SPEC-0044
- GITVIEW-SPEC-0049
- GITVIEW-SPEC-0026
sources:
  predecessor_draft: docs/drafts/GITVIEW-SPEC-0089.yaml
  owner_local_day: conversation_memory/sketches/gitview/revisions/3077fdcd9a8247769def8d6403c2e61c/notes.hc
specification:
  ontology_refs:
  - gitview:pullRequestRepository
  - gitview:Project
  - gitview:Repository
  - gitview:PullRequest
  - gitview:Issue
  - gitview:CIStatus
  objective: Preserve the meaning of Today inclusion and active filters when their source observations
    refer to different times or revisions.
  authority_boundary: Today includes earlier unfinished work and work completed during the user's current
    local calendar day under 0027. Other inclusion alternatives, source freshness evidence, time-zone
    change mechanics and native presentation remain open; no arbitrary validity duration is selected.
    When GitHub externally revokes access to a private Repository, the retained-data visibility and local
    access described here apply while the relevant account remains active. Independently of revocation,
    while account B is active, the account-switch boundary in 0019 applies. Behavior after returning to
    A is not selected.
  requirements:
    day: Dynamic Today follows the user's applicable current local calendar day under 0049. A completed
      object does not qualify for a new day solely because it completed on the previous day; other independently
      applicable inclusion conditions may qualify it.
    fact_context: Preserve each supported fact's object, source scope, event time where applicable and
      observation time when supported, plus revision where applicable and coverage. The time an observation
      was retrieved is not automatically the time a source event occurred; refreshing one field does not
      refresh omitted fields.
    inclusion_and_filters: Today inclusion, current lifecycle and each active filter are separate claims.
      A supported inclusion alternative can establish base eligibility without proving a separate active
      filter. An unknown required filter remains uncertain unless another independently applicable false
      required condition decides exclusion under 0027.
    applicability: Do not represent an earlier observation as confirmed for a later requested context
      solely because it was locally read, another field refreshed or no later event is known. Retain its
      supported last-known context and expose applicable uncertainty; source-specific evidence for current
      applicability remains open rather than assuming a universal time-to-live or permanent uncertainty.
    revision: A source-confirmed newer PR revision does not automatically inherit checks or review observations
      from an older revision. Preserve their original context and use independently supported evidence
      when evaluating the current revision under 0028.
    combined: Facts observed at different times are not presented as one confirmed simultaneous snapshot
      without sufficient supporting evidence. Preserving a selected filter or period does not establish
      complete source coverage.
    revoked_private: Confirmed GitHub revocation of private Repository access for the relevant account
      does not hide supported saved facts and values; retain them as last known with indication and supported
      time when known under 0019, and stop synchronization. A late earlier response does not restore access
      or become a newly accepted update.
    accessibility: Make active filters, uncertainty, relevant observation context and incomplete coverage
      discoverable without relying solely on color or transient feedback.
  scenarios:
    event_received_tomorrow: A PR merged yesterday at 23:55 in the user's local time and GitView first
      observes that event today at 00:05. The merge alone does not qualify it for today's completed work;
      retain both supported times and evaluate current lifecycle and filters separately.
    today_and_filter: A supported merge event places a PR in Today, but the active failed-CI filter lacks
      applicable CI evidence. Base eligibility is supported while filter outcome remains uncertain.
    prior_revision: A failed check was observed for PR revision R1; revision R2 is confirmed without applicable
      R2 check evidence. Keep R1 as last known in its context and do not claim a current R2 failure or
      exclusion.
    mixed_time: A PR lifecycle was observed at T1 and a review fact at T2 without evidence of simultaneity.
      Preserve both contexts rather than inventing a shared snapshot time.
    late_revocation: The relevant account remains active throughout this scenario. A saved PR and earlier
      CI observation remain visible as last known when GitHub confirms private Repository revocation;
      a response initiated earlier does not establish fresh access.
  open_questions:
  - Source-specific ordering, revision applicability and evidence for current filter claims.
  - Other Today inclusion alternatives and behavior when the user local time zone changes.
  - Native presentation of uncertain candidates and per-field observation context.
  ontology_status: Project, Repository, PullRequest, Issue and CIStatus use selected ontology vocabulary;
    temporal applicability and filtering are not new domain entities.
acceptance:
- Today retains the selected local-day behavior and does not treat yesterday's completion alone as today's
  work.
- Inclusion, active filter inputs and displayed lifecycle retain their own supported context and limitations.
- Old revision checks and mixed-time observations do not silently become confirmed current or simultaneous
  facts.
- Confirmed private Repository revocation retains supported saved values with indication and supported
  time when known; synchronization stops. Visibility and local access follow the active-account and A-to-B
  boundary in 0019.
- Filter state and uncertainty are discoverable without color or transient feedback alone.

```

## GITVIEW-SPEC-0091: GitView - Work scope as Project membership changes

Источник `specs/nodes/GITVIEW-SPEC-0091.yaml`, SHA-256 `be71aa6d2f5cbca1a380fb5557c50aa2eb285b4fad835d619d6006e0fea20350`

```yaml
id: GITVIEW-SPEC-0091
title: GitView - Work scope as Project membership changes
kind: spec
created_at: '2026-11-16T12:28:00Z'
updated_at: '2026-11-16T19:55:33Z'
status: specified
refines:
- GITVIEW-SPEC-0074
depends_on:
- GITVIEW-SPEC-0019
- GITVIEW-SPEC-0023
- GITVIEW-SPEC-0024
- GITVIEW-SPEC-0025
- GITVIEW-SPEC-0027
- GITVIEW-SPEC-0029
- GITVIEW-SPEC-0031
- GITVIEW-SPEC-0044
- GITVIEW-SPEC-0049
- GITVIEW-SPEC-0073
- GITVIEW-SPEC-0089
sources:
  predecessor_draft: docs/drafts/GITVIEW-SPEC-0091.yaml
  project_model: docs/drafts/project-summary-proposal.md
  multi_repository_entry_decision: conversation_memory/sketches/gitview/revisions/35c247299c0b447dbe280e0d9a3bfbd9/metadata.json
specification:
  ontology_refs:
  - gitview:User
  - gitview:Project
  - gitview:Repository
  - gitview:PullRequest
  - gitview:Issue
  - gitview:projectIncludesRepository
  objective: Preserve the operator's actual Project or Repository work scope as Project membership changes.
  authority_boundary: A Project contains one or more Repositories, and a Repository may belong to several
    Projects. Ordinary entry to a multi-Repository Project is Project-wide; this node distinguishes it
    from an explicitly selected Repository route. When GitHub externally revokes access to a private Repository,
    the retained-data visibility and local access described here apply while the relevant account remains
    active. Independently of revocation, while account B is active, the account-switch boundary in 0019
    applies. Behavior after returning to A is not selected.
  requirements:
    scope_intent: Distinguish a Project-wide work selection from an explicitly selected Repository within
      a Project, even if the Project currently has only one member. Density or source refresh does not
      silently change the chosen scope.
    confirmed_expansion: When a saved membership edit adds Repository B to Project P, an existing P-wide
      selection reevaluates against P's confirmed new member set while retaining the valid Project, period,
      filters and density. Prior complete observations for A alone do not establish B's work or complete
      coverage for A and B under 0044.
    explicit_repository: When the operator is viewing explicitly selected Repository A within P, adding
      B does not silently widen the selection to B. If A is removed from P, do not silently substitute
      B or another Project; identify the changed origin and offer a supported route under 0024.
    confirmed_contraction: A saved membership removal changes the Project-wide scope without proving source
      deletion or erasing independently retained data. Another Project containing the same Repository
      retains its own membership and observation context.
    uncertain_edit: A pending, cancelled before submission, failed or indeterminate edit is not itself
      proof of a new saved membership. An independently confirmed edit can nevertheless change the actual
      Project; if the current configuration cannot be reconciled, keep it uncertain rather than claiming
      complete coverage for either presumed member set under 0025.
    open_object: An already open preview or object that remains available under the applicable context
      stays available with its supported identity through a membership edit; it does not silently become
      a different object. On dismissal or return restore the actual valid in-session origin or explain
      its limitation under 0024 and 0031, without inventing a new intermediate route. This preserves the
      actual origin without changing the selected Project-wide ordinary entry for a later fresh entry.
    access: Confirmed GitHub revocation of private Repository access for the relevant account does not
      hide already saved local Project or Repository information under 0019. Keep its indication and supported
      update time when known, stop syncing the affected Repository and do not claim renewed access.
    accessibility: Make scope changes, incomplete coverage and applicable recovery routes discoverable
      without relying only on color or transient feedback.
  scenarios:
    expanded_project: A Project-wide Today selection for P contains Repository A; a saved edit adds B,
      whose work is unobserved. Preserve P and active period and filters, include B in the scope and mark
      B's work coverage incomplete rather than zero.
    explicit_narrow_scope: The operator explicitly views A within P; a saved edit adds B. The work selection
      remains A until the operator explicitly changes scope.
    removed_origin: P contains A and B, and the operator views B explicitly. A saved edit removes B while
      P remains valid. Explain the changed origin rather than silently opening A or another Project.
    preview_member_replaced: P contains A and an A PR preview is open from P-wide Today. A valid saved
      edit replaces A with B while the preview remains available. Keep the same preview until dismissal;
      then return to the valid P scope for B with its actual coverage or explain a limitation, without
      substituting a B object for the previewed PR or claiming A was deleted from the source.
    direct_route_return: The operator entered P-wide work directly from the portfolio when P had one member;
      P later gains another member. Return to the actual valid portfolio origin rather than inventing
      an intermediate member-overview step; a later ordinary Project entry opens Project-wide work.
    signal_member_change: A failed-CI signal was observed for P members A and B; P changes to A and C,
      whose work is unobserved. Preserve the old signal's A-and-B context and do not label it a complete
      current A-and-C result; any new supported selection retains incomplete coverage for C.
    shared_repository: A Repository is a member of P and Q. Removing it from P does not change Q, delete
      source work or erase observations needed by Q.
    uncertain_outcome: An edit from A to A and B may have committed but the durable result cannot be established.
      Do not assert that either set is confirmed current or its work coverage complete.
  open_questions:
  - Native presentation of changed or uncertain origin, focus and recovery.
  - Storage and coordination mechanisms for membership edits and their evidence.
  ontology_status: Project, Repository, PullRequest and Issue use selected ontology vocabulary; work scope
    and navigation are interaction concepts rather than new domain entities.
acceptance:
- Project-wide and explicitly Repository-scoped selections preserve their distinct intent as membership
  changes.
- A confirmed membership change does not silently clear the valid Project, period or filters or reuse
  prior coverage for an unobserved member.
- Removed or uncertain origin does not silently substitute another Repository or Project or imply source
  deletion.
- An open object's identity is retained through membership changes; saved private data remains visible
  after confirmed revocation under 0019. Visibility and local access follow the active-account and A-to-B
  boundary in 0019.
- Scope limitations and recovery are understandable without color or transient feedback alone.

```

## GITVIEW-SPEC-0092: GitView - Signal-origin selection and explicit filter changes

Источник `specs/nodes/GITVIEW-SPEC-0092.yaml`, SHA-256 `11892e9716b7977e526284e3940351c7d0851a202955dc16da9673df15404f93`

```yaml
id: GITVIEW-SPEC-0092
title: GitView - Signal-origin selection and explicit filter changes
kind: spec
created_at: '2026-11-16T08:52:00Z'
updated_at: '2026-11-16T20:05:42Z'
status: specified
refines:
- GITVIEW-SPEC-0047
depends_on:
- GITVIEW-SPEC-0007
- GITVIEW-SPEC-0019
- GITVIEW-SPEC-0024
- GITVIEW-SPEC-0027
- GITVIEW-SPEC-0029
- GITVIEW-SPEC-0042
- GITVIEW-SPEC-0056
- GITVIEW-SPEC-0074
sources:
  predecessor_draft: docs/drafts/GITVIEW-SPEC-0092.yaml
  predecessor_revision: 9bbf79f
  owner_selection: docs/drafts/project-summary-proposal.md
  signal_filter_context_decision: conversation_memory/sketches/gitview/revisions/9544eaa87e5b4afcb48910299d60c520/metadata.json
specification:
  ontology_refs:
  - gitview:projectIncludesRepository
  - gitview:pullRequestRepository
  - gitview:issueRepository
  - gitview:ReviewThread
  - gitview:User
  - gitview:Project
  - gitview:Repository
  - gitview:PullRequest
  - gitview:Issue
  - gitview:Metric
  objective: Preserve the meaning of an actionable summary signal when the operator opens and navigates
    its associated work selection.
  authority_boundary: Direct navigation from an actionable Project signal and the limited historical merged-counter
    filter override are selected. Edits to signal conditions, the detailed filter hierarchy, controls
    and implementation remain open; this node does not establish source completeness or implementation
    readiness. When GitHub externally revokes access to a private Repository, the retained-data visibility
    and local access described here apply while the relevant account remains active. Independently of
    revocation, while account B is active, the account-switch boundary in 0019 applies. Behavior after
    returning to A is not selected.
  requirements:
    origin: Retain the supported originating Project and, for a Repository-specific signal, the actual
      Repository identity, condition, unit, period, membership basis, coverage and observation time when
      known. The origin does not prove that every contributing object has been loaded or that its observation
      is current.
    destination: Open the supported corresponding work selection with its actual condition and scope.
      If the condition, source identity or period cannot be represented with available evidence, make
      the limitation discoverable instead of silently substituting Today, a different Project or unrelated
      filter.
    units: Distinguish the signal's measurement unit from the destination's distinct PR or Issue cards.
      A count of checks, review threads or events is not automatically the number of PR or Issue cards;
      the same object is not duplicated merely because multiple events qualify.
    selected_override: For the selected transition from a historical merged-PR counter, temporarily override
      a conflicting saved merged exclusion under 0047 and 0056 to show the counter result without rewriting
      the saved preference. Other transitions follow their actual origin context, not an assumed universal
      override.
    explicit_changes: If the operator explicitly changes or clears an active condition, do not continue
      to describe every displayed object as matching the original condition. Such a change does not alter
      source objects or rewrite the earlier observed signal; persistence of ordinary user filters remains
      governed by 0007 and its own supported save outcome.
    coverage: Keep the origin measurement and destination's actual observation time, source scope and
      coverage attributable to each. If refresh or incomplete source evidence yields a different count
      or partial selection, do not fabricate equality, a missing object count or a confirmed empty result.
    context_change: A confirmed membership, source identity or day change may require reevaluating the
      applicable selection. Do not silently transfer an earlier observation to a different Project, Repository
      or historical period; use the relevant supported context or disclose a limitation under 0024 and
      0056.
    saved_data: Confirmed private Repository revocation does not hide already saved supported local origin
      details, counts or objects under 0019. Preserve their supported scope and time when known and the
      applicable indication; local visibility is not a fresh source grant.
    return: Return to the actual valid originating surface and context under 0024. A source error or absent
      evidence does not prove that another Project is the correct replacement.
    accessibility: Make the applicable signal meaning, active condition, scope, limitation and available
      navigation understandable without relying solely on color or a particular gesture.
    filter_origin: When the originating signal belongs to a filtered scope, preserve that scope and its
      applicable filters in the destination. A signal outside a filter context opens its corresponding
      selection without being narrowed by that unrelated filter. Preserve actual access, Project, period
      and coverage; this does not rewrite a saved preference or imply full source coverage. The detailed
      hierarchy, inheritance and controls remain open. The previously selected historical merged-counter
      case concerns a counter whose originating scope includes merged PRs; a saved exclusion outside that
      origin does not narrow its destination. A counter defined inside a merged-excluding scope instead
      retains that origin scope.
  scenarios:
    thread_unit: A signal reports three supported unresolved threads affecting one PR. The destination
      can contain one distinct PR card while preserving that the origin measured threads, not three PRs.
    merged_override: In the selected counter case, its originating scope includes merged PRs and the saved
      merged exclusion is outside that scope. A saved filter excludes merged PRs. Opening a supported
      historical merged counter temporarily shows its matching result without rewriting that saved preference.
    changed_condition: After opening a failed-CI signal, the operator explicitly clears that condition.
      Do not describe every subsequently displayed object as a failed-CI match or rewrite the earlier
      signal observation.
    changed_coverage: A signal reports supported partial data, and a later destination observation has
      a different scope or time. Preserve the respective limitations rather than forcing the destination
      count to equal the earlier signal.
    filtered_origin: In a complete, unchanged Project dataset, three PRs have failed CI, including one
      draft. A view whose active filter excludes drafts shows a failed-CI signal for the two PRs inside
      that filtered scope. Opening it retains that filter context and failed-CI condition, showing those
      two PRs.
    outside_filter: In the same complete, unchanged dataset, a failed-CI signal produced outside the saved
      draft-excluding filter context covers all three PRs. Opening it shows its supported three-PR selection
      without applying that unrelated exclusion; the saved preference is not rewritten.
  open_questions:
  - Native controls for changing signal conditions, return behavior and filter persistence scope.
  - Exact hierarchy, scope and inheritance of filters; how their context is presented during navigation.
  - Exact predicate and source evidence for each actionable signal and historical period.
  ontology_status: Project, Repository, PullRequest, Issue and Metric use selected ontology vocabulary;
    signal selection and navigation are interaction and measurement concepts, not new domain entities.
acceptance:
- An actionable signal preserves its supported origin, condition, scope, unit and period when opening
  its corresponding work selection, or exposes a limitation.
- Signal measurement units are not silently equated with counts of distinct destination cards.
- 'For the selected counter whose originating scope includes merged PRs and whose saved merged exclusion
  is outside that scope: The selected historical merged-counter transition temporarily overrides the conflicting
  saved merged exclusion without rewriting the saved preference.'
- An explicitly changed or cleared condition is not still presented as applying to every displayed object.
- Incomplete observations, changed context or confirmed private Repository revocation do not silently
  substitute another Project or invent fresh source data.
- A signal from a filtered scope retains its applicable filter context; an unrelated filter outside the
  signal context does not narrow its destination or rewrite saved preferences.

```

## GITVIEW-SPEC-0093: GitView - Preview availability and changing observations

Источник `specs/nodes/GITVIEW-SPEC-0093.yaml`, SHA-256 `df4e9568ba0ce58915cf062f2f309e9c2688eb868f1d0f943b8b8068f493e9c6`

```yaml
id: GITVIEW-SPEC-0093
title: GitView - Preview availability and changing observations
kind: spec
created_at: '2026-11-16T11:12:00Z'
updated_at: '2026-11-16T19:57:34Z'
status: specified
refines:
- GITVIEW-SPEC-0050
depends_on:
- GITVIEW-SPEC-0019
- GITVIEW-SPEC-0023
- GITVIEW-SPEC-0024
- GITVIEW-SPEC-0026
- GITVIEW-SPEC-0031
- GITVIEW-SPEC-0032
- GITVIEW-SPEC-0033
- GITVIEW-SPEC-0036
- GITVIEW-SPEC-0044
sources:
  predecessor_draft: docs/drafts/GITVIEW-SPEC-0093.yaml
  preview_proposal: docs/drafts/ux-preview-interactions.md
specification:
  ontology_refs:
  - gitview:User
  - gitview:Project
  - gitview:Repository
  - gitview:PullRequest
  - gitview:Issue
  objective: Keep the selected object's preview useful and correctly attributed as data availability and
    source observations change.
  authority_boundary: The first-version static preview and local retention after confirmed private Repository
    revocation are selected. Optional refresh timing, platform presentation and other account-change disclosure
    beyond 0019 remain open; the later sliding preview is not established here. When GitHub externally
    revokes access to a private Repository, the retained-data visibility and local access described here
    apply while the relevant account remains active. Independently of revocation, while account B is active,
    the account-switch boundary in 0019 applies. Behavior after returning to A is not selected.
  requirements:
    local_availability: Open a preview of already available supported local data where eligible for local
      display under 0019 without waiting for a network response. Identify the same selected object and
      preserve its origin; unavailable data is not invented or treated as confirmed zero.
    observation_scope: Each fact keeps its supported object, source, time, revision where relevant and
      limitations. A new title does not make an older review or CI observation current for a newer PR
      revision. A partial refresh updates only fields the observation actually supports.
    changed_preview: A late observation for an earlier preview must not be rendered as belonging to a
      different selected object. Reopening an object does not alone prove the earlier observation is current
      or eligible for the new view; apply its original context and applicable access and ordering rules
      before showing it.
    dismissal: Dismissing a preview does not implicitly open it again when an observation arrives or prove
      that an underlying request was cancelled. Return and explicit opening follow 0031 and 0024.
    cancelled_open: An explicitly cancelled or invalidated pending local open does not later navigate
      into an object or disrupt a newer context. Closing the preview as part of a successfully accepted
      open is not itself evidence of cancellation.
    revoked_private: If private Repository revocation is confirmed before or while preview is open, keep
      previously saved local details visible with revocation indication and supported time when known;
      stop synchronization under 0019. An earlier in-flight response does not silently restore source
      access or become a newly accepted update. Recovery or explicit local deletion remains reachable.
    source_actions: Opening locally, opening the source and sharing are distinct actions. A supported
      source link identifies the intended object and does not by itself establish current access or create
      a GitHub URL for a local Project under 0033.
    accessible: Provide discoverable ways to invoke and dismiss the preview of the same object without
      long press. Available identity, state, limitations and actions are accessible without relying on
      color; direct object open is distinct from access to preview under 0032.
  scenarios:
    offline: A saved Issue eligible for local display has title and lifecycle, its discussion count is
      unknown, and the network is unavailable. Preview the saved facts without waiting for network; the
      unknown count is not zero.
    late_other_object: Preview A is dismissed and preview B opens before A's response arrives. A's facts
      do not appear as B's; any independent retention respects A's source and access context.
    accessible_preview: The operator cannot use long press. An accessible route opens and dismisses the
      same object's preview and makes its supported details and limitations available without color alone.
    cancelled_navigation: An in-progress local open is explicitly cancelled, then its delayed result arrives.
      It does not later navigate or interrupt the operator's current context.
    revoked_during_preview: The relevant account remains active throughout this scenario. A saved private
      PR is previewed while a request is in flight and access is explicitly revoked before the response
      arrives. Keep saved details visible with indication and supported time when known; do not present
      the old response as fresh access or update.
    partial_refresh: A refresh supports a new title but fails to establish CI. Show the title with its
      own context and keep supported earlier CI as last known with its own context; do not report it as
      newly observed or successful.
  open_questions:
  - Whether and when preview initiates a separate refresh and its platform cancellation behavior.
  - Native presentation, precise field priorities and accessibility announcements.
  - Handling retained data in other account-change contexts beyond 0019.
  ontology_status: Project, Repository, PullRequest and Issue use selected ontology vocabulary; preview
    lifetime and presentation are interaction concepts, not new domain entities.
acceptance:
- Supported local preview information eligible for display is available without waiting for a network
  response and remains attributed to the selected object.
- Late or partial observations do not silently retarget a preview, reopen a dismissed preview or make
  unsupported fields current.
- Confirmed private Repository revocation leaves saved details visible with indication and supported update
  time when known; synchronization stops. Visibility and local access follow the active-account and A-to-B
  boundary in 0019.
- Local open, source handoff and sharing remain distinct. Preview invocation, dismissal, identity and
  limitations have accessible paths without long press or color alone.

```

## GITVIEW-SPEC-0094: GitView - Attention to lengthy review discussions

Источник `specs/nodes/GITVIEW-SPEC-0094.yaml`, SHA-256 `efb0b9235375a83dc36710bb26e305b5a1096ad802eeb5151e2726a482211d59`

```yaml
id: GITVIEW-SPEC-0094
title: GitView - Attention to lengthy review discussions
kind: spec
created_at: '2026-11-16T12:20:00Z'
updated_at: '2026-11-16T20:02:31Z'
status: specified
refines:
- GITVIEW-SPEC-0062
depends_on:
- GITVIEW-SPEC-0019
- GITVIEW-SPEC-0044
- GITVIEW-SPEC-0046
- GITVIEW-SPEC-0047
- GITVIEW-SPEC-0057
- GITVIEW-SPEC-0089
- GITVIEW-SPEC-0092
sources:
  predecessor_draft: docs/drafts/GITVIEW-SPEC-0094.yaml
  project_summary: docs/drafts/project-summary-proposal.md
  owner_intent: conversation:gitview/excerpt-02
  review_wait_meaning_decision: conversation_memory/sketches/gitview/revisions/8cefadc82b764a64b09fd8c3123f2f28/metadata.json
specification:
  ontology_refs:
  - gitview:pullRequestRepository
  - gitview:Project
  - gitview:Repository
  - gitview:PullRequest
  - gitview:ReviewThread
  - gitview:Metric
  objective: Help the operator notice review discussions that may need attention, including threads waiting
    a long time for a response, without leaving the work overview.
  authority_boundary: 'The owner requested visibility of long or problematic review threads and selected
    counters rather than individual thread content. The owner selected the meaning of one signal: a long
    wait for a reply to the latest message. Its predicate, threshold, source mapping and native presentation
    remain open; other problematic-discussion signals are not selected here. When GitHub externally revokes
    access to a private Repository, the retained-data visibility and local access described here apply
    while the relevant account remains active. Independently of revocation, while account B is active,
    the account-switch boundary in 0019 applies. Behavior after returning to A is not selected.'
  requirements:
    attention: Help the operator notice a review thread that has waited a long time for a reply to its
      latest message. Show such a signal when its predicate and the necessary evidence are established;
      the duration threshold, applicable actor and how waiting for a reply is established remain open.
    interpretation: Describe the actual meaning and scope of an available signal so the operator can understand
      why it needs attention. Unknown or incomplete information is not presented as proof that no discussion
      needs attention.
    counts: If counts are shown, distinguish the number of qualifying review threads from the number of
      affected PRs; several threads on one PR do not make several PRs. Individual thread content is not
      required in GitView.
    navigation: An actionable signal leads to the corresponding work in its Project or Repository context,
      with any applicable limitation. The operator can reach the original GitHub object.
    saved_data: After GitHub confirms private Repository access revocation, keep saved review information
      visible as last known with its revocation indication and supported update time when known; stop
      synchronization and preserve access recovery or explicit local deletion under 0019.
    accessibility: Make the signal meaning, applicable limitations and available navigation understandable
      without relying solely on color or transient feedback.
  scenarios:
    multiple_threads: Two qualifying threads belong to one PR. If both counts are available, the overview
      can show two threads and one affected PR without presenting them as three work items.
    unavailable_evidence: Some review information is unavailable. Keep supported information and its applicable
      limitation rather than reporting a confirmed zero or asserting that no discussion needs attention.
    revoked_private: The relevant account remains active throughout this scenario. A private Repository
      has saved review information when GitHub confirms access revocation. Keep the saved information
      visible with the revocation indication and supported update time when known under 0019; synchronization
      stops.
    wait_for_last_message: A review thread has waited a long time for a reply to its latest message. The
      desired signal highlights that wait when supported by the selected predicate and available evidence;
      an old thread or a count of comments alone does not establish it.
  open_questions:
  - How to establish an awaited reply to the latest message, the applicable actor and a long-wait threshold.
  - Available GitHub information, coverage and exact native presentation for a selected meaning.
  ontology_status: PullRequest and ReviewThread use selected ontology vocabulary; an attention signal
    is a presentation and measurement, not a new domain entity or proof of actor motive.
acceptance:
- The selected attention need concerns a long wait for a reply to the latest review-thread message; its
  predicate, threshold and evidence are not invented.
- An available signal has an understandable meaning and scope, and unknown information is not presented
  as a confirmed absence.
- Thread counts and affected PR counts remain distinguishable, and actionable navigation keeps the applicable
  scope.
- Saved private review information remains visible after confirmed access revocation with its indication
  and supported update time when known under 0019. Visibility and local access follow the active-account
  and A-to-B boundary in 0019.
- Signal meaning and available actions do not rely solely on color or transient feedback.
- The long-wait signal concerns a reply awaited to the latest review-thread message; its threshold and
  evidence remain to be specified.

```

## GITVIEW-SPEC-0101: GitView - Work object identity in Today

Источник `specs/nodes/GITVIEW-SPEC-0101.yaml`, SHA-256 `4987a331cc94419dc6f415ac87ed0fa14cde517d514a550b4f701597a13aa861`

```yaml
id: GITVIEW-SPEC-0101
title: GitView - Work object identity in Today
kind: spec
created_at: '2026-11-16T12:26:00Z'
updated_at: '2026-11-16T19:43:05Z'
status: specified
refines:
- GITVIEW-SPEC-0027
depends_on:
- GITVIEW-SPEC-0002
- GITVIEW-SPEC-0019
- GITVIEW-SPEC-0026
- GITVIEW-SPEC-0029
- GITVIEW-SPEC-0038
- GITVIEW-SPEC-0039
- GITVIEW-SPEC-0041
- GITVIEW-SPEC-0044
- GITVIEW-SPEC-0089
sources:
  predecessor_draft: docs/drafts/GITVIEW-SPEC-0101.yaml
  selected_fields: docs/drafts/pr-issue-selected-fields-coverage-20261114.md
specification:
  ontology_refs:
  - gitview:GitHub
  - gitview:Project
  - gitview:Repository
  - gitview:PullRequest
  - gitview:Issue
  - gitview:pullRequestRepository
  - gitview:issueRepository
  - gitview:pullRequestIssueLink
  - gitview:projectIncludesRepository
  objective: Preserve distinct source-supported PR and Issue identities when constructing a Today work
    selection from potentially overlapping or incomplete observations.
  authority_boundary: Today presents each eligible PR or Issue once per selection and retains distinct
    linked objects. Exact source representation mappings, queries and identifier association evidence
    remain open; this node does not establish GitHub integration or source population completeness. When
    GitHub externally revokes access to a private Repository, the retained-data visibility and local access
    described here apply while the relevant account remains active. Independently of revocation, while
    account B is active, the account-switch boundary in 0019 applies. Behavior after returning to A is
    not selected.
  requirements:
    typing: Before treating an observation as a PR or Issue, use supported object-type evidence. An untyped
      or identity-ambiguous representation remains unresolved; do not silently classify it or fabricate
      a confirmed match, exclusion or exact population count.
    same_object: Multiple source observations or inclusion conditions for a source-confirmed same PR or
      Issue do not create multiple cells for that object in the same selection. An Issues-source representation
      confirmed as a PR is not an additional independent Issue under 0039. The same Repository can belong
      to different Projects; its eligible object can appear once in each applicable Project selection,
      without changing membership or globally suppressing it across Projects.
    distinct_objects: A separately identified Issue and PR remain distinct even when linked or describing
      related work. Same-number PRs or Issues in different Repositories do not become one object. A link
      is not proof of motive or of independent task count.
    identifiers: Preserve identifier type, source instance and Repository context. Do not equate or interchange
      source representation identifiers solely because their numbers, names or addresses resemble one
      another. Repository identity follows 0038; associating work-object representations requires its
      own supported evidence under 0039, and the source-specific association method remains open.
    fields: Keep supported lifecycle, event time, observation time, scope and coverage distinct per fact.
      Missing, unrecognized, conflicting or omitted facts are not invented from another field or from
      retrieval time. A closed PR is not automatically merged; a PR closure is not an Issue closure.
    incomplete: An unresolved representation or missing type evidence can limit the completeness of a
      materialized work selection. Independently supported counts retain their own scope and evidence;
      a count alone does not create object identities or establish that all cards are present under 0044.
    revoked_private: On GitHub-confirmed private Repository revocation for the relevant account, previously
      saved supported work remains visible locally as last known with revocation indication and supported
      time when known under 0019; synchronization stops. An earlier response does not silently become
      a fresh update or restore access. Other account-change disclosure beyond the selected A-to-B rule
      in 0019 remains open.
    accessibility: Make known object type, identity context and applicable uncertainty understandable
      without relying only on color or a transient cue.
  scenarios:
    issue_representation_of_pr: A source-confirmed PR has an Issues-source representation and a separately
      associated PR representation. Show the PR once as a PR; the first representation is not another
      Issue.
    linked_issue: A source-confirmed PR and a separately identified linked Issue both meet all applicable
      Today conditions and active filters. Each appears once in that selection; their link neither merges
      them nor proves actor motive.
    unknown_type: A partial source response lacks the evidence needed to tell whether a record is a PR
      representation or an Issue. Preserve uncertainty rather than defaulting it to either type.
    cross_repository: Repository A and Repository B each contain a confirmed PR numbered 42. They remain
      distinct objects in their own source and Repository contexts.
    shared_repository: Repository R belongs to Projects P and Q; its confirmed PR meets each selection's
      applicable conditions and filters. The same PR appears once in each applicable Project selection,
      without a change to either membership.
    revoked_late_response: The relevant account remains active throughout this scenario. A saved private
      PR remains visible as last known after confirmed revocation; a response initiated before revocation
      arrives later. Do not use it to claim fresh data or restored access.
    closed_without_merge_evidence: A PR is supported as closed but merge evidence is unavailable. Preserve
      closed state and uncertainty about merge; do not fabricate a merge time from retrieval time.
  open_questions:
  - Source-specific type, object and Repository identity mapping and association evidence.
  - Partial population, access and source ordering semantics for selected operations.
  - Native presentation for unresolved records and their selection limitations.
  ontology_status: GitHub, Repository, PullRequest and Issue use selected ontology vocabulary; normalization
    is an observation operation, not a new domain entity or proof of actor motive.
acceptance:
- Confirmed PRs and Issues retain supported identity and type; unresolved representations are not silently
  classified.
- A source-confirmed PR represented through an Issues source is not counted as a separate Issue, and an
  independently linked Issue remains distinct.
- Equal local numbers or display names do not merge different Repository objects or substitute unsupported
  source identifiers.
- Missing source facts do not become a fabricated lifecycle transition, event time or complete work population.
- Saved supported work remains visible after confirmed private Repository revocation with indication and
  supported time when known. Visibility and local access follow the active-account and A-to-B boundary
  in 0019.

```

## GITVIEW-SPEC-0125: GitView - Completed work and PR review stage

Источник `specs/nodes/GITVIEW-SPEC-0125.yaml`, SHA-256 `83af919f38e3ee43d716e527889828a58976dfea74f9531c9c4c2e1cad6efe29`

```yaml
id: GITVIEW-SPEC-0125
title: GitView - Completed work and PR review stage
kind: spec
created_at: '2026-11-16T12:21:00Z'
updated_at: '2026-11-16T20:02:31Z'
status: specified
refines:
- GITVIEW-SPEC-0011
depends_on:
- GITVIEW-SPEC-0019
- GITVIEW-SPEC-0027
- GITVIEW-SPEC-0028
- GITVIEW-SPEC-0039
- GITVIEW-SPEC-0041
- GITVIEW-SPEC-0042
- GITVIEW-SPEC-0057
- GITVIEW-SPEC-0062
- GITVIEW-SPEC-0089
- GITVIEW-SPEC-0092
sources:
  predecessor_draft: docs/drafts/GITVIEW-SPEC-0125.yaml
  owner_intent_review: docs/drafts/owner-intent-coverage-review-20261115.md
  ready_meaning_decision: conversation_memory/sketches/gitview/revisions/23fe1cc490924a219f38c4bee721511f/metadata.json
specification:
  ontology_refs:
  - gitview:User
  - gitview:Project
  - gitview:Repository
  - gitview:PullRequest
  - gitview:Issue
  - gitview:ReviewThread
  objective: Preserve the requested view of what is ready while distinguishing completed outcomes from
    review stage and independently supported attention signals.
  authority_boundary: The owner asked to see what is ready and approved showing completed and unfinished
    work together in Today. A combined ready predicate, an open non-draft filter, exact source mappings
    and any merge-eligibility decision remain open; this node does not claim to resolve the broader need.
    When GitHub externally revokes access to a private Repository, the retained-data visibility and local
    access described here apply while the relevant account remains active. Independently of revocation,
    while account B is active, the account-switch boundary in 0019 applies. Behavior after returning to
    A is not selected.
  requirements:
    product_need: For PRs, the primary «Done» indicator means PRs already merged. Show readiness to merge
      separately; its product predicate, source evidence and applicability remain to be defined. A merged
      outcome is not the same as a PR awaiting merge, and one source field does not by itself establish
      the separate readiness signal.
    completed: Present a supported merged PR as merged and a PR closed without merge accordingly. Present
      an Issue as closed with its supported reason when available; an unknown or non-completion reason
      does not automatically establish a successfully completed task. Current lifecycle and an event during
      a selected period are distinct facts under 0039, 0041 and 0057.
    today: Without an applicable saved exclusion, an eligible PR in the selected Project with a supported
      merge today remains the same object in unfiltered Today while an explicitly unfinished-only selection
      can hide it under 0027. A filter does not modify the source object or erase the supported outcome.
    independent_signals: Preserve applicable PR lifecycle, draft status, review assessment, requests,
      unresolved threads and CI as independently supported facts with their actual observation context.
      Non-draft, green CI, approval or zero visible threads alone does not prove an assigned reviewer,
      completed review or merge eligibility. A combination of these signals also does not establish merge
      eligibility without a separately defined applicable predicate and sufficient source evidence.
    optional_candidate: If a future open non-draft PR filter is selected, name and explain its actual
      predicate; it must not be called merge-ready or treated as a review request solely from that status.
      The predecessor's proposed filter remains a candidate, not a mandatory first-version feature.
    uncertainty: Missing, stale, incompatible or incomplete evidence is not a confirmed ready state, completed
      outcome, exact count or absence. An independently supported lifecycle outcome may remain visible
      with its own context even when a review or CI signal is unknown.
    navigation: If an applicable signal or count opens work, retain its condition, scope, time and coverage
      under 0047 and 0092. Different counts or observations do not automatically identify the same PR
      population, and navigation does not modify GitHub.
    saved_data: After confirmed GitHub revocation of private Repository access for the relevant account,
      supported saved facts remain visible as last known with indication and supported update time when
      known under 0019; synchronization stops and a late old response does not restore current access.
    accessibility: Supported outcomes, independent signals and their limitations are understandable without
      relying on color or transient feedback alone.
  scenarios:
    merged_today: An eligible PR in the selected Project is confirmed merged during the user's current
      local day. The same PR remains in unfiltered Today and may be absent from an explicitly unfinished-only
      view; its source state is unchanged by the filter.
    non_draft_unknown_rules: A PR is confirmed open and non-draft while its branch rules and permissions
      are unobserved. Do not infer approval, required review completion or merge eligibility from non-draft.
    closed_issue_unknown_reason: An Issue is confirmed closed, but its applicable reason is unavailable.
      Show closed without fabricating the reason or calling the work successfully completed.
    green_and_review: A PR has a supported successful CI observation and independently supported changes
      requested. Preserve both rather than describing the PR as approved or ready to merge.
    unknown_merge_rules: A PR has supported green CI, approval and zero unresolved threads, but branch
      rules and permissions are unknown. Do not claim merge eligibility from that combination alone.
    done_and_ready: A PR merged in the selected period contributes to the primary PR «Done» outcome when
      supported by sufficient data. An open PR may be represented by a separate readiness-to-merge indicator
      only when its predicate and evidence are established; the two states are not conflated.
  open_questions:
  - The predicate, applicable operator and evidence for the separate readiness-to-merge indicator.
  - Whether an optional open non-draft PR filter is useful and how its source inputs are established.
  - Any merge eligibility scope, source policy and action require separate refinement.
  ontology_status: PullRequest, Issue and Project use selected ontology vocabulary; a stage or readiness
    signal does not create a domain entity or prove actor motive.
acceptance:
- The need to see ready work remains explicit without asserting that an unselected predicate resolves
  it.
- Supported completed outcomes, PR draft status, review signals and CI retain distinct meanings and context.
- Unfiltered Today preserves eligible same-day merged PRs unless the operator's applicable saved filter
  excludes them.
- Unknown or incomplete evidence does not become a confirmed ready state, completed outcome or exact count.
- Saved supported facts remain visible after confirmed private Repository revocation with indication and
  supported time when known. Visibility and local access follow the active-account and A-to-B boundary
  in 0019.
- For PRs the primary «Done» indicator means merged; readiness to merge is presented separately under
  a separately defined predicate and supported evidence.

```
