# SpecDraft pilot observations

Status: local pilot observations, not canonical requirements or evidence of a
completed product implementation.

## Setup and capture

- Existing product workspace: repository root; no second workspace created.
- Native runtime source commit: `538271c0fcb0460b6197c80ca4f2d48f14a9eb56`.
- Installed runtime: local `runtime-538271c0-py312`; Python 3.12.11.
- Project-local skill installed through the runtime, including its bundled
  `references/usage.md`.
- Local sketch `conversation_memory/sketches/gitview/` is ignored by Git.
  Eight attributed notes were read back at revision
  `1396c542e64749d1bdad985fb1f732b2`, with `canonical: false` and no review
  records.
- A human-readable, bounded proposal was prepared manually in
  `zoomable-grid-proposal.md`; no exporter or canonical materializer was run.
- Before the quotation correction, the installed runtime served the selected
  sketch on loopback; `/api/notes` returned `display_state: current` and then
  revision `98af2794d14b4c588b7fe1dfffcc1559`. The server was stopped after the
  check. Visual browser verification was unavailable because local browser use
  was disabled in Work settings.

## Manual steps and friction

1. The first installer invocation resolved to Python 3.9.6 and failed the
   package's Python 3.10 minimum. Its partially created destination was
   retained. A second invocation using an explicit Python 3.12 succeeded at
   a different destination.
2. Installing the skill did not configure Git ignore rules or agent
   instructions; both were added explicitly before capturing project notes.
3. The bundled skill documents the `specgraph` executable, while the native
   runtime exposes a `specgraph-runtime` launcher. The project instructions
   identify both supported routes and the chosen sketch path.
4. The existing workspace was reused. Reinitialization and next-move were not
   run because they write named local reports and no canonical spec exists yet.
5. A proposal still requires the agent to select sources, preserve the sketch
   revision, separate user statements from interpretations, and formulate
   review questions. This handoff is manual.
6. The first `foundations` source (`excerpt-08`) encoded line breaks as literal
   `\n` characters instead of preserving them. A `revise` operation added the
   exact quotation as `excerpt-08-corrected`. The erroneous source remains in
   immutable history and must not be treated as the exact quotation.

## Limits

The local runtime was exercised on real, source-attributed conversation input.
The recorded references are local excerpt labels, not authenticated source
retrieval. The sketch was not approved as a whole, and no canonical graph
mutation or real application validation was performed. The ignored sketch is
not backed up by Git.
