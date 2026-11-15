# Issue и PR: сверка спецификаций с ontology draft.12

Авторская выборочная сверка `local.gitview.domain@0.2.0-draft-composition.12`
со спецификациями 0034, 0039, 0041, 0057, 0062–0063 и 0077–0078. Источник
пакета: `composition/domain-ontology-package.yaml`, SHA-256
`cce3b65f5b2309f73957368aa3ba6cfeebd7276b2b2c13b2668a89ec525fb04b`.
Статус пакета — draft; это не независимое принятие его смысла и не проверка
всего графа. `motivcore@0.1.0` подключён как отдельный пакет композиции.

| Смысл в спецификации | Декларация в выбранном пакете | Граница утверждения |
| --- | --- | --- |
| PR и Issue относятся к source Repository | `pullRequestRepository`, `issueRepository`; `GitHubRepository` — контекстный protocol того же Repository. | Объявление не подтверждает конкретную identity, действующий доступ или актуальные base/head repositories PR. |
| Issue и PR могут быть связаны разными способами | `pullRequestIssueLink`, `issueClosingPullRequest`, `issueMentionedPullRequest`. | Source link не подтверждает merge, завершение Issue или мотив актора; разные связи требуют собственного evidence. |
| Прямые parent и child | `issueParent`, `issueSubIssue`. | Cardinality parent относится к текущему состоянию; обратный смысл применим лишь к совместимым свидетельствам, не гарантирует полную выборку или транзитивную связь. |
| Направленные зависимости Issue | `issueBlockedBy`, `issueBlocks`. | Это source links; наличие связи само не устанавливает open state blocker, Project membership его Repository или действие конкретного актора. |
| Мотив | Экспериментальный `issueMotiveLink` ссылается на `motivcore:Motive`; описания также могут содержать авторский текст Motivation. | Ни текст, ни source link, ни декларация `issueMotiveLink` сами не устанавливают конкретного актора, действие, причинность или достоверность атрибуции. Точное моделирование пользовательского примера остаётся открытым. |
| Review и CI | `ReviewThread`, `CIStatus`, `Metric` заданы раздельно; 0062 и 0057 используют их с разными контекстами. | Класс или ссылка не устанавливают оценку review, состояние проверки, полноту счётчика или merge eligibility. |

В корневом 0001 определения и правила их использования теперь расположены
раздельно: source identity и continuity Repository, регистрация через действие,
возможная связь Issue с мотивом и отсутствие автоматического результата PR
перенесены в `terminology_usage`. Это следование выбранному владельцем способу
различать признаки, свойства и отношения; formal package, его утверждение и
доказательство конкретных действий при этом не изменены.

`addsRepositoryTo`, `removesRepositoryFrom` и `managesRepository` в этом
пакете имеют формы subject/action/object. Ссылки Issue/PR выше заданы через
domain/range и сами не являются подтверждёнными экземплярами actor-action
отношения. `versionControlsCode` также остаётся кандидатом с открытым вопросом
о действии и результате. Ничто из этого не требует моделировать элементы UI,
`Activity`, storage records или source requests новыми domain entities.

15 ноября `ontology-doctor` установленного runtime с явно указанным compiler
проверил выбранную композицию и вернул `verified`; semantic approval остаётся
`not_established`, происхождение compiler — `not_verified`, его SHA-256
`30dd324aa1f641e7274a49fd6f158cced5ed95d810b6b275353d3d10f19a27cb`.
Это структурная проверка импортов и ссылок, а не доказательство реального
действия, мотива или корректности семантики. Отдельный прогон указанных восьми
candidate specs в составном context вернул `checked` без ошибок запуска; он
проверяет структурную применимость словаря, не исполняет сценарии и не заменяет
дальнейшее содержательное review.
