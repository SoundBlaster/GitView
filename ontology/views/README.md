# GitView ontology overview

## Current draft.13 reference

[Readable composition](composition-draft13.md) is a separate source-derived
projection of all `spec` sections in the GitView, motivation-core and
events-core packages, including their definitions and links. It records each
source hash and retains complete declaration values. Foundation imports are
not expanded there; the projection is not an ontology package or proof of
semantic approval. It does not replace the structurally checked HC/HCS pair.

[HC](gitview-draft13.hc) and [HCS](gitview-draft13.hcs) are a structural
export from the separately authored [selection HC](gitview-draft13.selection.hc)
and [selection HCS](gitview-draft13.selection.hcs). The exporter checked ten
class references against the working draft.13 source and returned `exported`,
with semantic approval not established. Its HC is byte-identical to the older
agent-authored selection below; HCS now binds to draft.13 and its recorded hashes.

The exporter does **not** include class descriptions in the HC/HCS output.
The proposed meaning of Project must therefore be read in the [draft.13 source](../candidates/domain-v0.2.0-draft.13/composition/domain-ontology-package.yaml)
or [semantic review](../review/project-repository-spec-alignment-20261115.md);
the HCS reference identifies that source, but the overview alone does not show
the wording. The user's `gitview-proposed.hc` remains the preferred reading
composition and is not replaced by this class-only export. In particular, this
export does not include its `GitView` root, `User`, contextual protocol or
relationships; hierarchy is not evidence of the latter.

Exported with SpecGraph runtime `3593bd75`, Hypercode binary SHA-256
`44ce61494b3a88af849db10ebd7914638a8aa36427a98b2a9e336353dffe3cef`,
and locally built `ontologyc` SHA-256
`3e7b70f3789e683de177d7f5d78e507fda993c4aa2990baabe31530db0e63720`.
Output was first inspected on TB5 in
`GitView-a40d73ccf162f8d8/ontology-overview-draft13-20261115/`.

## Historical context and owner's composition

The later [consolidated domain model](../domain-model.md) and
[completeness audit](../review/completeness.md) reconcile the conversation beyond
the pinned package. The owner has clarified `User` as the GitView operator;
GitHub identities remain separate (`excerpt-53-reply`). This resolves its intended
meaning, not its technical ontology binding. The proposed HC remains unchanged.

The owner's newer [proposed composition](gitview-proposed.hc) supersedes the
reading arrangement below for discussion. The owner corrected the indentation:
`GitView` is the single root; `User` and `Project` are its children. The earlier
three-root layout was a typo, not an intended model of multiple applications.
It is an unbound draft: `GitView`,
`User`, and `GitHubRepository` were not classes in the historical 0.1.0 package,
and the current overview exporter requires an explicit versioned ontology
binding for each occurrence. Do not invent bindings or add ontology
entities just to make it export. The meaning of its nesting and the appropriate
technical representation of `GitHubRepository` need review. Its intended meaning
has been clarified: GitHub acts on Repository, establishing a management relation
in which that Repository is called GitHubRepository (`excerpt-31`). The product
currently expects GitHub-specific properties; generalized management systems and
other providers are deferred. The owner suggests Decorator as a conceptual
analogy: GitHub decorates Repository (`excerpt-32`). Implementation remains an
independent architecture choice. See the project ontology discussion below.
The checked pair below is the
earlier agent-authored example, retained for comparison, not the owner's new view.

The readable [HC](gitview.hc) and its technical [HCS](gitview.hcs) are a
**proposed, review-only** selection from the project ontology draft 0.1.0.
The editable inputs are [selection HC](gitview.selection.hc) and
[selection HCS](gitview.selection.hcs). The export checks ten explicit
class references and carries source/compiler hashes; it does not approve their
meaning or prove actual instances or relationships.

Indentation is an authored reading composition, not inheritance, cardinality,
causality, action or a complete domain model. In particular, a GitView project
can contain multiple repositories, a repository can belong to multiple projects,
and the arrangement does not change either rule. GitHub as actor, the distinction
between links and action-derived relations, and Issue as a possible motive need
their own treatment. `Activity` remains a tentative idea and is intentionally
not declared here. See [project ontology](../packages/gitview/README.md) and
[product discovery](../../docs/product-discovery.md) for sources and gaps.

## Preparation

Edit the selection pair, retaining stable occurrence IDs. Run the installed
runtime against the product workspace with an existing Hypercode executable and
`ontologyc` 0.5.0. Use a **new** output directory on verified TB5; the exporter
refuses to overwrite a directory. Replace the paths below with the actual tools:

```sh
specgraph-runtime --workspace /path/to/GitView ontology-overview -- \
  --hc ontology/views/gitview.selection.hc \
  --hcs ontology/views/gitview.selection.hcs \
  --hypercode /path/to/hypercode --ontologyc /path/to/ontologyc \
  --output-dir /path/to/new/tb5-output
```

Inspect `context.hc`, `context.hcs` and the command status; compare the pair
with the tracked files before updating them. Do not treat structural export as
semantic acceptance. This example was exported with SpecGraph `43ea8e92`,
Hypercode binary SHA-256 `ed236f86551590d3b0539c66e572cdfcdcf0ce567fa3913e2f2dfa0097dfc78b`
and `ontologyc` SHA-256 `dcdc37216246f9acebca7387e14b61300d9dec4367f7c1630445b97280c80168`.
The executable hashes identify bytes, not provenance attestation.
