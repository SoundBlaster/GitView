# GitView: Structural leaf triage

Snapshot at `7bd64b3`: 123 candidates, 55 structural leaves, all `idea / pre_canonical`. This is a draft triage map, not canonical acceptance.

Groups are a manual navigation aid based on the leaf purpose and declared gaps, not proof that other dependencies are ready. Each row quotes only the first declared unresolved item; consult the linked YAML for its full contract, further unresolved items and dependencies. No leaf is established implementation-ready by this inventory. Missing executed device or integration tests is not automatically a defect in a pre-implementation specification.

0018 describes future depth; 0055 needs a release-scope decision. 0090 covers an agreed authoring process and is not authorization to change GitHub. 0043, 0070 and 0079 are verification obligations, not necessarily product modules.

Priorities: source operations, identity, permission and coverage (0100-0102, 0112, 0116); storage schema, coordinator and recovery (0104, 0113, 0114, 0117, 0122, 0123); FSD boundaries and native routes (0107, 0115); typed pure decisions and SpecificationCore applicability (0110, 0111, 0119). Perform semantic review against parents and sources before calling a leaf implementable.

## Future scope

| Leaf | First declared open item |
| --- | --- |
| [GITVIEW-SPEC-0018](GITVIEW-SPEC-0018.yaml) - Calendar overview and future depth | Calendar metric, data source, navigation and future PR depth remain undefined. |

## Scope decision

| Leaf | First declared open item |
| --- | --- |
| [GITVIEW-SPEC-0055](GITVIEW-SPEC-0055.yaml) - Fixed PR cohort completion view | Whether and how the operator initiates and retains a fixed cohort, and whether this view belongs to the first release. (+2 in YAML) |
| [GITVIEW-SPEC-0090](GITVIEW-SPEC-0090.yaml) - Required description process outcome and path coverage | The participating repositories, actual creation paths, checkpoint, authority and exception policy must be selected before deploying the process. (+2 in YAML) |

## Acceptance and cross-cutting verification

| Leaf | First declared open item |
| --- | --- |
| [GITVIEW-SPEC-0043](GITVIEW-SPEC-0043.yaml) - Cross-branch overview and recovery scenarios | Precise device and source fixtures, credentials, test levels and executable acceptance procedures depend on implementation and platform decisions. (+2 in YAML) |
| [GITVIEW-SPEC-0070](GITVIEW-SPEC-0070.yaml) - Verification of metric history behavior | Concrete Swift test frameworks, source adapter contract, fixture formats and actual storage implementation remain to be chosen. (+2 in YAML) |
| [GITVIEW-SPEC-0079](GITVIEW-SPEC-0079.yaml) - Cross-cutting verification applicability | Evidence record format, precise ownership of applicability decisions and any SpecGraph support for cross-cutting policy remain to be specified. (+2 in YAML) |

## Source and data semantics

