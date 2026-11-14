"""Illustrative mutable-list counterexample, not an implementation or GitHub test."""
from pathlib import Path
import hashlib
import json

initial = ['A', 'B', 'C', 'D']
page_size = 2  # Minimal example only, not a product or source API limit.
first_page = initial[:page_size]
after_removal = ['B', 'C', 'D']
second_page = after_removal[page_size:page_size * 2]
terminal_page = after_removal[page_size * 2:page_size * 3]
returned = first_page + second_page
assert terminal_page == []
assert 'C' in after_removal and 'C' not in returned

drafts = Path(__file__).resolve().parent.parent
sha = lambda name: hashlib.sha256((drafts / name).read_bytes()).hexdigest()
record = {
    'artifact_kind': 'gitview_mutable_pagination_counterexample',
    'specifications': {'GITVIEW-SPEC-0026': sha('GITVIEW-SPEC-0026.yaml'),
                       'GITVIEW-SPEC-0044': sha('GITVIEW-SPEC-0044.yaml')},
    'initial_order': initial,
    'first_page': first_page,
    'order_after_removal': after_removal,
    'second_page': second_page,
    'terminal_page': terminal_page,
    'missed_current_item': 'C',
    'assumptions': 'A toy offset-paginated mutable list with no stable snapshot and one deletion between pages.',
    'limitations': 'One illustrative construction, not an exhaustive model or claim about any GitHub endpoint, pagination strategy, source guarantee, real application or process.',
    'application_scenarios_executed': False,
}
out = drafts / 'evidence/autonomous-goal-pagination-coverage-20261114.json'
out.write_text(json.dumps(record, indent=2, ensure_ascii=False) + '\n')
print(json.dumps(record, ensure_ascii=False))
