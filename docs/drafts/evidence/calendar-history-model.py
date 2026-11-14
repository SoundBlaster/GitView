"""Author-built examples for 0069; this is not application or iOS code."""
from datetime import date, datetime, time, timedelta, timezone
from pathlib import Path
from zoneinfo import ZoneInfo
import hashlib
import json

UTC = timezone.utc


def day_bounds(day, zone):
    start = datetime.combine(day, time.min, tzinfo=zone).astimezone(UTC)
    end = datetime.combine(day + timedelta(days=1), time.min, tzinfo=zone).astimezone(UTC)
    return start, end


def in_half_open(instant, start, end):
    return start <= instant < end


def latest_sample(samples):
    if not samples:
        return None
    newest = max(sample['observed'] for sample in samples)
    tied = [sample for sample in samples if sample['observed'] == newest]
    if len({(sample['value'], sample.get('coverage')) for sample in tied}) > 1:
        return {'state': 'conflict', 'observed': newest}
    return tied[0]


ny = ZoneInfo('America/New_York')
tokyo = ZoneInfo('Asia/Tokyo')
spring = day_bounds(date(2026, 3, 8), ny)
autumn = day_bounds(date(2026, 11, 1), ny)
assert (spring[1] - spring[0]) == timedelta(hours=23)
assert (autumn[1] - autumn[0]) == timedelta(hours=25)
for start, end in (spring, autumn):
    assert in_half_open(start, start, end)
    assert not in_half_open(end, start, end)
    assert in_half_open(end - timedelta(microseconds=1), start, end)

start, end = day_bounds(date(2026, 11, 1), ny)
evaluation = datetime(2026, 11, 1, 20, tzinfo=UTC)
assert start < evaluation < end
assert not in_half_open(evaluation, start, evaluation)
assert in_half_open(evaluation, start, evaluation + timedelta(seconds=1))

same_instant = datetime(2026, 11, 1, 2, tzinfo=UTC)
assert same_instant.astimezone(ny).date() == date(2026, 10, 31)
assert same_instant.astimezone(tokyo).date() == date(2026, 11, 1)
assert in_half_open(same_instant, *day_bounds(date(2026, 10, 31), ny))
assert in_half_open(same_instant, *day_bounds(date(2026, 11, 1), tokyo))
frozen_bounds = day_bounds(date(2026, 10, 31), ny)
assert frozen_bounds != day_bounds(date(2026, 10, 31), tokyo)

samples = [
    {'observed': '2026-11-01T09:00:00Z', 'value': 7, 'coverage': 'complete', 'components': ['09:00Z']},
    {'observed': '2026-11-01T17:00:00Z', 'value': 5, 'coverage': 'partial', 'components': ['16:30Z', '17:00Z']},
]
latest = latest_sample(samples)
assert latest['coverage'] == 'partial' and latest['components'] == ['16:30Z', '17:00Z']
assert latest_sample([]) is None
assert latest_sample([{'observed': 'T', 'value': 1}, {'observed': 'T', 'value': 2}])['state'] == 'conflict'
assert latest_sample([{'observed': 'T', 'value': 1, 'coverage': 'complete'},
                      {'observed': 'T', 'value': 1, 'coverage': 'partial'}])['state'] == 'conflict'

drafts = Path(__file__).resolve().parent.parent
spec = drafts / 'GITVIEW-SPEC-0069.yaml'
result = {
    'artifact_kind': 'gitview_calendar_history_author_model',
    'spec': spec.name,
    'spec_sha256': hashlib.sha256(spec.read_bytes()).hexdigest(),
    'examples': ['new_york_spring_23h', 'new_york_autumn_25h', 'half_open_day_boundaries',
                 'current_cutoff_exclusive', 'new_york_tokyo_different_local_day',
                 'captured_zone_bounds_distinct', 'later_partial_preserved',
                 'empty_samples_gap', 'equal_time_value_conflict', 'equal_time_coverage_conflict'],
    'limitations': 'Author-built illustrative model using the host time-zone database; not an independent interpretation, Swift/iOS test, live source observation, or exhaustive calendar and sample ordering validation.',
    'application_scenarios_executed': False,
}
out = drafts / 'evidence/autonomous-goal-calendar-history-model-20261114.json'
out.write_text(json.dumps(result, indent=2, ensure_ascii=False) + '\n')
print(json.dumps(result, ensure_ascii=False))
