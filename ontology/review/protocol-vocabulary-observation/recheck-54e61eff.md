# Независимый protocol consumer-control — 54e61eff

2026-11-03 проверен установленный snapshot SpecGraph PR #873, head
`54e61eff88716b4d5b173de44cb31e8944910c09`. GitView input commit:
`0f0fc8e3b943d0462b55423429a80e8e40fae8e3`.

Повторён **один** исходный синтетический контроль из observation, в отдельном
runtime и workspace на проверенном TB5. Использованы неизменённые candidate
source/IR, foundation selection и fixture `GITVIEW-SPEC-9001`. Fixture не является
продуктовой или canonical specification.

Результат: exit 0, context `verified`, target `checked`, domain `analyzed`,
meta `not_requested`. Findings/gaps синтетического контроля отсутствуют.

| Исходная ссылка | Kind результата | URI suffix |
| --- | --- | --- |
| gitview:Project | class | /classes/Project |
| gitview:User | protocol | /protocols/User |
| gitview:GitHubRepository | protocol | /protocols/GitHubRepository |

У каждого имени ровно один candidate origin с соответствующим kind. Оба
protocol names больше не классифицируются как unknown. Entity classes ради
этого результата не создавались. Поле native report `accepted_bindings`
означает структурный advisory result, не принятие онтологии пользователем.

Compiler: ontologyc 0.5.0, SHA-256
`dcdc37216246f9acebca7387e14b61300d9dec4367f7c1630445b97280c80168`.
Provenance остаётся `not_verified`. Source SHA-256
`0cdf42f607438739315a95b239a45ef3648a54389e91d39a14d9f13e167ed8cd`,
IR SHA-256 `ee19051689b9e7b1a5746407e4b51d8027481a30303733b2ee993bab5abceee4`
совпадают с исходным observation. Hash fixture также сохранён.

[Receipt](recheck-54e61eff.json) содержит точные argv, runtime receipt, input
pins, kinds/URI, producer, outcomes и путь/hash полного локального JSON.
Candidate installation находится в
`/Volumes/TB5/Developer/Builds/GitHub/GitView-a40d73ccf162f8d8/ontology/protocol-consumer-54e61eff-r7h5efvt/runtime/`.

Основной runtime GitView остаётся `dc35597b`. Product draft, выбранные domain
contexts, ontology candidate declarations, SpecDraft и canonical graph не менялись.
Composition, typo/malformed/collision controls и 197 upstream tests здесь не
повторялись. Merge/CI или upstream closure этим consumer-control не подтверждены.

Наблюдение подтверждает исправление конкретной диагностики на этом head;
правильность contextual contracts User/GitHubRepository и identity при
rename/transfer остаются отдельными предметными вопросами.

Следующий шаг — использовать receipt в review #873; основную установку менять
отдельно после решения о переходе на принятую версию.
