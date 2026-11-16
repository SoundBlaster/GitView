# Refresh triggers and observation status: outlined nodes

Baseline `986d172`. Nodes 0048 and 0044 refine manual, foreground and opportunistic background refresh, scoped source observations and visible failure. Exact staleness thresholds, API costs and operations, source error mappings, persistence provider and native controls remain open. The pinned ontology compiler mismatch is recorded in the 0AL ledger; no fresh composition verification or implementation readiness is claimed.

Independent read-only first-draft reviews and dispositions:

- `0048`: initial SHA `cb90c7ac93122a0818cf94cee165d8f034640b1c9c756378d184460cfecb56a2`. Reviewer identified missing shared source budget/cost across refresh triggers, the need to surface an actually supported GitHub error and last success when known, and the distinction between manual refresh and an age-only stale threshold. The author added these while leaving numeric policy open; focused rereview confirmed final SHA `653602691621ba35b6945f452bbc3debfff196639fc54eee9d2370647965ad63`.
- `0044`: initial SHA `9413b9e794296c3fc7fc0d44baf61630b28bc5957f79fe0b804edb0d58f1e72a`. Reviewer identified omitted/errored/ambiguous fields versus confirmed absence, unorderable or in-flight attempt outcomes, explicit graph dependencies and unknown saved time. The author corrected each; focused rereview confirmed final SHA `00abc957f17e3df7ad9d121642b67f314f39787485db2082e5b1ea4c8ab3bc64`.

Byte-identical temporary candidates returned `checked`; `next-move --target-spec` and YAML lint passed. These checks do not prove actual GitHub behavior, native background execution or implementation readiness.
