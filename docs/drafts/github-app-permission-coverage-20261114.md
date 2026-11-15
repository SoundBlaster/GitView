# GitHub App: обзор permission coverage для выбранных данных

Для диагностики REST GitHub описывает заголовок
[`X-Accepted-GitHub-Permissions`](https://docs.github.com/en/rest/using-the-rest-api/troubleshooting-the-rest-api#resource-not-accessible):
запятые задают сочетание прав, а точка с запятой разделяет альтернативные
наборы. 0100 сохраняет эту структуру для конкретной операции. Заголовок не
является перечнем фактически одобренных grants и не доказывает причину любого
403; для GraphQL он не заменяет проверку конкретных полей. Реальных ответов
GitView этот документ не содержит.

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
проверены. На момент этого среза client flow, размеры запросов и расписание
обновлений ещё не были выбраны.

## Рабочий профиль и сверка групп полей

[0098](GITVIEW-SPEC-0098.yaml) предлагает GitHub App user token с PKCE, а
[0100](GITVIEW-SPEC-0100.yaml) — начальный кандидатный профиль `Metadata`,
`Pull requests`, `Issues`, `Checks` и `Commit statuses`, все repository
permissions на чтение. Это обоснованная отправная точка, не подтверждённый
полный minimum: конкретные операции, GraphQL permissions, доступ к private
targets и реальные grants требуют проверки. `Contents` не предлагается только
из-за присутствия Code в онтологии: GitView не обещает доступ к файлам или
clone. GitHub документирует альтернативу `Contents: read` для
[Get a pull request](https://docs.github.com/en/rest/pulls/pulls#get-a-pull-request),
но существование альтернативы само по себе не делает её необходимой GitView.

| Согласованная группа | Документированный ориентир | Граница до подтверждения |
| --- | --- | --- |
| Repository discovery и identity | [Installations и доступные repositories](https://docs.github.com/en/rest/apps/installations); repository listing для user token указывает Metadata read. | Не доказывает весь GitHub аккаунт, source identity mapping или доступ к PR/Issue. |
| PR identity, текст, lifecycle, branches, author и счётчики | [Pull requests](https://docs.github.com/en/rest/pulls/pulls), [GraphQL PullRequest](https://docs.github.com/en/graphql/reference/pulls#pullrequest); документированы, например, additions и changed files. | Список и отдельная карточка могут иметь разные поля; counts, revision и полный PR A–G mapping ещё не доказаны. |
| PR review и reviewers | [Reviews](https://docs.github.com/en/rest/pulls/reviews#list-reviews-for-a-pull-request) и [requested reviewers](https://docs.github.com/en/rest/pulls/review-requests#get-all-requested-reviewers-for-a-pull-request) документируют Pull requests read. | Список reviews не равен aggregate decision; GraphQL reviewThreads, comment-age и access каждого поля требуют проверки. |
| PR checks и statuses | [Check runs](https://docs.github.com/en/rest/checks/runs#list-check-runs-for-a-git-reference) — Checks read; [commit statuses](https://docs.github.com/en/rest/commits/statuses#list-commit-statuses-for-a-reference) — Commit statuses read. | Один доступный тип не доказывает другой; нужны applicable revision, retry semantics, идентичность и полнота. |
| Issue identity, текст, состояние, роли и type | [Get an issue](https://docs.github.com/en/rest/issues/issues#get-an-issue) — Issues read для указанной fine-grained операции; [GraphQL Issue](https://docs.github.com/en/graphql/reference/issues#issue) описывает поля. | Права на отдельные GraphQL поля и source-представления type, reason и связей не следуют из одного REST разрешения. |
| Issue hierarchy и blockers | [Sub-issues](https://docs.github.com/en/rest/issues/sub-issues#list-sub-issues) и [dependencies](https://docs.github.com/en/rest/issues/issue-dependencies#list-dependencies-an-issue-is-blocked-by) документируют Issues read. | Доступ к связанному target, его состоянию, полнота связи и scope вне Project остаются независимы. |
| Issue ↔ PR связи | [Issue.closedByPullRequestsReferences](https://docs.github.com/en/graphql/reference/issues#issue) имеет `includeClosedPrs`, по умолчанию false; [PullRequest.closingIssuesReferences](https://docs.github.com/en/graphql/reference/pulls#pullrequest) описывает ссылки на потенциально закрываемые Issues. | Open-only результат не доказывает весь выбранный набор. Closing связь, mention и мотив различны; права конкретного GraphQL query и visibility targets не установлены. |
| Issue comments, authors, последнее время | [Issue comments](https://docs.github.com/en/rest/issues/comments#list-issue-comments) допускает Issues read или Pull requests read для указанной операции. | `Issue.participants` описывает Users, участвующих в обсуждении; это не автоматически число авторов выбранных comments, которое может включать иных actors. Содержимое comment не обязательно показывать или сохранять. |
| Исторические outcomes | [Issue timeline](https://docs.github.com/en/rest/issues/timeline), [ClosedEvent](https://docs.github.com/en/graphql/reference/issues#closedevent) и PR `mergedAt` — ориентиры для конкретных событий. | Не доказаны полнота периода и объектов, event identity и причина каждого closure; snapshot не превращается в source history. |

Уже установленная App может сохранить прежние права, пока новые permissions не
одобрены. Это документирует [GitHub](https://docs.github.com/en/apps/using-github-apps/approving-updated-permissions-for-a-github-app);
такой исход не подтверждает доступность новой категории и не требует подавлять
независимые ранее доступные данные. Пользовательский опыт, источник точного
статуса approval и раздельные сроки наблюдений задаются 0088 и 0100.

## Независимые факты при частичном доступе

| Наблюдение | Что может остаться полезным | Чего оно не доказывает |
| --- | --- | --- |
| Разрешённый [repository Issue list](https://docs.github.com/en/rest/issues/issues#list-repository-issues) вернул запись с PR marker; PR list недоступен | Те поля этой записи, которые действительно возвращены и разрешены, после нормализации как PR по 0101. | Полный PR list, PR-specific детали, review и CI; сама ошибка PR list не устанавливает её причину. |
| Разрешён [timeline одного Issue](https://docs.github.com/en/rest/issues/timeline#list-timeline-events-for-an-issue); GitHub документирует `Issues: read` **или** `Pull requests: read` для этой операции | Подтверждённое событие конкретного идентифицированного объекта с его собственным временем и scope. | Полный список Issues репозитория и полную историю событий; альтернативные permissions не становятся взаимозаменяемыми для прочих операций. |
| Разрешены [check runs](https://docs.github.com/en/rest/checks/runs#list-check-runs-for-a-git-reference), но commit statuses не наблюдались | Подтверждённые checks применимого revision с отдельным ограничением. | Полную объединённую CI-сводку или отсутствие failure в ненаблюдавшемся status family. |

Это conditional mapping по конкретным документированным operations для
GitHub App user token, а не утверждение, что любая комбинация grants даст
такие ответы в конкретном Repository. Public resources, частичные ответы и
доступ конкретного пользователя имеют собственные условия.
