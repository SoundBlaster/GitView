# Connection state and saved observations: outlined node

Baseline `bb272d9`, predecessor `docs/drafts/GITVIEW-SPEC-0036.yaml` at `fef38bd`; owner rationale `conversation_memory/sketches/gitview/revisions/ef1c2f72ef08420980a423cd63c6d34a/notes.hc`. The outlined node separates connection failure, confirmed source revocation, disconnect and locally stored observations, while preserving the operator entry point. Cross-account isolation, technical authorization and exact presentation remain open. It is not implementation readiness.

Independent read-only first-draft review checked SHA `51ca0c87bf44fa7c989e180ae60c0d49e7a351e49f60543b453a94a2f7b6634b` against the owner decisions and canonical 0019/0003/0023 and found no blocker. The reviewer suggested an explicit sentence distinguishing the selected local card behavior from undecided cross-account policy. The author added it and focused rereview confirmed SHA `d5e271e283400a4839865bd54356ca7d826934be7702eb0cc9e4e47cda12e370` with no remaining concern in that scope.

A byte-identical temporary candidate returned `checked`; `next-move --target-spec` and YAML lint passed. These are not proof of semantic completeness, implementation or device behavior.
