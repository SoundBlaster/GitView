# GitView: оценка ветвей PR и Issue

Авторская сверка девяти указанных candidates с выбранным составом
[PR](pull-request-ontology-options.md) и [Issue](issue-ontology-options.md) на
14 ноября. Это не независимый semantic review и не проверка всего
транзитивного графа; все девять узлов остаются `idea / pre_canonical`.
Версии зафиксированы ниже и требуют пересмотра при изменении.

| Узел | Определено | Что нужно уточнить до реализации границы | Что проверять отдельно после реализации |
| --- | --- | --- | --- |
| [0039](GITVIEW-SPEC-0039.yaml): Issue overview | Выбранные A–G доступны в пределах обзора, когда факты разрешены и наблюдены; связи и счётчики не обязаны помещаться одновременно. | Проверить mapping и полноту каждого поля и связанного объекта; определить доступное представление отсутствующих и частичных данных. | Реальные source responses, устройства и accessibility. |
| [0041](GITVIEW-SPEC-0041.yaml): PR overview | Выбранные A–G доступны внутри обзора; review, CI и измерения изменений раздельны; diff и списки отдельных checks/commits не требуются. | Завершить source field/revision mapping, правила доступности refs и mixed-time представление. | Source adapter, выбранные поля, native UI и доступность. |
| [0060](GITVIEW-SPEC-0060.yaml): CI entries | Единица — актуальный применимый check run или status context, не workflow run и не вся история попыток; head и test-merge revision различаются. | Выбрать источник и проверить correspondence, актуальную попытку и применимую PR revision; не заявлять GitHub equivalence без evidence. | Реальные fork, retry и revision cases и фактические permissions. |
| [0061](GITVIEW-SPEC-0061.yaml): CI counters | Кандидатные success/failure/pending плюс отдельные special/unclassified результаты; сумма трёх категорий может быть меньше total. Timeout не называется failed test. | Сопоставить конкретные поддерживаемые source enum и определить обнаруживаемое нецветовое представление special и unknown. | Реальные GitHub data, pagination и iOS accessibility. |
| [0062](GITVIEW-SPEC-0062.yaml): review | Review request, aggregate assessment и unresolved threads — независимые факты; outdated thread не обязательно resolved. | Зафиксировать применимость, источник и интерфейс для разных времён и overlapping signals; не заменять assessment счётчиком threads. | GraphQL permissions, dismissals, source changes и native display. |
| [0063](GITVIEW-SPEC-0063.yaml): blocked Issue | Считается distinct открытая affected Issue с подтверждённой direct blocked-by связью и открытым blocker; внешний blocker не добавляет Repository в Project. | Установить фактическую доступность target, relation и его состояния; обеспечить безопасный результат при частичных данных. | Межрепозиторный доступ, source timing и accessible navigation. |
| [0077](GITVIEW-SPEC-0077.yaml): обсуждение | Comment count, participant count и latest-comment time имеют разные единицы и coverage. | Проверить предложенное агентом определение participants как distinct авторов допустимых comments; source Users connection не автоматически эквивалентен этому определению. | Удалённые/скрытые comments, идентичность actors и source ordering. |
| [0078](GITVIEW-SPEC-0078.yaml): связи | Mention, closing link, parent/child и dependency различаются по типу и направлению; direct children не включают внуков. | Довести source mapping, visibility target и семантику aggregates; source link сам не доказывает мотив актора. | Реальные permissions, изменения связей и доступный путь к разрешённым данным. |
| [0094](GITVIEW-SPEC-0094.yaml): long-thread proxy | Предложен unresolved thread с подтверждённым comment возрастом не менее 24 часов; это не возраст thread, не время без ответа и не непрерывное unresolved состояние. | Оценить полезность и маркировку **агентского** proxy и порога; не выдавать их за явно выбранное пользователем определение. | Тimestamps, permissions, полнота комментариев и native accessibility. |

## Границы выбранного состава

- PR review D1 и D3 выбраны; просмотр отдельных ReviewThread и их содержимого
  не входит в текущий состав. CI E — счётчики, F — счётчики изменений.
- Issue A–G выбраны; комментарии и участники E, direct sub-Issues F — счётчики,
  а не обязательный браузер полного содержимого дискуссий.
- Успех одного поля, например title, не делает review, CI или связанные
  объекты актуальными. Restricted данные и раскрывающие counts остаются под
  текущей access policy; неизвестное не становится нулём или зелёным статусом.
- Эти контракты используют предметный словарь без автоматического добавления
  UI-полей в Ontology. Source link не устанавливает actor/action или motive.

До готовности к реализации нужно закончить общие source, identity, access и
storage boundaries, затем связать выбранные API fields с каждым полем и
выполнить независимый semantic review. Сценарии в YAML и чтение документации
не являются тестированием работающего продукта.

```text
0039  d8227ed39da8974fac44c19162847b9d713c2cae72a00be8b06c692c9adcf05a
0041  db0f035405489dd44229192c263881a215a47e31c7d7bb1a2d9fb7a40c0aedd6
0060  877ff8611ac0e18b94f8c370e15e34beaf191a2069e43baaadf06e4e7dab0d9a
0061  8089a881307bb867a595bff47d9c6c4801411858b23847a15a92d52cc0819cbf
0062  9c72bd1f8f356be8d3c17e62bb78fb0e758430bf030825436b08825fdb596737
0063  127bd80004a8a798d32b8ad3f6f8bcd9709839b94cad846796f66c4314a0a2a9
0077  1c5725975db513395e8e4c50a997201b79db4ff22e7ab1b15a24b4dd3a9c65cc
0078  e4deb7c8230aee275d5ddf688404c9bf6f3ee30f57588010b30046c9a67777e0
0094  64873cf0e0a63a14e098b75bc0c3b5a28f9f24e3301cc7e79413f1955ff2450d
```
