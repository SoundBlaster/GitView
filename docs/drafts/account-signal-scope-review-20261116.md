# Account visibility and signal origin — review record

Baseline: Git `7e181bf`. Scope: the selected account boundary and signal-origin filter context, not a full semantic review of every product requirement or an implementation review.

## Decision and corrections

External GitHub revocation keeps already saved private data visible with indication and known update time while the relevant account remains active; sync stops. While B is active, A's saved private data is not shown and is not deleted just by switching, regardless of revocation. Return to A remains open. Mixed or unknown aggregate lineage and pending choices are not resolved here.

The owner's signal context statement is preserved in SpecDraft revision `9544eaa87e5b4afcb48910299d60c520`. Signals inside a filtered scope retain that scope; unrelated outside filters do not narrow signals produced outside that context. The chosen historical merged counter case presupposes its origin includes merged PRs and the saved exclusion is outside that origin. Filter hierarchy and which specific surfaces use which scope remain open.

## Read-only review

Three independent reviewers audited overlapping groups of affected nodes, traced external revocation while A remains active and subsequent A-to-B switching, and reviewed corrections. They found and resolved two scope defects: language that could constrain ordinary pre-revocation display, and language that could make switching rules conditional on revocation. A fourth reviewer checked the signal selection and historical merged-counter case; updated scenarios and acceptance were rechecked after clarifying the counter's origin. SHA-256 below pins the reviewed final artifacts; no runtime implementation was observed.

## Tool checks

- SpecGraph YAML lint: 71 nodes passed.
- Candidate checks: 45 changed nodes checked; these validate candidate structure, not semantic completeness.
- `ontology-ref-diff` against HEAD: no explicit refs or terminology declarations removed by this change.
- Comparison with predecessor drafts finds pre-existing omissions/differences in 0001, 0004, 0023, 0026, 0064 and 0093. Their presence predates this change; classification and any intentional scope exclusions need a separate predecessor review, not an assertion of equivalence. Full reports retained in the local TB5 review artifact directory.
- Isolated composed `domain_vocabulary` checks: 45 checked, 269 accepted structural bindings, 0 gaps, 0 findings or warnings, and no empty binding inventory. These checks are advisory and do not prove ontology meaning, product acceptance or implementation readiness. Compiler SHA `3e7b70f3789e683de177d7f5d78e507fda993c4aa2990baabe31530db0e63720`; compiler provenance unverified. Full reports are retained on TB5 under `GitView-a40d73ccf162f8d8/ontology-review-3a6c1g83`.
- Conversation `verify_history`: complete, 152 revisions before fresh-clone verification.

## Reviewed nodes and SHA-256

