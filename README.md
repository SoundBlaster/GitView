# GitView

GitView is a planned native iOS app for understanding work across many GitHub
repositories. Its starting point is a zoomable view of projects, pull requests,
issues, reviews, checks, and activity.

This repository currently contains **product discovery and a SpecGraph product
workspace**. It does not yet contain an iOS application or claim that any
behavior has been implemented or tested on a device.

- [Root intent](.specgraph/root_intent.md) — pre-canonical product input.
- [Discovery notes](docs/product-discovery.md) — agreed direction, ideas, and
  unresolved questions from the initial conversation.
- [First autonomous product pass](docs/drafts/product-first-pass-20261115.md) — product outcomes, relationships and open questions.
- [First-pass product graph](docs/drafts/product-first-graph-20261115.md) — product nodes and stage boundary.
- [Product foundation draft](docs/drafts/product-foundation.md) — idea,
  candidate vocabulary, application boundary, UX and proposed spec map.
- [Product overview specification candidate](docs/drafts/GITVIEW-SPEC-0001.yaml)
  — a source-attributed, pre-canonical draft for review and scoped checks.
- [Repository exploration](docs/drafts/repository-meaning.md) — proposed domain
  meaning and open questions.
- [Project ontology draft](ontology/packages/gitview/README.md) — candidate
  vocabulary, source map, open questions and structural verification.
- [Executable operator candidate](ontology/candidates/domain-v0.2.0-draft.3/README.md) — a GitView User adds an existing Repository to one Project.
- [Readable ontology composition](ontology/views/README.md) — a review-only
  HC/HCS pair and its reproducible source selection.
- [Motivation composition pilot](ontology/pilots/motivation-composition/README.md)
  — an opt-in experiment with the existing Ontology motive vocabulary.
- [Product workspace configuration](specgraph.project.yaml) — initialized by
  SpecGraph and configured to select the draft ontology context.
- [Spec ID policy](.specgraph/spec-id-policy.json) — reserves the
  `GITVIEW-SPEC` namespace for future spec allocation; it does not create specs.
- [Zoomable grid proposal](docs/drafts/zoomable-grid-proposal.md) and
  [SpecDraft pilot observations](docs/drafts/specdraft-pilot-observations.md)
  — pre-canonical inputs for review.

## Working with SpecGraph

This repository root is the product workspace root. SpecGraph's engine and
policies remain in the separate SpecGraph checkout. The initial workspace was
created using the local engine at commit
`697f3dcf3969ecc2ff47370dcf89719f6d3598b2`; that is provenance, not an
automatically enforced version pin.

The initializer wrote a local receipt to
`runs/product_workspace_initialization.json`. Runtime reports under `runs/` and
Supervisor worktrees under `.worktrees/` are local and ignored by Git. A clone
contains the tracked intent and configuration, not those local receipts.
Initialization captures intent for review; it does not create or approve a
canonical specification. Use the product workspace workflow and explicitly
review the next materialization step. Do not rerun the initializer blindly
after other project files have been added: it validates the workspace layout.

For conversational capture, the installed project-local SpecDraft skill and
runtime are described in [AGENTS.md](AGENTS.md). The GitView sketch and its
complete published revision chain are kept in this local Git repository; runtime
lock and temporary files remain excluded. Future revisions need to be committed
with their complete ancestry. A commit does not approve a draft or publish it.
The [local history check](docs/drafts/specdraft-history-check.md) records the
earlier backup and recovery test.

## Intended foundations

- [FSD iOS](https://github.com/SoundBlaster/FSD) supplies the feature-sliced
  architectural approach and tooling. It is not an app runtime dependency.
- [SpecificationCore](https://github.com/SoundBlaster/SpecificationCore) is
  intended for named domain policy decisions when the Swift application is
  created, such as evaluating PR readiness from typed, sufficiently fresh
  facts. Network access, storage, and UI effects remain outside those policies.

Neither foundation has been integrated into application code yet. The version
and integration approach must be chosen when that code is introduced.
