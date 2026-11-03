# Domain candidate 0.2.0-draft.2: identity continuity

Статус: draft, не default selection и не принятие всего package. Ревизия
продолжает [draft.1](../domain-v0.2.0-draft.1/README.md), который сохранён
как воспроизводимый контроль. Основной контекст 0.1.0 не изменён.

## Изменение по решению пользователя

Выбран вариант A: если источник подтверждает тот же объект GitHub, rename
и transfer сохраняют один Repository, историю и членство в Projects.
Вопрос и ответ раздельно сохранены в sketch
`7fa3afce25204e24ae8b11fc1fec618f`, `excerpt-54-proposal` / `excerpt-54-reply`.
Точный scope, альтернативы, примеры и первичные GitHub sources:
[repository-identity.md](../../review/repository-identity.md).

Изменены только версия и этот аспект семантики:

- Уточнён `protocols.GitHubRepository`; источник может подтверждать тот же объект
  при меняющихся owner/name/адресе.
- Добавлена manual policy `RepositoryIdentityContinuity` для Repository/Project.
- В composition сохранены прежние импорт motivation-core и candidate issueMotiveLink.

По сравнению с draft.1 неизменны 10 классов, 45 optional scalar fields,
остальные contracts и 12 foundation links/relations (13 в composition).
Теперь 3 manual policies. Новые сущности или поля ID не создавались. User
остаётся предложенным contextual protocol, не автоматически Person/Account.
Наличие policy в source/IR не является исполнением её при rename/transfer.

## Что не решено вместе с A

Выбор REST numeric ID или GraphQL Node ID, host/provider scope, encoding,
ID aliases и локальное хранение остаются технической specification work.
Не выбраны automatic Project rename, объединение независимых GitHub-объектов
или backfill исторических observations текущим owner. Неполный доступ не
превращается в удаление объекта или нулевые показатели.

Source owner/name/URL не объявлены immutable identity. GraphQL ID рассматривается
как opaque reference с возможной миграцией представления; не вводится парсинг
его внутреннего формата. Проверка одинакового source object и обработка неизвестности
требуют отдельного observation/reference contract.

## Покрытие и проверки

[coverage.yaml](coverage.yaml) сохраняет все 59 выбранных checklist-пунктов
и отдельную ссылку на новое identity decision. Это не процент полноты:
23 пункта остаются unencoded/spec behavior, а scalar mappings — частичные.

Root draft обновлён только в этом ограниченном scope, `idea/pre_canonical`.
Новый SHA-256:
`728f2af8f135dbdc1fc9747282b4ad83fb606066e34c8e33318f9926999d45c0`.
Предыдущие digests `e3b75460…` и `56fd32cf…` сохраняются через Git и старые reports.
Их результаты не объявляются fresh для нового документа.

Оба source package прошли `ontologyc check` и `compile`, source/IR hashes
закреплены в [foundation](foundation-context.yaml) и
[composition](composition-context.yaml) selections. Runtime — b1583e58,
ontologyc 0.5.0 SHA-256
`dcdc37216246f9acebca7387e14b61300d9dec4367f7c1630445b97280c80168`,
compiler provenance `not_verified`.

На изолированных TB5 копиях нового root draft оба contexts дали `verified`,
target `checked`, domain `analyzed`, meta `not_requested`:

| Context | Findings |
| --- | --- |
| Foundation | GitView, motivcore:Motive |
| Composition | GitView |

User/GitHubRepository распознаются как protocols, Motive берётся из общего пакета
только в composition. [Разбор findings](../../review/remaining-findings.md)
отделяет отсутствие exported symbol GitView от намеренно не выбранного Motive
и ограниченности общей диагностической метки. Классы для удаления warnings
не добавлялись.

[verification.json](verification.json) содержит compiler/native команды,
точные inputs, producer, findings и hashes полных локальных отчётов.
Policy текст сохраняется в IR, но её выполнение, правильность пользовательских
данных и семантическое принятие этим не подтверждены.

Сборка новых SDK остаётся на TB5. Для следующего изменения использовать
редактируемый [source](domain-ontology-package.yaml), вывести composition из него,
повторить check/compile, перенести IR и согласованно обновить оба selection.
Не редактировать два варианта независимо. Canonical spec graph не материализован.

Следующий ограниченный шаг — typed observation/reference contract: как связывать
source identity, меняющийся адрес, время наблюдения и причины неизвестности.
