"""Finite author-built design model, not a GitView implementation or platform test."""

from collections import Counter
from hashlib import sha256
from itertools import product
import json
from pathlib import Path

F, U, T = "false", "unknown", "true"
VALUES = (F, U, T)
BOOL = (False, True)


def tri_or(values):
    return T if T in values else U if U in values else F


def tri_and(values):
    return F if F in values else U if U in values else T


def model(opened, outcome, created, scope, lifecycle, ci, life_on, ci_on,
          all_excluded, identity_allowed, ci_allowed, coverage_complete):
    # An unavailable private CI value cannot be used as an observable predicate.
    visible_ci = ci if ci_allowed else U
    life_condition = F if all_excluded else lifecycle if life_on else T
    ci_condition = visible_ci if ci_on else T
    included = tri_or((opened, outcome, created))
    result = tri_and((scope, included, life_condition, ci_condition))
    # Identity permission is independent of predicate uncertainty.
    card = ("confirmed" if result == T else "uncertain" if result == U else "none") if identity_allowed else "suppressed"
    # Filtered emptiness and coverage are separate: neither is a hidden count.
    view_status = "intentional_filtered_empty" if all_excluded else "selection"
    coverage_status = ("incomplete" if not coverage_complete or not identity_allowed or result == U
                       else "covered_for_this_abstraction")
    return result, card, view_status, coverage_status


def completions(value):
    return (False, True) if value == U else (value == T,)


def oracle(opened, outcome, created, scope, lifecycle, ci, life_on, ci_on,
           all_excluded, identity_allowed, ci_allowed, coverage_complete):
    """Enumerate concrete worlds compatible with the information supplied."""
    ci_input = ci if ci_allowed else U
    observed_lifecycle = F if all_excluded else lifecycle if life_on else T
    observed_ci = ci_input if ci_on else T
    possible = {
        (o or e or c) and s and l and k
        for o, e, c, s, l, k in product(
            *map(completions, (opened, outcome, created, scope, observed_lifecycle, observed_ci))
        )
    }
    if possible == {True}:
        return T
    if possible == {False}:
        return F
    return U


counts = Counter()
cards = Counter()
case_count = 0
for inputs in product(VALUES, VALUES, VALUES, VALUES, VALUES, VALUES,
                      BOOL, BOOL, BOOL, BOOL, BOOL, BOOL):
    opened, outcome, created, scope, lifecycle, ci, life_on, ci_on, all_excluded, identity_allowed, ci_allowed, coverage_complete = inputs
    # "All lifecycle states excluded" is an active lifecycle selection.
    if all_excluded and not life_on:
        continue
    result, card, view_status, coverage_status = model(*inputs)
    assert result == oracle(*inputs), inputs
    assert identity_allowed or card == "suppressed", inputs
    assert card != "confirmed" or result == T, inputs
    assert card != "uncertain" or result == U, inputs
    if all_excluded:
        assert result == F and view_status == "intentional_filtered_empty", inputs
    if not coverage_complete or not identity_allowed or result == U:
        assert coverage_status == "incomplete", inputs
    # A restricted CI value must not alter the observable result.
    if ci_on and not ci_allowed:
        changed = list(inputs)
        changed[5] = {F: T, T: F, U: T}[ci]
        assert model(*changed) == (result, card, view_status, coverage_status), inputs
    if not identity_allowed:
        changed = list(inputs)
        changed[0] = {F: T, T: F, U: T}[opened]
        _, other_card, other_view, other_coverage = model(*changed)
        assert (other_card, other_view, other_coverage) == (card, view_status, coverage_status), inputs
    counts[result] += 1
    cards[card] += 1
    case_count += 1

# Concrete design example: all 100 PRs remain Today after 95 merge; an
# explicitly selected lifecycle exclusion then leaves the five open PRs.
before = [model(T, F, F, T, T, T, False, False, False, True, True, True)[1]
          for _ in range(100)]
after = [model(F if i < 95 else T, T if i < 95 else F, F,
               T, T, T, False, False, False, True, True, True)[1]
         for i in range(100)]
filtered = [model(F if i < 95 else T, T if i < 95 else F, F,
                  T, F if i < 95 else T, T, True, False, False,
                  True, True, True)[1] for i in range(100)]
assert before.count("confirmed") == 100
assert after.count("confirmed") == 100
assert filtered.count("confirmed") == 5

root = Path(__file__).resolve().parents[1]
specs = {name: sha256((root / name).read_bytes()).hexdigest() for name in (
    "GITVIEW-SPEC-0027.yaml", "GITVIEW-SPEC-0042.yaml",
    "GITVIEW-SPEC-0049.yaml", "GITVIEW-SPEC-0088.yaml",
)}
record = {
    "artifact_kind": "gitview_today_selection_access_finite_model",
    "spec_sha256": specs,
    "case_count": case_count,
    "selection_counts": dict(counts),
    "presentation_counts": dict(cards),
    "model_sha256": sha256(Path(__file__).read_bytes()).hexdigest(),
    "hundred_pr_design_example": {"initial": 100, "after_95_merged": 100, "merged_excluded": 5},
    "oracle": "Exhaustive Boolean completions of the stated three-valued inputs after applying visibility and active filters.",
    "assumptions": [
        "The Boolean completions are a deliberately simplified independent-input abstraction.",
        "A CI value inaccessible to the operator is unknown for current filter evaluation.",
        "Object-level visibility and source-wide coverage are independent model inputs.",
        "All excluded lifecycle states are an explicit active filter, not proof that source work is absent.",
        "Intentional filtered emptiness is represented independently of scope coverage.",
    ],
    "limitations": [
        "No real GitHub or iOS behavior, app implementation, actual permission inference or accessibility output is tested.",
        "No temporal ordering, correlated facts, identity resolution, source pagination or concurrent gesture is modeled.",
        "Abstract scope status is not a user-visible count or proof of privacy for actual UI and cache.",
        "The oracle checks logical consistency of this abstraction, not whether its assumptions implement the complete product specification.",
    ],
    "application_scenarios_executed": False,
}
out = root / "evidence/autonomous-goal-today-selection-access-20261114.json"
out.write_text(json.dumps(record, indent=2, ensure_ascii=False) + "\n")
print(json.dumps({"cases": case_count, "counts": dict(counts), "output": str(out)}, ensure_ascii=False))
