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

SpecGraph сравнил обе композиции на всех 123 одинаковых кандидатах по scope
`domain_vocabulary`: [результат и SHA входов](full-verification.json). Summaries
и содержимое gaps/findings совпадают; в 0001 сохраняются один gap и одно warning
о product label GitView, в остальных gap и finding не выявлены. [Первый
ограниченный прогон](verification.json) сохраняется отдельно. Это не semantic
approval, поведенческая проверка или доказательство source identity. После
переключения 24 ссылок их [изменённые байты проверены отдельно](rebinding-verification.json);
полный сравнительный отчёт относится к SHA до смены ссылок.

После выбора draft.11 project config некоторое время ошибочно сохранял
default selection draft.10. Теперь `specgraph.project.yaml` также указывает на
draft.11; `ontology-doctor` без явного `--selection` проверил именно этот путь
с указанным выше compiler SHA. Это исправление конфигурации, не новое
сравнение всех спецификаций и не semantic approval. Ранее записанные отчёты
сохраняют собственные явно указанные selection и SHA.

`ontologyc diff` вернул `compatible: true` и пустой перечень изменений, хотя
реальный source diff содержит изменение версии и текста `semanticConstraints`.
Поэтому отчёт совместимости сам по себе не подтверждает смысловую эквивалентность;
наблюдение передано в локальный ledger. Draft.11 выбран рабочим context для
дальнейших candidate specs. Исторические отчёты и старые экспорты сохраняют
фактические версии; выбор не является утверждением ontology package.

Позднее для этой композиции выполнена [сверка с compiler, независимо собранным
из чистого checkout Ontology](../../review/compiler-rebuild-comparison-20261115.md).
Результаты `check` и 10 файлов `compile` совпали для выбранных входов; это не
подтверждает происхождение прежнего бинарника или semantic approval.
