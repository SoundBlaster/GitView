# GitView agent workflow

GitView is a SpecGraph product workspace. Read `.specgraph/root_intent.md` and
`docs/product-discovery.md` before product work. `docs/drafts/` contains
reviewable proposals, not canonical specifications; `specs/nodes/` is reserved
for governed specification artifacts.

## Conversational capture

Use the project-local skill
`.codex/skills/specgraph-conversation-notes/SKILL.md` when discussing product
or design ideas. The local runtime installed for this pilot is
`/Users/egor/.local/share/specgraph/runtime-43ea8e92/specgraph-runtime`.
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

## Product ontology

Use `.codex/skills/specgraph-project-ontology/SKILL.md` when discussing,
drafting or reviewing domain terminology and relationships. Its installed
version is supplied by the runtime above. Project terminology in notes and
drafts is not automatically an accepted ontology; preserve gaps and sources.
Read `ontology/packages/gitview/README.md` for the current project draft and
its source map. `ontology/context.yaml` selects that draft for structural
checks; selection and successful checks do not approve its meanings.
An opt-in, versioned composition experiment lives at
`ontology/pilots/motivation-composition/`; it does not replace the selected
foundation-only context or establish actor, motive or causal facts.
