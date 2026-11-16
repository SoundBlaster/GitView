# Repository selection and historical outcome selection: outlined nodes

Baseline `2d23ede`. Node 0045 keeps the owner-selected one-Repository default separate from the unselected agent proposal for persistent default association or multi-selection. Node 0056 refines the supported historical selection and limited merged-counter filter override without mandating a full timeline or selecting source semantics. Both remain outlined; ontology draft.13 is not semantically accepted and no fresh composition verification is claimed because the pinned compiler hash mismatch is recorded in the 0AL ledger.

Independent read-only first-draft reviews and dispositions:

- `0045`: initial SHA `c558300d3d30fea4b3b3e782e6e6b1c003c37ab5bbabc139da64786cf719a6a3`. Reviewer identified that cancelling an unsubmitted selection should prevent that cancelled attempt from later submitting it, and that the one-Repository default must remain separate per Repository if multi-selection is supported. The author added both without mandating multi-selection, undoing submitted effects or selecting a default association. Focused rereview confirmed final SHA `246735102c8135d5b2e47b30dab10c145f0e832a84412f713574ba5d4a06ae27`.
- `0056`: initial SHA `9420880ea0ad4d7eb0dba5ebb0e9da02dd17f1f3dea6e9e3073d485340a75db2`. Reviewer identified that a historical period's supported boundaries and time-zone interpretation must survive transition to its destination when known. The author added the rule and uncertainty when unknown without choosing a bucket policy; focused rereview confirmed final SHA `7d9845a903c870cf5d82538c4848c51438fa415e67d07d8b78e74def1508761b`.

Byte-identical candidate copies returned `checked`; target next-move and YAML lint passed for both. These checks do not prove source behavior, UI or implementation readiness.
