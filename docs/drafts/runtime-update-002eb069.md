# Installed SpecGraph update — 002eb069

On 2026-11-06, updated GitView from `b1583e58` to SpecGraph
`002eb0691b39ea2ccdcc50d0c5c31fc84022e3bf` (package version `0.2.0`).
`AGENTS.md` now selects the separate installation at
`/Users/egor/.local/share/specgraph/runtime-002eb069/specgraph-runtime`.
The previous runtime remains available; workspace initialization was not repeated.

## Verification

- Installed CLI starts and reads the existing sketch. Full history verification
  reports 79 revisions complete at `f7c0ae6bc12849eba02d53201dd4ac26`, including
  recovery from a fresh local clone. Notes were not edited.
- All four selected checks return `verified`: the current default ontology,
  the existing motivation composition, and both foundation/composition contexts
  of the separate `domain-v0.2.0-draft.3` candidate.
- The actual `GITVIEW-SPEC-0001` draft was copied byte for byte into the isolated
  checkout's spec location solely for the target-scoped CLI. Both current-domain
  and existing-composition checks return `checked`, domain `analyzed`, and
  metamodel `not_requested`. No canonical specification was created in GitView.
- The new distributed ontology skill describes typed action references. Its
  `GitView project example` extension was preserved byte for byte; the unchanged
  conversation skill already matches the new distribution.
- All 302 protected tracked files under notes, ontology and specifications
  remain byte-identical. The selected project context is unchanged.

The historical draft.3 runtime limitation recorded in its README is superseded
by this run: the new SpecGraph accepts its foundation 0.2.0 and authored
`subject / action / object`. This does not select or approve the candidate.
Its existing `repositoryId` model has not been migrated to `Ref<Repository>`.
The existing ontologyc 0.7.0 binary was reused; its SHA-256 is recorded in the
commands. Release provenance was not re-established during this runtime update.

[Machine-readable receipt](evidence/runtime-update-002eb069.json) includes input
revision, exact draft hash, runtime receipt, commands, history and context results.
Full reports are retained under
`/Volumes/TB5/Developer/Builds/GitHub/GitView-a40d73ccf162f8d8/runtime-update-002eb069/`.
`verified` and `checked` describe structural/advisory checks, not approval of
terms, specification completeness or executed product behavior.

Next: review the operator candidate with the updated skill before deciding
whether to migrate its repository reference or select it as the project context.
