# Confirmed private-repository revocation: decision and review

Owner decisions captured verbatim in SpecDraft revision `b0795ae580e94ba0be8c59cefcbd3a97`: keep saved private data locally without synchronization; continue showing it with a revocation indication and last update time. This is not a whole-sketch approval.

Scope: confirmed revocation for the affected private repository and account. Ambiguous source errors are not themselves confirmation. Disconnect, account change, evidence of revocation, recovery and exact missing-time presentation remain open. Existing draft-only policies requiring hidden cached content must be reconciled before promotion; at least drafts 0019, 0023, 0031, 0036, 0037 and 0075 contain candidate formulations that may conflict in this scenario. Do not treat them as owner-approved exceptions.

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
