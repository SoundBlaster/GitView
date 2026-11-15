# GitView ontology draft.12 — Repository, связанный с PR

Отдельный кандидат на основе draft.11; действующая project selection остаётся
на draft.11. Версия package изменена на `0.2.0-draft-composition.12`, а описание
`pullRequestRepository` уточнено согласно [review](../../review/pr-repository-context-20261115.md).
Связь описывает source-associated Repository PR с сохранением контекстного
ограничения GitHubRepository; base/head ref остаются отдельными source facts.
`domain`, `range` и cardinality не изменены. Новых сущностей и действий нет.

На закреплённом compiler `30dd324a…` прошли `ontologyc check` и `compile` с
imports, а SpecGraph `ontology-context` вернул `verified`, ноль diagnostics и
`semantic_approval: not_established`. Происхождение этого compiler остаётся
неподтверждённым; [отдельное сравнение сборки](../../review/compiler-rebuild-comparison-20261115.md)
не доказывает его происхождение.

В изолированных копиях на одинаковых YAML проверены 0008, 0041, 0074, 0101 и
0115 с draft.11 и draft.12. Все результаты `checked`, верхнеуровневые и
`domain_vocabulary` diagnostics совпадают и пусты. Полные исходы находятся на
TB5 в `GitView-a40d73ccf162f8d8/gitview-draft11-pr-advisory-_irjvdla` и
`GitView-a40d73ccf162f8d8/gitview-draft12-final-advisory-13y1rux9`.
Проверка структуры словаря не устанавливает смысловую эквивалентность,
source behavior, проверку всех кандидатов или semantic approval.

Перед выбором draft.12 рабочим context требуется оценить изменение смысла и
проверить весь текущий граф на одном наборе SHA, включая известные warnings.
В существующих specs и project config никаких ссылок не переключено.

## Полная структурная сверка 15 ноября

После указанной выборки выполнено [сравнение 124 кандидатов](full-verification.json)
на одинаковых байтах с draft.11 и draft.12. Сравнивались outcome, diagnostics,
summary, gaps и findings в scope `domain_vocabulary`; различий не обнаружено.
В обоих контекстах 0001 содержит один gap и warning о `GitView` как product
label, как и ранее; у остальных в summary gaps/findings нет. Исходные отчёты
сохранены на TB5 по пути из JSON. `passed_check_count` не является количеством
исполненных проверок поведения приложения.

Эта проверка не оценивает новую формулировку семантически. Выбор draft.12 и
обновление project config и ссылок не выполнены; хеши отчёта относятся к
состоянию до возможного переключения.
