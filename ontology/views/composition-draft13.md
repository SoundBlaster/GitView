# GitView: состав ontology draft.13

Это читаемая структурная проекция трёх source packages: локального GitView, motivation-core и events-core. Ниже также приведены точные каталоги foundation, которые разрешает выбранный контекст; эти каталоги перечисляют символы, но не содержат их смысловых определений. Описания и все данные деклараций приведены из указанных YAML; структура страницы не является новым пакетом, semantic approval или доказательством реальных фактов.

## local.gitview.domain @ 0.2.0-draft-composition.13

Источник: `ontology/candidates/domain-v0.2.0-draft.13/composition/domain-ontology-package.yaml`  
SHA-256: `3c603ccf59b9efba2f3d0e1c152e21f320b09f508594f1942f5161e3380e6feb`  
Статус источника: `draft`

### imports

```yaml
imports:
- id: ontology.foundation
  namespace: ont
  version: 0.2.0
- id: org.0al.motivation.core
  namespace: motivcore
  version: 0.1.0
```

### classes

#### `User`

```yaml
User:
  extends: ont:DomainEntity
  description: Identified participant operating GitView in this interaction. A GitHub
    author, reviewer or assignee reference alone does not identify this operator.
    Identity storage and authentication belong to the application.
```

#### `RegisterRepository`

```yaml
RegisterRepository:
  extends: ont:Action
  description: Register the Repository with GitHub to establish its management by
    GitHub.
```

#### `AddRepository`

```yaml
AddRepository:
  extends: ont:Action
  description: Add the referenced existing Repository to the Project named as the
    object of this interaction.
  fields:
    repository:
      type: ref
      target: Repository
      required: true
      description: Typed reference to an existing Repository; resolution and existence
        are application responsibilities.
```

#### `RemoveRepository`

```yaml
RemoveRepository:
  extends: ont:Action
  description: Remove the referenced existing Repository from the Project named as
    the object of this interaction.
  fields:
    repository:
      type: ref
      target: Repository
      required: true
      description: Typed reference to an existing Repository; resolution and existence
        are application responsibilities.
```

#### `Project`

```yaml
Project:
  extends: ont:DomainEntity
  description: A unit for organizing work for its overview in GitView. Identity, properties
    and Repository membership are described separately; this product-scoped meaning
    remains a candidate.
  fields:
    name:
      type: string
      required: false
      description: Selected display name; optional here only for a partial projection,
        not a completed-project creation rule.
    description:
      type: string
      required: false
      description: Optional selected purpose description.
```

#### `Code`

```yaml
Code:
  extends: ont:DomainEntity
  description: Code, described by the owner as essentially a folder with files. Its
    precise boundary remains open.
```

#### `VersionControlSystem`

```yaml
VersionControlSystem:
  extends: ont:DomainEntity
  description: A system that acts on code to manage versions; Git is the example named
    for GitView.
```

#### `Repository`

```yaml
Repository:
  extends: ont:DomainEntity
  description: Code in which a version control system acts, in the owner's working
    formulation.
```

#### `GitHub`

```yaml
GitHub:
  extends: ont:DomainEntity
  description: GitHub, which can occupy the actor role when managing a repository
    and its change workflow.
```

#### `Issue`

```yaml
Issue:
  extends: ont:DomainEntity
  description: A source-recorded issue addressing a question, problem or work request.
    In a particular case it may be associated with a motive for an actor, but it does
    not itself act; the association and actor are not inferred merely from an issue
    or a link.
  fields:
    sourceId:
      type: string
      required: false
      description: Opaque identifier as observed in GitHub; not a decision about stable
        cross-owner identity or framework id mapping.
    number:
      type: integer
      required: false
      description: Number within the source repository; not a portfolio-wide identifier.
    title:
      type: string
      required: false
      description: Title from the source.
    body:
      type: string
      required: false
      description: Original description text; missing text is not generated.
    url:
      type: string
      required: false
      description: Original object link; URL identity and normalization rules remain
        open.
    lifecycleState:
      type: string
      required: false
      description: Selected lifecycle vocabulary; mapping and enum constraints require
        review.
    problemText:
      type: string
      required: false
      description: Problem section text, if present.
    motivationText:
      type: string
      required: false
      description: Authored Motivation section; does not prove an actor motive.
    expectedOutcomeText:
      type: string
      required: false
      description: Intended result section; not evidence of achievement.
    referencesText:
      type: string
      required: false
      description: Raw References section text, not a serialized structured link collection.
    stateReason:
      type: string
      required: false
      description: State/closure reason if supplied; closed is not automatically completed.
    issueType:
      type: string
      required: false
      description: Source Issue type when present; not the labels collection.
    commentCount:
      type: integer
      required: false
      description: Comments; known nonnegative count, no default for unavailable data.
    participantCount:
      type: integer
      required: false
      description: Discussion participants; known nonnegative count, no default for
        unavailable data.
    directSubIssueCount:
      type: integer
      required: false
      description: Direct sub-issues; known nonnegative count, no default for unavailable
        data.
    closedDirectSubIssueCount:
      type: integer
      required: false
      description: Closed direct sub-issues; known nonnegative count, no default for
        unavailable data.
```

#### `PullRequest`

