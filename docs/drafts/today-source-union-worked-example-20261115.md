# Today: source portions to grid, worked example

This is an agent-authored illustrative fixture for 0027, 0102, 0110, 0115 and
0116. It is a proposed behavioral example, not an executed test, a GitHub
response or proof of exhaustive source visibility. It uses a captured local-day
interval `[D0, D1)` and unrestricted lifecycle filters.

Project P has confirmed members A and B; all four known identities below and
the stated facts are independently confirmed and currently permitted. Source
and observation contexts remain attached to each fact. The example assumes
their stated predicates are applicable at the captured evaluation context;
merely receiving an old fact would not establish that assumption.

| Portion / input | Evidence received | Consequence |
| --- | --- | --- |
| A open PR | X, created before D0, with applicable open lifecycle. | X matches Today because it remains open. |
| A recent PR | X again with supported same identity, and Z with a supported merge at `D0`. | X remains one candidate; Z matches through its merge at the inclusive start. The two observations of X keep their separate contexts. |
| A recent Issue | Y, created inside `[D0, D1)` and currently closed. | Y matches through creation today; no inferred close event or completion reason is needed. |
| B Issue | U, created before D0; current lifecycle and relevant outcome-event coverage unavailable. | U's Today decision is unknown, not a confirmed non-match or match. It may be reached in the explicitly identified uncertain portion under 0042. |
| Other required portions | Not observed or not supported well enough to establish their requested coverage. | The union is incomplete or unproven even if every returned page is terminal. No missing-object count can be calculated from these facts. |

With no extra filter, X, Y and Z are three distinct **known matches**, and U
is one **known uncertain candidate**. The grid can render the three permitted
matches and provide the uncertain candidate through its labeled route; neither
three nor four is an exact count of all Today work. A supported aggregate from
GitHub would remain a separate claim and could not by itself identify missing
cards. The Issue's closed state does not imply successful completion; the PR's
merge does not imply the status of CI or review.

If the local day rolls forward while a request for this interval is pending,
reevaluate supported observations against the newly captured interval. The old
request cannot be relabeled as complete coverage of the new day. An event
exactly at D1 is outside this old half-open interval; whether it belongs to the
new one depends on its captured boundaries. If a newer restriction applies to
B, U and any revealing count are withheld according to 0036 even though this
illustration previously included it. A later valid observation is evaluated
under its own source and access context; arrival alone does not turn the old
selection into a current or complete snapshot.

For later deterministic route testing, supply these inputs through independent
source, clock, access and storage doubles; check unique identity, the three
confirmed matches, one known uncertainty and incomplete population separately.
This fixture does not test real GraphQL permissions, mutable pagination, event
history, persistence, gesture behavior or native accessibility.
