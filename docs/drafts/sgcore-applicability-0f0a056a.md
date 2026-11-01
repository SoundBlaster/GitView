# GitView: применимость предупреждений SpecGraph Core

Статус: локальное исследование и feedback для SpecGraph, не решение об
утверждении онтологии или спецификации. Проверена копия реального проектного
черновика [GITVIEW-SPEC-0001](GITVIEW-SPEC-0001.yaml), SHA-256
`56fd32cf5118687e2b14d8058fa35ca644e19b91f67b2091bb09b5fcd3ca7d4f`.
Файл помещался в `specs/nodes/` только изолированных test workspace. Исходные
GitView spec, ontology selection и пакеты не менялись.

## Вывод

Три наблюдаемых предупреждения не показывают три отсутствующих понятия
предметной области GitView. Они возникают при попытке сопоставить структуру
spec-файла с `sgcore`, который не выбран ни в основном, ни в экспериментальном
составном контексте GitView. Такое сопоставление может иметь смысл на уровне
модели самого SpecGraph, но его применимость к внешнему product workspace и
источник этой модели нужно определить отдельно; `verified` контекста GitView
сам по себе её не устанавливает.

| Finding | Как возникает |
| --- | --- |
| `missing_required_binding` для `sgcore:Spec` | Validation требует этот binding для каждого анализируемого entry. |
| `unknown_legacy_term: spec` | Binding index интерпретирует `kind: spec` как ссылку на `sgcore:Spec`. |
| `unknown_legacy_term: node` | Binding index интерпретирует наличие `id` как ссылку на `sgcore:Node`. |

`spec` и `node` здесь добавлены проверяющей программой из полей документа, а не
найдены в `specification.terminology` как неизвестные термины GitView. Первые
два findings связаны с одним отсутствующим `sgcore:Spec`; третий относится к
`sgcore:Node`. Присутствие `id` в копии черновика само по себе не доказывает
принятие графового узла. Отдельный `Activity` остаётся действительным
неразрешённым словом в явном inventory; это не предложение автоматически
создавать новую сущность.

## Основания в SpecGraph

Проверен установленный runtime с source commit
`0f0a056a522a9c6bbba0e75e3748bad909d1d5c7` после PR #858:

- `tools/spec_ontology_binding_index.py`, `spec_entry`, без выбора профиля
  применимости выводит `sgcore:Spec` из `kind` и `sgcore:Node` из `id`.
- `tools/spec_ontology_validation_report.py`, `validate_entry`, безусловно
  требует `sgcore:Spec` и выводит warning, когда такого binding нет.
- `docs/proposals/0134_legacy_spec_ontology_binding_index.md` ограничивает
  исходную задачу существующим corpus спецификаций самого SpecGraph;
  `docs/proposals/0135_spec_ontology_validation_report.md` строит на ней
  report-only проверку. Эти исторические документы не устанавливают отдельную
  универсальную policy для внешних product workspace.
- `ontology/packages/specgraph-core/domain-ontology-package.yaml` определяет
  `org.0al.specgraph.core` / `sgcore` версии `0.1.0` со статусом `draft`.
  Его `modelApplicability` указывает домен `specgraph_core`, исключает
  `unrelated_product_domain`, а assumption `project_local_authority` оставляет
  пакет локальным без отдельного решения о публикации.

Последний пункт не отвечает автоматически на вопрос, является ли **описание
спецификации внешнего продукта** частью подходящего meta-контекста SpecGraph:
это другой вопрос, чем принадлежность `Project`, `Repository` или `Activity`
к предметной области GitView. Нынешний context-check проверяет заявленный
структурный профиль и не устанавливает это решение о применимости.

## Контрольные прогоны

Для всех строк использована одна и та же побайтовая копия черновика и release
`ontologyc` 0.5.0 для macOS arm64 с SHA-256
`dcdc37216246f9acebca7387e14b61300d9dec4367f7c1630445b97280c80168`.
`sgcore` брался без правок из установленного runtime: source SHA-256
`5bfa2ff40b6174def589546ab2fea2501e1f256c4f1446f36c45c7f3fffcd929`,
normalized IR SHA-256
`7a9d1cb640f154c32a2a15a4ec8868349bee04be30a0b5da886422c0d3eb638f`.
Варианты, включающие `sgcore`, являются только диагностическими selection на
TB5, а не изменением selection GitView.