```yaml
PullRequest:
  extends: ont:DomainEntity
  description: A source-recorded proposal of code changes for consideration and possible
    inclusion. Its creation alone does not imply approval, merging or an achieved
    outcome.
  fields:
    sourceId:
      type: string
      required: false
      description: Opaque identifier as observed in GitHub; not a decision about stable
        cross-owner identity or framework id mapping.
    number:
      type: integer
      required: false
      description: Number within the source repository; not a portfolio-wide identifier.
    title:
      type: string
      required: false
      description: Title from the source.
    body:
      type: string
      required: false
      description: Original description text; missing text is not generated.
    url:
      type: string
      required: false
      description: Original object link; URL identity and normalization rules remain
        open.
    lifecycleState:
      type: string
      required: false
      description: Selected lifecycle vocabulary; mapping and enum constraints require
        review.
    problemText:
      type: string
      required: false
      description: Problem section text, if present.
    motivationText:
      type: string
      required: false
      description: Authored Motivation section; does not prove an actor motive.
    expectedOutcomeText:
      type: string
      required: false
      description: Intended result section; not evidence of achievement.
    referencesText:
      type: string
      required: false
      description: Raw References section text, not a serialized structured link collection.
    isDraft:
      type: boolean
      required: false
      description: Draft flag separately from lifecycle, review and CI.
    baseBranch:
      type: string
      required: false
      description: Source-provided target branch name/reference; no branch entity
        introduced.
    headBranch:
      type: string
      required: false
      description: Source-provided source branch name/reference.
    revisionRef:
      type: string
      required: false
      description: Reference to the observed current change revision; relevance/attempt
        rules remain open.
    reviewAssessment:
      type: string
      required: false
      description: Source aggregate review assessment; unavailable assessment is not
        approval.
    changesText:
      type: string
      required: false
      description: Authored Changes section.
    validationText:
      type: string
      required: false
      description: Authored Validation section; not independently verified evidence.
    reviewThreadCount:
      type: integer
      required: false
      description: All review threads; known nonnegative count, no default for unavailable
        data.
    unresolvedReviewThreadCount:
      type: integer
      required: false
      description: Unresolved review threads; known nonnegative count, no default
        for unavailable data.
    redCheckCount:
      type: integer
      required: false
      description: Current red individual checks; known nonnegative count, no default
        for unavailable data.
    yellowCheckCount:
      type: integer
      required: false
      description: Current yellow individual checks; known nonnegative count, no default
        for unavailable data.
    greenCheckCount:
      type: integer
      required: false
      description: Current green individual checks; known nonnegative count, no default
        for unavailable data.
    totalCheckCount:
      type: integer
      required: false
      description: All current individual checks; known nonnegative count, no default
        for unavailable data.
    addedLineCount:
      type: integer
      required: false
      description: Added lines; known nonnegative count, no default for unavailable
        data.
    deletedLineCount:
      type: integer
      required: false
      description: Deleted lines; known nonnegative count, no default for unavailable
        data.
    changedFileCount:
      type: integer
      required: false
      description: Changed files; known nonnegative count, no default for unavailable
        data.
    commitCount:
      type: integer
      required: false
      description: Commits; known nonnegative count, no default for unavailable data.
```

#### `ReviewThread`

```yaml
ReviewThread:
  extends: ont:DomainEntity
  description: A discussion thread relevant to review; duration and resolution semantics
    need clarification.
```

#### `CIStatus`

```yaml
CIStatus:
  extends: ont:ValueObject
  description: An observed source-reported status of one status-check entry. Its interpretation
    requires the entry and observation context; a summary of counts is a distinct
    derived measurement. The status does not by itself establish that CI ran or that
    a change is mergeable.
```

#### `Metric`

```yaml
Metric:
  extends: ont:ValueObject
  description: A result of a measurement according to a defined rule for an identified
    subject and scope. Its interpretation requires the measured quantity, relevant
    unit or time representation, observation or period and evidential coverage as
    applicable. A definition, chart, unknown result or absent value is not itself
    a measured value.
```

### relations

#### `addsRepositoryTo`

```yaml
addsRepositoryTo:
  subject: User
  action: AddRepository
  object: Project
  description: The operator adds an existing repository to this project's membership.
    The Project keeps its identity, and the repository can also be a member of other
    projects.
```

#### `removesRepositoryFrom`

```yaml
removesRepositoryFrom:
  subject: User
  action: RemoveRepository
  object: Project
  description: The operator removes an existing repository from this Project without
    deleting it or changing other Projects.
```

#### `versionControlsCode`

```yaml
versionControlsCode:
  domain: VersionControlSystem
  range: Code
  description: Candidate declaration for a version-control system acting on code;
    the originating action and resulting property require further modeling.
```

#### `managesRepository`

```yaml
managesRepository:
  subject: GitHub
  action: RegisterRepository
  object: Repository
  description: Registering a Repository with GitHub establishes GitHub's management
    of that same Repository. In this context the Repository plays the GitHubRepository
    role.
```

#### `projectIncludesRepository`

```yaml
projectIncludesRepository:
  domain: Project
  range: Repository
  cardinality:
    min: 1
    max: '*'
  description: Selected membership link. Current product requires the GitHubRepository
    context; reverse membership can span Projects. Does not assert the actor/action
    that established membership.
```

#### `pullRequestRepository`

```yaml
pullRequestRepository:
  domain: PullRequest
  range: Repository
  cardinality:
    min: 1
    max: 1
  description: Source-associated Repository of the PullRequest in its GitHub context,
    restricted to GitHubRepository by the contextual contract; used for Project attribution
    when supported by source evidence. The base-ref and head-ref Repositories are
    separate source relationships and are not inferred from this link alone.
```

#### `issueRepository`

```yaml
issueRepository:
  domain: Issue
  range: Repository
  cardinality:
    min: 1
    max: 1
  description: Selected source repository context for this Issue, restricted to GitHubRepository
    by the contextual contract.
```

#### `pullRequestIssueLink`

```yaml
pullRequestIssueLink:
  domain: PullRequest
  range: Issue
  cardinality:
    min: 0
    max: '*'
  description: Selected source link to Issue; no motive or causal attribution inferred.
```

#### `issueClosingPullRequest`

```yaml
issueClosingPullRequest:
  domain: Issue
  range: PullRequest
  cardinality:
    min: 0
    max: '*'
  description: Explicit source closing link, distinct from a mention; no completed
    outcome inferred.
```

#### `issueMentionedPullRequest`

```yaml
issueMentionedPullRequest:
  domain: Issue
  range: PullRequest
  cardinality:
    min: 0
    max: '*'
  description: Source mention without an inferred closing relation or motive.
```

#### `issueParent`

```yaml
issueParent:
  domain: Issue
  range: Issue
  cardinality:
    min: 0
    max: 1
  description: A current direct parent link in a GitHub source context. The cardinality
    concerns one current state, not an assertion that a parent is known or that past
    observations cannot differ. Reassignment, scope, conflicts and source access require
    separate evidence.
```

#### `issueSubIssue`

```yaml
issueSubIssue:
  domain: Issue
  range: Issue
  cardinality:
    min: 0
    max: '*'
  description: A current direct child link in a GitHub source context; it is inverse
    in meaning to the direct parent link when compatible evidence establishes the
    relationship. It is not a transitive work-completion measure or proof of a complete
    child collection.
```

#### `issueBlockedBy`

```yaml
issueBlockedBy:
  domain: Issue
  range: Issue
  cardinality:
    min: 0
    max: '*'
  description: Selected link to blocking Issue; unknown blocker state is not proof
    of active blocking.
```

