# GitHub App: обзор permission coverage для выбранных данных

Документальный срез для выбора authorization, 14 ноября 2026. Таблица
показывает **примеры документированных операций для GitHub App user token**,
а не выбранные запросы, полный minimum permission set или доказательство
доступности всех полей. Область действительного доступа дополнительно зависит
от пользователя, приложения, установки, выбранных репозиториев и действующих
ограничений источника. Примеры относятся к документированным частным данным;
доступность публичных ресурсов рассматривается отдельно.

| Продуктовая категория | Документированный ориентир | Что пока не установлено |
| --- | --- | --- |
| Account и discovery в установке | [Доступные repositories установки](https://docs.github.com/en/rest/apps/installations) для user token: `Metadata: read`. | Полный список всего доступного человеку вне установок, поиск, coverage и идентификация пользователя для выбранного flow. |
| PR: основной обзор и lifecycle | [Список PR](https://docs.github.com/en/rest/pulls/pulls): `Pull requests: read`. | Все выбранные поля, fork/revision, непротиворечивость страниц и итоговая API strategy. |
| Issue: основной обзор и lifecycle | [Список Issues](https://docs.github.com/en/rest/issues/issues): `Issues: read`. | Полная семантика type, reason и всех выбранных полей; REST Issue-представление может включать PR. |
| Reviews и ожидающие reviewers | [Reviews](https://docs.github.com/en/rest/pulls/reviews) и [review requests](https://docs.github.com/en/rest/pulls/review-requests): примеры с `Pull requests: read`. | Эквивалентность списков выбранной aggregate assessment, revision и текущей политике review. |
| Review threads и unresolved counts | [GraphQL PullRequest](https://docs.github.com/en/graphql/reference/pulls) документирует threads и их состояние. | Permissions конкретного GraphQL query, частичный доступ, полнота и подсчёт unresolved; разрешение REST операции не доказывает их. |
| Check runs | [Список check runs для ref](https://docs.github.com/en/rest/checks/runs): `Checks: read`. | Какая revision соответствует PR, попытки, актуальность и полнота сводки для всех условий. |
| Commit statuses | [Combined status для ref](https://docs.github.com/en/rest/commits/statuses): `Commit statuses: read`. | Совместимость с check runs и выбранным подсчётом: одно поле combined state не является числом всех check entries. |
| Issue discussions | [Issue comments](https://docs.github.com/en/rest/issues/comments): для документированных операций указан один из вариантов `Issues: read` или `Pull requests: read`. | Совпадение source participant count с выбранными авторами комментариев, last-comment time, hidden/deleted data и полнота. |
| Parent/sub-issues и блокировки | [Sub-issues](https://docs.github.com/en/rest/issues/sub-issues) и [blocked-by](https://docs.github.com/en/rest/issues/issue-dependencies): соответствующие операции с `Issues: read`. | Access к каждому связанному объекту, граф, точные totals и видимость межрепозиторных связей. |
| Исторические состояния и outcomes | [Issue timeline](https://docs.github.com/en/rest/issues/timeline) документирует события для Issues и PR. | Полнота и retention конкретных events, причины закрытия, история CI/review, доступ, тождество и реконструкция past snapshots. |

GitHub отдельно рекомендует проверять конкретные GraphQL queries на нужные
permissions: [Choosing permissions for a GitHub App](https://docs.github.com/en/apps/creating-github-apps/registering-a-github-app/choosing-permissions-for-a-github-app).
Отсутствие одного grant не является доказательством общего отказа доступа к
Project; недостаточная полнота не равна нулю. [0088](GITVIEW-SPEC-0088.yaml)
фиксирует продуктовые последствия без предположений о деталях errors или UI.

Потенциальные repository permissions из примеров — Metadata, Pull requests,
Issues, Checks и Commit statuses на уровне read **для указанных операций**.
Их объединение не объявляется обязательным минимумом для всего продукта:
альтернативные запросы, доступ к публичным данным, field-level GraphQL
permissions, ранее выбранные метрики и организация конкретного grant ещё не
проверены. Не выбран client flow, размеры запросов или расписание обновлений.
