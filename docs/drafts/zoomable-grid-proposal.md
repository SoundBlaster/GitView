# Draft proposal: zoomable project grid

Status: **pre-canonical proposal for discussion**. No specification node,
canonical requirement, approval, implementation, or acceptance result has been
created by this document.

## Source and trace

- Project sketch: `conversation_memory/sketches/gitview/` (tracked locally).
- Sketch revision: `1396c542e64749d1bdad985fb1f732b2`.
- Selected note IDs: `zoom-grid`, `calendar`, `pr-depth`.
- Source references are local excerpt labels, not authenticated chat IDs.
- Target canonical spec: none selected; `specs/nodes/` currently contains no
  specification nodes. This proposal suggests a first bounded concern rather
  than assigning an ID or claiming an existing graph relation.

The user said, in `conversation:gitview/excerpt-04`:

> Можно было бы сделать очень оригинально: как Photos app - сетка квадратиков которую можно pinch to zoom и обратно и погружаться в карточки или отдаляться, чтобы видеть больше

The user also said, in `conversation:gitview/excerpt-05`:

> Возможно кстати клетчатый календарь гитхаба неплох как самый максимальный уровень отдаления от деталей

The calendar is a possibility to investigate, rather than an accepted
requirement. After this proposal's source revision, the user clarified in
`conversation:gitview/excerpt-14` that the current scope does not delve into a
PR and should display its metrics. The historical source revision remains intact.

## Proposed bounded change

Consider a first product specification for navigating a grid of GitHub work at
different levels of detail. A person can zoom outward to see more of the work
and inward to inspect cards; a pinch gesture is part of the proposed interaction.
This proposal does not decide the complete screen hierarchy, metrics, GitHub
authentication, CI/readiness rules, or an implementation framework.

## Proposed examples for review

These examples are agent-proposed candidates, not accepted criteria:

1. Given a grid showing several projects, an outward zoom displays a broader
   view; an inward zoom returns to a more detailed view.
2. Given a visible project, a person can enter its work and see distinguishable
   PR or issue cards without confusing their repository identity.
3. A person unable to use a pinch gesture can navigate the same information via
   a discoverable alternative; the exact system control remains to be chosen.

Before making these normative, define the starting data, scale boundaries,
gesture and tap behavior, loading/error states, and an observable device-level
check. Investigate how selection and scroll position should be preserved.

## Open decisions

- Is zoom continuous, discrete, or a combination? What does each level show?
- How does selection relate to pinch, tapping a card, and returning to a view?
- Does the activity calendar filter projects by date, or navigate independently?
  Its cells represent days; project cells represent repositories.
- Which accessible controls and VoiceOver behavior are appropriate?
- Is a deeper PR interior part of this concern or a later specification?

## Handoff

Review the selected sources and open decisions with the product owner. Then
follow the applicable SpecGraph review and materialization workflow for one
bounded product node. Do not infer whole-sketch approval from permission to
conduct this pilot.
