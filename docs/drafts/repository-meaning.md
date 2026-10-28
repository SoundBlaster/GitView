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

## Proposed interpretation

Repository is an identifiable GitHub source of work and activity. It connects
the GitView project view to the PRs, issues and other information available
from that repository. Its role in GitView is a proposal for discussion; it
does not imply that GitView must model all of GitHub or clone repository files.

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

## Questions

1. Is Repository primarily a navigable source of work, or does its own
   lifecycle and health deserve equal attention in the product?
2. Which repository-level facts should be visible before opening its PRs and
   issues? Which can stay in details?
3. When one repository appears in multiple projects, should a project-specific
   view carry its own annotations, filters or settings?
4. What should distinguish no activity from inaccessible or stale data?

No formal ontology term, relation, identity scheme, specification or UI
behavior is adopted by this exploration.