#### `issueBlocks`

```yaml
issueBlocks:
  domain: Issue
  range: Issue
  cardinality:
    min: 0
    max: '*'
  description: Selected link to an Issue blocked by this Issue; not an actor action.
```

#### `issueMotiveLink`

```yaml
issueMotiveLink:
  domain: Issue
  range: motivcore:Motive
  description: Experimental link from an Issue to separately identified motive content.
    Its declaration neither identifies Issue with Motive nor establishes a particular
    actor, action, instance, source-link implication or causal attribution. Actor-scoped
    interpretation and evidence remain separate and unverified.
```

### protocols

#### `GitHubRepository`

```yaml
GitHubRepository:
  description: Candidate contextual contract for the same Repository under management
    by GitHub; not a subclass or duplicate repository.
  semanticConstraints:
  - Applicable only in a context where management by GitHub is established; merely
    naming the protocol is not evidence of that relation.
  - Project membership and PR/Issue repository references use the underlying Repository
    identity in this GitHub-scoped context.
  - Repository does not globally implement this protocol; non-GitHub repositories
    are possible outside the current product scope.
  - Where the source confirms the same GitHub repository object, rename and transfer
    preserve the same Repository, its accumulated history and Project memberships.
  - Within one GitHub instance, the confirmed numeric REST repository ID is the selected
    identity comparison key; encoding, cross-instance matching, sufficient source
    evidence and establishing the management relation remain under review.
```

### policies

#### `GitHubRepositoryContext`

```yaml
GitHubRepositoryContext:
  extends: ont:Policy
  enforceability: manual
  appliesTo:
  - Repository
  - Project
  - PullRequest
  - Issue
  text: 'Review contract: current GitView repository membership/source contexts require
    management by GitHub. GitHubRepository names this contextual contract on the same
    Repository, not a new identity or a globally inferred implementation. Compiler
    relations used for membership/source links do not establish actor-action-derived
    relation occurrences.'
```

#### `PartialObservationBoundary`

```yaml
PartialObservationBoundary:
  extends: ont:Policy
  enforceability: manual
  appliesTo:
  - Project
  - PullRequest
  - Issue
  text: Candidate fields are optional partial projections, not complete entity snapshots
    or creation requirements. Missing is not zero, false, empty, unchanged, or not
    applicable. Counts are nonnegative when known; enum/range/availability/freshness
    semantics need separate specifications and are not enforced by scalar typing.
    No identity from the implicit generated id is adopted as the source/project key.
```

#### `RepositoryIdentityContinuity`

```yaml
RepositoryIdentityContinuity:
  extends: ont:Policy
  enforceability: manual
  appliesTo:
  - Repository
  - Project
  text: Within the same GitHub instance, matching numeric REST repository IDs identify
    the same Repository; rename and transfer preserve its history and Project memberships.
    A different numeric ID denotes a different Repository even at an earlier address.
    HTTP 404 does not establish the current state and must not erase the last known
    Repository or its memberships. Local key encoding and cross-instance matching
    remain open.
```

#### `ProjectMembershipScope`

```yaml
ProjectMembershipScope:
  extends: ont:Policy
  enforceability: manual
  appliesTo:
  - Project
  - Repository
  text: A Project contains one or more GitHub-managed Repositories. The same Repository
    can be a member of multiple Projects, including Projects containing repositories
    from different GitHub organizations. By default one Project corresponds to one
    Repository. These are product membership rules; they do not identify an actor
    for every historical membership or prescribe the mechanics of creating default
    Projects.
```

## org.0al.motivation.core @ 0.1.0

Источник: `ontology/pilots/motivation-composition/dependencies/motivation-core/domain-ontology-package.yaml`  
SHA-256: `3061eca33ddc2296c2c292695d98daf6697e92fb582da544bc1d5107721ae955`  
Статус источника: `draft`

### imports

```yaml
imports:
- id: specgraph.foundation
  namespace: sg
  version: 0.1.0
- id: org.0al.events.core
  namespace: eventcore
  version: 0.2.0
```

### classes

#### `Motive`

```yaml
Motive:
  extends: sg:DomainEntity
  layer: mechanics
  central: true
  description: A prompting reason that may move any Entity actor toward action or
    omission; consciousness, deliberation and intention are not required. Content
    is separate from its scoped attribution.
  fields:
    motiveKey:
      type: string
      required: true
    description:
      type: string
      required: true
    label:
      type: string
      required: false
```

#### `MotivationHypothesis`

```yaml
MotivationHypothesis:
  extends: sg:DomainEntity
  lifecycle: MotivationReview
  description: Proposed attribution of one motive to the actor's action or omission
    in one existing interpretation or source-only interpretation candidate. It may
    retain an unresolved actor; review does not establish motivation or physical causation.
  fields:
    hypothesisKey:
      type: string
      required: true
    contributionKind:
      type: string
      required: true
```

#### `OperatorMotivationSupport`

```yaml
OperatorMotivationSupport:
  extends: sg:DomainEntity
  description: Explicit uncited support supplied by a named operator Entity; authorship
    and rationale do not become a source citation or proof of motive.
  fields:
    supportKey:
      type: string
      required: true
    rationale:
      type: string
      required: true
```

#### `ReviewMotivation`

```yaml
ReviewMotivation:
  extends: sg:Command
  description: Record review of the attribution proposal without confirming its truth,
    performing an action or promoting source-only physical observations.
```

#### `RejectMotivation`

```yaml
RejectMotivation:
  extends: sg:Command
  description: Reject the attribution proposal while retaining its sources and support;
    rejection does not prove absence of the motive.
```

### protocols

Нет объявлений.

### relations

#### `hypothesisMotive`

```yaml
hypothesisMotive:
  domain: MotivationHypothesis
  range: Motive
  cardinality:
    min: 1
    max: 1
  description: A hypothesis attributes exactly one prompting-reason content; multiple
    hypotheses may explain the same contribution without being mutually exclusive.
```

#### `hypothesisView`

```yaml
hypothesisView:
  domain: MotivationHypothesis
  range:
    oneOf:
    - eventcore:Interpretation
    - eventcore:InterpretationCandidate
  cardinality:
    min: 1
    max: 1
  description: The sole scope anchor. Episode, action/event identity and known observations
    derive through this view, not duplicate actor/event fields.
```

#### `hypothesisActorRole`

