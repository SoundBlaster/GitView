# Local visibility cross-graph review

Owner rationale: SpecDraft revision `ef1c2f72ef08420980a423cd63c6d34a`. Baseline: Git commit `fef38bd`. Scope is previously saved local data, confirmed GitHub revocation, disconnect, source refresh and accessible recovery; cross-account disclosure and external sharing remain separate. This is a draft reconciliation, not acceptance of the whole graph.

Independent read-only reviews covered bounded groups and compared them with the owner decision and canonical 0019. Review findings included stale hide-cache clauses, VoiceOver and gesture loss, preview source-access conflation, partial metrics and stale observations, incorrect source refresh after revocation, account-specific admission fences, and an old unselected-local-day clause. The author corrected the findings and the respective reviewers performed focused rechecks on the updated digests; final messages reported no outstanding issue in the reviewed corrections. Other untouched drafts still require audit.

For each file below, the final digest is the reviewed artifact. `next-move --candidate-file` reported `checked`; it is only a mapping, kind and identifier check and does not establish semantic completeness or readiness.

- `GITVIEW-SPEC-0024` `f58762c36c70cf4e50232a9941c23fe1b534309b5f449c1a7ff38b4fcf0d06f9`
- `GITVIEW-SPEC-0032` `c65a8571be256f0c90b23b36f16f63817d842668b8a8bdfa49a18cf905b08592`
- `GITVIEW-SPEC-0042` `a6664a9778a550dd621cd3fcbdbfbb86e30c4d8f4a72168b69edcbc29060db6b`
- `GITVIEW-SPEC-0043` `4349c107c36b691f57180768cf4abe8dffdeed60c7289222bd5262d7b3f60611`
- `GITVIEW-SPEC-0044` `8ba7df0d9dba7dee3ccdff3fd57970cc4fea1e47ad95fcb0d8a69c35477d0c1c`
- `GITVIEW-SPEC-0047` `6574c6b1c7fcc04fbac494673c5e99bb70e9a17caa63351ddfa6400bf2a10941`
- `GITVIEW-SPEC-0049` `c0dc629f844547294a9142c51259588c42f368d723d6a18ab8b77af878cee855`
- `GITVIEW-SPEC-0053` `0bb42a6a64107bbe7d849745da059e3932bb48a67808a10bc7c434ceaa77e0a5`
- `GITVIEW-SPEC-0055` `d77059724e0736e9d15b0ed6f9b48afca63b4dc5b9ff082891e3c714dc39af38`
- `GITVIEW-SPEC-0058` `552f099a5fc9ba3b12bc107b9a96e000b9d9737b8b5e59b327a5032baec2c806`
- `GITVIEW-SPEC-0064` `075836b8563b22fbba4c833af731769d2bb44dfb6b337c517b69b33b074308d3`
- `GITVIEW-SPEC-0071` `3134155ba7b1a9ccea7c124caf4e0d59ee53c9fbce1e512bee80376299f3470d`
- `GITVIEW-SPEC-0073` `21e18b06febaf0a6cd3c4c83fcf1a4ae39ba42f71be86385ab91c6fbd34b0310`
- `GITVIEW-SPEC-0074` `491c8f30b213988ea6230def6bc0beab0a14b6cdda88376a3dc435d1f88936d3`
- `GITVIEW-SPEC-0085` `9432567442ea5f3598cb0ac1c0b8a11db957817aa8b4fd267b53e231bb6cab77`
- `GITVIEW-SPEC-0088` `6d109b23cff4cb295ced54a78740dbfe9df7adf9cfa94b18ad47b88ff421d284`
- `GITVIEW-SPEC-0089` `14a76d92072794b5c3ad6b569bad21edc35c14a78d4db06d49fd1bd283af486d`
- `GITVIEW-SPEC-0093` `bef2816ee7b520c13ef619bfbc488eda14979a60fee5ecd8141d55dd2c135885`
- `GITVIEW-SPEC-0102` `a66c6589dfc8bff849c2459bc6fee56dd8ceb20a3b03671b8e790394229b88a3`
- `GITVIEW-SPEC-0104` `5868f4c43264f9a435abf23b861fd7b61156ccbf4e32c42df39738472ae9a8ac`
- `GITVIEW-SPEC-0105` `669290679533f45996b5259ebcaee7591c6005255935677a0aa1dc80a72afd9c`
- `GITVIEW-SPEC-0111` `f25cf84fa4fa3ff679f9c1a594ceb8e2d23781603f3032d01862f57831e53c11`
- `GITVIEW-SPEC-0112` `be0410afdbd475d09087df3d872ae3d6a246652782ffea26b5e867e30f73e37e`
- `GITVIEW-SPEC-0113` `9fd3dfcaa15c75612606a9d496858f8e5e30e0e85239c8bb97b82b7dd12b4d11`
- `GITVIEW-SPEC-0114` `5a0eac3263b85f8d61dc00e85c3339d868fcf0fa3dd1abeafb2011247ab4084c`
- `GITVIEW-SPEC-0115` `2ffe309252a745a028e31d7aa22bbe02ca62fcdbef2d689c3a18e7e0f511f3df`
- `GITVIEW-SPEC-0116` `3f6e7427039a959bfd44dd47e9237dc9386e5a49a06979088aa46fe55a419cb8`
- `GITVIEW-SPEC-0119` `ee358fd6aa48839951189937447e41d7a6333920a0968ab11739a59f2d1082d8`

The YAML linter reports existing draft metadata problems such as missing `updated_at`; baseline comparison is needed before attributing them to these edits. User-approved Today local-day behavior and persistent filter preferences were also reconciled in the reviewed scenarios.
