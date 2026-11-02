# Независимый потребительский прогон opt-in meta-check

Дата: 2026-11-02. Проверен конкретный candidate head SpecGraph #871:
`b8657bc8a90b9904105edfdc3f667afee9be6d4f`, включая его базу #870.
Это локальный consumer probe установленного snapshot, не свидетельство merge,
CI, принятия спецификации или полноты её содержания.

## Входы и изоляция

- GitView до прогона: `7648e08c8b252ae3ec3f5f18237c708c04630e0e`, чистый.
- Актуальный draft SHA-256:
  `e3b75460f71a8946267132037d051f4a33b76030b2a3692528a3c9c2573cd09f`.
- Исторический контроль из `b388aa3`, SHA-256:
  `56fd32cf5118687e2b14d8058fa35ca644e19b91f67b2091bb09b5fcd3ca7d4f`.
- Основной runtime GitView остаётся на `3131f3c1`; `AGENTS.md` не изменён.
- Отдельный candidate runtime установлен с Python 3.12.11 на проверенный TB5:
  `/Volumes/TB5/Developer/Builds/GitHub/GitView-a40d73ccf162f8d8/specgraph-runtime/consumer-meta-b8657bc8-303kk496/runtime/`.
  Installer build products, временные данные и поддерживаемые caches также
  использовали TB5.

Тестовые workspace `default/` и `composition/` находятся рядом с этим runtime.
Они получили копии реальных ontology inputs и config GitView. Байты draft
помещены в `specs/nodes/GITVIEW-SPEC-0001.yaml` только в этих workspace,
как требует существующий target CLI. Исходный canonical graph не менялся.

Оба domain selections сохранены без правок. Дополнительный metamodel selection
явно выбирает только `org.0al.specgraph.core@0.1.0`, namespace `sgcore`, отдельно
от domain. Его копия как evidence:
[metamodel-selection.yaml](evidence/consumer-meta-b8657bc8/metamodel-selection.yaml).
Это тестовый вход, не активная project selection GitView.

Pins:

| Вход | SHA-256 |
| --- | --- |
| sgcore source | `5bfa2ff40b6174def589546ab2fea2501e1f256c4f1446f36c45c7f3fffcd929` |
| sgcore IR | `7a9d1cb640f154c32a2a15a4ec8868349bee04be30a0b5da886422c0d3eb638f` |
| ontologyc 0.5.0 binary | `dcdc37216246f9acebca7387e14b61300d9dec4367f7c1630445b97280c80168` |
| applicability-decision.json bytes | `c9f53fba2b25364084ff1fb3cdc086d0b86b93588d6bfee21696a92d1891b17b` |

Compiler provenance остаётся `not_verified`. Decision/producer provenance
остаётся caller-attributed, без независимой аттестации. Hash файла решения выше
отличается от нормализованного JSON digest, который runtime записывает как
`decision_sha256`; оба вида не следует смешивать.

## Наблюдаемые результаты

| Сценарий | Exit / target | Domain | Meta | Previous freshness |
| --- | --- | --- | --- | --- |
| default-domain | 0 / checked | analyzed | not_requested | — |
| default-both | 0 / checked | analyzed | analyzed | — |
| default-repeat | 0 / checked | analyzed | analyzed | fresh |
| composition-domain | 0 / checked | analyzed | not_requested | — |
| composition-both | 0 / checked | analyzed | analyzed | — |
| composition-repeat | 0 / checked | analyzed | analyzed | fresh |
| current-meta | 0 / checked | not_requested | analyzed | — |
| missing-mapping | 1 / unavailable | analyzed | unavailable | — |
| missing-selection | 1 / unavailable | analyzed | unavailable | — |
| invalid-pin-without-mapping | 2 / invalid | analyzed | invalid | — |
| historical-meta | 0 / checked | not_requested | analyzed | stale |
| schema2-previous | 0 / checked | analyzed | analyzed | invalid |

Положительный meta-result: явное отображение `kind: spec` в `sgcore:Spec`,
`class_check.result: matched`, с identity/path/digest проверяемого документа.
Meta-only не создал domain inventory. Bundle с meta имеет schema 3, domain-only
сохраняет schema 2. Inventory freshness остаётся `not_assessed`.

Domain findings одинаковы до и после добавления meta:

- Основной: GitHubRepository, GitView, User, motivcore:Motive.
- Составной: GitHubRepository, GitView, User.

Это ожидаемые открытые gaps нового draft относительно неизменённых пакетов.
Meta-контекст не снабдил domain lookup неявными символами sgcore.

Исторический контроль успешно проанализирован как отдельный документ-артефакт;
при сравнении с актуальным meta-only отчётом прежние evidence стали `stale`.
После сценария байты тестовой копии восстановлены к актуальному draft.
Исторический и актуальный документ не подменяют друг друга в отчётах.

## Ограничения и отличие от ожидания наблюдателя

