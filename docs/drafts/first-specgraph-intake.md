# First SpecGraph intake: GitView

Status: exploratory, pre-canonical. No graph candidate or specification was
accepted or materialized. The source is `.specgraph/root_intent.md` and the
conversation sketch at revision `1396c542e64749d1bdad985fb1f732b2`.

Using the installed native runtime at `ae423c62`, the intake interview was run
with isolated outputs in `runs/gitview-first-intake-v2/`. It returned
`needs_clarification`, with eight questions concerning ontology, domain,
context, model applicability, events, commands and policies. Its reported
source was not written. This is a workflow gate, not a judgement that the
product concept is incomplete.

An additional experiment in `runs/gitview-first-intake-v3/` supplied proposed
technical frame values and agent-suggested event/command/policy hints. The
result was structurally `ready_for_event_storming_intake`, but its derived
domain record marked the agent-provided `domain.gitview` as
`owner_confirmed: true`. The user has not explicitly confirmed that domain
reference. Treat that field as an incorrect attribution; do not use this
experiment's source as an approved input or promote it. No canonical specs
were changed. The v3 values, including the proposed identity-preservation
policy, are exploratory suggestions rather than user-approved requirements.

The first v1 attempt omitted the required public-safe summary; the wrapper
therefore suppressed the raw text from the session and reported missing intent.
The separate v2 output supplies a short summary without overwriting v1.

For the product discussion, the immediate open question is how zoom should
behave: continuous, discrete, or a combination. The calendar remains a
possible view. See `zoomable-grid-proposal.md` for exact quotations, proposed
examples, and additional open decisions. Resolve the authority attribution
before advancing any intake-derived graph.

The raw reports under `runs/` are local and Git-ignored. They are not a backup;
the tracked note records the interpretation and limitations, not the full
input payload.
