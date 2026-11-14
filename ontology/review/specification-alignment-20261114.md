# Сверка онтологии с графом GitView

Статус: авторский аудит рабочего context `local.gitview.domain@0.2.0-draft-composition.10`,
не принятие онтологии или спецификаций. Источник проекта имеет `approvalStatus:
draft`, source SHA-256 `73dfccf3c7b360ee6dd9e943f8603bde6bff63d3fcf85c478aacf7759a40905c`.
В композицию также входят `org.0al.motivation.core@0.1.0` и
`org.0al.events.core@0.2.0`, оба draft. Рабочая selection находится в
[composition-context.yaml](../candidates/domain-v0.2.0-draft.10/composition-context.yaml).
Структурная проверка не означает semantic approval; происхождение используемого
компилятора отдельно не подтверждено.

`ontology-doctor` с явно указанным compiler и его SHA подтвердил выбранный
структурный context без предлагаемых шагов настройки. Затем все 96 candidate
specs проверены через `domain_vocabulary` в изолированной TB5-копии:
[отчёт с SHA каждого входа](all-candidate-domain-vocabulary-20261114.json).
Все вызовы завершились `checked`; в 0001 остались один advisory finding и один
соответствующий gap для `GitView` как product label в `specification.terminology`.
Остальные проверенные входы не дали findings/gaps. `passed_check_count` во всех
отчётах равен нулю: это не выполненные поведенческие или semantic checks.

Это снимок по указанным в отчёте SHA, а не проверка каждого последующего
изменения. Позднее 0024, 0037, 0043 и 0073 проверены по новым SHA в
[отдельном отчёте](../../docs/drafts/evidence/autonomous-goal-ontology-check-identity-navigation-20261114.json).
Ещё 20 кандидатов после уточнения исторического и текущего context проверены
по новым SHA в [этом отчёте](../../docs/drafts/evidence/autonomous-goal-ontology-check-current-context-references-20261114.json).
После этого 0043 и 0066 проверены ещё раз вместе с 0071 в
[отчёте о replay](../../docs/drafts/evidence/autonomous-goal-ontology-check-retention-replay-20261114.json).
После дополнения каталога исторических метрик 0043, 0057, 0064, 0066, 0068, 0069 и
новый 0097 проверены по более свежим SHA в
[отчёте каталога](../../docs/drafts/evidence/autonomous-goal-ontology-check-expanded-metric-history-20261114.json).
Затем 0094 и 0097 проверены повторно после сверки source evidence в
[этом отчёте](../../docs/drafts/evidence/autonomous-goal-ontology-check-metric-source-matrix-20261114.json).
После выбора рабочего comment-age proxy более новые SHA 0043, 0057, 0094 и
0097 проверены в [следующем отчёте](../../docs/drafts/evidence/autonomous-goal-ontology-check-long-thread-comment-proxy-20261114.json).

Явные `ontology_refs` найдены во всех 96 файлах и содержат 17 различных
qualified names. Среди них 23 файла ссылаются на `gitview:Metric`, девять — на
`gitview:CIStatus`, один — на `motivcore:Motive`. Это count явных ссылок, не
общее число косвенных потребителей. Семантические примеры ниже — выборочная
ручная сверка, а не полный semantic audit каждого из 96 документов.

## Смысл и использование

| Область | Термины и граница | Основные спецификации |
| --- | --- | --- |
| Оператор и Project | `User` — оператор GitView; автор Issue/PR и reviewer не становятся им автоматически. `Project` имеет локальную identity, название и необязательное описание; membership — отдельная связь. | 0005, 0025, 0082–0084, 0091 |
| Repository и GitHub | `Repository` и `Code` сохраняют обсуждавшиеся значения; `GitHubRepository` — контекстный contract того же Repository, а не второй объект. Rename/transfer не меняет identity при подтверждении источника. | 0002, 0038, 0080–0081 |
| Membership и действия | `AddRepository`/`RemoveRepository` — кандидатные actions, `projectIncludesRepository` — описание состава. Наличие membership или разница snapshots не доказывают конкретного актора, действия или мотива. | 0025, 0082–0084 |
| Issue и PR | Отдельные source objects с выбранными свойствами. Mention, closing link, parent/child и блокировки сохраняют свой смысл и направление; их существование не доказывает мотив или результат действия. | 0034, 0039, 0041, 0078 |
| Мотив | Импортированный `motivcore:Motive` — отдельный общий термин; экспериментальный `issueMotiveLink` не устанавливает мотив конкретного актора или причинность. Авторский текст Motivation также не является доказательством мотива. | 0001, 0034, 0051, 0090 |
| Review и CI | `ReviewThread` — тред review; его счётчик не заменяет review assessment. `CIStatus` в draft.10 — наблюдаемый статус одной status-check entry, а не сводка, mergeability или доказательство запуска CI. | 0028, 0060–0062, 0094 |
| Metric | `Metric` — кандидатное значение измерения в определённом контексте. Известный ноль, unknown, partial, число проверок и число PR различаются; график или определение показателя не равны конкретному значению. | 0055, 0057, 0064–0069 |

Новые в обсуждении графа `Today`, `coverage`, `cohort`, `refresh`, `preview`,
`selection policy`, `route` и `storage` используются как выборки, условия,
контекст, взаимодействие или реализационные границы. Их присутствие в
спецификации само по себе не обосновывает новую ontology entity. `Activity`
остаётся невыбранной гипотезой; имя продукта `GitView` не объявлено классом
ради устранения advisory warning.

## Что остаётся открытым

- `versionControlsCode` и source links в package имеют domain/range-смысл;
  они не становятся action-derived отношениями конкретного актора только из-за
  синтаксического раздела `relations`. Действие, состояние и evidence требуют
  отдельного обоснования там, где это важно для продукта. В [разборе VCS](version-control-action-boundary-20261114.md)
  различены запись версии и начало управления; для обоих нужны дополнительные
  основания, поэтому ни одно действие не внесено в package как установленное.
- Выбранные свойства времени, labels и роли участников описаны в specs, но не
  все представлены полями или типизированными связями package. Это не означает,
  что каждое поле интерфейса необходимо переносить в онтологию; требуется
  предметное решение о полезности и типах, а не подстановка строк ради компиляции.
- Семантическое принятие `Metric`, `CIStatus`, Issue/PR и экспериментального
  `issueMotiveLink`, а также actor/action происхождение связей не доказаны
  работой компилятора. Source availability и concrete GitHub mapping отдельно
  не проверены в этом аудите.

Этот обзор не меняет package, не утверждает canonical nodes и не моделирует
исполнение приложения. Счётчик ссылок `ontology_refs` — инвентаризация явно
записанных терминов, а не полное обнаружение неявных понятий или доказательство
правильности значений.
