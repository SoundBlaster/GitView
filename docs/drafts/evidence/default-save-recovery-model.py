"""Finite decision table for the proposed 0052 recovery contract; no app code is run."""
from itertools import product
from pathlib import Path
import hashlib
import json

def decision(readable, project, association, membership_confirmed, pending):
    if not readable:
        return 'unknown_hold'
    if project != association or (not project and membership_confirmed):
        return 'inconsistent_hold'
    if project and association:
        return 'reuse_saved' if membership_confirmed else 'membership_unverified_hold'
    if pending:
        return 'pending_hold'
    return 'explicit_retry_may_create'

counts = {}
for readable, project, association, membership_confirmed, pending in product((False, True), repeat=5):
    result = decision(readable, project, association, membership_confirmed, pending)
    counts[result] = counts.get(result, 0) + 1
    if not readable:
        assert result == 'unknown_hold'
    if readable and (project != association or (not project and membership_confirmed)):
        assert result == 'inconsistent_hold'
    if readable and project and association and membership_confirmed:
        assert result == 'reuse_saved'
    if readable and project and association and not membership_confirmed:
        assert result == 'membership_unverified_hold'
    if readable and not project and not association and not membership_confirmed and pending:
        assert result == 'pending_hold'
    if result == 'explicit_retry_may_create':
        assert readable and not project and not association and not membership_confirmed and not pending

drafts = Path(__file__).resolve().parent.parent
spec = drafts / 'GITVIEW-SPEC-0052.yaml'
record = {
    'artifact_kind': 'gitview_default_save_recovery_finite_model',
    'spec': 'GITVIEW-SPEC-0052',
    'spec_sha256': hashlib.sha256(spec.read_bytes()).hexdigest(),
    'input_axes': ['configuration_readable', 'project_visible', 'matching_association_visible', 'membership_confirmed', 'operation_pending'],
    'combinations': 32,
    'decisions': counts,
    'limitations': 'Author-built decision table only; it assumes reliable inputs and does not model the batch operation record, cancellation, atomic writes, process termination, concurrent late commits, source access or persistence behavior.',
    'application_scenarios_executed': False,
}
out = drafts / 'evidence/autonomous-goal-default-save-model-20261114.json'
out.write_text(json.dumps(record, indent=2, ensure_ascii=False) + '\n')
print(json.dumps(record, ensure_ascii=False))