```yaml
hypothesisActorRole:
  domain: MotivationHypothesis
  range: eventcore:RoleBinding
  cardinality:
    min: 0
    max: 1
  description: If resolved, hypothesisActorRole must be the target of interpretationBindsRole
    or candidateBindsRole from the selected hypothesisView and have roleName actor;
    derive Entity through roleBoundEntity. Other views may reference the same role.
    Absence preserves an unknown actor.
```

#### `hypothesisPromptingEntity`

```yaml
hypothesisPromptingEntity:
  domain: MotivationHypothesis
  range: eventcore:Entity
  cardinality:
    min: 0
    max: '*'
  description: Optional contextual entity involved in the prompting reason, such as
    an instruction sender or external influence. This is distinct from the motivated
    actor and establishes no causal force or mental state.
```

#### `hypothesisPromptingFact`

```yaml
hypothesisPromptingFact:
  domain: MotivationHypothesis
  range: eventcore:Fact
  cardinality:
    min: 0
    max: '*'
  description: Optional contextual proposition/polarity support about the prompting
    circumstances; a declared Fact is not a complete physical StateSnapshot.
```

#### `hypothesisPromptingView`

```yaml
hypothesisPromptingView:
  domain: MotivationHypothesis
  range:
    oneOf:
    - eventcore:Interpretation
    - eventcore:InterpretationCandidate
  cardinality:
    min: 0
    max: '*'
  description: Optional interpretation of a reported prompting occurrence. Temporal/cross-episode
    alignment needs separate review; this link is not an automatically verified CausalHypothesis.
```

#### `hypothesisPositiveSupport`

```yaml
hypothesisPositiveSupport:
  domain: MotivationHypothesis
  range:
    oneOf:
    - eventcore:SourceAssertion
    - OperatorMotivationSupport
  cardinality:
    min: 0
    max: '*'
  description: Support for this specific actor/view/motive attribution. Quotes and
    their speakers remain source-scoped; relevance and meaning are not inferred by
    generated object schemas.
```

#### `hypothesisNegativeSupport`

```yaml
hypothesisNegativeSupport:
  domain: MotivationHypothesis
  range:
    oneOf:
    - eventcore:SourceAssertion
    - OperatorMotivationSupport
  cardinality:
    min: 0
    max: '*'
  description: Explicit opposition to this specific attribution. It coexists with
    positive support; missing evidence and rejected workflow status do not create
    negative support.
```

#### `operatorSupportAuthor`

```yaml
operatorSupportAuthor:
  domain: OperatorMotivationSupport
  range: eventcore:Entity
  cardinality:
    min: 1
    max: 1
  description: Declared support author, independently of the hypothesis actor or quoted
    speaker; no human-only identity or authentication is inferred.
```

### policies

#### `ActorScopedMotivation`

```yaml
ActorScopedMotivation:
  extends: sg:Policy
  enforceability: manual
  appliesTo:
  - Motive
  - MotivationHypothesis
  text: A Motive is a broad prompting reason applicable to any Entity actor, including
    communities, AI, machines and natural phenomena; intention and consciousness are
    optional interpretations, never admission requirements. A hypothesis has one view.
    A selected actor RoleBinding must be reached by interpretationBindsRole or candidateBindsRole
    from that selected hypothesisView and named actor; exclusive ownership is not
    required. Actor Entity and episode derive from existing links. An unresolved actor
    remains unresolved, and evidence or motives are never transferred to another participant
    or episode by label similarity.
```

#### `IndependentMotivationSupport`

```yaml
IndependentMotivationSupport:
  extends: sg:Policy
  enforceability: manual
  appliesTo:
  - MotivationHypothesis
  text: Positive and negative declared support are independent collections. When both
    collections are empty the attribution is unknown or unsupported; positive only
    means supported, negative only means opposed, and both means contested. These
    are support-presence descriptions, not factual truth. Competing positive motives
    may coexist. Missing hypotheses do not imply that no motive exists; removing support
    does not invent its opposite. Do not store a duplicate truth-state field.
```

#### `SourceAndOperatorMotivation`

```yaml
SourceAndOperatorMotivation:
  extends: sg:Policy
  enforceability: manual
  appliesTo:
  - MotivationHypothesis
  - OperatorMotivationSupport
  text: Preserve exact source/revision/digest/quote/speaker identity. A speaker reporting
    a reason need not be the actor, and I in a letter is not automatically the narrator.
    Cited and uncited operator support remain distinct; relevance, authenticity and
    inferred psychological or physical meaning require explicit separate review. An
    unsupported model proposal may remain proposed without fabricating operator authorship
    or citations.
```

#### `SeparateContributionAndConsequence`

```yaml
SeparateContributionAndConsequence:
  extends: sg:Policy
  enforceability: manual
  appliesTo:
  - Motive
  - MotivationHypothesis
  text: contributionKind is action or omission by explicit interpretation. A motive
    does not prove performance, an omission's duty/deadline/capability/exception grounds,
    deliberation, intention, fault, responsibility or sanction. The selected view's
    record-owned optional exact Delta describes own change only; an empty local difference
    does not assert absence of downstream consequences. Hypothesized downstream consequences
    follow an explicit CausalHypothesis whose hypothesisCauseView is exactly the selected
    hypothesisView, then hypothesisEffectView and its own RecordedEvent and optional
    exact Delta. Preserve hypothesis identity and workflow state without promoting
    causal attribution to fact or merging Deltas. For the pilot use a separate omission
    record plus CausalHypothesis to the effect record; an owner reading of the movement
    record is a different motive scope. An InterpretationCandidate may remain source-only
    without states, record or Delta. Unknown changes are not an empty diff; a desired
    outcome is not an actual consequence, and this draft adds no goal class or outcome
    inference.
```

#### `PromptingReasonBoundary`

```yaml
PromptingReasonBoundary:
  extends: sg:Policy
  enforceability: manual
  appliesTo:
  - MotivationHypothesis
  text: Prompting Entity/Fact/view anchors are optional contextual declarations, not
    proof that they motivated the actor. A prompting occurrence cannot be its own
    target recorded event. A claimed ordered causal chain needs explicit scope alignment,
    valid comparable clocks and cause start no later than contribution start; unknown
    temporal data remains unresolved. Motive attribution and event-to-event CausalHypothesis
    are distinct interpretations, neither automatically establishes the other or changes
    supplied states.
```

#### `ReviewIsNotMotiveTruth`

