# GitView ontology draft.11 — уточнение identity

Отдельный candidate на основе draft.10. В `GitHubRepository` уточнено уже
согласованное правило: в пределах одного GitHub instance сравнивается
подтверждённый numeric REST repository ID. Encoding, cross-instance matching,
достаточность source evidence и установление management relation остаются
открыты. Identity Repository, роль GitHubRepository и правила membership не
изменены. Основание — [сверка 0001](../../review/root-composition-recheck-20261115.md).

На compiler SHA-256
`30dd324aa1f641e7274a49fd6f158cced5ed95d810b6b275353d3d10f19a27cb`
`ontologyc check` вернул пустой список diagnostics, `compile` прошёл.
Происхождение compiler независимо не подтверждено. Source и IR закреплены
хешами в [composition-context.yaml](composition-context.yaml).

SpecGraph сравнил обе композиции на восьми одинаковых спецификациях по scope
`domain_vocabulary`: [результат и SHA входов](verification.json). В 0001
сохранились один gap и одно warning о product label GitView; в остальных семи
finding и gap не было. Это не сравнение всех 123 спецификаций, semantic approval,
поведенческая проверка или доказательство применимости source identity.

`ontologyc diff` вернул `compatible: true` и пустой перечень изменений, хотя
реальный source diff содержит изменение версии и текста `semanticConstraints`.
Поэтому отчёт совместимости сам по себе не подтверждает смысловую эквивалентность;
наблюдение передано в локальный ledger. **Рабочий context пока остаётся draft.10**
до более широкой проверки и согласования контекста в зависимых артефактах.
