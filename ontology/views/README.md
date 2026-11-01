# GitView ontology overview

The owner's newer [proposed composition](gitview-proposed.hc) supersedes the
reading arrangement below for discussion. The owner corrected the indentation:
`GitView` is the single root; `User` and `Project` are its children. The earlier
three-root layout was a typo, not an intended model of multiple applications.
It is an unbound draft: `GitView`,
`User`, and `GitHubRepository` are not classes in the selected 0.1.0 package,
and the current overview exporter requires an explicit versioned ontology
binding for each occurrence. Do not invent bindings or add ontology
entities just to make it export. The meaning of its nesting and the appropriate
representation of `GitHubRepository` need review. The checked pair below is the
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
