#!/usr/bin/env python3
"""Inventory declared candidate structure, not semantic implementation readiness."""
import argparse
import hashlib
import json
from collections import Counter
from pathlib import Path

import yaml

parser = argparse.ArgumentParser(description=__doc__)
parser.add_argument('output', type=Path, help='new JSON report path; an existing file is never overwritten')
args = parser.parse_args()

root = Path(__file__).resolve().parents[3]
drafts = root / 'docs/drafts'
files = sorted(drafts.glob('GITVIEW-SPEC-*.yaml'))
specs = {}
hashes = {}
for path in files:
    data = yaml.safe_load(path.read_text())
    key = data['id']
    if key in specs or path.stem != key:
        raise ValueError(f'duplicate or mismatched ID: {path}')
    specs[key] = data
    hashes[key] = hashlib.sha256(path.read_bytes()).hexdigest()

def edges(node, kinds):
    for kind in kinds:
        for target in specs[node].get(kind, []):
            if target not in specs:
                raise ValueError(f'missing {kind} target: {node} -> {target}')
            yield target

def validate_acyclic(kinds):
    state = {}
    def visit(node):
        if state.get(node) == 1:
            raise ValueError(f'cycle through {node}: {kinds}')
        if state.get(node) == 2:
            return
        state[node] = 1
        for target in edges(node, kinds):
            visit(target)
        state[node] = 2
    for node in specs:
        visit(node)

def closure(node, kinds):
    pending = list(edges(node, kinds))
    reached = set()
    while pending:
        target = pending.pop()
        if target not in reached:
            reached.add(target)
            pending.extend(edges(target, kinds))
    return reached

for relation_set in [('refines',), ('depends_on',), ('refines', 'depends_on')]:
    validate_acyclic(relation_set)

root_id = 'GITVIEW-SPEC-0001'
unrooted = sorted(k for k in specs if k != root_id and root_id not in closure(k, ('refines',)))
parents = {p for d in specs.values() for p in d.get('refines', [])}
leaves = sorted(set(specs) - parents)
items = []
for key in leaves:
    d = specs[key]
    reached = closure(key, ('refines', 'depends_on'))
    items.append({
        'id': key,
        'title': d['title'],
        'status': d.get('status'),
        'draft_status': d.get('draft_status'),
        'sha256': hashes[key],
        'direct_refines': d.get('refines', []),
        'direct_depends_on': d.get('depends_on', []),
        'reachable_declared_nodes': len(reached),
        'reachable_precanonical_nodes': sum(specs[x].get('draft_status') == 'pre_canonical' for x in reached),
        'scenario_counts_by_field': {
            field: len(d.get('specification', {}).get(field, []))
            for field in ('scenarios', 'review_scenarios', 'pilot_scenarios')
        },
        'declared_unresolved': d.get('specification', {}).get('unresolved', []),
    })

report = {
    'scope': 'Static declared graph and literal author-supplied fields only; not semantic assessment, implementation readiness, test coverage or acceptance.',
    'candidate_count': len(specs),
    'structural_leaf_count': len(leaves),
    'status_counts': dict(sorted(Counter(f"{v.get('status')} / {v.get('draft_status')}" for v in specs.values()).items())),
    'unrooted_by_refines': unrooted,
    'acyclic_relations': ['refines', 'depends_on', 'refines + depends_on'],
    'candidate_sha256': hashes,
    'leaves': items,
}
output = args.output
with output.open('x') as f:
    json.dump(report, f, indent=2, ensure_ascii=False)
    f.write('\n')
print(f'{len(specs)} candidates; {len(leaves)} structural leaves; {len(unrooted)} unrooted; wrote {output}')
