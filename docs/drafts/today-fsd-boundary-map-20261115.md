# Project → Today: FSD boundary map

Agent-authored architecture candidate for 0095, 0107, 0110, 0115–0116, 0119
and 0126. This is a responsibility and dependency contract, not a Swift package
layout, implemented architecture or independent review. The product remains
pre-canonical; parent and cross-cutting requirements apply before implementation.

```text
app composition
  -> Project work page -> project-work domain contract
                       -> bounded refresh feature -> project-work domain contract
  -> domain-aware source and storage adapters -> project-work domain contract
                                               -> generic shared facilities
  -> platform clock, access and system capabilities

project-work domain contract -> generic shared facilities, where needed
```

The arrows describe allowed dependency direction, not runtime call order or a
mandate for one package per box. Composition may inject capability interfaces
defined by the owning domain boundary into the page or feature; adapters do not
import their consuming page or sibling feature. Actual adapter placement and
target dependencies must be checked against the selected FSD integration.

| Responsibility | Owns | Does not own |
| --- | --- | --- |
| App composition | Concrete capability construction, lifetimes and permitted wiring. | Project policy, source truth or a global service locator by requirement. |
| Work page | Actual Project/Repository route, selected day and filters, density, anchor, permitted presentation and user actions. | Credentials, raw GitHub payloads, database transactions or domain evaluation hidden in view rendering. |
| Refresh feature, if extracted | Bounded user-initiated request coordination via public capabilities. | Sibling edit/authentication feature internals, independently rewriting membership or declaring source coverage. |
| `project-work` entity slice | Cohesive product facts, source and membership identities, named Today and summary decisions, and public domain-facing capability contracts. | UI navigation, network requests inside pure decisions, or an ontology class named after this code slice. |
| Domain-aware adapters | Mapping supported GitHub and storage representations to the domain contracts; scoped limitations and actual effect results. | Platform UI decisions or production claims about fields not actually returned. |
| Generic shared | Reusable transport, storage and clock mechanics without importing GitView product types. | GitView-specific Project, PR, Issue, coverage or authorization policy. |

## Setup and Project editing composition

The setup/discovery page owns its query, pending Repository selection, account
context and explicit default-batch or custom-Project intent under 0108. It
composes connection, discovery and Project-save capabilities through the app
or an appropriate higher layer. A discovery result is an observation, not an
authorization callback, confirmed selection or saved membership. Raw tokens
stay with the connection boundary. If these actions are separate feature slices,
none imports another sibling feature; their common domain-facing contracts live
at a permitted lower boundary and composition stays above them.

The Project editor owns a draft against a captured Project identity and base
version, while the 0111 decision evaluates the proposal and the 0104 boundary
coordinates a durable effect. A valid decision is not a saved Project; a
receipt is not a current configuration read. The work page reacts to an
independently confirmed configuration change through the Project boundary,
retaining its own filters, density and origin according to 0024 and 0091. It
does not import an editor feature to interpret membership or relabel an older
source request as the edited scope. Reusing the Repository picker is an option
only through a valid FSD composition; shared visual controls must not become a
home for Project-specific policy.

Verification should exercise separately the pending selection, valid but
uncommitted proposal, stale base, indeterminate save and confirmed edit while a
refresh is active. A route test can inject the public boundaries; a domain
decision test needs no network or UI. Review actual Swift type dependencies
after implementation: the proposed boxes and an architecture lint alone do not
prove that setup, authentication, editor and refresh slices are isolated.

## Policy and integration outcomes

The named Today decision accepts an immutable validated candidate context and
prepared three-valued inputs described in 0110. Its typed domain output is
`match`, `non-match` or `unknown`; evaluating it performs no source, storage,
clock or UI effects. An invalid required context is rejected before evaluation.
At the top-level validated candidate, an unexpected `DecisionSpec` no-result
is an integration limitation, not `unknown` or an implicit exclusion. The
caller independently assembles population coverage and rechecks disclosure.

The inspected local SpecificationCore `DecisionSpec` returns an optional
typed result; its `FirstMatchSpec` consumes ordered Boolean predicates. This
supports exploring a typed three-valued outcome but does not make Boolean
negation safe for an unknown input. A fallback must not conceal a missing rule
or invalid integration. The local checkout at
`483214469828c42f7b615654aa70d0acbecc4dbf` is reference evidence, not a
resolved GitView dependency. No concrete API or dependency version is selected
by this document.

## Verification boundaries

Before implementation, finalize actual public value and error shapes and
ownership against the parent graph. For a future TDD slice, test the pure truth
table and no-result mapping independently from route tests that inject source,
storage, clock and access. Test adapters, real durable restart, authorized
GitHub and native accessibility separately. An architecture linter can detect
some forbidden references but does not by itself prove semantic ownership or
runtime behavior. These are planned checks; no product code or tests exist here.

FSD reference observed locally at `21731b9dd7d5008b832af5caca6d19f7a36fe54f`;
the local checkouts do not establish a resolved version for GitView or the
latest upstream state.
