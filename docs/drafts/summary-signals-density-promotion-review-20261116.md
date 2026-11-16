# Summary scope, PR signals and grid density: outlined nodes

Baseline `9c598dd`. The three outlined nodes refine existing owner-selected product outcomes; they do not establish implementation readiness or semantic acceptance of the selected draft.13 ontology. The local ontology compiler no longer matches the pinned SHA-256, so a fresh composition verification was unavailable; the mismatch is recorded in the local 0AL ledger.

## Independent first-draft reviews

- `0029`: initial SHA `82de11f4057c178ab33de3ea011a525718d5975656e663ebe1506a1c9cba3c08`. The reviewer found that the historical graph needed to identify current Project membership as the calculation basis. The author added that requirement without claiming past membership; focused review confirmed final SHA `661b3709774147c6867c33f82d1ca4c0b7181baf379f5c01d5d97a488cf07de7`.
- `0035`: initial SHA `c355ed11ec3e3349f6c5f8df6beb4e19ee1f2b434342ae5f285d98404cb17f22`. The reviewer found that feedback during pinch and accessible distinction between PR and Issue were not explicit. The author added both while leaving interpolation and device feasibility open; focused review confirmed final SHA `704c64719c4df9f3564cccd85844efcb3c26d76a42682b233a6515dc229492f6`.
- `0028`: initial SHA `d80c6fe37b36780a2dd32d81c71a8826f01d81d285b630be25ce9ec4220cb7d4`. The reviewer identified missing explicit distinction between no review, unavailable assessment and source-reported requirement, and an ambiguity when revision or time is unknown. The author corrected both; focused review confirmed final SHA `64bbf47b43a3f4d008eeef0c6ee4e255b94e6e2f40be994df914a518bebf0e5f`.

Byte-identical temporary candidates returned `checked`; `next-move --target-spec` and standalone YAML lint passed for all three nodes. A separate graph traversal found 34 nodes, no dangling references and no cycles among `refines` and `depends_on` edges. These are structural checks, not proof of source semantics, native behavior or implementation readiness.