```yaml
ReviewIsNotMotiveTruth:
  extends: sg:Policy
  enforceability: manual
  appliesTo:
  - MotivationHypothesis
  text: MotivationReview records proposal workflow only. Reviewed does not establish
    the motive, make a cited assertion true or authorize physical enrichment; rejected
    does not erase sources or produce negative support. Existing eventcore-v1 and
    eventcore-provenance-v1 profiles do not admit motivcore nodes or relations. A
    future consumer needs an explicitly reviewed contract before claiming these policies
    are enforced at runtime.
```

### stateMachines

#### `MotivationReview`

```yaml
MotivationReview:
  states:
  - proposed
  - reviewed
  - rejected
  transitions:
  - from: proposed
    to: reviewed
    command: ReviewMotivation
  - from: proposed
    to: rejected
    command: RejectMotivation
```

### modelApplicability

#### `appliesTo`

```yaml
appliesTo:
  domains:
  - general_event_modeling
  contexts:
  - draft_vocabulary_review
  - actor_scoped_explanation
  - source_only_candidates
```

#### `excludes`

```yaml
excludes:
  contexts:
  - automatic_motive_truth
  - automatic_liability_assignment
  - implicit_instance_profile_extension
```

#### `assumptions`

```yaml
assumptions:
- id: broad_actor
  text: Any Entity may occupy an actor role. A prompting reason does not require intention,
    consciousness or human identity.
- id: explicit_consumer_boundary
  text: Package/object-shape validation does not enforce selected-view role edges,
    causal traversal, cross-node scope, contribution enums, temporal coherence or
    semantic relevance. Manual policies remain declarations.
- id: consequence_availability
  text: Own changes derive from the selected recorded event states; hypothesized downstream
    effects retain an explicit causal link and the separate effect record Delta. Empty
    own change does not mean no downstream effects. Narrative motives and partial
    observations never supply missing physical snapshots.
```

#### `invalidationTriggers`

```yaml
invalidationTriggers:
- id: consumer_contract_changed
  text: Re-review this vocabulary and its dependency pin before adopting an executable
    motivation consumer profile.
```

## org.0al.events.core @ 0.2.0

Источник: `ontology/pilots/motivation-composition/dependencies/events-core/domain-ontology-package.yaml`  
SHA-256: `92a3245fc9acd15748fd1fa3cfb8e4fdc8fda429a5fd6cffd7a97bc13f2f359e`  
Статус источника: `draft`

### imports

```yaml
imports:
- id: specgraph.foundation
  namespace: sg
  version: 0.1.0
```

### classes

#### `Entity`

```yaml
Entity:
  extends: sg:DomainEntity
  layer: mechanics
  description: Any scoped entity, including an abstract community, machine, AI or
    natural phenomenon; actor is a role, not a human-only type.
  fields:
    label:
      type: string
      required: false
```

#### `Episode`

```yaml
Episode:
  extends: sg:DomainEntity
  description: Scope grouping records and interpretations without asserting that all
    reports describe one true incident.
  fields:
    scopeKey:
      type: string
      required: true
```

#### `ActionKind`

```yaml
ActionKind:
  extends: sg:ValueObject
  description: Declared kind of occurrence or contribution; omission and action interpretation
    require separate explicit grounds.
  fields:
    actionKey:
      type: string
      required: true
```

#### `EventRegistry`

```yaml
EventRegistry:
  extends: sg:DomainEntity
  description: One immutable local registry revision containing recorded events; recordKey
    is unique within this registry revision, not globally.
  fields:
    registryKey:
      type: string
      required: true
    revisionKey:
      type: string
      required: true
```

#### `RecordedEvent`

```yaml
RecordedEvent:
  extends: sg:Event
  layer: mechanics
  central: true
  description: Immutable scoped event with direct supplied comparable before/after
    StateSnapshots; descriptions with missing data remain candidates.
  fields:
    recordKey:
      type: string
      required: true
    intervalStart:
      type: integer
      required: true
    intervalFinish:
      type: integer
      required: true
    clockKey:
      type: string
      required: true
```

#### `EventCandidate`

```yaml
EventCandidate:
  extends: sg:DomainEntity
  description: Source-backed occurrence description that may lack interval, state
    or other data needed for a checked record.
  fields:
    candidateKey:
      type: string
      required: true
    description:
      type: string
      required: false
```

#### `Interpretation`

```yaml
Interpretation:
  extends: sg:DomainEntity
  description: Role reading of a registered RecordedEvent; it supplies no replacement
    event states and establishes no legal responsibility.
  fields:
    interpretationKey:
      type: string
      required: true
```

#### `InterpretationCandidate`

```yaml
InterpretationCandidate:
  extends: sg:DomainEntity
  lifecycle: ProposalReview
  description: Source/role proposal with unresolved observations or bindings; review
    does not turn it into a checked Interpretation.
  fields:
    candidateKey:
      type: string
      required: true
```

#### `RoleBinding`

```yaml
RoleBinding:
  extends: sg:ValueObject
  description: Role occupied by an Entity in a particular interpretation or relation;
    actor, target and instrument are contextual roles.
  fields:
    roleName:
      type: string
      required: true
```

#### `RelationInstance`

```yaml
RelationInstance:
  extends: sg:DomainEntity
  description: Contextual relation occurrence whose participant roles and origin can
    be recorded independently of its continuation.
  fields:
    relationType:
      type: string
      required: true
```

#### `StateObservation`

```yaml
StateObservation:
  extends: sg:DomainEntity
  description: Candidate-only observation availability; known references one StateSnapshot,
    partial may supply individual facts, and unknown supplies no state. Availability
    is checked by the selected instance profile.
  fields:
    availability:
      type: string
      required: true
```

#### `StateSnapshot`

```yaml
StateSnapshot:
  extends: sg:ValueObject
  layer: mechanics
  description: A declared complete finite fact set in its schema/scope/projection
    with exactly one typed origin and explicit external confirmation under the provenance
    profile. Completeness is the declaration made by this type, not a second flag;
    unavailable or partial observations are not StateSnapshot values.
  fields:
    schemaKey:
      type: string
      required: true
    scopeKey:
      type: string
      required: true
    projectionKey:
      type: string
      required: true
```

#### `Fact`

```yaml
Fact:
  extends: sg:ValueObject
  description: Scoped proposition with independent polarity support; the selected
    profile checks key/polarity sets, while semantic argument interpretation remains
    external.
  fields:
    propositionKey:
      type: string
      required: true
    polarity:
      type: string
      required: true
```