| Node | SHA-256 |
| --- | --- |
| 0001 | `178da2f069dc4aa62e36a31508254657eebf28f3d0e37018b57eca82ee5a32c7` |
| 0003 | `8c91bb801b5839440525df16bbc16135192a114bd027287965a91aa16990a360` |
| 0004 | `4ff3729ae90254d835ccf5ba9a8f6b215cbb7f297d305a1ca84409af1070a785` |
| 0007 | `c4864210d69d6800006274e7ada4ca7e88ca2c6ad284d422697f034fcf209523` |
| 0015 | `f21820a0f5a6fbd2d1e7039ee4b2fa90868a80db777d6cc2a30a8261551a5b23` |
| 0017 | `171004274c42c6e3d7677c4738d9e705541675ee5554f251f700fd195d99dac8` |
| 0020 | `105ab323c41fca58c238fb68b94d46018ca045a827bc2293362c7dde16d1dce1` |
| 0023 | `47a1f74affd648ea28da169fa1ca1f053cbd265777a1c3b0b9ca5d666b12f940` |
| 0024 | `8b6fe541d99e37462b350b8883cd0cb89f304110914c6cad0859d8e74bc0335c` |
| 0025 | `36b9266d8651ac1d3d751603a09a3e89923effb3ee04bfea89941c8e0043a903` |
| 0026 | `52574a6e7af2e7b399c1f5bb6b6d6f61e49088692f47b1b965d6de6367cdad6c` |
| 0027 | `eaf542af82e65fcc8ad20504a97d9301a6e09db7ddcd6a23ed81ac499d73251a` |
| 0029 | `3e9ff2fcb3a6fc712d965d0be171c4aaa17ae9db653dc5dce63b87576794c5fe` |
| 0030 | `ee42412f4b40e5f949b876e0c402c18a9564df564d6937956d969d8fc45e1696` |
| 0031 | `660a618ff9e85fde28b83f9d815cdf3f79f063ae15eb498c9c915a14bbaf8692` |
| 0032 | `e53c5ba8cabe9b21ecb223a500ac50b18c764f7da663b68a9f90482976ad6d09` |
| 0033 | `157ec218a2d9a539aaf86d8097ca9d43c5daee773a58d780d63336f4c963ce7d` |
| 0034 | `cfd7f3c1e9be3b1d139a4c0aafc08682f77aeb84b48410c4a8bc4a151759727a` |
| 0037 | `6dd50ea946c5623dd1279d8e0c51d29c7708193973b7e3c7bb1fd6148ae09ab3` |
| 0039 | `e918d6d1b421a0a8856839191c4ff0ae913c6bc8d8867958d69edbf7294c6eee` |
| 0041 | `02cd308f77f9b4194c021b9bd6fe5083e162d850d7da6678465a65ecdadd4326` |
| 0042 | `142fbc551cbd588a9b273a571c3bf28d5b53b22ebbc9ff8dd277ed4191c1f271` |
| 0044 | `afd84ba2a0b2df7c29109ab98a98ad9c04fc3c1c0787491f9f44e2f0974edc68` |
| 0045 | `258b0bd952f6502fb276ef85314e1fe3408f6c9d54a03d6d29aab030d2d00abc` |
| 0046 | `863692cfe53ec34a27053e5384041a8d3b97c21c1699f7e2c27f8630af1c7b94` |
| 0047 | `3f7e1e5e1e70ee63a8034d85f279e4887169eee801feaf963f3c51163b97aa23` |
| 0048 | `3d4f9dd263fd7dfe04f3d0d22b495f50edfabc532e051eae931d3d0b28b32c9c` |
| 0050 | `f5fe3e311d2a0252b3fc3aef02b46a453e06d4b33ea463d07a57919710c4402d` |
| 0056 | `dd8918a82da8f87f84cbf8b4343488a3cf8b18951672ebaf082e5086d34a4a58` |
| 0058 | `823e6114fb8b46d89e8670fa97c360c46494d66280090028da9598a9362df974` |
| 0059 | `ae314cd71f620681f92e09b6b28024b6afd1d0cf3b7208178d4e57f179d97cf0` |
| 0064 | `cb71631737a2a4189b67d33a1124e85a462e00f2d087ec2e2c22ffbf4f2ed6a5` |
| 0072 | `d6605a33a0632f639df2c8b8e6b246ef44321c3b254146e64531531bc1480a54` |
| 0073 | `40a0aed966c1d4c04bed2c310fbd717343672c5fc54d35b6c0f804d46d2233cf` |
| 0074 | `14d92702ca6448d7d7f783452a9c7fb382286890a5cc129db534e19287baa341` |
| 0075 | `be58e0785b5693b0182b8a499481676f6f8b9844e52757adcb5928749e31e47e` |
| 0077 | `cde633a797a0b350e9efffe112a9b54877827b187f88d00721584b7366e147c9` |
| 0078 | `1be5bc2c8ccc4eef82d3bacc3747cb4949b889a0259486caedf22d49b4220362` |
| 0089 | `41a99b77700cf42584d0d27da7b8201c58fdcaab4e3c69b94f9af40634c6c595` |
| 0091 | `4ca432e9b9f07533adb60227da1a92628237ea5ca5fb82626cfdaca40c7cff87` |
| 0092 | `ee431420884c57568377c472de58a6aa25af8e4f1c169fe9aa299b9f15e6f782` |
| 0093 | `4138782ab6f90afbe5d90d57fcda222b43acd572d40300df0795c899360f3827` |
| 0094 | `b65bce9bcbc99b221f332e5b99d726c30d689a9853565e2f2fecf1258d145ef0` |
| 0101 | `8d084def5d6fa9cc94228c09ef5f0e41c6cd4627bf4f4ce4f10870bc85d54cf8` |
| 0125 | `6a6d5cdf4a18c8ca4de48dbcae99ac0b53e63c5a5fa6325865d704d7bed4c0d2` |
