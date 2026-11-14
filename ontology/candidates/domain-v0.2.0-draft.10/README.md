# GitView ontology draft.10 — текущая иерархия Issue

Кандидат на основе draft.9. `issueParent` задаёт от дочерней Issue к её
текущему непосредственному parent кардинальность `0..1`; `issueSubIssue`
остаётся `0..*` в обратном смысловом направлении. Это не storage model
исторических наблюдений и не доказательство доступа, отсутствия, причинного
действия или автоматической синхронизации двух полей.

[Предметная сверка и источники](../../review/issue-hierarchy-current-state.md)
содержат границы применимости и неопределённости. Compiler с локального snapshot
SHA-256 `30dd324aa1f641e7274a49fd6f158cced5ed95d810b6b275353d3d10f19a27cb`
прошёл `check` без diagnostics и `compile`; происхождение compiler
независимо не проверено. Candidate не имеет semantic approval, приложение и
source mapping не исполнялись.

После [сравнения 84 одинаковых входов](verification.json) draft.10 выбран
рабочим контекстом: findings и gaps совпадают с draft.9, включая прежний
warning в 0001. Проверка словаря не исполняет правила cardinality.
После изменения путей к контексту повторно проверены четыре затронутые specs:
0001 сохранил прежний warning/gap, в остальных findings и gaps отсутствуют.
`ontology-doctor` подтвердил выбранную композицию; compiler provenance и
semantic approval остаются неподтверждёнными.
