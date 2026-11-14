import hashlib, itertools, json
from pathlib import Path

# Independent finite model of the proposed 0027 selection contract.
values = ('false', 'unknown', 'true')
def logical_or(items):
    if 'true' in items: return 'true'
    if 'unknown' in items: return 'unknown'
    return 'false'
def logical_and(items):
    if 'false' in items: return 'false'
    if 'unknown' in items: return 'unknown'
    return 'true'

counts = {v: 0 for v in values}
cases = 0
for opened, outcome, created, scope, active_filter in itertools.product(values, repeat=5):
    inclusion = logical_or((opened, outcome, created))
    result = logical_and((scope, inclusion, active_filter))
    cases += 1
    counts[result] += 1
    # These are consequences stated by 0027, not runtime or UI observations.
    if 'true' in (opened, outcome, created): assert inclusion == 'true'
    if scope == 'false' or active_filter == 'false' or inclusion == 'false': assert result == 'false'
    if scope == 'true' and active_filter == 'true' and inclusion == 'true': assert result == 'true'
    if active_filter == 'unknown' and scope == 'true' and inclusion == 'true': assert result == 'unknown'
    if inclusion == 'true' and active_filter == 'true' and scope == 'true': assert result != 'unknown'

spec = Path(__file__).resolve().parent.parent / 'GITVIEW-SPEC-0027.yaml'
record = {'artifact_kind':'gitview_three_valued_selection_model', 'spec':'GITVIEW-SPEC-0027',
          'spec_sha256':hashlib.sha256(spec.read_bytes()).hexdigest(), 'input_variables':5,
          'domain':list(values), 'combinations':cases, 'result_counts':counts,
          'model':'(open OR same_day_outcome OR same_day_creation) AND scope AND active_filter',
          'claims':'Finite model checks logical consequences only; it does not validate source mapping, actual coverage, UI, persistence, or application behavior.',
          'application_scenarios_executed':False}
out = spec.parent / 'evidence/autonomous-goal-today-logic-20261114.json'
out.write_text(json.dumps(record, indent=2, ensure_ascii=False)+'\n')
print(json.dumps(record, ensure_ascii=False))
