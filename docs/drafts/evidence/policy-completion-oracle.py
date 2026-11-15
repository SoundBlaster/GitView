"""Check two candidate policies against an independent Boolean-completion oracle.

This models independent prepared facts only; it is not GitView product code.
The output goes to stdout so the caller selects the evidence location.
"""

import collections
import hashlib
import itertools
import json
from pathlib import Path

VALUES = (False, None, True)  # None means domain unknown, not a missing rule.


def tri_and(values):
    return False if False in values else None if None in values else True


def tri_or(values):
    return True if True in values else None if None in values else False


def completions(values):
    return itertools.product(*(VALUES[::2] if value is None else (value,) for value in values))


def oracle(values, predicate):
    answers = {predicate(*case) for case in completions(values)}
    return answers.pop() if len(answers) == 1 else None


def today(scope, type_gate, opened, created, event, active_filter):
    return tri_and((scope, type_gate, tri_or((opened, created, event)), active_filter))


def today_boolean(scope, type_gate, opened, created, event, active_filter):
    return scope and type_gate and (opened or created or event) and active_filter


def project_validity(conditions):
    if False in conditions:
        return 'invalid'
    return 'insufficient' if None in conditions else 'valid'


def project_oracle(conditions):
    value = oracle(conditions, lambda *case: all(case))
    return {False: 'invalid', None: 'insufficient', True: 'valid'}[value]


def name(value):
    return {False: 'false', None: 'unknown', True: 'true'}[value]


today_counts = collections.Counter()
for facts in itertools.product(VALUES, repeat=6):
    actual = today(*facts)
    expected = oracle(facts, today_boolean)
    if actual != expected:
        raise AssertionError(('today', facts, actual, expected))
    today_counts[name(actual)] += 1

validity_counts = collections.Counter()
for conditions in itertools.product(VALUES, repeat=4):
    actual = project_validity(conditions)
    expected = project_oracle(conditions)
    if actual != expected:
        raise AssertionError(('project', conditions, actual, expected))
    validity_counts[actual] += 1

assert today(False, None, None, False, False, None) is False
assert today(True, True, True, False, None, True) is True
assert project_validity((False, None, True, True)) == 'invalid'
assert project_validity((True, None, True, True)) == 'insufficient'

root = Path(__file__).resolve().parent.parent
hashes = {name: hashlib.sha256((root / name).read_bytes()).hexdigest()
          for name in ('GITVIEW-SPEC-0110.yaml', 'GITVIEW-SPEC-0111.yaml')}
print(json.dumps({
    'kind': 'abstract-policy-completion-oracle',
    'spec_sha256': hashes,
    'today': {'facts': 6, 'combinations': sum(today_counts.values()), 'outcomes': dict(today_counts)},
    'project': {'generic_required_conditions': 4, 'combinations': sum(validity_counts.values()), 'outcomes': dict(validity_counts)},
    'mismatches': 0,
    'limitations': 'Independent Boolean completions of prepared facts only; no source semantics, correlated facts, evidence, nil, effects, privacy, persistence, integration or product behavior are exercised.',
    'product_tests_executed': False,
}, indent=2))
