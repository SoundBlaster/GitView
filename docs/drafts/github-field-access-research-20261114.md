# GitHub: обзор доступности выбранных данных

Документальный срез на 14 ноября 2026 года для сравнения кандидатов GitView
с GitHub. Таблица показывает примеры документированных read operations и
их условия для указанных **fine-grained token types**. Она не является
исчерпывающей матрицей разрешений приложения, утверждённым API mapping или
доказательством доступности всех полей. Реальные scopes OAuth App и
permissions GitHub App не взаимозаменяемы.

| Потребность | Что документировано | Оставшаяся граница |
| --- | --- | --- |
| PR | [Список PR](https://docs.github.com/en/rest/pulls/pulls) поддерживает GitHub App user/installation tokens и fine-grained PAT; для операции указано repository permission `Pull requests: read`. | Объём полей каждого представления, полнота выбранных счётчиков и все необходимые операции ещё не сопоставлены. |
| Issue | [Список repository issues](https://docs.github.com/en/rest/issues/issues) указывает `Issues: read` для поддерживаемых fine-grained tokens. Документация отдельно предупреждает, что результат может содержать PR, а `id` такого элемента относится к Issue, не к PR. | Нужна типизированная нормализация источника; совпадение или различие числовых IDs разных представлений само по себе не доказывает identity. |
| Review | Для [списка reviews](https://docs.github.com/en/rest/pulls/reviews) и [requested reviewers](https://docs.github.com/en/rest/pulls/review-requests) указано `Pull requests: read` для соответствующих fine-grained tokens. | Список отдельных reviews не является автоматически вычисленной текущей оценкой review; семантику aggregate и временной контекст нужно проверить отдельно. |
| Review threads | В [GraphQL-модели PullRequest](https://docs.github.com/en/graphql/reference/pulls) документированы `reviewThreads` и состояние thread `isResolved`. | Permissions и ошибки для конкретного GraphQL query, полнота connection и привязка к revision этим наблюдением не установлены. |
| CI | [Check runs для ref](https://docs.github.com/en/rest/checks/runs) имеют отдельное permission `Checks: read`; [commit statuses](https://docs.github.com/en/rest/commits/statuses) — `Commit statuses: read`. | Это разные source-семейства. Какие именно элементы включены в GitHub-подобную текущую сводку GitView, как обращаться с повторами и fork/merge refs и как доказать полноту, ещё не выбрано. |
| Blockers | [Список зависимостей blocked-by](https://docs.github.com/en/rest/issues/issue-dependencies) документирован с `Issues: read` для указанных fine-grained tokens. | Возможность перечислить связи не доказывает доступ к состоянию каждого blocker или полную видимость cross-repository отношений. |

Даже при нужном repository permission доступ GitHub App user token ограничен
совместно правами человека, полномочиями App и установками: см. [предыдущий
срез](github-ios-access-research-20261114.md). Набор прав зависит от выбранных
способов получения всех полей и категорий, поэтому приведённые примеры не
следует объявлять полным минимальным permission set.

Следующий предметный шаг — определить, что GitView считает элементом
пользовательской CI-сводки при источниках check runs и commit statuses;
только затем можно проверять mapping и требования доступа. Численные размеры
запросов и частота обновления остаются вне этого среза.

## Дополнение: единица и revision

GitHub описывает [два типа status checks](https://docs.github.com/en/pull-requests/reference/status-checks):
checks и commit statuses. Его [GraphQL StatusCheckRollup](https://docs.github.com/en/graphql/reference/commits)
имеет connection для check runs и status contexts. Это основание для candidate
[0060](GITVIEW-SPEC-0060.yaml), но не доказательство идентичности конкретному
PR status box или выбора API.

GitHub отдельно указывает, что check и commit status с одинаковым именем
могут оба иметь значение для required-check policy; имя недостаточно для
их объединения. Для PR требуется также различать head и test merge commit:
какой commit используется, зависит от контекста. [GitHub: troubleshooting required checks](https://docs.github.com/en/pull-requests/how-tos/merge-and-close-pull-requests/troubleshooting-required-status-checks).
Эта документация не устанавливает, как GitView должен отнести каждый
special conclusion к цвету или считать повторные попытки.
