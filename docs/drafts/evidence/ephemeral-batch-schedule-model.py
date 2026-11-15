"""Explore a proposed setup policy; this does not execute product code."""
from itertools import permutations
from pathlib import Path
import hashlib
import json
import sys

EVENTS = ('read', 'admit', 'commit', 'cancel', 'crash', 'restart', 'retry')


def simulate(schedule, *, guard_cancellation, durable_admission, unique_commit):
    active = True
    cancelled = False
    read_allowed = False
    admitted = False
    ticket = False
    projects = 0
    late_admission = False
    blocked_retry = False
    for event in schedule:
        if event == 'read':
            read_allowed = active and not cancelled
        elif event == 'admit':
            # The original worker cannot resume after its process has died.
            if active and read_allowed and (not guard_cancellation or not cancelled):
                late_admission = cancelled
                admitted = True
                ticket = durable_admission
        elif event == 'commit':
            # A started storage operation may finish after process death.
            if admitted:
                if not unique_commit or projects == 0:
                    projects += 1
                ticket = False
        elif event == 'cancel':
            if active:
                cancelled = True
        elif event == 'crash':
            active = False
            read_allowed = False
        elif event == 'restart':
            active = True
            # No unsubmitted selection is restored or automatically submitted.
        elif event == 'retry':
            # An intentional fresh selection, not automatic batch resumption.
            if ticket:
                blocked_retry = True
            elif projects == 0:
                # A new retry observes no saved association at its commit.
                projects += 1
    return projects, late_admission, blocked_retry


schedules = [s for s in permutations(EVENTS)
             if s.index('read') < s.index('admit') < s.index('commit')
             and s.index('crash') < s.index('restart') < s.index('retry')]
unsafe_duplicates = []
unsafe_after_cancel = []
blocked = 0
for schedule in schedules:
    good = simulate(schedule, guard_cancellation=True, durable_admission=True, unique_commit=True)
    no_pending = simulate(schedule, guard_cancellation=True, durable_admission=False, unique_commit=False)
    stale_cancel = simulate(schedule, guard_cancellation=False, durable_admission=True, unique_commit=True)
    assert good[0] <= 1 and not good[1]
    blocked += good[2]
    if no_pending[0] > 1:
        unsafe_duplicates.append(schedule)
    if stale_cancel[1]:
        unsafe_after_cancel.append(schedule)
assert unsafe_duplicates and unsafe_after_cancel and blocked
spec = Path(__file__).resolve().parent.parent / 'GITVIEW-SPEC-0045.yaml'
result = {
    'artifact_kind': 'gitview_ephemeral_batch_schedule_model',
    'source_spec_sha256': hashlib.sha256(spec.read_bytes()).hexdigest(),
    'schedules': len(schedules),
    'safe_duplicate_or_post_cancel_admission': 0,
    'safe_retry_blocked_by_unresolved_ticket': blocked,
    'naive_duplicate_count': len(unsafe_duplicates),
    'naive_duplicate_example': unsafe_duplicates[0],
    'stale_cancellation_admission_count': len(unsafe_after_cancel),
    'stale_cancellation_example': unsafe_after_cancel[0],
    'assumptions': 'One Repository, one original worker, one cancellation, one crash and one newly confirmed retry. A submitted operation may commit after crash. Guarded admission is ordered with cancellation; admission evidence survives restart; uniqueness is atomic at commit; old unsubmitted work is never resumed automatically.',
    'limitations': 'Bounded author-authored abstraction; not a real process, persistence provider, identity/access, failure, receipt recovery, or native UX test. Durable admission is assumed, not implemented. No full batch selection, two-Repositories, custom duplicate, multiple workers or crash-during-atomic-step is modeled.',
    'application_scenarios_executed': False,
}
output = Path(sys.argv[1])
output.write_text(json.dumps(result, indent=2) + '\n')
print(json.dumps(result))