#### `Delta`

```yaml
Delta:
  extends: sg:ValueObject
  layer: mechanics
  description: Authored exact Added/Removed difference owned by one RecordedEvent;
    before/after/projection derive exclusively from that record, with no independent
    snapshot references. Exact set validation belongs to the explicitly selected instance
    profile.
```

#### `SourceAssertion`

```yaml
SourceAssertion:
  extends: sg:DomainEntity
  description: Source/revision/digest/quote provenance for an assertion; speaker is
    source-scoped and may remain unknown.
  fields:
    sourceRef:
      type: string
      required: true
    revisionKey:
      type: string
      required: true
    sourceDigest:
      type: string
      required: true
    quote:
      type: string
      required: true
    startOffset:
      type: integer
      required: true
    endOffset:
      type: integer
      required: true
    speakerKey:
      type: string
      required: false
```

#### `CausalHypothesis`

```yaml
CausalHypothesis:
  extends: sg:DomainEntity
  lifecycle: ProposalReview
  description: Proposed link between cause/effect Interpretations, each bound to its
    RecordedEvent; endpoint records derive from the views. Time order and review do
    not prove physical causation.
  fields:
    profileRef:
      type: string
      required: true
```

#### `ReviewProposal`

```yaml
ReviewProposal:
  extends: sg:Command
  description: Record review of an interpretation candidate or causal hypothesis without
    promotion, factual truth or established physical causation.
```

#### `RejectProposal`

```yaml
RejectProposal:
  extends: sg:Command
  description: Record rejection of a proposal while preserving its source and history.
```

#### `SourceSnapshotOrigin`

```yaml
SourceSnapshotOrigin:
  extends: sg:ValueObject
  description: Declared source extraction for a complete snapshot. Citations alone
    do not confirm origin or factual truth; the pinned provenance profile requires
    external authority confirmation.
  fields:
    originKey:
      type: string
      required: true
    extractionMethod:
      type: string
      required: true
```

#### `DirectObservationOrigin`

```yaml
DirectObservationOrigin:
  extends: sg:ValueObject
  description: Declared direct capture by an observer with an artifact identity and
    time; authenticity and factual accuracy are not inferred.
  fields:
    originKey:
      type: string
      required: true
    observerKey:
      type: string
      required: true
    artifactRef:
      type: string
      required: true
    artifactDigest:
      type: string
      required: true
    observedAt:
      type: integer
      required: true
    clockKey:
      type: string
      required: true
```

#### `OperatorSnapshotOrigin`

```yaml
OperatorSnapshotOrigin:
  extends: sg:ValueObject
  description: Deliberately operator-supplied complete state, explicitly uncited.
    Admission requires the named operator's scoped supply-operator-state capability
    and confirmation.
  fields:
    originKey:
      type: string
      required: true
    operatorKey:
      type: string
      required: true
    rationale:
      type: string
      required: true
```

### protocols

Нет объявлений.

### relations

#### `recordInEpisode`

```yaml
recordInEpisode:
  domain: RecordedEvent
  range: Episode
  cardinality:
    min: 1
    max: 1
  description: A record belongs to one explicit episode.
```

#### `recordOfActionKind`

```yaml
recordOfActionKind:
  domain: RecordedEvent
  range: ActionKind
  cardinality:
    min: 1
    max: 1
  description: A record declares its kind without determining actor or human contribution.
```

#### `recordInRegistry`

```yaml
recordInRegistry:
  domain: RecordedEvent
  range: EventRegistry
  cardinality:
    min: 1
    max: 1
  description: A record belongs to one immutable registry revision; its recordKey
    must be unique in that scope. The selected pinned instance profile enforces membership
    and uniqueness.
```

#### `recordBeforeSnapshot`

```yaml
recordBeforeSnapshot:
  domain: RecordedEvent
  range: StateSnapshot
  cardinality:
    min: 1
    max: 1
  description: A recorded event requires one supplied complete before snapshot directly;
    candidate availability is not an alternative range.
```

#### `recordAfterSnapshot`

```yaml
recordAfterSnapshot:
  domain: RecordedEvent
  range: StateSnapshot
  cardinality:
    min: 1
    max: 1
  description: A recorded event requires one supplied complete after snapshot directly,
    comparable to its before snapshot.
```

#### `observationSnapshot`

```yaml
observationSnapshot:
  domain: StateObservation
  range: StateSnapshot
  cardinality:
    min: 0
    max: 1
  description: A candidate known observation references one StateSnapshot; partial
    or unknown observations do not. Availability is checked by the selected instance
    profile and never mediates a RecordedEvent's states.
```

#### `observationSuppliesFact`

```yaml
observationSuppliesFact:
  domain: StateObservation
  range: Fact
  cardinality:
    min: 0
    max: '*'
  description: Partial candidate evidence can retain individual facts without declaring
    a complete snapshot or permitting exact Delta.
```

#### `snapshotContainsFact`

```yaml
snapshotContainsFact:
  domain: StateSnapshot
  range: Fact
  cardinality:
    min: 0
    max: '*'
  description: Supplied finite fact membership; absence of an observation is not an
    empty membership list.
```

#### `deltaOfRecord`

```yaml
deltaOfRecord:
  domain: Delta
  range: RecordedEvent
  cardinality:
    min: 1
    max: 1
  description: The sole owning record determines both compared snapshots and their
    projection. The selected instance profile validates exact Added/Removed against
    those states, not arbitrary independent endpoints.
```

#### `deltaAddsFact`

```yaml
deltaAddsFact:
  domain: Delta
  range: Fact
  cardinality:
    min: 0
    max: '*'
  description: Facts present only after; exact set difference requires a separate
    checker.
```

#### `deltaRemovesFact`

```yaml
deltaRemovesFact:
  domain: Delta
  range: Fact
  cardinality:
    min: 0
    max: '*'
  description: Facts present only before; removal does not create opposite support.
```

#### `interpretsRecord`

```yaml
interpretsRecord:
  domain: Interpretation
  range: RecordedEvent
  cardinality:
    min: 1
    max: 1
  description: Every checked interpretation refers to one immutable registered record.
```

#### `interpretationBindsRole`

```yaml
interpretationBindsRole:
  domain: Interpretation
  range: RoleBinding
  cardinality:
    min: 0
    max: '*'
  description: Role assignments are owned by an interpretation and do not replace
    event observations.
```

#### `roleBoundEntity`