| Selection / профиль | Наблюдение на runtime `0f0a056a` |
| --- | --- |
| GitView, `ontologyc-foundation-v1` | Context `verified`, target `checked`, 5 warning: три `sgcore`, `Activity` и невыбранный `motivcore:Motive`. |
| GitView + motivation + events, `ontologyc-motivation-composition-v1` | Context `verified`, target `checked`, 4 warning: те же три `sgcore` и `Activity`; `motivcore:Motive` разрешён. |
| Только `sgcore`, `ontologyc-foundation-v1` | Context `verified`, target `checked`; `sgcore:Spec` и `sgcore:Node` связаны, все три их warning исчезли. При этом 10 терминов GitView, `Activity` и `motivcore:Motive` остаются неизвестными: 12 warning. |
| GitView + `sgcore`, `ontologyc-foundation-v1` | `unavailable`: профиль требует ровно один пакет. |
| GitView + `sgcore`, `ontologyc-structural-v1` | `unavailable`: проверка композиции и closure не поддержана. |
| GitView + motivation + events + `sgcore`, `ontologyc-motivation-composition-v1` | `invalid`: профиль видит два project package и также требует от `sgcore` импорт motivation-core. Отдельная диагностика сообщает, что поддержан один project package. |

Успешный контроль с одним `sgcore` подтверждает происхождение предупреждений,
но не является способом одновременно проверить метасловарь и предметный словарь
GitView. Четырёхпакетный случай фиксирует поведение ограниченного профиля, а не
универсальную несовместимость этих онтологий.

## Повторная проверка PR #858

На **одном workspace и тех же байтах** старый runtime `54db6fb9` не выводил
неизвестный `motivcore:Motive` в single-member binding/validation, а новый
`0f0a056a` выводит его и в inventory, и в binding gaps, и в validation findings.
Количество warning выросло с 4 до 5. При передаче старого отчёта через
`--ontology-context-previous-report old.json` результат для
binding/validation bundle — `stale`, причина `producer_identity changed`;
project ID, workspace и context revision совпали. `inventory_freshness` при
этом явно `not_assessed`. Это не семантическое принятие терминов.

## Предложение для разработчика SpecGraph

1. Явно разделить проверку **структуры спецификации / meta-контекста** и
   проверку **терминов предметной области**. Выбор project ontology не должен
   неявно превращать служебные `spec` и `node` в её domain gaps.
2. Для structural binding объявлять требуемый источник, применимость и статус
   проверки. Если проверка обязательна, но нужный пакет недоступен или не
   выбран, сообщать `unavailable` с причиной; если не запрошена — явный статус
   неприменения или невыбранной проверки. Не выдавать её за успешно выполненную
   и не подставлять другую версию пакета автоматически.
3. Сохранить реальные неизвестные и неоднозначные ссылки в domain inventory,
   binding и validation. Если `sgcore` явно выбран в поддержанном контексте,
   его структурные проверки и их происхождение должны оставаться видимыми.
   Существующее поведение no-context legacy отчётов требует отдельной
   совместимости. Если изменятся правила или форма отчёта, учесть profile /
   producer identity и freshness ранее сохранённых результатов.

Полные отчёты, selection и проверенные входные hash находятся на TB5:
`/Volumes/TB5/Developer/Builds/GitHub/GitView-a40d73ccf162f8d8/ontology/gitview-sgcore-applicability-0f0a056a-zgo9b1d8/`.
Например, повторить составной вариант в сохранённом test workspace можно так:

```sh
SPECGRAPH=/Users/egor/.local/share/specgraph/runtime-0f0a056a/specgraph-runtime
WORKSPACE=/Volumes/TB5/Developer/Builds/GitHub/GitView-a40d73ccf162f8d8/ontology/gitview-sgcore-applicability-0f0a056a-zgo9b1d8/composition
ONTOLOGYC=/Volumes/TB5/Developer/Builds/GitHub/GitView-a40d73ccf162f8d8/ontology/motivation-composition-je20hetf/release-0.5.0/ontologyc-0.5.0-macos-arm64/ontologyc
"$SPECGRAPH" --workspace "$WORKSPACE" supervisor -- \
  --build-project-ontology-context-check --ontology-context-project-id gitview \
  --target-spec GITVIEW-SPEC-0001 \
  --ontology-context-selection ontology/pilots/motivation-composition/context.yaml \
  --ontologyc "$ONTOLOGYC" \
  --ontologyc-sha256 dcdc37216246f9acebca7387e14b61300d9dec4367f7c1630445b97280c80168 \
  --output-mode full > "$WORKSPACE/recheck.json"
```

Для остальных строк выберите одноимённый соседний workspace и его selection:
`ontology/context.yaml` для `default`, `ontology/sgcore-probe-context.yaml` для
`sgcore-only` и `composition-plus-sgcore`, `ontology/sgcore-pair-context.yaml`
для обоих вариантов `*-pair`. Отчёты не являются тестами реализации GitView и
не устанавливают семантическое или каноническое принятие.