В `schema2-previous` передан корректный старый domain-only отчёт этого же
candidate, а новый запрос включает meta. Runtime не объявил его `fresh`, но
вернул freshness `invalid` с `meta binding shape invalid`. Я первоначально
ожидал `unavailable`; это ожидание остановило внешний driver после получения
полного JSON. Сценарий повторён отдельно, наблюдаемый результат проверен и
сохранён. Проверки оригинальных входов и целостности отчётов завершены отдельно.

Это ограничение диагностики миграции: сообщение не объясняет явно различие
schema 2/3. Оно относится к прежнему binding, не к новому target: текущий
анализ остаётся `checked`. Ошибочного `fresh` не наблюдалось; изменение runtime
или решение о том, должен ли здесь быть другой outcome, в GitView не вносилось.

Остальные границы:

- Проверяется только узкий Spec-artifact identity/class mapping известного
  закреплённого sgcore. Это не общий evaluator произвольных metamodel packages.
- Node membership и lifecycle — `not_assessed`; смысл, полнота, критерии,
  evidence-support и правильность продукта этим срезом не проверены.
- Draft сохраняет `idea/pre_canonical`. Отсутствующие acceptance/evidence
  не преобразованы в критерии, выполненные тесты или основание принятия.
- Успешный свежий report — не trusted attestation. Проверка digest компилятора
  не меняет его provenance; записанное решение не становится аттестованным.
- Это 12 ограниченных CLI-сценариев с реальным compiler и установленным runtime,
  не повторение полного upstream test suite или CI.

## Команды и воспроизведение

Точные argv всех сценариев, context pins, meta summaries, findings, producer,
freshness и пути/SHA-256 полных локальных stdout сохранены в
[results.json](evidence/consumer-meta-b8657bc8/results.json).

Пример combined-команды для существующего изолированного default workspace:

```sh
GITVIEW_PILOT_ROOT=/Volumes/TB5/Developer/Builds/GitHub/GitView-a40d73ccf162f8d8/specgraph-runtime/consumer-meta-b8657bc8-303kk496
GITVIEW_PILOT_COMPILER=/Volumes/TB5/Developer/Builds/GitHub/GitView-a40d73ccf162f8d8/ontology/motivation-composition-je20hetf/release-0.5.0/ontologyc-0.5.0-macos-arm64/ontologyc
rtk proxy "$GITVIEW_PILOT_ROOT/runtime/specgraph-runtime" \
  --workspace "$GITVIEW_PILOT_ROOT/default" supervisor -- \
  --build-project-ontology-context-check \
  --ontology-context-project-id gitview --target-spec GITVIEW-SPEC-0001 \
  --ontology-context-selection ontology/context.yaml \
  --ontology-context-metamodel-selection ontology/metamodel-context.yaml \
  --ontology-context-map-spec-artifact \
  --ontology-context-check-scope domain_vocabulary \
  --ontology-context-check-scope specification_metamodel \
  --ontologyc "$GITVIEW_PILOT_COMPILER" \
  --ontologyc-sha256 dcdc37216246f9acebca7387e14b61300d9dec4367f7c1630445b97280c80168 \
  --ontology-context-previous-report reports/default-both.json \
  --output-mode full
```

Для composition заменить workspace и domain selection на соответствующие
значения из receipt. Для нового независимого повтора сначала проверить TB5,
установить тот же full commit в новый runtime, скопировать входы из GitView
`7648e08`, добавить pinned sgcore source/IR из candidate snapshot по путям
тестового metamodel selection и разместить копию draft в `specs/nodes/`.
Без previous-report получается первый результат; затем сохранить полный target
JSON внутри workspace и передать его для freshness-повтора. Новый workspace path
может отличаться; input pins и состояния сравниваются отдельно от абсолютных путей.

Следующий шаг — передать независимые результаты владельцу #871, включая
диагностику schema-2 previous report; переключение основного runtime GitView
в этот прогон не входит.

## Узкий повтор после исправления — 20a31d8b

2026-11-02 независимо проверен candidate
`20a31d8b6895178c06a9b7fdff6a4077c658887e` в новой установленной копии на TB5.
Повторён только валидный `schema2-previous` в составном контексте, включая
подготовительный domain-only запуск для получения свежего schema-2 отчёта.
Актуальный документ сохранил SHA-256 `e3b75460…`; compiler pin не менялся.

Результат: target `checked`, domain и meta `analyzed`, previous freshness
`unavailable`, diagnostic:

```text
schema 2 domain report has no metamodel freshness evidence
```

Оба CLI-вызова завершились exit 0. Ранее обнаруженное ограничение классификации
валидного schema-2 previous report на этом head исправлено. Повреждённый отчёт
и остальные сценарии прежнего набора повторно не проверялись; их результаты
не переносятся автоматически на новый head.

Точные команды, полные target/compiler hashes, producer, outcomes и hashes
локальных stdout сохранены в
[receipt повторного прогона](evidence/consumer-schema2-20a31d8b.json).
Compiler provenance осталась `not_verified`. Основной runtime `3131f3c1`,
исходный draft, domain selections и canonical graph не менялись.

Следующий шаг — использовать это подтверждение при завершении review #871;
обновление основного runtime выполняется отдельно.