| Leaf | First declared open item |
| --- | --- |
| [GITVIEW-SPEC-0041](GITVIEW-SPEC-0041.yaml) - PR overview facts and change counters | Source mapping and availability of the selected facts, including revision association for counters. (+1 in YAML) |
| [GITVIEW-SPEC-0053](GITVIEW-SPEC-0053.yaml) - Conflicting source observations | Source-specific evidence that establishes a comparable field revision or ordering across partial responses. (+1 in YAML) |
| [GITVIEW-SPEC-0057](GITVIEW-SPEC-0057.yaml) - Project metric catalog and coverage | Verified GitHub source mapping and semantics for outstanding review requests, blocking links, check revision and historical closure reasons. (+3 in YAML) |
| [GITVIEW-SPEC-0061](GITVIEW-SPEC-0061.yaml) - Status-check count categories | Verify the selected source schemas, applicability, retry selection and handling of special outcomes against actual GitHub PR observations. (+2 in YAML) |
| [GITVIEW-SPEC-0063](GITVIEW-SPEC-0063.yaml) - Blocked Issue attention and source access | Exact GitHub source visibility and completeness guarantees for cross-Repository dependencies, private blockers and link changes. (+2 in YAML) |
| [GITVIEW-SPEC-0077](GITVIEW-SPEC-0077.yaml) - Issue discussion counts and latest comment time | Whether comment authors are the desired product definition of discussion participants and whether source-provided aggregates have matching semantics require review and source evidence. (+2 in YAML) |
| [GITVIEW-SPEC-0078](GITVIEW-SPEC-0078.yaml) - Issue links, hierarchy and partial access | Source-specific relationship types, directionality, per-field access, pagination and aggregate semantics need documented and real-source evidence. (+2 in YAML) |
| [GITVIEW-SPEC-0081](GITVIEW-SPEC-0081.yaml) - Repository address conflict and recovery | Source evidence and an ordering rule that can actually supersede all competitors remain unverified; repeated rechecks may leave conflict unresolved. (+2 in YAML) |
| [GITVIEW-SPEC-0089](GITVIEW-SPEC-0089.yaml) - Temporal applicability of Today and filter evidence | Source-specific ordering, revision applicability, correction and freshness evidence remain to be established for each selected field. (+2 in YAML) |
| [GITVIEW-SPEC-0094](GITVIEW-SPEC-0094.yaml) - Unresolved review threads with an older observed comment | Verify actual permission and coverage for submitted comments, timestamps, thread resolution and PR state; this candidate does not select an API request. (+2 in YAML) |
| [GITVIEW-SPEC-0098](GITVIEW-SPEC-0098.yaml) - GitHub App public-client authorization and renewal | Establish the exact app-specific callback target and supported deployment version, verify GitHub registration acceptance and native session behavior, and define handling and rotation of the extractable client registration value and per-operation permission coverage; no credentials or registration are created by this proposal. (+3 in YAML) |
| [GITVIEW-SPEC-0099](GITVIEW-SPEC-0099.yaml) - GitHub App installation scope in first setup | Verify the candidate user-token installation and Repository-list operations against the selected registration, organization approval, public data and actual grants; these choices do not assume complete enumeration. (+2 in YAML) |
| [GITVIEW-SPEC-0100](GITVIEW-SPEC-0100.yaml) - GitHub App read-permission coverage for selected data | Trace exact selected operations and field-level GraphQL permissions, particularly review threads, comment-age proxy, relationship links, identity and historical outcomes; perform authorized source validation before declaring a complete grant set. (+2 in YAML) |
| [GITVIEW-SPEC-0101](GITVIEW-SPEC-0101.yaml) - Normalize GitHub work representations for Today | Select and validate actual source representations, ID association evidence and source-event fields for the initial product slice without assuming GraphQL and REST identifiers are interchangeable. (+2 in YAML) |
| [GITVIEW-SPEC-0102](GITVIEW-SPEC-0102.yaml) - Population coverage evidence across refreshes | For each chosen GitHub source operation, document pagination consistency, update visibility, ordering, deletion, access and applicable temporal guarantees; absence of evidence is not a claim that GitHub lacks a capability. (+2 in YAML) |
| [GITVIEW-SPEC-0112](GITVIEW-SPEC-0112.yaml) - Repository access evidence applicability | Confirm the exact selected GitHub endpoint, pagination, field-level permissions and applicable response mappings against the chosen authentication integration. (+2 in YAML) |
| [GITVIEW-SPEC-0116](GITVIEW-SPEC-0116.yaml) - Scoped observation exchange for work routes | Select concrete Swift interface shapes and source-to-domain mappings for the chosen GitHub operations, including source-specific errors, identity association and coverage evidence. (+2 in YAML) |

## Local storage and recovery

