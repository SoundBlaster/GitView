"""Bounded model of selected 0025/0045 invariants; not product code or an app test."""
from itertools import product
from pathlib import Path
import hashlib
import json

repos = ('R1', 'R2')
projects = ('P', 'Q')
membership_options = (None, frozenset({'R1'}), frozenset({'R2'}), frozenset(repos))
association_options = (None,) + projects

def valid(members, default):
    return all(members[p] is None or members[p] for p in projects) and all(
        p is None or (members[p] is not None and r in members[p])
        for r, p in default.items()
    )

def clone(members, default):
    return dict(members), dict(default)

checked_states = 0
transitions = {'create_default': 0, 'reuse_default': 0, 'add_member': 0,
               'remove_member': 0, 'reject_last_member': 0, 'delete_project': 0}
for member_values in product(membership_options, repeat=2):
    members = dict(zip(projects, member_values))
    for association_values in product(association_options, repeat=2):
        default = dict(zip(repos, association_values))
        if not valid(members, default):
            continue
        checked_states += 1
        for r in repos:
            if default[r] is not None:
                # Confirming again reuses the existing association without mutation.
                before = (dict(members), dict(default))
                after = clone(members, default)
                assert after == before and r in after[0][after[1][r]]
                transitions['reuse_default'] += 1
            else:
                for p in projects:
                    if members[p] is None:
                        m, d = clone(members, default)
                        m[p] = frozenset({r}); d[r] = p
                        assert valid(m, d) and r in m[d[r]]
                        transitions['create_default'] += 1
        for p in projects:
            if members[p] is None:
                continue
            for r in repos:
                m, d = clone(members, default)
                if r not in m[p]:
                    m[p] = m[p] | {r}
                    assert valid(m, d) and d == default
                    transitions['add_member'] += 1
                elif len(m[p]) == 1:
                    # Save is rejected; last saved state is unchanged.
                    assert (m, d) == (members, default)
                    transitions['reject_last_member'] += 1
                else:
                    m[p] = m[p] - {r}
                    if d[r] == p:
                        d[r] = None
                    assert valid(m, d)
                    assert all(m[q] == members[q] for q in projects if q != p)
                    transitions['remove_member'] += 1
            m, d = clone(members, default)
            m[p] = None
            for r in repos:
                if d[r] == p:
                    d[r] = None
            assert valid(m, d)
            assert all(m[q] == members[q] for q in projects if q != p)
            transitions['delete_project'] += 1

drafts = Path(__file__).resolve().parent.parent
sha = lambda name: hashlib.sha256((drafts / name).read_bytes()).hexdigest()
record = {
    'artifact_kind': 'gitview_project_lifecycle_finite_model',
    'specifications': {'GITVIEW-SPEC-0025': sha('GITVIEW-SPEC-0025.yaml'),
                       'GITVIEW-SPEC-0045': sha('GITVIEW-SPEC-0045.yaml')},
    'bounded_domain': {'repositories': len(repos), 'project_slots': len(projects)},
    'valid_states_examined': checked_states, 'transitions_checked': transitions,
    'invariants': ['saved projects are nonempty', 'default association points to an existing member',
                   'edits preserve other project memberships', 'repeat confirmation reuses default'],
    'limitations': 'Author-built abstract model only; no concurrency, source access, persistence, UI or real GitHub behavior is executed.',
    'application_scenarios_executed': False,
}
out = drafts / 'evidence/autonomous-goal-project-lifecycle-model-20261114.json'
out.write_text(json.dumps(record, indent=2, ensure_ascii=False) + '\n')
print(json.dumps(record, ensure_ascii=False))
