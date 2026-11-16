# GitView agent workflow

GitView is a SpecGraph product workspace. Read `.specgraph/root_intent.md` and
`docs/product-discovery.md` before product work. `docs/drafts/` contains
reviewable proposals, not canonical specifications; `specs/nodes/` is reserved
for governed specification artifacts.

## Conversational capture

Use the project-local skill
`.codex/skills/specgraph-conversation-notes/SKILL.md` when discussing product
or design ideas. The local runtime installed for this pilot is
`/Users/egor/.local/share/specgraph/runtime-aa9f6cb9-py313/specgraph-runtime`
(SpecGraph v0.2.0, commit `aa9f6cb9010a003b8d09b1b4773498c07d1395ba`).
The previous installation at
`/Users/egor/.local/share/specgraph/runtime-3a7f176a/specgraph-runtime`
is retained for rollback; select it explicitly when testing the old version.
For the selected runtime's standalone `specgraph` CLI, use its executable
at `venv/bin/specgraph`, or invoke the runtime's `draft` subcommand. If that
installation is unavailable, report it and choose or install a compatible
runtime before writing; do not silently switch to a developer checkout.

Use `conversation_memory/sketches/gitview/` as the persistent, Git-tracked
sketch. Begin with `read_notes`, use its exact revision for `update_notes`, and
preserve verbatim quotations separately from agent interpretations. Local
source references identify excerpts; they are not authenticated message IDs.
Only record whole-sketch approval when the user explicitly approves the
displayed whole sketch at its exact revision. A note or proposal is not a
canonical spec. See the skill's `references/usage.md` for the full contract.

Preserve `CURRENT` and every reachable revision's `notes.hc`, `notes.hcs`, and
`metadata.json` together in Git. Before staging, follow the skill's Git storage
contract: inspect the full history and destination, avoid concurrent writers,
run `notes verify_history`, and stage the exact reachable files. Do not stage
`.lock`, temporary files or unreachable revisions. Verify recovery in a fresh
checkout. The sketch contains conversation quotations and remains local-only
unless the user explicitly authorizes a destination for publication. Capturing
a revision does not itself create a Git commit; commit it with its full ancestry.
Other sketches and local `runs/` remain excluded from this repository.

For a single YAML proposal under `docs/drafts/`, use the read-only candidate
check directly in this workspace:
`/Users/egor/.local/share/specgraph/runtime-aa9f6cb9-py313/specgraph-runtime --workspace "$PWD" next-move -- --candidate-file docs/drafts/GITVIEW-SPEC-0004.yaml`.
The report checks YAML mapping, spec kind and filename/ID consistency; it does
not validate ontology, dependencies, acceptance or maturity and does not
materialize the draft into `specs/nodes/`.

Lint specification YAML with the installed runtime, passing explicit
workspace-relative paths. For all current canonical nodes from the project root:

```sh
/Users/egor/.local/share/specgraph/runtime-aa9f6cb9-py313/specgraph-runtime \
  --workspace "$PWD" lint -- specs/nodes/*.yaml
```

For an individual draft, pass its `docs/drafts/...yaml` path instead. Inspect
the JSON `status` and per-file `issues`; lint checks YAML and canonical
formatting, not semantic review, ontology approval or implementation readiness.

## Ontology references during promotion

When creating or revising a governed node from a predecessor draft, compare its
explicit `ontology_refs` and `specification.terminology` with the node's actual
scope and the selected ontology context. Preserve or add relevant references;
record the reason for omitted predecessor declarations and for a node with no
applicable references. Do not infer specific actor actions or instance facts
from vocabulary references. Historical source material retains its own context.

Run the installed runtime's `domain_vocabulary` context check for each changed
node and inspect inventory, resolved candidates and gaps, not only `checked`.
Record a no-input result separately from a successful binding. A structural
binding does not establish semantic correctness or implementation behavior.
Use `ontology-ref-diff` for the predecessor/successor comparison and explicitly
explain intentional removals, for example:

```sh
/Users/egor/.local/share/specgraph/runtime-aa9f6cb9-py313/specgraph-runtime \
  --workspace "$PWD" ontology-ref-diff -- \
  docs/drafts/GITVIEW-SPEC-0001.yaml specs/nodes/GITVIEW-SPEC-0001.yaml
```

It compares exact declarations; renamed or qualified terms require separate
semantic review. Use `--explain-removal TERM REASON` for each intentional
removal rather than treating an explanation as proof of equivalence.

## Independent specification review

For a new or substantively revised specification, run the structural
candidate check and request semantic review from a read-only subagent before
using the draft to assess readiness for the next stage. Review one node or a
small group of nodes that describe the same behavior.

State the review objective in the brief. Choose it from the work the draft
is doing and the specific problem under review.

- **First draft.** Check that the draft captures the recorded intent, defines
  its scope and makes the expected outcomes and open choices visible. Ask for
  an example where omitted intent or an unstated choice could change the draft.
- **Refinement.** Compare the draft with the preceding revision and applicable
  parent and dependency contracts. Check that criteria and scenarios agree
  about observable outcomes, boundary cases and the status of product choices.
- **Correction.** Give the reviewer the reported defect and an example that
  exercises it. Ask them to trace the example before and after the change
  and check nearby cases for unintended effects.

Give the reviewer the exact Git revision or artifact digest, the agreed intent,
the relevant parent and dependency contracts, and the required behavior.
Use fresh context and let the reviewer derive expected outcomes from these
sources before comparing them with the draft. Ask for findings with a stable
locator, a concrete example and the consequence for the proposed behavior.

Record the reviewed revision, objective, scope, findings and the author's
disposition in the corresponding review note. Send substantive corrections
back for focused review on the updated revision. If a reviewer is unavailable,
record the pending review for that scope. The review can support a readiness
assessment. Product approval and authorization to proceed follow the project's
governance process.

## Product ontology

Read `ontology/domain-model.md` for the consolidated semantic model and
`ontology/review/completeness.md` for its current gaps. These reconcile later
decisions beyond the pinned package. Current priority is ontology completeness,
then the specification graph; visual review-indicator work is deferred.

Use `.codex/skills/specgraph-project-ontology/SKILL.md` when discussing,
drafting or reviewing domain terminology and relationships. Its installed
version is supplied by the runtime above. Project terminology in notes and
drafts is not automatically an accepted ontology; preserve gaps and sources.
Read [the approved 0.2.0 package guide](ontology/packages/gitview/versions/0.2.0/README.md)
for the working ontology context. `specgraph.project.yaml` selects its
`composition-context.yaml` for preparing the specification graph. The owner accepted the selected local package content as a project baseline;
see `ontology/review/owner-acceptance-20261116.md`. Its local package metadata is approved; imported packages retain their own status. Structural checks do not establish actor, motive or causal
facts. Draft.9, draft.8, draft.7, draft.6, draft.5 and draft.4 remain available as controls. The former selection at `ontology/context.yaml` and the original
`ontology/pilots/motivation-composition/` are available as controls.

For the selected context, pass the compiler at `git config --get gitview.ontologyc` to the installed runtime.
The compiler is a locally built, SHA-256-pinned snapshot of Ontology commit
`4c5027b`; see the selected package guide. It is not a verified release binary.
The `ontology-context` command reads the selection from project configuration.
For a target check via `supervisor`, pass that same path explicitly with
`--ontology-context-selection`.
For the earlier operator-action control, use the [draft.3 package and verification command](ontology/candidates/domain-v0.2.0-draft.3/README.md).
The old ontologyc 0.7.0 release does not support the draft.5 typed reference.