| Leaf | First declared open item |
| --- | --- |
| [GITVIEW-SPEC-0052](GITVIEW-SPEC-0052.yaml) - Recover an interrupted default Project save | Local persistence mechanism and evidence that concurrent or late commits enforce the stated uniqueness and visibility guarantees. (+2 in YAML) |
| [GITVIEW-SPEC-0064](GITVIEW-SPEC-0064.yaml) - Project membership basis for historical metrics | Specify a practical provenance representation and evidence for whether a computed point depends on currently restricted inputs; validate any broader safe-aggregate policy before relaxing suppression. (+3 in YAML) |
| [GITVIEW-SPEC-0104](GITVIEW-SPEC-0104.yaml) - Project configuration storage boundary | Select concrete Project ownership, version evidence and commit mechanism after reviewing application composition and persistence candidates. (+2 in YAML) |
| [GITVIEW-SPEC-0114](GITVIEW-SPEC-0114.yaml) - Recoverable connection binding across local stores | Specify and validate secure-store item uniqueness, generation comparison, writer quiescence and exact recovery evidence on supported iOS versions. (+2 in YAML) |
| [GITVIEW-SPEC-0117](GITVIEW-SPEC-0117.yaml) - Durable history clear and observation admission | Define exact database schema, migration, transactional coordinator and observable failure mapping for the chosen SQLite provider; verify journal and protection settings on supported devices. (+2 in YAML) |
| [GITVIEW-SPEC-0122](GITVIEW-SPEC-0122.yaml) - Local store schema evolution and recovery | Define concrete physical schemas, actual supported upgrade paths, provider operations and integrity checks once the data representation is chosen. (+2 in YAML) |
| [GITVIEW-SPEC-0123](GITVIEW-SPEC-0123.yaml) - Recoverable observation evidence record contract | Select physical schema, identifier encoding, evidence-reference constraints, provider and migration paths without losing these associations. (+2 in YAML) |

## UX, platform, and composition

| Leaf | First declared open item |
| --- | --- |
| [GITVIEW-SPEC-0023](GITVIEW-SPEC-0023.yaml) - Project overview observation states | Freshness classification thresholds and display of coverage by metric require the observation and summary branches. (+1 in YAML) |
| [GITVIEW-SPEC-0024](GITVIEW-SPEC-0024.yaml) - Navigation context and restoration | Stable sort order for the collection is owned by 0007 and proposed in 0042; this fallback operates on the last known ordered collection. The ordering proposal still needs review. (+2 in YAML) |
| [GITVIEW-SPEC-0042](GITVIEW-SPEC-0042.yaml) - Work ordering and uncertain selection presentation | User-selected alternative ordering and historical grouping semantics. (+2 in YAML) |
| [GITVIEW-SPEC-0048](GITVIEW-SPEC-0048.yaml) - Refresh triggers and visible outcomes | Validate the agent-authored fifteen-minute eligibility default against actual use, energy, data volume and user experience; source budget and platform constraints can still defer work. (+2 in YAML) |
| [GITVIEW-SPEC-0049](GITVIEW-SPEC-0049.yaml) - Today boundary and active navigation | Validate the 0069 fixed historical period proposal across time-zone changes and long-running navigation on the native interface. (+2 in YAML) |
| [GITVIEW-SPEC-0056](GITVIEW-SPEC-0056.yaml) - Historical outcome selection | Candidate 0069 proposes distinct merged-PR and closed-Issue daily outcomes, seven- and thirty-day calendar presets and a fixed captured current-member basis; its usability and other origins or metrics remain to be resolved. (+2 in YAML) |
| [GITVIEW-SPEC-0069](GITVIEW-SPEC-0069.yaml) - Initial metric series and calendar periods | Confirm source-specific completeness, object and event identity, state-sample timestamps and retention for each series. (+2 in YAML) |
| [GITVIEW-SPEC-0072](GITVIEW-SPEC-0072.yaml) - Stable Project overview order and position | Native collection update, focus and gesture behavior requires accessibility and device verification. (+2 in YAML) |
| [GITVIEW-SPEC-0073](GITVIEW-SPEC-0073.yaml) - Accessible focus during live overview updates | Supported assistive technologies, focus APIs, announcement policy and timing require implementation-independent platform design and device evaluation. (+2 in YAML) |
| [GITVIEW-SPEC-0075](GITVIEW-SPEC-0075.yaml) - Grid gesture arbitration and interruption | Native gesture competition, preview dismissal, anchor geometry, cancellation handling and platform accessibility actions require device evaluation. (+2 in YAML) |
| [GITVIEW-SPEC-0083](GITVIEW-SPEC-0083.yaml) - Review and retry a conflicting Project edit | Exact difference presentation, review controls, accessibility focus and retention of unsaved drafts across restart require product and native evaluation. (+2 in YAML) |
| [GITVIEW-SPEC-0091](GITVIEW-SPEC-0091.yaml) - Work scope continuity as Project membership changes | The default Project-wide intent and transient return to a surviving member overview are agent-authored product choices requiring UX evaluation. (+2 in YAML) |
| [GITVIEW-SPEC-0092](GITVIEW-SPEC-0092.yaml) - Signal-origin selection and explicit filter changes | Exact native presentation of origin, edited filters and differing observation times requires UX and accessibility evaluation. (+2 in YAML) |
| [GITVIEW-SPEC-0093](GITVIEW-SPEC-0093.yaml) - First-version preview content and availability | Native layout, system preview presentation, exact field order and truncation require UX and device evaluation. (+2 in YAML) |
| [GITVIEW-SPEC-0097](GITVIEW-SPEC-0097.yaml) - History for the agreed Project summary metrics | Validate the proposed additional capture and local membership-count series with native UX; no iOS chart, storage, history-clear or restart behavior has been implemented or tested. (+2 in YAML) |
| [GITVIEW-SPEC-0108](GITVIEW-SPEC-0108.yaml) - Setup and Project creation route composition | Specify concrete startup and setup presentation, accessibility focus, callback handling and storage recovery interfaces after upstream contracts and native constraints are reviewed. (+2 in YAML) |
| [GITVIEW-SPEC-0109](GITVIEW-SPEC-0109.yaml) - Initial iOS platform and system interaction baseline | Verify actual Xcode SDK deployment support, availability of selected APIs, target devices and any iPad-specific support before an implementation or release claim. (+2 in YAML) |
| [GITVIEW-SPEC-0115](GITVIEW-SPEC-0115.yaml) - Project Today inspection route assembly | Define actual source-to-domain mappings, public interface shapes and ownership of source, storage, clock, access and navigation boundaries after prerequisite decisions are complete. (+2 in YAML) |
| [GITVIEW-SPEC-0118](GITVIEW-SPEC-0118.yaml) - Accessible historical point inspection and return | Choose and evaluate native inspection, traversal, focus, announcement and fallback controls across supported iOS versions and assistive technologies. (+2 in YAML) |
| [GITVIEW-SPEC-0120](GITVIEW-SPEC-0120.yaml) - Targeted zoom across overview scopes | Validate whether the proposed boundary, target arming and commit-on-release interaction are discoverable and practical in the first version; exact thresholds and ambiguity rules require native UX prototyping. (+2 in YAML) |
| [GITVIEW-SPEC-0121](GITVIEW-SPEC-0121.yaml) - Source handoff admission and access ordering | Identify the actual earliest data-transfer boundary, platform callbacks, cancellation and access-ordering mechanism for the selected iOS open and sharing APIs. (+2 in YAML) |

