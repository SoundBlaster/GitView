"""Bounded abstract cancellation/admission schedules; no application code is executed."""
from itertools import permutations
from pathlib import Path
import hashlib
import json

# One worker reads a confirmed, initially active batch before attempting to
# admit an entry. Cancellation becomes durable at its single modeled event.
events = ('worker.read', 'worker.admit', 'cancel.commit')
schedules = [s for s in permutations(events)
             if s.index('worker.read') < s.index('worker.admit')]


def simulate(schedule, guard_at_admission):
    cancelled = False
    read_active = None
    admitted_at = None
    cancelled_at = None
    for index, event in enumerate(schedule):
        if event == 'worker.read':
            read_active = not cancelled
        elif event == 'cancel.commit':
            cancelled = True
            cancelled_at = index
        elif read_active and (not guard_at_admission or not cancelled):
            admitted_at = index
    return admitted_at, cancelled_at


naive_witnesses = []
guarded_admitted_before_cancel = 0
guarded_rejected_after_cancel = 0
for schedule in schedules:
    naive_admit, cancel_at = simulate(schedule, False)
    guarded_admit, _ = simulate(schedule, True)
    if naive_admit is not None and naive_admit > cancel_at:
        naive_witnesses.append(list(schedule))
    assert guarded_admit is None or guarded_admit < cancel_at
    if guarded_admit is not None:
        guarded_admitted_before_cancel += 1
    elif schedule.index('worker.admit') > cancel_at:
        guarded_rejected_after_cancel += 1
assert naive_witnesses and guarded_admitted_before_cancel and guarded_rejected_after_cancel

drafts = Path(__file__).resolve().parent.parent
spec = drafts / 'GITVIEW-SPEC-0045.yaml'
record = {
    'artifact_kind': 'gitview_batch_cancellation_admission_model',
    'spec': 'GITVIEW-SPEC-0045',
    'spec_sha256': hashlib.sha256(spec.read_bytes()).hexdigest(),
    'schedules_examined': len(schedules),
    'naive_post_cancellation_admission_witnesses': naive_witnesses,
    'guarded_admissions_before_cancellation': guarded_admitted_before_cancel,
    'guarded_rejections_after_cancellation': guarded_rejected_after_cancel,
    'assumptions': 'One worker, one cancellation and a pre-existing durable batch. In the guarded abstraction, cancellation and admission are totally ordered and the admission guard reads the cancellation state atomically.',
    'limitations': 'Author-built finite model, not a proof of a database or implementation. It does not model persistence failure, partial acknowledgement, multiple workers, entry completion, recovery, source access or real process termination.',
    'application_scenarios_executed': False,
}
out = drafts / 'evidence/autonomous-goal-batch-cancellation-model-20261114.json'
out.write_text(json.dumps(record, indent=2, ensure_ascii=False) + '\n')
print(json.dumps(record, ensure_ascii=False))
