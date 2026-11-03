# Происхождение GitView и motivcore:Motive в advisory findings

Проверка источников: 2026-11-03. Основание — сохранённые native отчёты
`protocol-vocabulary-observation/merged-b1583e58.json`, root draft и pinned
source/IR/selections. Диагностика не подавляется изменением словаря ради нуля.

| Term | Где взят в root draft | Foundation candidate | Composition candidate | Предметная классификация |
| --- | --- | --- | --- | --- |
| GitView | `/specification/terminology/GitView` | unknown_legacy_term, нет candidates | тот же finding | Есть текстовое определение продукта; нет экспортированной class/relation/protocol declaration. Это не обязательство создать entity class. |
| motivcore:Motive | `/specification/ontology_refs/0` | unknown_legacy_term, нет candidates | class из org.0al.motivation.core@0.1.0 | Пакет намеренно не выбран в foundation; существующее общее определение есть в composition, локальный дубликат не нужен. |

## GitView: имя продукта, не обязательная сущность

В `ontology/views/gitview-proposed.hc` GitView — корень авторской композиции
(`excerpt-30`). Root draft прямо отличает название продукта от автоматически
объявленного DomainEntity. В project source/IR нет класса, protocol или relation
GitView; такого символа нет и в замыкании composition. Поэтому scope lookup
возвращает unknown для этой glossary entry.

Значение слова в беседе не отсутствует. Для этого scope не установлена
необходимость отдельного ontology concept GitView. Не создан класс или alias
на Project ради предупреждения. Возможность отдельно аннотировать в draft
product-context labels — вопрос authoring/report contract, не новый класс
и не реализованное подавление сигнала.

## Motive: определение есть, выбор контекста различается

Общий источник:
`ontology/pilots/motivation-composition/dependencies/motivation-core/domain-ontology-package.yaml`.
Package `org.0al.motivation.core`, namespace `motivcore`, version `0.1.0`,
`approvalStatus: draft`. Класс Motive описывает содержание побуждающей причины,
отдельно от её отнесения к конкретному актору/действию.

Source SHA-256:
`3061eca33ddc2296c2c292695d98daf6697e92fb582da544bc1d5107721ae955`.
IR SHA-256:
`25da040f4bd0b014014b1ed996250cd4c17a64503355f6f558917bec9ddd1fe9`.
Разрешённый URI:
`ontology://org.0al.motivation.core/0.1.0/classes/Motive`.

Основной контекст 0.1.0 и foundation candidate выбирают только project package
с foundation; motivation-core туда не включён. Старый composition pilot и
composition candidate выбирают project + motivation-core + events-core;
direct/import closure проверяется отдельно. Увеличение числа участников
не устанавливает мотив конкретного Issue или причинность Issue → PR.

## Что означает ограничение диагностики

Текущий scoped vocabulary ищет только символы явно выбранного контекста.
Одна классификация `unknown_legacy_term` не объясняет, является ли слово:
необъявленным product label, настоящей опечаткой или термином известного,
но не подключённого пакета. Это ограничение объяснения результата; foundation
не обязан неявно подключать все доступные пакеты. Здесь не воспроизведён новый
дефект разрешения Motive: composition разрешает правильный class и origin.

Из этих findings не следует ни необходимость новых entities, ни canonical
approval, ни готовность/неготовность всей онтологии. Protocol omission из прежнего
runtime — отдельный исправленный defect, не причина этих двух оставшихся случаев.

Точные findings, source pointers, observed/exported symbol inventories, версии
и hashes сведены в adjacent `remaining-findings.json`. Новый root draft сохраняет
оба термина и их provenance; warning count не используется как цель моделирования.
