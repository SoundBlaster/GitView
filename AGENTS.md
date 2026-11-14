# GitView agent workflow

GitView is a SpecGraph product workspace. Read `.specgraph/root_intent.md` and
`docs/product-discovery.md` before product work. `docs/drafts/` contains
reviewable proposals, not canonical specifications; `specs/nodes/` is reserved
for governed specification artifacts.

## Conversational capture

Use the project-local skill
`.codex/skills/specgraph-conversation-notes/SKILL.md` when discussing product
or design ideas. The local runtime installed for this pilot is
`/Users/egor/.local/share/specgraph/runtime-3593bd75/specgraph-runtime`.
For its standalone `specgraph` CLI, use the executable in the same installation
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
`/Users/egor/.local/share/specgraph/runtime-3593bd75/specgraph-runtime --workspace "$PWD" next-move -- --candidate-file docs/drafts/GITVIEW-SPEC-0004.yaml`.
The report checks YAML mapping, spec kind and filename/ID consistency; it does
not validate ontology, dependencies, acceptance or maturity and does not
materialize the draft into `specs/nodes/`.

## Product ontology

Read `ontology/domain-model.md` for the consolidated semantic model and
`ontology/review/completeness.md` for its current gaps. These reconcile later
decisions beyond the pinned package. Current priority is ontology completeness,
then the specification graph; visual review-indicator work is deferred.

Use `.codex/skills/specgraph-project-ontology/SKILL.md` when discussing,
drafting or reviewing domain terminology and relationships. Its installed
version is supplied by the runtime above. Project terminology in notes and
drafts is not automatically an accepted ontology; preserve gaps and sources.
Read [the draft.9 package guide](ontology/candidates/domain-v0.2.0-draft.9/README.md)
for the working ontology context. `specgraph.project.yaml` selects its
`composition-context.yaml` for preparing the specification graph. The package
remains a draft. Structural checks do not establish actor, motive or causal
facts. Draft.8, draft.7, draft.6, draft.5 and draft.4 remain available as controls. The former selection at `ontology/context.yaml` and the original
`ontology/pilots/motivation-composition/` are available as controls.

For the selected context, pass the compiler at `git config --get gitview.ontologyc` to the installed runtime.
The compiler is a locally built, SHA-256-pinned snapshot of Ontology commit
`4c5027b`; see the draft.9 guide. It is not a verified release binary.
The `ontology-context` command reads the selection from project configuration.
For a target check via `supervisor`, pass that same path explicitly with
`--ontology-context-selection`.
For the earlier operator-action control, use the [draft.3 package and verification command](ontology/candidates/domain-v0.2.0-draft.3/README.md).
The old ontologyc 0.7.0 release does not support the draft.5 typed reference.