```yaml
roleBoundEntity:
  domain: RoleBinding
  range: Entity
  cardinality:
    min: 1
    max: 1
  description: A resolved role binds any Entity; missing participants remain unresolved
    candidates.
```

#### `candidateInEpisode`

```yaml
candidateInEpisode:
  domain: EventCandidate
  range: Episode
  cardinality:
    min: 1
    max: 1
  description: Candidate descriptions retain their episode scope.
```

#### `candidateBeforeObservation`

```yaml
candidateBeforeObservation:
  domain: EventCandidate
  range: StateObservation
  cardinality:
    min: 0
    max: 1
  description: Candidate before observation may be absent, unknown or partial without
    inventing a snapshot.
```

#### `candidateAfterObservation`

```yaml
candidateAfterObservation:
  domain: EventCandidate
  range: StateObservation
  cardinality:
    min: 0
    max: 1
  description: Candidate after observation may be absent, unknown or partial without
    inventing a snapshot.
```

#### `describesCandidateEvent`

```yaml
describesCandidateEvent:
  domain: InterpretationCandidate
  range: EventCandidate
  cardinality:
    min: 1
    max: 1
  description: A source-level role candidate can describe an event candidate before
    a checked record exists.
```

#### `candidateBindsRole`

```yaml
candidateBindsRole:
  domain: InterpretationCandidate
  range: RoleBinding
  cardinality:
    min: 0
    max: '*'
  description: Candidate role assignments remain proposals even when reviewed.
```

#### `candidateCitesAssertion`

```yaml
candidateCitesAssertion:
  domain: InterpretationCandidate
  range: SourceAssertion
  cardinality:
    min: 0
    max: '*'
  description: Preserve exact source/speaker provenance when available; uncited assertions
    require explicit review labeling.
```

#### `recordCitesAssertion`

```yaml
recordCitesAssertion:
  domain: RecordedEvent
  range: SourceAssertion
  cardinality:
    min: 0
    max: '*'
  description: Supplied source assertions support a record without proving narrative
    truth.
```

#### `candidateEnrichedByRecord`

```yaml
candidateEnrichedByRecord:
  domain: EventCandidate
  range: RecordedEvent
  cardinality:
    min: 0
    max: '*'
  description: Explicit enrichment provenance to a new record after required observations
    are supplied; the original candidate remains unchanged.
```

#### `candidateResolvedAsInterpretation`

```yaml
candidateResolvedAsInterpretation:
  domain: InterpretationCandidate
  range: Interpretation
  cardinality:
    min: 0
    max: '*'
  description: Explicit provenance to a separately checked interpretation; candidate
    review alone never creates this link or establishes its validity.
```

#### `relationBindsRole`

```yaml
relationBindsRole:
  domain: RelationInstance
  range: RoleBinding
  cardinality:
    min: 0
    max: '*'
  description: A relation can retain multiple contextual participant roles.
```

#### `relationOriginRecord`

```yaml
relationOriginRecord:
  domain: RelationInstance
  range: RecordedEvent
  cardinality:
    min: 0
    max: 1
  description: An optional supplied origin record does not prescribe the relation's
    persistence or termination.
```

#### `hypothesisCauseView`

```yaml
hypothesisCauseView:
  domain: CausalHypothesis
  range: Interpretation
  cardinality:
    min: 1
    max: 1
  description: Cause interpretation binds participant roles to a record via interpretsRecord;
    its registered event is derived from that link.
```

#### `hypothesisEffectView`

```yaml
hypothesisEffectView:
  domain: CausalHypothesis
  range: Interpretation
  cardinality:
    min: 1
    max: 1
  description: Effect interpretation supplies its own bound roles and derived record.
    Both endpoint records must belong to the same registry revision and remain distinct
    under the selected profile.
```

#### `hypothesisCitesAssertion`

```yaml
hypothesisCitesAssertion:
  domain: CausalHypothesis
  range: SourceAssertion
  cardinality:
    min: 0
    max: '*'
  description: Hypothesis grounds retain their source; citations alone do not establish
    causation.
```

#### `snapshotSourceOrigin`

```yaml
snapshotSourceOrigin:
  domain: StateSnapshot
  range: SourceSnapshotOrigin
  cardinality:
    min: 0
    max: 1
  description: One of exactly three disjoint snapshot origin alternatives under eventcore-provenance-v1.
```

#### `snapshotDirectOrigin`

```yaml
snapshotDirectOrigin:
  domain: StateSnapshot
  range: DirectObservationOrigin
  cardinality:
    min: 0
    max: 1
  description: Direct observation alternative; absence is not an observation of an
    empty state.
```

#### `snapshotOperatorOrigin`

```yaml
snapshotOperatorOrigin:
  domain: StateSnapshot
  range: OperatorSnapshotOrigin
  cardinality:
    min: 0
    max: 1
  description: Explicit operator-supplied alternative, distinct from source citations
    and direct capture.
```

#### `originCitesAssertion`

```yaml
originCitesAssertion:
  domain: SourceSnapshotOrigin
  range: SourceAssertion
  cardinality:
    min: 1
    max: '*'
  description: Exact extraction citations. Their presence and source offsets do not
    prove semantic completeness, authenticity or truth.
```

### policies

#### `PreserveRecordedObservations`

```yaml
PreserveRecordedObservations:
  extends: sg:Policy
  enforceability: manual
  appliesTo:
  - EventRegistry
  - RecordedEvent
  - Interpretation
  text: A record belongs to exactly one EventRegistry revision, where recordKey is
    unique; the registry identity is registryKey plus revisionKey. Reinterpreting
    roles never replaces supplied snapshots. Enrichment preserves known snapshots
    and all partial facts, and creates a linked new record; this declaration is not
    an implemented registry service.
```

#### `KnownStatesForExactDelta`

```yaml
KnownStatesForExactDelta:
  extends: sg:Policy
  enforceability: manual
  appliesTo:
  - StateObservation
  - StateSnapshot
  - RecordedEvent
  - Delta
  - EventCandidate
  text: RecordedEvent directly requires complete StateSnapshots with matching schema/scope/projection,
    without availability or complete flags on the record path. Delta derives both
    states through deltaOfRecord and must equal their exact difference. Unknown or
    partial candidate observations cannot create a record or Delta by substituting
    empty states or operator review states. Equal explicitly supplied and provenance-confirmed
    empty snapshots allow an exact empty Delta.
```

#### `ScopedSourceAttribution`

