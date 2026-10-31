# GitView: native ontology context pilot

Status: review-only installation and exploratory smoke check. This does not
create or accept a GitView ontology package or a specification.

## Installation

- SpecGraph native source runtime: commit
  `39b66a60ad0d1713d51f5c7a041a4733391563c9`, Python 3.12.11,
  `/Users/egor/.local/share/specgraph/runtime-39b66a60/specgraph-runtime`.
- SpecGraph source checkout and `origin/main` matched at installation time.
  The previous `runtime-562342bb` was retained.
- `specgraph-project-ontology` already matched the new distribution. The
  conversation-notes skill gained contextual-agreement guidance: installation
  correctly refused to overwrite its older copy, which was verified against
  the previous distribution and Git before updating it from a staged install.
  Re-running the installer returned `already_installed` for both skills.
- The new runtime verified the existing GitView sketch at revision
  `e93b731085884d77a995812813531bd4`, with 27 revisions and `canonical: false`.
- A separate copy of that sketch under the TB5 pilot workspace was used to
  test writing: two clearly synthetic notes captured a proposal and a scoped
  reply, with the reply linked to the proposal. `verify_history` confirmed 29
  revisions in the copy and no whole-sketch approvals; the original `CURRENT`
  remained unchanged. No synthetic note was written to the project sketch.

## Real workspace: missing selection

Running `ontology-context` against the GitView workspace and its existing
`specgraph.project.yaml` returned exit 1, `outcome: unavailable`: no ontology
selection and no compiler had been supplied. It correctly retained
`semantic_approval: not_established` and `canonical_mutations_allowed: false`.
No project ontology selection was automatically created.

## Isolated positive and negative controls

The following checks used a separate workspace under TB5:

`/Volumes/TB5/Developer/Builds/GitHub/GitView-a40d73ccf162f8d8/ontology-pilot-39b66a60/`

The temporary `app.gitview.pilot` package is a draft with candidate `Project`
and `Repository` classes and a **trial structural** membership declaration.
It draws on conversation excerpts 10, 24 and 25. Its relation declaration
does not establish the actor/action semantics discussed in excerpt 21 and is
not a formalization decision. `SG-SPEC-9001` is a synthetic test input only;
its deliberately unknown `Group` term tests gap detection and is not a GitView
specification or a proposal to introduce Group.

The compiler was the existing local `Ontology/.build/debug/ontologyc` binary,
SHA-256 `98c5e50f3b779888fc290ec4159e29d6dd0179ac9f4706ec476bec327bb5f847`.
Its provenance was not verified. `ontologyc check` and `compile` both passed;
the `ontologyc-foundation-v1` context check returned `verified` for the pinned
source, IR and compiler (exit 0). This is structural verification, not review
or acceptance of the draft's meanings.

Two controls returned `invalid` (exit 2): a deliberately wrong source digest,
and an unknown `sg:Typo` base class. The latter also had a missing IR; the
report retained the invalid name-resolution diagnostic instead of masking it
as unavailable. Reports and inputs remain in the isolated workspace above.

The native Supervisor's target-scoped advisory operation was then run on the
synthetic specification. It returned `checked`, preserved the target bytes,
matched Project and Repository as spelling candidates, and reported Group as
an unknown term with a source location. Its binding report also emitted gaps
for the synthetic `kind` and `id`; these are observations from the test input,
not findings about existing GitView specifications. `checked` was returned
despite gaps: it means that the advisory operation ran, not that the target
passed a semantic gate. The report explicitly leaves prose unassessed, semantic
approval unestablished and canonical mutation/policy activation disabled.

## Boundary and next step

The distribution does not install `ontologyc`, and the real GitView workspace
still has no selected project ontology or accepted terms. A future decision can
review whether and how to author a real project package and select it; this
pilot does not make that decision. The real project still has no specification
node to pass to the target-scoped operation.
