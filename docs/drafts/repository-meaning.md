# Repository: exploratory domain meaning

Status: questions and agent proposals for discussion; not an accepted ontology
or specification. The user's request to examine the meaning of Repository is
captured in `conversation:gitview/excerpt-13`, note `repository-semantics`,
and the clarification below in `excerpt-14`, sketch revision
`c86dc353095f4730ae159c6538b3d22e`.

## Established context

A GitView Project contains one or more repositories; a repository can belong
to multiple projects. By default one project corresponds to one repository.
GitHub organizations are metadata and a project may contain repositories from
different organizations. Project is the concept used for this relationship;
a separate Group concept is presently redundant.

## Working direction from the user

In `conversation:gitview/excerpt-18`, the user describes Repository as an
entity providing access to the history of changes to source code through Git,
with PRs, issues and similar objects central to the GitView perspective. This
is the source statement, not an approved formal definition.

For discussion, distinguish Git's versioned content and history from GitHub's
associated PRs and issues. A PR can refer to proposed changes and commits; an
issue tracks a topic or work and does not necessarily represent a code change.
PRs and issues do not constitute the complete Git history. Git repositories may
also contain other files; whether GitView's definition should be limited to
source code is open. These distinctions are an agent interpretation to review,
not additional owner decisions.

## Ontology approach

The user rejected defining an entity through higher-level entities and noted
that the previous Repository definition mixed meaning, characteristics,
properties and relations (`conversation:gitview/excerpt-16`). Its definition
remains open. Describe these aspects separately, and distinguish the domain
concept from GitView's presentation and use of it.

Possible aspects to explore:

- Identity and context: repository identity, display name and GitHub owner.
  An owner can be a person or organization; organization is not a project.
- Associated work: PRs and issues, with review discussions and checks in the
  context in which they arise.
- Activity and metrics: events and measurements scoped to the repository, with
  an explicit time range and freshness; these are not quality scores.
- Navigation: a repository can appear through more than one project without
  becoming multiple distinct repositories.
- Visibility and access: GitHub permissions bound which data can be retrieved;
  access loss and incomplete data need separate future decisions.

Branches, releases, source browsing, workflow runs and deployments may also be
relevant, but their product scope has not been decided.

## PR overview and possible shared abstraction

The user clarified that the application should not delve inside a PR, while it
should display PR metrics such as lines, commits, runs and threads. The exact
definitions (for example additions versus deletions, which runs and which
threads) remain open. The earlier idea of a deeper PR view is deferred, not a
current product obligation.

The user suggested a possible meta-entity with a name, perhaps a link, and
dynamic properties, while questioning whether it is useful before there are
specifications. Treat this as an open hypothesis. A shared presentation shape
could reduce repetition, but a generic bag of properties could obscure the
different meanings, units, availability and freshness of PR, repository,
check and thread data. These considerations are agent interpretations, not
accepted requirements. No common entity or inheritance relationship is adopted.

## Compact overview and source

The user clarified that GitView does not replace GitHub: an entity can link to
its original source. The intended display is minimal: title, ID, badges and
text (`conversation:gitview/excerpt-15`). Which fields apply to each entity,
what text to show, and how the link is presented remain open. This is a
presentation direction; it does not establish a common ontology entity.

## Questions

1. Should the definition refer to versioned content generally, or specifically
   to source code? How should Git history and the GitHub work objects be
   described separately?
2. Which repository-level facts should be visible before opening its PRs and
   issues? Which can stay in details?
3. When one repository appears in multiple projects, should a project-specific
   view carry its own annotations, filters or settings?
4. What should distinguish no activity from inaccessible or stale data?

No formal ontology term, relation, identity scheme, specification or UI
behavior is adopted by this exploration.
