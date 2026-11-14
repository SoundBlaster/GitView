"""Illustrative author-created scenario model, not GitView or source implementation."""

from datetime import date, datetime, time, timedelta, timezone
from hashlib import sha256
import json
from pathlib import Path
from zoneinfo import ZoneInfo

UTC = timezone.utc
zone = ZoneInfo("America/New_York")


def bounds(day):
    return (
        datetime.combine(day, time.min, tzinfo=zone).astimezone(UTC),
        datetime.combine(day + timedelta(days=1), time.min, tzinfo=zone).astimezone(UTC),
    )


def in_interval(instant, interval):
    return interval[0] <= instant < interval[1]


def historical_match(known_closures, interval, complete):
    # A single confirmed positive suffices; absence requires complete coverage.
    if any(in_interval(t, interval) for t in known_closures):
        return "true"
    return "false" if complete else "unknown"


day0 = bounds(date(2026, 10, 31))
day1 = bounds(date(2026, 11, 1))
day2 = bounds(date(2026, 11, 2))
assert day0[1] == day1[0] and day1[1] == day2[0]
assert day1[1] - day1[0] == timedelta(hours=25)

# One identified Issue, with independently supplied source-confirmed fixtures.
first_close = day1[0] - timedelta(seconds=1)
first_reopen = day1[0] + timedelta(seconds=1)
second_close = day2[0] - timedelta(seconds=1)
second_reopen = day2[0] + timedelta(seconds=1)
closures = (first_close, second_close)
assert first_close < first_reopen < second_close < second_reopen
assert historical_match(closures, day0, True) == "true"
assert historical_match(closures, day1, True) == "true"
assert historical_match(closures, day2, True) == "false"
assert not in_interval(day1[0], day0) and in_interval(day1[0], day1)

# At the first boundary, an independently observed open state includes the
# Issue in the new Today while the prior day's closure remains historical.
first_current_state = "open"
assert in_interval(first_reopen, day1) and first_current_state == "open"
first_today_open = first_current_state == "open"
first_prior_day_match = historical_match((first_close,), day0, True)
first_current_closed_filter = first_current_state == "closed"
assert first_today_open and first_prior_day_match == "true" and not first_current_closed_filter

# Each daily distinct-Issue bucket is one, not two independent Issues in the
# combined period; a separate event metric counts both distinct closures.
daily_distinct_issues = [int(historical_match(closures, day, True) == "true")
                         for day in (day0, day1)]
period = (day0[0], day2[0])
period_events = sum(in_interval(t, period) for t in closures)
period_distinct_issues = int(historical_match(closures, period, True) == "true")
assert daily_distinct_issues == [1, 1]
assert period_events == 2 and period_distinct_issues == 1

# The current state is supplied as independent evidence after the second
# reopen, not reconstructed by the code from the closure history.
current_state = "open"
today_day2_inclusion = current_state == "open" or any(in_interval(t, day2) for t in closures)
prior_history_match = historical_match(closures, day1, True)
closed_filter_matches = current_state == "closed"
assert today_day2_inclusion and prior_history_match == "true" and not closed_filter_matches

# With no closure time and incomplete historical coverage, current open still
# establishes unfinished Today inclusion but cannot prove a prior-day match.
assert current_state == "open"
assert historical_match((), day1, False) == "unknown"

drafts = Path(__file__).resolve().parents[1]
spec_names = ("GITVIEW-SPEC-0027.yaml", "GITVIEW-SPEC-0043.yaml",
              "GITVIEW-SPEC-0049.yaml", "GITVIEW-SPEC-0056.yaml",
              "GITVIEW-SPEC-0069.yaml", "GITVIEW-SPEC-0089.yaml")
record = {
    "artifact_kind": "gitview_issue_reopening_boundary_example",
    "spec_sha256": {name: sha256((drafts / name).read_bytes()).hexdigest() for name in spec_names},
    "model_sha256": sha256(Path(__file__).read_bytes()).hexdigest(),
    "timezone": zone.key,
    "day1_duration_hours": 25,
    "example": {
        "first_closure_utc": first_close.isoformat(),
        "first_reopening_utc": first_reopen.isoformat(),
        "first_new_day_open_today": first_today_open,
        "first_prior_day_closure_match": first_prior_day_match,
        "first_current_closed_filter_match": first_current_closed_filter,
        "second_closure_utc": second_close.isoformat(),
        "second_reopening_utc": second_reopen.isoformat(),
        "daily_distinct_issues": daily_distinct_issues,
        "period_distinct_issues": period_distinct_issues,
        "period_closure_events": period_events,
        "next_day_open_today": today_day2_inclusion,
        "prior_day_closure_match": prior_history_match,
        "current_closed_filter_match": closed_filter_matches,
        "missing_closure_time_prior_match": "unknown",
    },
    "limitations": [
        "An author-created example with supplied identity, event times, source scope and current-state observations.",
        "Uses host time-zone database, not Apple calendar behavior; it is not an exhaustive time-zone or DST test.",
        "Does not verify source event completeness, access policy, source integration, UI, storage or GitView implementation.",
        "A model execution is not execution of application scenarios or proof of semantic acceptance.",
    ],
    "application_scenarios_executed": False,
}
out = drafts / "evidence/autonomous-goal-issue-reopening-boundary-20261114.json"
out.write_text(json.dumps(record, indent=2, ensure_ascii=False) + "\n")
print(json.dumps({"output": str(out), "example": record["example"]}, ensure_ascii=False))
