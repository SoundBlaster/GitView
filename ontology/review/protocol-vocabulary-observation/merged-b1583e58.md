# Влитый runtime: оба candidate contexts — b1583e58

2026-11-03 установлен SpecGraph
`b1583e580856012ad57748cc4d61dd29e7b1c8ec` после merge #873 (`9acca291`)
и #867. Наличие merge #873 в ancestry проверено локальным Git. Независимая
повторная проверка upstream CI в этот прогон не входила.

Runtime: `/Users/egor/.local/share/specgraph/runtime-b1583e58/`, Python 3.12.11.
Операционный путь закреплён в AGENTS.md; предыдущая установка сохранена.
Installer builds, временные workspace и caches использовали проверенный TB5.
Ontology skill обновлён до распределённой версии #867 с сохранением project-local
раздела GitView. Conversation skill совпадает с новой distribution без изменений.

## Зафиксированные входы

Входной GitView commit, source/IR/selection hashes, fixture и target digests
сохранены в [receipt](merged-b1583e58.json). Ontology source, normalized IR,
оба candidate selections и synthetic fixture из `0f0fc8e` не изменялись.
Root draft сохраняет SHA-256
`e3b75460f71a8946267132037d051f4a33b76030b2a3692528a3c9c2573cd09f`.

Использованы явно выбранные candidate contexts:

- `ontology/candidates/domain-v0.2.0-draft.1/foundation-context.yaml`:
  `local.gitview.domain@0.2.0-draft.1`.
- `ontology/candidates/domain-v0.2.0-draft.1/composition-context.yaml`:
  `local.gitview.domain@0.2.0-draft-composition.1`, motivation-core `0.1.0`,
  events-core `0.2.0`.

Тесты выполнялись на копиях в изолированных workspace. Source project's
`specs/nodes/` не пополнялся ни synthetic, ни canonical spec.

## Результаты четырёх CLI-вызовов

Все четыре завершились exit 0: context `verified`, target `checked`, domain
`analyzed`, meta `not_requested`.

| Context | Вход | Findings |
| --- | --- | --- |
| foundation | original synthetic GITVIEW-SPEC-9001 | нет |
| composition | original synthetic GITVIEW-SPEC-9001 | нет |
| foundation | real GITVIEW-SPEC-0001 | GitView, motivcore:Motive |
| composition | real GITVIEW-SPEC-0001 | GitView |

Во всех отчётах User и GitHubRepository разрешены как `kind: protocol`, с URI
`/protocols/User` и `/protocols/GitHubRepository`. У каждого ровно один origin;
package ID/version, source SHA-256, IR SHA-256 и compiler SHA-256 совпадают
с project member соответствующего selection. Project остаётся `class` с URI
`/classes/Project`. Protocols не были превращены в классы, а предупреждения
не подавлялись изменением входной онтологии.

Motive разрешается из общего пакета только в composition; в foundation это
ожидаемый невыбранный термин. GitView остаётся названием продукта без
обязательного отдельного ontology-класса. Эти оставшиеся advisory findings
не относятся к исправленному пропуску protocols.

Compiler: ontologyc 0.5.0, SHA-256
`dcdc37216246f9acebca7387e14b61300d9dec4367f7c1630445b97280c80168`.
Provenance остаётся `not_verified`. Producer evidence остаётся caller-attributed,
не trusted attestation. `accepted_bindings` — структурный advisory result,
не согласование предметной модели.

## Воспроизводимость и границы

Receipt содержит полные argv каждого вызова, input hashes, protocol/class
bindings и origins, findings, producer и путь/hash полных локальных JSON.
Для нового повтора подготовить отдельный workspace на проверенном TB5,
скопировать frozen inputs и поместить копию нужного документа в `specs/nodes/`.
Повторить argv с новым workspace path, сохранив candidate selection и pins.
Полные отчёты текущего прогона находятся в
`/Volumes/TB5/Developer/Builds/GitHub/GitView-a40d73ccf162f8d8/ontology/protocol-merged-b1583e58-q8xbti8d/`.

Новая установка также вернула `notes verify_history: complete` для 75 ревизий,
CURRENT `bc92164b9c924f738d5d37801a67363f`, `canonical: false`. Заметки не менялись.
Повтор всего upstream suite/negative controls, meta-check или overview export
здесь не заявляется.

Операционный runtime/skill обновлены; исходный product draft, ontology declarations,
candidate IR, оба candidate contexts и основной domain selection 0.1.0 не изменены.
Canonical graph остаётся пустым. Выбор contextual contracts и identity при
rename/transfer остаётся предметной работой; структурное распознавание не
подменяет её и не означает достаточной готовности онтологии.

Следующий шаг — вернуться к предметному вопросу identity/context репозитория,
а затем закрыть reference/time/availability gaps выбранного объёма.
