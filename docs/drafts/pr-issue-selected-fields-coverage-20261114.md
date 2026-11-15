# Сверка выбранных полей PR и Issue

Для счётчиков PR 0041 теперь фиксирует документированные кандидаты GraphQL
`additions`, `deletions`, `changedFiles` и `commits.totalCount`, отдельно от
`headRefOid` и `baseRefOid`. Base может измениться при прежнем head, поэтому
один head не подтверждает применимость прежнего head-versus-base commit count.
Это mapping отдельных полей по [GitHub PullRequest](https://docs.github.com/en/graphql/reference/pulls#pullrequest),
а не доказательство атомарного snapshot, доступности query или реального UI.

Выбор владельца сохранён в [PR options](pull-request-ontology-options.md) и
[Issue options](issue-ontology-options.md), объединён в 0001. Это авторская
сверка групп полей с candidate specs на 14 ноября, не source mapping и не
подтверждение implementation readiness. Понятия Issue и PullRequest в
рабочей композиции `local.gitview.domain@0.2.0-draft-composition.12` имеют
draft-статус; их [исторический разбор и кандидатные значения](../../ontology/review/issue-pr-meaning-candidate.md)
не утверждают автоматических причинных связей или действий акторов.

| Выбранный состав | Основные specs | Граница проверки и открытый вопрос |
| --- | --- | --- |
| PR A1–A4, Issue A1–A4: identity, title, text, URL | 0002, 0033–0034, 0038–0039, 0041, 0051 | Контекст source и исходный текст заданы; API identity, eligibility URL и source field semantics требуют подтверждения. |
| PR B1–B3, Issue B1–B4: lifecycle, draft, labels, Issue type/reason | 0039, 0041, 0044, 0053 | State, draft и reason различаются; отсутствие поля и null-like error не всегда означают пустое значение. Источники и доступность конкретных характеристик не доказаны. |
| PR C1–C5: target Repository, branches/revision, author, reviewers, linked Issues | 0041, 0062 | Роли и ссылки не устанавливают motive. Нужны source mapping и поведение удалённой или недоступной branch; source identity отдельных участников требует проверки. |
| PR D1/D3 и E: review assessment, thread и текущие check counters | 0028, 0060–0062 | Сигналы и единицы разделены; mapping revision, retries, special outcomes и GitHub equivalence ещё не подтверждены. Содержимое тредов и прогонов не входит в выбранный scope. |
| PR F1–F3, G1–G3: change counters и времена | 0041, 0044, 0053 | Счётчики и времена различаются; связь со scope и revision, применимость source values и stale fields требуют evidence. Diff и отдельные коммиты не входят в scope. |
| Issue C1–C3: Repository, creator, assignees | 0039, 0038 | Source roles не определяют GitView User или актора изменения. Состав участников и доступ к источнику нуждаются в проверке. |
| Issue D1–D4: PR links, parent/children, blockers и milestone | 0039, 0056, 0063 | Направления и типы ссылок не заменяют мотив; explicit blocker и его состояние независимы. Доступность, полнота и идентичность связанных объектов остаются открытыми. |
| Issue E1–E2, G4: комментарии, участники и время последнего комментария | 0039, 0077 | Для E2 предложен отдельно подписанный GitHub participating-Users count; авторы комментариев — иная популяция. Участие иных акторов, точные permissions и поведение источника остаются открытыми. |
| Issue F1–F2 и G1–G3: direct sub-issue counters и времена | 0039, 0044 | Direct дети отличны от потомков, закрыто не означает выполнено; source coverage, event semantics и полные counts не доказаны. |

Связь с онтологией в таблице — использование словаря и ссылок в candidate
specs. Она не утверждает, что у каждого поля уже есть формальное объявление,
что обнаружена actor/action relationship или что его source binding корректен.
Общий вопрос `Motive` и других терминов остаётся в
[ontology impact matrix](../../ontology/review/specification-impact-matrix.md).
Новые UI-состояния и участники обсуждения не добавлялись как ontology entities.

## Доступность выбранных полей в GitView

Сверка пользовательского пути после preview выявила, что часть контекста была
только «сохранена» в 0041 или семантически описана в 0039. Это не гарантировало
её просмотр. Уточнённые контракты 0041 и 0039 теперь требуют доступного пути к
каждой разрешённой и наблюдённой выбранной группе в обзоре того же объекта;
вся группа не обязана помещаться одновременно или в preview.

| Группа | Путь и граница |
| --- | --- |
| PR A–C | 0041: identity, оригинал, state, ветки, revision, author, reviewers и связанные Issues доступны при наличии данных; 0033 отдельно определяет source action. Source-associated Repository и base/head Repository сохраняют отдельные основания; недоступный target или branch не подменяется. |
| PR D, E, F, G | 0041, 0061 и 0062: отдельные review и CI факты, счётчики изменений и даты доступны со своей областью и временем. Diff, список checks, коммиты и содержание тредов не требуются. |
| Issue A–D | 0039 и 0078: identity, описание, state, роли, milestone и допустимые наблюдённые endpoints связей доступны с типом и покрытием. Частичный список не объявляется полным, чужой Repository не становится участником Project. |
| Issue E–G | 0039 и 0077: счётчики комментариев, участников и прямых sub-issues и выбранные даты доступны с их ограничениями. Содержимое комментариев и список участников обсуждения не требуются. |

Это сверка текстовых требований, а не проверка источника или нативного экрана.
Открыты source mapping, право доступа, порядок и формат представления, работа с
разными размерами текста и фактическая доступность всех выбранных полей.

Следующий проход должен проверить, какие ссылки и выборки Issue требуют
отдельного поведения для частичного доступа, а затем сопоставить оставшиеся
leaf contracts с транзитивными зависимостями. Конкретные API-запросы и их
стоимость не выбираются этим обзором.
