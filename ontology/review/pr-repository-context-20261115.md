# PullRequest и Repository: уточнение смысла связи

Авторский review рабочего `local.gitview.domain@0.2.0-draft-composition.11`.
Это предложение изменения описания, не изменение выбранного package и не
утверждение онтологии. Источники: поле `pullRequestRepository` в
[package](../candidates/domain-v0.2.0-draft.11/composition/domain-ontology-package.yaml),
[0101](../../docs/drafts/GITVIEW-SPEC-0101.yaml) и
[GitHub GraphQL PullRequest](https://docs.github.com/en/graphql/reference/pulls#pullrequest).

## Неоднозначность

В draft.11 связь `pullRequestRepository` описана как `target/source-host
repository context`. Слово *target* можно прочитать как Repository целевой
base branch, хотя тот же текст использует и более общий контекст самого PR.
GitHub документирует у PullRequest отдельно `repository`, `baseRepository` и
`headRepository`: первые описывают связанный с PR node и Repository base ref,
а последний — Repository head ref. Схема сама по себе не доказывает, что эти
поля обязательно различаются, всегда равны или доступны одновременно.

В спецификации 0101 выбранная source-association для отнесения PR к Project
задаётся через подтверждённый `PullRequest.repository`; base/head сохраняются
отдельно. Для fork PR head может принадлежать другому Repository. Сходство
названий и наличие одной связи не доказывают идентичность других источников.

## Предложение для следующей версии package

Уточнить описание существующей связи, не меняя её имя, domain, range или
cardinality:

> Source-associated Repository of the PullRequest in its GitHub context; this
> is the identity used for Project attribution when supported by source
> evidence. The base-ref and head-ref Repositories are separate source
> relationships and are not inferred from this link alone.

Это описание — кандидат для review, а не утверждение, что Project membership
входит в определение Repository, что связью установлено действие актора или что
GitHub всегда возвращает все три поля. Не добавлять отдельные ontology entities
для base/head только ради UI; при необходимости формализации новых связей
потребуется отдельное предметное обоснование и source evidence.

Проверить потребителей 0008, 0041, 0074, 0101 и 0115 при следующем обновлении
package и его versioned selection. До этого сохранять ограниченное чтение 0101
и не выдавать target/base за автоматически доказанную identity. Semantic review,
совместимость package и реальный source adapter этой записью не подтверждены.
