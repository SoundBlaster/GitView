# Confirmed private-repository revocation: decision and review

Owner decisions captured verbatim in SpecDraft revision `b0795ae580e94ba0be8c59cefcbd3a97`: keep saved private data locally without synchronization; continue showing it with a revocation indication and last update time. This is not a whole-sketch approval.

Scope: confirmed revocation for the affected private repository and account. Ambiguous source errors are not themselves confirmation. Disconnect, account change, evidence of revocation, recovery and exact missing-time presentation remain open. The later owner rationale broadens the UX principle against disappearing saved data. Six directly affected drafts were reconciled as documented below; other dependent drafts still require review before promotion. Account isolation and unrelated access cases remain open.

## Independent semantic review

Review objective: compare the selected owner behavior with the prior nodes, preserve boundaries around unsupported source signals and access cases, and trace an already-open preview and missing update time. Read-only reviewers inspected exact artifact hashes. Initial findings were: 0003 retained an overly broad disclaimer, 0003/0019 did not consistently qualify unknown time, 0020/0024 treated the chosen policy as wholly open, and 0015 lacked a revocation scenario and separate restrictions/freshness boundary. All were corrected and substantively changed files independently re-reviewed; no further contradiction was found in the reviewed scope. 0001 and 0015 passed their original or focused review without further findings.

Final reviewed SHA-256:

- 0001 `d49ca236ab3b99585aa3b20cf0ed179410a5bdc5ce04fed2952d967569074a23`
- 0003 `9ebe03bc0b4d4a7323e89154abf1b7c43b5861fcc6eda672e168db98202a79ef`
- 0015 `d27d289a8aac795be6492a17148a8fc0025c839aa7649cd498779e8b0f34fe0a`
- 0019 `7ae080ed4d8c1fd738deb969b037238d29c8786c64bbd4add721889c98a1d771`
- 0020 `e687576c931d56afd17c00ac99a122ffa30a04d171391d5e7632a4dc34f822cf`
- 0024 `6c9324c798b156fb8a8f74fecd96a06edefc59063de71465ccde0b72b3da1336`

Structural candidate checks on temporary byte-identical copies returned `checked`; this only checks YAML mapping, kind and ID, not semantics or readiness. Targeted `next-move` returned targeted refinement, not implementation readiness.

## Owner rationale and dependent drafts, 2026-11-16

SpecDraft revision `ef1c2f72ef08420980a423cd63c6d34a` preserves the exact owner objection to hiding saved data, including the need to understand what happened and retain a point of access for recovery or intentional deletion. This is a UX principle and does not prove that unavailable local records exist, or decide cross-account isolation.

Corrected draft scope: 0019 and 0036 access and retention, 0023 overview and missing credentials, 0031 local preview/open, 0037 in-flight refresh, 0075 gestures. These remain drafts; no promotion or implementation readiness is implied. A separate account identity is not proof of access to another account's data.

Independent read-only reviewers compared each draft against Git revision `9466d0b`, canonical 0019 and the owner decision. Initial review found contradictions on offline restart, rollback, missing credential, disconnect, local open during preview and gesture recognition. Follow-up corrections were reviewed against their exact digests. A second pass found filtered preview and missing-credential overview still ambiguous; both were corrected and independently rechecked. Reviewers reported those findings closed and no further contradiction within the inspected scope.

Final checked artifact SHA-256:

- 0019 `d630c322f54f9d0732f90f5a30b6b73d1d2f3c324e128952a28eeeb41d03fb41`
- 0023 `c891d838270c65eebe4826f22ba7141072d545f53c1a69fbacc2a18946444c83`
- 0031 `73004aad0ca177a129ee9f6f2ca3c54faaa2f35e23514bfc78a48a838dc316dd`
- 0036 `8195791aae30c9859b0e394072a55c2fdf738d94660998b31b231cee3078da1c`
- 0037 `8d411b2562d9ad647790cad1a6144365c5546fa19e89806fcb8c20c33401ed05`
- 0075 `c37ad32cbbde56dbcb796f48dcc12f942b814ec902c026f1ba01dfcc95fd1617`

Candidate checks only validate structure, kind and identifier. The standalone YAML linter reports missing `updated_at` on five of these drafts; comparison with the preceding Git revision confirms the missing fields predate this change. This is not evidence that semantic review or implementation is complete.
