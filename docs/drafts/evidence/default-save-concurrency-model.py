"""Explore a two-attempt counterexample; this is not an implementation of GitView persistence."""
from itertools import permutations
from pathlib import Path
import hashlib
import json

operations = ('A.read', 'A.commit', 'B.read', 'B.commit')
schedules = [s for s in permutations(operations)
             if s.index('A.read') < s.index('A.commit') and s.index('B.read') < s.index('B.commit')]

def simulate(schedule, enforce_at_commit):
    observed = {}
    associations = set()
    for step in schedule:
        actor, action = step.split('.')
        if action == 'read':
            observed[actor] = bool(associations)
        elif not observed[actor]:
            # The guarded model checks uniqueness atomically at commit time;
            # the naive model trusts only the prior read.
            if not enforce_at_commit or not associations:
                associations.add(actor)
    return associations

naive_witnesses = []
for schedule in schedules:
    naive = simulate(schedule, False)
    guarded = simulate(schedule, True)
    if len(naive) > 1:
        naive_witnesses.append(list(schedule))
    assert len(guarded) <= 1
assert naive_witnesses

drafts = Path(__file__).resolve().parent.parent
spec = drafts / 'GITVIEW-SPEC-0052.yaml'
record = {
    'artifact_kind': 'gitview_default_save_concurrency_counterexample',
    'spec': 'GITVIEW-SPEC-0052',
    'spec_sha256': hashlib.sha256(spec.read_bytes()).hexdigest(),
    'bounded_domain': 'two attempts for one already identified Repository; read before commit per attempt',
    'schedules_examined': len(schedules),
    'naive_duplicate_witness_count': len(naive_witnesses),
    'naive_example_schedule': naive_witnesses[0],
    'guarded_duplicate_count': 0,
    'guarded_model_assumption': 'uniqueness is checked atomically at commit',
    'limitations': 'A simplified author-built interleaving model, not a model of the batch record or cancellation and not a test or proof of any real database, lock, process termination, access policy or GitHub integration.',
    'application_scenarios_executed': False,
}
out = drafts / 'evidence/autonomous-goal-default-save-concurrency-20261114.json'
out.write_text(json.dumps(record, indent=2, ensure_ascii=False) + '\n')
print(json.dumps(record, ensure_ascii=False))
