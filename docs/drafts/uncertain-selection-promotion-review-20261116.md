# Uncertain work selection: outlined node

Baseline `587ea39`; predecessor `docs/drafts/GITVIEW-SPEC-0042.yaml` at `33fb739`; canonical owner decisions in 0019, 0027 and 0032. The node defines inspection, coverage and accessibility outcomes for uncertain work, without selecting a particular native section, ordering or UI implementation. It remains outlined, not implementation ready.

Independent first-draft read-only review checked SHA `f36a77187c440f7ec55f84aae5a32ebf2f4eab6036993c5b1eabb8568bf6a4da` against parent and dependencies. The reviewer identified that a known uncertain object may be available from a current partial response before durable save, and that time must be shown only when supported. The author corrected both without treating unpersisted data as saved. Focused rereview confirmed final SHA `ece847f332a298e77382eb0219e8240dc4dbf444f08893c763cf0993b9e1d2c5` and reported both concerns closed.

A byte-identical temporary candidate returned `checked`; `next-move --target-spec` and YAML lint passed. These do not prove semantic completeness, source availability, device behavior or implementation readiness.
