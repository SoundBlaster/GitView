# SpecGraph runtime update — 3131f3c1

Verified on 2026-11-02. This is an installation and compatibility receipt,
not ontology acceptance or a new specification check.

## Installation

- Fetched `origin/main` in the clean SpecGraph checkout. Both checkout HEAD and
  the fetched ref selected `3131f3c170c49fc416ff73745aad076e15ba53f2`.
- Installed a separate native runtime at
  `/Users/egor/.local/share/specgraph/runtime-3131f3c1/` with Python 3.12.11.
  The previous `runtime-43ea8e92` installation remains available.
- Installer temporary build products and pip cache were routed to verified TB5.
  The installed source snapshot and virtual environment use the runtime path above.
- Updated the operational runtime path in `AGENTS.md`.

## Compatibility checks

- Native help and the installed CLI version command succeeded (`specgraph 0.2.0`).
- `notes read_notes` read the existing sketch at
  `0bbeb16ed68e4cd6a5e660743e225325`, with `canonical: false`.
- `notes verify_history` returned `status: complete` for all 74 revisions.
  No note revision was created or changed.
- The conversation-notes installer reported `already_installed`; both project
  files match the new distribution byte for byte.
- The ontology skill installed successfully into an isolated probe project.
  Its distributed bytes are unchanged from the previous runtime. GitView's
  installed skill differs only by its existing `GitView project example` section;
  that local extension was preserved.
- Both default and motivation-composition contexts passed native
  `ontology-context` capture (exit 0) using copied inputs in an isolated TB5
  workspace. Source/IR hashes and selected package identities were checked.
  These were context checks, not spec inventory/binding/validation runs.

The compiler was the existing ontologyc 0.5.0 executable, pinned by SHA-256
`dcdc37216246f9acebca7387e14b61300d9dec4367f7c1630445b97280c80168`.
Checking that digest does not independently establish compiler provenance.

Local context reports are retained under
`/Volumes/TB5/Developer/Builds/GitHub/GitView-a40d73ccf162f8d8/specgraph-runtime/runtime-3131f3c1-pln1zapz/workspace/runs/`
as `default.json` and `composition.json`.

The initial direct attempt to write a report outside the selected workspace was
rejected by path confinement; a subsequent isolated-workspace attempt required
its output parent to exist. After preparing that directory, both captures passed.

## Boundary and next step

This revision includes the external specification artifact profile from #868
as a design candidate. Applicability approval and its runtime meta-check are
not implemented by that profile. No canonical spec, domain package, source draft
or conversation history was changed by this update.

Next: once the coordinated opt-in 0232 implementation is available, run the
consumer pilot against the frozen GitView draft with separate domain and meta
contexts and reports.
