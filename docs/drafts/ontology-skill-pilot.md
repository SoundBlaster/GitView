# GitView: project ontology skill pilot

Status: exploratory, agent-authored application of the installed
`specgraph-project-ontology` skill; not an accepted ontology or specification.
Workspace: GitView. Sources: `.specgraph/root_intent.md`,
`docs/product-discovery.md`, `docs/drafts/repository-meaning.md`, and
`conversation_memory/sketches/gitview` revision
`97c38ec111e84406ba08dfbc0e144148`. References to `excerpt-N` below identify
source quotations in that sketch, not authenticated external message IDs.

## Context and limits

No `ontology/` directory or ontology package was found in this workspace;
`specs/nodes/` contains only `.gitkeep`. No accepted project ontology terms,
package version or ontology import were found in the inspected project sources.
This is a limit of the inspection, not proof that an external ontology does not
exist or that the vocabulary is empty. The installed native launcher exposes
`init`, `next-move`, `supervisor` and `draft`; its `draft` route exposes notes,
preview and skill installation. No ontology-validation command was identified
in those help surfaces, so this is manual analysis, not a compiler result.

## Bounded application: Project and Repository

| Item | Source and current reading | Open point |
| --- | --- | --- |
| Project | User identifies Project as the concept, rather than introducing Group (`excerpt-10`, `excerpt-11`, `excerpt-12`). Candidate term, not an accepted ontology term. | Definition and identity are not yet agreed. Do not equate it with GitHub Projects. |
| Repository | User describes access to source-code change history through Git and highlights PRs and issues (`excerpt-18`). Do not define it through Project membership (`excerpt-16`). | Distinguish Git history from GitHub work objects and clarify whether versioned content includes more than source code. |
| Project–Repository membership | A Project contains one or more repositories; a repository can belong to multiple projects (`excerpt-10`). | Under `excerpt-21`, examine the actor, action and resulting property before calling this an Ontology relation; creation and persistence are open. |
| Default | One project per repository by default (`excerpt-10`). | How defaults are created, named and changed is not yet decided. It is not a claim that a repository cannot be in multiple projects. |
| GitHub organization | User describes organizations as metadata; projects can contain repositories from different organizations (`excerpt-10`). | Exact relation to repository ownership and needed presentation are open. It is not the GitView Project. |
| Group | User considers a separate Group concept redundant at present (`excerpt-11`, `excerpt-12`). | Do not introduce it as a separate entity without a distinct need; not a permanent prohibition. |

Repository properties such as name, identifier and link are candidates to
discuss, not established essential characteristics. PRs and issues are
associated work to explore separately; their relationship to Repository must
not be silently used as its definition. Compact UI presentation and a link to
the source are a separate product direction (`excerpt-15`).

The user distinguishes generic links from Ontology relations arising during an
actor's action on an object (`excerpt-21`), and describes Issue → PR as the
actor's motive (`excerpt-22`). The evidence for the motive and actor in a given
case remains open. Whether a process or script qualifies as an actor in a
particular case remains a question from the user.

## Observations and next questions

- The skill provided a useful distinction between user statements, candidate
  vocabulary, relationships and implementation or UI details without requiring
  an ontology package before discussion.
- It cannot check whether GitView terminology is consistent with an accepted
  ontology when no such project package or import was found. Future package
  status, version, sources and available validation need explicit inspection.
- Next discussion: identify Repository's essential characteristics independent
  of Project, and distinguish those characteristics from fields such as name or
  URL. Separately clarify whether a Project is defined by membership alone or
  has additional meaning.

No package, ontology binding, canonical node, or acceptance decision was
created by this pilot.
