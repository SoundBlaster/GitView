# Диагностика связки спецификаций с онтологией, 16 ноября 2026

## Результат

Нулевой счётчик в прошлой выборке вызван не переключением draft.13 → approved 0.2.0. Выбранная композиция 0.2.0 структурно проверена; для одинаковой неизменённой корневой спецификации обе версии дают одинаковый нулевой inventory. Это не доказывает правильность всех терминов в свободном тексте.

Установленный SpecGraph `3a7f176a`, профиль `specgraph-explicit-terms-v1`, извлекает ключи `specification.terminology`, список `ontology_refs` на корневом уровне или в `specification`. В 75 из 75 текущих `specs/nodes/*.yaml` эти поля отсутствуют или пусты (проверка YAML 16 ноября). Спецификации упоминают понятия в prose и через общий `sources.ontology_context`, но данный профиль не извлекает из них bindings автоматически. В частности, старый `docs/drafts/GITVIEW-SPEC-0001.yaml` содержит `specification.terminology`, а его действующий successor в `specs/nodes/` этого поля не содержит. Это различие формата входов, не подтверждение потери самих предметных требований.

## Контрольный эксперимент

В копии проекта на TB5 проверен один и тот же `GITVIEW-SPEC-0001` SHA-256 `9a6610922e7ec49a6ba21f53e3467ce6ac1e1122936bbff84df31ea13809a5b4`, через `supervisor --build-project-ontology-context-check --ontology-context-map-spec-artifact --ontology-context-check-scope domain_vocabulary`. Отличался только выбранный ontology context:

| Вход | draft.13 | approved 0.2.0 |
| --- | --- | --- |
| Реальная спецификация | inventory 0; bindings 0; gaps 0 | inventory 0; bindings 0; gaps 0 |
| Копия с тремя явными refs | inventory 3; bindings 2; gaps 1 | inventory 3; bindings 2; gaps 1 |

В контрольной копии добавлены `gitview:Project`, `gitview:Repository` и намеренно несуществующий `gitview:NoSuchConcept`: первые два разрешены структурно, третий диагностирован как `missing_ontology_ref`. Значения не были внесены в рабочую спецификацию. Оба прогона показывают `checked` как результат анализа; это не означает семантическое согласование или реализацию. В `0.2.0` Project и Repository разрешены к URI версии 0.2.0; прежний context даёт URI draft.13.

Сырые отчёты, временная копия и проверенные inputs: `/Volumes/TB5/Developer/Builds/GitHub/GitView-a40d73ccf162f8d8/ontology-020-bindings-d1itfq4l/compare-{real,explicit_control}-{draft13,approved}.json`. Для продолжения нужен осмысленный обзор явных ссылок каждой ветви и независимое review изменений спецификаций, а не автоматическое добавление одинакового словаря во все узлы. Структурное совпадение имён не доказывает правильность применения терминов или фактические действия акторов.
