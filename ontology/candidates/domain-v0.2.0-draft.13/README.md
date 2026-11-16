# GitView ontology draft.13 — значение Project

**16 ноября:** владелец принял текущее содержимое локального пакета для GitView; [решение и границы](../../review/owner-acceptance-20261116.md). Дальнейший текст сохраняет историю до решения. Метаданные исходного артефакта остаются `draft`.

Рабочий candidate на основе draft.12. Меняет версию пакета на
`0.2.0-draft-composition.13` и описание Project на предлагаемый смысл:
«единица организации работы для её обзора в GitView». Identity, свойства и
членство в Repository остаются отдельными. Формулировка и её примеры описаны в
[предметной сверке](../../review/project-repository-spec-alignment-20261115.md).
Это предложение агента, не semantic approval и не новый выбор владельца.

## Сверка продуктовой границы

На снимке `c13f883` повторно прочитаны декларации локального пакета и
верхние продуктовые ссылки 0002–0017 и 0019. В локальном пакете нет классов
для grid, preview или жестов: эти слова используются в спецификациях как
поведение представления. `Activity` в 0001 сохранена как гипотеза, не как
самостоятельная сущность. Project, Repository, PR, Issue и Metric имеют
проектные определения; связь участия Repository в Project и действие оператора
по добавлению описаны раздельно. GitHubRepository остаётся контекстным
protocol для того же Repository под управлением GitHub. Полнота или точность
смысла каждого поля и всех потребителей этим выборочным чтением не доказана.

Повторный `ontology-doctor` без указанного compiler вернул `unavailable`,
поскольку executable отсутствовал в PATH. Вызов с сохранённым compiler на TB5
и SHA-256 `3e7b70f3789e683de177d7f5d78e507fda993c4aa2990baabe31530db0e63720`
вернул exit 0 и `verified`; provenance compiler — `not_verified`,
semantic approval — `not_established`. Это проверка выбранной композиции,
не подтверждение всех смысловых bindings или поведения продукта.

Сравнение распарсенных YAML подтвердило, что помимо версии и описания Project
остальные данные source package равны draft.12. Compiler, собранный из checkout
Ontology `4c5027b7fe075e80d141e77f576eaa58ca0d3679`, SHA-256 бинарника
`3e7b70f3789e683de177d7f5d78e507fda993c4aa2990baabe31530db0e63720`,
успешно выполнил `ontologyc check` и `compile` с motivation-core и events-core.
SpecGraph `ontology-doctor` с явным selection и тем же pinned compiler вернул
`outcome: verified`, `semantic_approval: not_established`,
`compiler_provenance: not_verified` и пустой `next_steps`. Отчёт и полный
вывод compiler — на TB5 в `GitView-a40d73ccf162f8d8/gitview-draft13-gokn5qw1/`.

Проверка формы не устанавливает правильность предлагаемого значения или
совместимость всех spec bindings. Новые ID, действия, поля, связи и
кардинальности не добавлены.

## Сравнение candidate specs

На копии workspace на TB5 проверены все 127 одинаковых YAML candidates с
draft.12 и draft.13 через Supervisor, scope `domain_vocabulary`, с одинаковым
compiler, указанным выше. Ошибок запуска нет. Сырые отчёты всех 127 пар
различаются ожидаемыми версией и provenance пакета. После явной нормализации
только версии, URI версии, source/IR hashes и context revision совпали
сравниваемые outcome, diagnostics, summary, binding index и validation report;
неожиданных различий нет. Полный список замен и поузловых результатов находится
в `GitView-a40d73ccf162f8d8/gitview-draft12-13-7elehatc/normalized-summary.json`,
исходные отчёты — рядом в `comparisons/`.

В 0001 остаётся один gap и одно warning для `GitView` как имени продукта.
Совпадение структурной диагностики не устанавливает semantic approval,
полноту specification metamodel или правильность и применимость каждого узла.
Рабочий context самим сравнением не переключался.

## Выбор рабочего контекста

После предметной сверки и сравнения выбран draft.13 для дальнейшей черновой
работы. `specgraph.project.yaml` и 25 явных текущих ссылок specs обновлены;
исторические snapshots не переписаны. После обновления `ontology-doctor` с
явным compiler вернул `verified` и `semantic_approval: not_established`;
`next-move --candidate-file` для всех 127 YAML вернул `checked` на уровне
mapping, kind и совпадения имени с ID. Это не повторное полное vocabulary
comparison после изменения текстов ссылок, не canonical acceptance и не
оценка поведения GitView.

После переключения в отдельной копии повторно выполнен Supervisor advisory
`domain_vocabulary` для всех 25 specs, чьи явные ссылки были изменены.
Ошибок запуска нет; outcome, diagnostics и сводки совпали с проверкой тех
же узлов до замены ссылок. У 0001 сохранились один gap и одно warning о
`GitView` как имени продукта. Отчёты и SHA-256 входов лежат на TB5 в
`GitView-a40d73ccf162f8d8/gitview-draft12-13-7elehatc/post-rebind/`.
Сравнение не заменяет semantic approval или проверку поведения приложения.
