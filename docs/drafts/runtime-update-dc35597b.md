# Installed merge runtime and meta-only check — dc35597b

Verified on 2026-11-02 against SpecGraph merge revision
`dc35597b7c29528f68cf74502fb3b379b284478c` (#871, including #870).
This receipt records a local installed-runtime check, not independent CI
verification, semantic approval or canonical graph admission.

## Runtime and inputs

- Installed with Python 3.12.11 at
  `/Users/egor/.local/share/specgraph/runtime-dc35597b/`.
- Updated the operational launcher path in `AGENTS.md`. The prior
  `runtime-3131f3c1` installation remains available.
- Temporary installer builds and supported caches used verified TB5.
- Distributed skill files match the project installation, excluding its
  preserved `GitView project example` extension. No skill files needed changes.
- GitView input commit before this update:
  `6ce623efc2ee55f569725a04ecb93d9cd61cd19c`.
- The actual pre-canonical draft remains at SHA-256
  `e3b75460f71a8946267132037d051f4a33b76030b2a3692528a3c9c2573cd09f`.

## Narrow meta-only result

The installed merge runtime ran against a byte-identical copy of the current
draft in an isolated TB5 workspace. The copy was placed at
`specs/nodes/GITVIEW-SPEC-0001.yaml` only for the target CLI; no specification
was added to the source project's canonical graph.

The operation explicitly requested `specification_metamodel`, selected a
separate pinned sgcore metamodel context and supplied the Spec-artifact mapping.
It did not request domain analysis or change either GitView domain selection.

- Exit 0; target `checked`.
- Meta `analyzed`, with `sgcore:Spec` class check `matched`.
- Domain `not_requested`; domain inventory, binding and validation absent.
- Bundle schema 3. Node membership and lifecycle remain `not_assessed`;
  semantic approval is `not_established`, full spec conformance `not_assessed`.
- ontologyc 0.5.0 SHA-256:
  `dcdc37216246f9acebca7387e14b61300d9dec4367f7c1630445b97280c80168`.
  Compiler provenance remains `not_verified`; decision/producer provenance
  remains caller-attributed rather than independently attested.

No full replay of the candidate's earlier 12-scenario suite is claimed here.
The exercised meta-check modules and distributed skills match the previously
checked `20a31d8b` candidate; this run verifies the installed merge snapshot.

## Notes and evidence

The new runtime's `notes verify_history` returned `complete` for 74 revisions
at `0bbeb16ed68e4cd6a5e660743e225325`, `canonical: false`. The sketch was not
updated. Original draft, ontology packages/IR/selections and canonical specs
were unchanged during the check.

[Evidence](evidence/meta-merge-dc35597b.json) contains the exact input commit,
runtime receipt, argv, context pins, target digest, per-scope assessments,
producer, skill hashes and history verification. It also identifies the full
local report and its SHA-256. The saved metamodel selection from the candidate
pilot was reused as a test input; it is not installed as GitView's domain context.

Next: return to GitView ontology work, starting with the unresolved identity and
technical representation of GitHubRepository. The successful artifact class
check does not resolve those product questions.