## Pure decisions

| Leaf | First declared open item |
| --- | --- |
| [GITVIEW-SPEC-0051](GITVIEW-SPEC-0051.yaml) - Conservative description section recognition | Exact handling of malformed or nested mixed Markdown delimiters other than the specified unclosed-region rule, and supported additional heading formats. (+2 in YAML) |
| [GITVIEW-SPEC-0110](GITVIEW-SPEC-0110.yaml) - Pure Today selection decision contract | Select a SpecificationCore dependency version and verify the proposed typed representation and caller mapping against that resolved version without collapsing unknown into rule non-applicability. (+2 in YAML) |
| [GITVIEW-SPEC-0111](GITVIEW-SPEC-0111.yaml) - Project configuration validity decision | Review the proposed Unicode whitespace-only name rule, invisible or otherwise ambiguous text, exact purpose entry semantics, input types and SpecificationCore dependency version before declaring the decision independently implementable. (+2 in YAML) |
| [GITVIEW-SPEC-0119](GITVIEW-SPEC-0119.yaml) - Scoped summary aggregation decision | Choose concrete input and result types, SpecificationCore version and caller composition after the parent and dependency contracts are ready. (+2 in YAML) |

## Evidence boundary

The leaf list and declared fields come from graph-readiness-inventory.py, whose snapshot records source hashes. The script is structural and does not establish semantic completeness, ontology consistency, source permissions, native behavior or readiness. Implementation and pilot remain deferred until the graph and relevant branches are sufficiently specified.