```yaml
ScopedSourceAttribution:
  extends: sg:Policy
  enforceability: manual
  appliesTo:
  - SourceAssertion
  - InterpretationCandidate
  text: Preserve source/revision/digest/quote/speaker identity and episode scope.
    I in a letter refers to the source author, not automatically the narrator; absent
    speaker remains unknown. Structural citations do not prove semantic relevance.
```

#### `CandidateAuthorityBoundary`

```yaml
CandidateAuthorityBoundary:
  extends: sg:Policy
  enforceability: manual
  appliesTo:
  - EventCandidate
  - InterpretationCandidate
  - Interpretation
  text: Candidate review is not event registration, factual truth, human attribution
    or responsibility. Package validation and generated schemas establish structure
    only; the selected instance profile checks references, state alternatives and
    explicit origin/enrichment admission; normative responsibility remains external.
```

#### `BoundedCausalHypothesis`

```yaml
BoundedCausalHypothesis:
  extends: sg:Policy
  enforceability: manual
  appliesTo:
  - CausalHypothesis
  text: Cause/effect Interpretations derive their endpoint records through interpretsRecord;
    both records must belong to the same EventRegistry revision and have distinct
    recordKeys, the same clockKey, valid intervals and cause start no later than effect
    start. Overlap is allowed. Proposal review does not prove causation; graph/temporal
    checks belong to the selected instance profile and no responsibility is transferred.
```

#### `SnapshotOriginAdmission`

```yaml
SnapshotOriginAdmission:
  extends: sg:Policy
  enforceability: manual
  appliesTo:
  - StateSnapshot
  - SourceSnapshotOrigin
  - DirectObservationOrigin
  - OperatorSnapshotOrigin
  text: The eventcore-provenance-v1 profile requires exactly one typed origin per
    snapshot and an explicit scoped authority confirmation bound to exact graph bytes.
    The authority input is selected by the trusted caller, never self-issued by graph
    review. Source presence, origin confirmation and factual truth are distinct; no
    cryptographic identity authentication is implemented.
```

#### `ExplicitEnrichmentAdmission`

```yaml
ExplicitEnrichmentAdmission:
  extends: sg:Policy
  enforceability: manual
  appliesTo:
  - EventCandidate
  - InterpretationCandidate
  - RecordedEvent
  text: Candidate-to-record enrichment requires separate scoped authority admission
    after snapshot origin confirmation. Interpretation resolution must use an explicitly
    enriched record. Missing physical states may remain source-only indefinitely,
    without a record or Delta. Never auto-upgrade old reports or infer a complete
    empty state from silence.
```

### stateMachines

#### `ProposalReview`

```yaml
ProposalReview:
  states:
  - proposed
  - reviewed
  - rejected
  transitions:
  - from: proposed
    to: reviewed
    command: ReviewProposal
  - from: proposed
    to: rejected
    command: RejectProposal
```

### modelApplicability

#### `appliesTo`

```yaml
appliesTo:
  domains:
  - general_event_modeling
  contexts:
  - draft_vocabulary_review
  - offline_consumer_contract_design
```

#### `excludes`

```yaml
excludes:
  contexts:
  - automatic_liability_assignment
  - trusted_physical_causation
  - unselected_runtime_profile
```

#### `assumptions`

```yaml
assumptions:
- id: manual_semantic_review
  text: Selected instance profiles enforce bounded structural/admission rules. Citation
    relevance, completeness and factual truth require separate trusted review.
- id: observation_availability
  text: Only candidates use StateObservation availability. StateSnapshot declares
    a complete supplied state; unknown/partial observations never become empty snapshots
    or a record's direct states.
```

#### `invalidationTriggers`

```yaml
invalidationTriggers:
- id: instance_contract_changed
  text: Re-review package vocabulary and mappings when the chosen pinned InstanceGraph/profile
    contract changes.
```


## Foundation: каталоги символов

Каталоги ниже извлечены из зафиксированных Git commits и проверены по hash, указанному в отчёте ontology context. Они не содержат определений; список имён не следует считать полным смысловым описанием классов. Второй каталог в отчёте назван `specgraph.foundation`, но исходный JSON сам содержит `id: ontology.foundation`; здесь сохранены оба названия без их отождествления.

### ontology.foundation @ 0.2.0

Источник: `Ontology@40672c189f33dee2b8c6fdac903758e90d9fba86:SPECS/ontology/foundation/0.2.0/exports.json`
SHA-256: `0444a5848b89cc8b0505ebc8a3114d07bfce9c9089a07f1c5a952f6ce8087841`

```json
{
  "classes" : [
    "Action",
    "Capability",
    "Command",
    "DomainEntity",
    "Event",
    "Invariant",
    "Policy",
    "StateMachine",
    "ValueObject"
  ],
  "id" : "ontology.foundation",
  "namespace" : "ont",
  "policyBases" : [
    "Policy"
  ],
  "protocols" : [
    "Approvable",
    "Auditable",
    "DeviceBound",
    "RestrictableCapability",
    "Signable",
    "TimeBound",
    "Versioned"
  ],
  "schemaVersion" : 1,
  "version" : "0.2.0"
}
```

### Дополнительный каталог SpecGraph

Источник: `Ontology@c52553f872f440dde26c61abf9193f5fff171d98:SPECS/ontology/foundation/0.1.0/exports.json`
SHA-256: `1c6b3ac3e4aa9b4e56d823b3645f94c126840c1922c555998b848e9e0fe18f8f`

```json
{
  "classes" : [
    "Actor",
    "Capability",
    "Command",
    "DomainEntity",
    "Event",
    "Invariant",
    "Policy",
    "StateMachine",
    "SystemActor",
    "ValueObject"
  ],
  "id" : "ontology.foundation",
  "namespace" : "ont",
  "policyBases" : [
    "Policy"
  ],
  "protocols" : [
    "Approvable",
    "Auditable",
    "DeviceBound",
    "RestrictableCapability",
    "Signable",
    "TimeBound",
    "Versioned"
  ],
  "schemaVersion" : 1,
  "version" : "0.1.0"
}
```

Сопутствующая модель типов `ontology.foundation@0.2.0` в том же исходном commit: [`foundation-types.md`](https://github.com/0al-spec/Ontology/blob/40672c189f33dee2b8c6fdac903758e90d9fba86/SPECS/ontology/foundation-types.md). Это описание типов и отношений, а не набор проверенных конкретных экземпляров.
