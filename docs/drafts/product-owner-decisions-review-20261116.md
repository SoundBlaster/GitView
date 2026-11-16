# Product decisions: grid and account boundary — review record

Owner decisions are captured with full SpecDraft history. A multi-Repository Project opens its shared grid; the Repository list is in Project settings. Pinch moves through discrete detail levels and transitions at a maximum cell-size boundary when the intended target is determined. Sharing a local Project is not required for the first version. GitHub access revocation is external and separate from switching the active account: while A remains active, A's retained private data is visible with the selected indication; while B is active, private data saved from A is not displayed and is not deleted merely by switching. Behavior after returning to A remains open.

Read-only independent reviews: multi-Project choice (0004/0006/0074/0091); pinch (0014/0024/0035/0074/0075); sharing (0016); account correction (0001/0019/0036). Reviewers identified ambiguity about settings navigation, mandatory pinch transition, and account boundary after external revocation; revised cases were rechecked. The exact 0016 SHA was rechecked after its provenance-only path correction and passed. Account review covers these three nodes, not all graph consumers. The exact 0014 acceptance correction was independently rechecked.

Structural checks: all 71 nodes pass YAML lint. Candidate copies of the 12 changed nodes passed `next-move --candidate-file`; that check does not establish semantic correctness. `ontology-ref-diff` against each predecessor draft found no missing declarations except historical differences: 0001 retains qualified refs but the older draft also has unqualified terminology and `motivcore:Motive`; 0004's draft includes Issue and PullRequest, and 0016 and 0036 each include Project. These differences predate this change and are not proof of semantic equivalence; they remain for a separately scoped predecessor audit. No current `ontology_refs` were removed relative to HEAD. The 12 per-node composition context checks returned `checked`; their detailed inventories and gaps still require inspection. Structural checking is not ontology or implementation approval.

Full graph independent review and reconciliation of other account-change consumers remain separate from these scoped reviews. Filter-conflict behavior outside the historical merged-counter decision and the definitions of ready and long-waiting review remain open.

## SHA-256 of nodes at this review

- 0001: `94e3f6432b60f9f866087a0706d8e24dba1bc04cf19bb48eeb6254c623a7974f`
- 0004: `af36e3f63d43bd2a3f57459a87018343df9e5d16e20e222cefbdb002528ffad6`
- 0006: `721bc79f0640334e5046d98ba7abd04438a714fc6980f7fbb12c0bed10c8f0df`
- 0014: `d2d69924f51bdcd5c0945299ec9d451c079e881c918878e5dce73a45719f65a0`
- 0016: `52a0c6129646503a6c99dfe46ebec2371f9aaa4053049658d565a196de4ff25b`
- 0019: `54b615d1684537238f82031cba4441eddcfb6ba7a5a56db3fb0cf57e97e7ed4f`
- 0024: `e37ec342e4a512f33095e11cc55af4e24da300daf83dccb7e1e733dc52132c02`
- 0035: `0207b8d6bfd1e2fdcec876dd7a63fee44323c16734384a576eff920b5fb60fdf`
- 0036: `5285b69a2417838b16b1b8c560f497cd06006fc1c773d23ae2bba3589c10a3c4`
- 0074: `2c99728a669120afdd7f8de09e130681b6328b17b9eb7bc0fa8eceaa79fb0c45`
- 0075: `9f7982320b1aaedbd69d7177c8c82e69ebc1b04a98f450d351cacc2573579bdf`
- 0091: `76784c53880fef224563478a6d89a901f0e41ccac6e82a307ba4eb1d5eb06923`
