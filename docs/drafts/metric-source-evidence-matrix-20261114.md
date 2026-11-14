# Входы и evidence исторических метрик GitView

Срез публичной документации GitHub от 14 ноября 2026 года и авторская сверка
кандидатов [0057](GITVIEW-SPEC-0057.yaml), [0065](GITVIEW-SPEC-0065.yaml),
[0066](GITVIEW-SPEC-0066.yaml) и [0097](GITVIEW-SPEC-0097.yaml). Это не
выбранные queries, подтверждённые permissions, source coverage или результат
работы с аккаунтом пользователя. Значение на графике также требует контекста
scope, identity, access, времени, predicate version и соответствующего
сохранённого или доказуемо восстановленного evidence.

| Серия | Минимальные предметные входы | Ориентир в документации и остающаяся граница |
| --- | --- | --- |
| Open PR / open Issue | Отдельные source-identified популяции, состояние каждого объекта и покрытие каждого Repository. | [PR](https://docs.github.com/en/graphql/reference/pulls) и [Issue](https://docs.github.com/en/graphql/reference/issues) описывают текущее состояние. Текущее поле не восстанавливает прошлый snapshot. |
| Draft PR | Open PR и применимый draft flag; draft — подмножество, а не дополнительные PR. | [PullRequest.isDraft](https://docs.github.com/en/graphql/reference/pulls#pullrequest) описан как признак draft. Он не устанавливает прежнее значение или покрытие всей популяции. |
| Failed CI: PR | Open PR, применимая head revision, идентифицированные статусы и категория каждого наблюдённого check. Единица графика — PR. | [PullRequest](https://docs.github.com/en/graphql/reference/pulls#pullrequest) документирует head и status rollup; [StatusCheckRollup](https://docs.github.com/en/graphql/reference/commits#statuscheckrollup) описывает check runs и status contexts. Нужны сопоставление revision, семантика retry и полнота соответствующего контекста. |
| Waiting for review | Open PR и доказанный действующий запрос к человеку или команде; единица — PR. | [PullRequest.reviewRequests](https://docs.github.com/en/graphql/reference/pulls#pullrequest) — отдельный список. Его отсутствие не доказывает approval или review decision; нужны coverage и интерпретация доступа. |
| Changes requested | Open PR и применимая текущая aggregate review assessment; единица — PR. | [PullRequest.reviewDecision](https://docs.github.com/en/graphql/reference/pulls#pullrequest) и `CHANGES_REQUESTED` описаны отдельно от индивидуальных reviews и threads. Не установлены полная применимость к policy GitView и история после dismissals. |
| Unresolved threads / PR с ними | Идентичность PR и threads, их применимое состояние разрешённости; единицы — отдельно threads и PR. | [PullRequestReviewThread](https://docs.github.com/en/graphql/reference/pulls#pullrequestreviewthread) документирует identity и `isResolved`. Полная выборка и доступ к каждому thread не следуют из наличия поля. |
| Long-thread proxy | Open PR, unresolved thread и хотя бы один подтверждённый submitted comment с `createdAt` не менее чем за 24 часа до reference time; отдельно threads и PR. | В перечне [PullRequestReviewThread](https://docs.github.com/en/graphql/reference/pulls#pullrequestreviewthread) нет `createdAt`, но [PullRequestReviewComment](https://docs.github.com/en/graphql/reference/pulls#pullrequestreviewcomment) документирует время комментария. 0094 использует его как время комментария, не время создания thread; semantics и 24 часа — авторский выбор, coverage и permissions ещё не проверены. |
| Blocked Issues | Open affected Issue, направленная прямая blocked-by связь и open state хотя бы одного допустимого blocker; единица — affected Issue. | [Issue.blockedBy](https://docs.github.com/en/graphql/reference/issues#issue) документирован отдельно от `blocking`. Доступ к внешнему Repository, состояние blocker и полнота связей нужно устанавливать отдельно. |
| Merged PR за период | Source identity PR и доказанное merge time внутри интервала; дедупликация по PR. | [PullRequest.mergedAt](https://docs.github.com/en/graphql/reference/pulls#pullrequest) может поддержать время конкретного merge, не доказывая полноту PR в периоде. |
| Closed Issues по причинам | Closure event, identity Issue и события, время, применимая причина и покрытие периода; distinct Issue и события — разные единицы. | [ClosedEvent](https://docs.github.com/en/graphql/reference/issues#closedevent) содержит время и nullable `stateReason`. Текущий reason Issue не заменяет отсутствующую причину конкретного события. |
| Число Repository в Project | Подтверждённый локальный состав и контекст его наблюдения; фактическая история состава отличается от ретроспективы по нынешним members. | Данные GitView Project являются локальной конфигурацией; состояние GitHub organization не доказывает её прошлое значение. 0097 предлагает локальные samples, а не предполагает готовый ledger. |
| Coverage наблюдений | Числитель, знаменатель, категория, допустимый scope и время фактического observation. | Доступность Repository или сам факт получения страницы не доказывает полноту CI, review или истории. Частичное покрытие нельзя автоматически представить как ноль. |

Для state series достаточно подходящего сохранённого наблюдения в его реальном
контексте либо отдельно доказанной реконструкции; ни один из приведённых source
полей сам по себе не доказывает историю. Для outcome series единичное событие
доказывает его собственное occurrence, но не полноту bucket или Project.
Сохранение aggregate не доказывает identities участников и не гарантирует
возможность построить тот же результат для другого состава Project. Доступ и
ограничения источника остаются отдельной проверкой от локального сохранения.

Ранний общий обзор — [github-history-evidence-20261114.md](github-history-evidence-20261114.md),
проверка потенциальных permissions — [github-app-permission-coverage-20261114.md](github-app-permission-coverage-20261114.md).
