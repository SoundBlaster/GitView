# Today: кандидаты GraphQL-операций

Это reviewable примеры запросов к опубликованной GitHub GraphQL schema для рабочего направления [0102](GITVIEW-SPEC-0102.yaml). В 0102 эти четыре запроса выбраны рабочим направлением первоначального discovery; это не код приложения, не проверка permissions и не доказательство полноты Today. Состав ограничен базовыми identity, lifecycle и данными для компактного представления; остальные согласованные поля PR/Issue и история требуют отдельных решений.

Каждая операция относится к одному подтверждённому Repository Node ID и одному discovery purpose. `$pageSize` и `$cursor` передаются вызывающей стороной: здесь не выбираются конкретный размер страницы, частота или budget. Repository Node ID должен быть связан с локальной identity с доказательством 0080; одинаковые названия или числовой REST ID сами по себе не являются этим Node ID. `node` может быть недоступен, а type condition может не совпасть; такой результат не является пустым Repository.

## Open Issues

```graphql
query GitViewOpenIssues($repository: ID!, $pageSize: Int!, $cursor: String) {
  node(id: $repository) {
    __typename
    ... on Repository {
      id
      issues(first: $pageSize, after: $cursor, states: [OPEN]) {
        pageInfo { hasNextPage endCursor }
        nodes { id number title url state createdAt updatedAt }
      }
    }
  }
}
```

OPEN без ограничения по `since` позволяет искать и старую открытую работу. Он не покрывает объекты, которые уже закрыты сегодня, и сам по себе не доказывает полноту даже открытой популяции.

## Recent Issues

```graphql
query GitViewRecentIssues($repository: ID!, $pageSize: Int!, $cursor: String, $since: DateTime!) {
  node(id: $repository) {
    __typename
    ... on Repository {
      id
      issues(first: $pageSize, after: $cursor, states: [OPEN, CLOSED], filterBy: {since: $since}) {
        pageInfo { hasNextPage endCursor }
        nodes { id number title url state createdAt updatedAt }
      }
    }
  }
}
```

`$since` представляет захваченное начало выбранного интервала Today в UTC; локальный календарный день устройства — одна из предложенных интерпретаций, не принятое правило. `IssueFilters.since` относится к **обновлению**, а не непосредственно к закрытию. Появление кандидата не доказывает event в этом интервале, отсутствие в выдаче не доказывает отсутствие подходящего event. При смене интервала контекст и применимость курсора пересматриваются; пригодность source cutoff для выбранной интерпретации требует собственного основания.

## Open PRs

```graphql
query GitViewOpenPullRequests($repository: ID!, $pageSize: Int!, $cursor: String) {
  node(id: $repository) {
    __typename
    ... on Repository {
      id
      pullRequests(first: $pageSize, after: $cursor, states: [OPEN]) {
        pageInfo { hasNextPage endCursor }
        nodes { id number title url state isDraft createdAt updatedAt mergedAt }
      }
    }
  }
}
```

`isDraft` и lifecycle — самостоятельные наблюдения, не merge verdict. Запрос одного OPEN portion не покрывает сегодняшние завершённые PR.

## Recent PR candidates

```graphql
query GitViewRecentPullRequests($repository: ID!, $pageSize: Int!, $cursor: String) {
  node(id: $repository) {
    __typename
    ... on Repository {
      id
      pullRequests(first: $pageSize, after: $cursor, states: [OPEN, CLOSED, MERGED], orderBy: {field: UPDATED_AT, direction: DESC}) {
        pageInfo { hasNextPage endCursor }
        nodes { id number title url state isDraft createdAt updatedAt mergedAt }
      }
    }
  }
}
```

Для `Repository.pullRequests.orderBy` опубликованная schema описывает `IssueOrder`. Scan отсортированного списка может быть ограничен доступным временем и источником; порядок по `updatedAt` не устанавливает gap-free выборку событий и не заменяет время merge. Поле `mergedAt`, если применимо и успешно получено, может подтвердить конкретный merge; `closedAt` и текущий state сами по себе не устанавливают полную историю повторных закрытий.

## Границы всех операций

- Атрибуция узла к Repository следует фактически возвращённому typed Repository parent с проверенной identity и контекстом запроса; fork head или URL не заменяют этот witness.
- `nodes` и отдельные элементы могут быть `null`. Field errors, aliases, null propagation и полезные соседние facts интерпретируются по фактическому response и schema; пропущенное значение не становится empty или false. `pageInfo` — состояние обхода, а не сертификат полного snapshot.
- Результаты open и recent сохраняют отдельные scope, attempt и coverage; одна подтверждённая identity отображается единожды при допустимом сопоставлении. Retention, access и source outcome имеют отдельные результаты.
- Для отдельного close event необходимо отдельно получить либо иметь пригодное subject-associated event evidence. Примеры выше не задают timeline query и не утверждают полноту close/reopen history, включая события в том же дне.
- Доступ зависит от user-token, установки, Repository и конкретного запроса. REST permissions не считаются доказанными GraphQL permissions. Эти примеры не обращаются к GitHub и не удостоверяют source visibility, значения полей или поведение iOS.

Источники: [GitHub Repository schema](https://docs.github.com/en/graphql/reference/repos#repository), [Issues](https://docs.github.com/en/graphql/reference/issues#issuefilters), [Pull requests](https://docs.github.com/en/graphql/reference/pulls#pullrequest), [GitHub public schema](https://docs.github.com/en/graphql/overview/public-schema) и [GraphQL execution errors](https://spec.graphql.org/September2025/#sec-Handling-Execution-Errors). Все поля и условия — ограниченное рабочее предложение агента, подлежащее проверке выбранной версии схемы и последующему source review.
