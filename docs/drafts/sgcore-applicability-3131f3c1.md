# GitView: входы для решения о применимости sgcore

Дата проверки: 2026-11-02. Статус: наблюдение для review, не решение о
применимости и не принятие спецификации или онтологии.

## Зафиксированный вход

GitView заморожен на `815405d7fc4707afee8c66ba7f8972d15cc3d86c`.
Runtime закреплён на SpecGraph `3131f3c170c49fc416ff73745aad076e15ba53f2`.
Исходный GitView был чистым при начале проверки.

Проверен реальный [GITVIEW-SPEC-0001.yaml](GITVIEW-SPEC-0001.yaml), SHA-256:
`56fd32cf5118687e2b14d8058fa35ca644e19b91f67b2091bb09b5fcd3ca7d4f`.
Последний commit, изменявший сам файл:
`b388aa305953b573b0e7c89531d24e297802798c`.

| Поле | Наблюдение |
| --- | --- |
| `id` | `GITVIEW-SPEC-0001`; совпадает с именем файла и project prefix |
| `kind` | `spec` |
| `status` | `idea` |
| `draft_status` | `pre_canonical` |
| `created_at`, `updated_at` | `2026-11-01T08:52:37Z` |
| Top-level `acceptance`, `acceptance_evidence`, `evidence` | Все три поля отсутствуют; это не пустые списки и не malformed values |
| `specification.review_examples` | Три текстовых примера; не критерии или выполненные тесты |
| Явная терминологическая ссылка | `/specification/ontology_refs/0`: `motivcore:Motive` |
| Связи экземпляров / критериев | Явных полей bindings/relations/depends_on/refines и ссылок evidence на criterion нет |
| Canonical specs | YAML/YML-файлов в исходном `specs/nodes/` нет |

**Сам черновик после последующих продуктовых договорённостей не обновлялся.**
Обновление runtime на `815405d` изменило путь инструмента и receipt, а
`848dec6` сохранил более свежую предметную модель, аудит и карту покрытия.
В частности, root draft ещё не включает согласованный смысл User, выбранный
набор свойств PR/Issue, детализацию CI и поздние UX-договорённости. Его
`sources.sketch.revision` — `fae218b80fa3496c94df47560997b2c6`, текущий указатель
замороженного sketch — `0bbeb16ed68e4cd6a5e660743e225325`.
Сохранённый старый вход пригоден для воспроизводимого пилота; он не является
полной актуальной спецификацией продукта. Его байты и статусы не исправлялись
ради проверки.

## Domain contexts и повторный поддерживаемый прогон

Все source/IR SHA-256, package identity и версии обоих selection совпали с
закреплёнными значениями. Полные значения сохранены в
[inputs.json](evidence/sgcore-applicability-3131f3c1/inputs.json).

- Основной: `ontology/context.yaml`, `local.gitview.domain@0.1.0`, профиль
  `ontologyc-foundation-v1`.
- Составной: `ontology/pilots/motivation-composition/context.yaml`, GitView
  `0.2.0-pilot.1`, motivation-core `0.1.0`, events-core `0.2.0`, профиль
  `ontologyc-motivation-composition-v1`.
- `sgcore` не выбран ни в одном domain context и не добавлялся при проверке.

Поддерживаемая advisory-команда исполнена установленным runtime в изолированных
workspace на TB5. В каждом находится побайтовая копия root draft по адресу
`specs/nodes/GITVIEW-SPEC-0001.yaml`, необходимому существующему CLI. Такое
размещение в тестовой копии не означает admission в реальный canonical graph.

| Случай | Exit | Target | Domain | Meta | Domain warnings |
| --- | --- | --- | --- | --- | --- |
| default-domain | 0 | checked | analyzed | not_requested | Activity, motivcore:Motive |
| composition-domain | 0 | checked | analyzed | not_requested | Activity |
| default-both | 1 | unavailable | analyzed | unavailable | Activity, motivcore:Motive |
| composition-both | 1 | unavailable | analyzed | unavailable | Activity |
| composition-meta | 1 | unavailable | not_requested | unavailable | Domain inventory/binding/validation отсутствуют |

При meta-запросе runtime сообщает:
`Meta source, applicability profile and supported checking are not established.`
Это проверка существующей scope-границы, **не выполнение нового профиля #868**.
В domain-only режимах нет служебных sgcore-предупреждений. `checked` здесь
означает исполнение advisory-проверки; semantic approval и полнота не следуют
из этого статуса. Исторические отчёты не использовались вместо новых прогонов.

Compiler: существующий ontologyc 0.5.0 с SHA-256
`dcdc37216246f9acebca7387e14b61300d9dec4367f7c1630445b97280c80168`.
Digest проверен; независимая provenance компилятора не установлена.

## Существующий sgcore и ограничения #868

Данные прочитаны из закреплённого installed source snapshot, не из изменяемой
ветки разработчика. Пакет `org.0al.specgraph.core@0.1.0`, namespace `sgcore`,
`approvalStatus: draft`:

- Source SHA-256:
  `5bfa2ff40b6174def589546ab2fea2501e1f256c4f1446f36c45c7f3fffcd929`.
- IR SHA-256:
  `7a9d1cb640f154c32a2a15a4ec8868349bee04be30a0b5da886422c0d3eb638f`.
- IR `sourceDigest` совпадает с source. Source и IR сохраняют одинаковые
  applicability-декларации с учётом нормализации порядка записей по ID.
  Пакет заново не компилировался в этом наблюдении.

`modelApplicability` ограничивает область `specgraph_core`, исключает
`unrelated_product_domain`, содержит `project_local_authority` и
`human_review_required`. Наличие `sgcore:Spec` и подходящее описание класса
сами по себе не разрешают расширить эту область.

В IR присутствуют Spec, Node, AcceptanceCriterion и Evidence; наличие классов
не связывает с ними данный документ. `hasAcceptanceCriterion` имеет endpoints
Spec → AcceptanceCriterion и `min: 0`. Поэтому отсутствие acceptance list
не нарушает эту кардинальность. `evidenceSupportsCriterion` требует явно
представленной связи Evidence → AcceptanceCriterion; таких входов здесь нет.
SpecReviewState содержит `draft/reviewed`; `idea/pre_canonical` не были
преобразованы в эти состояния.

Профиль `specgraph-external-specification-artifact-v1` из #868 имеет
`status: design_candidate`, `runtime_implemented: false`,
`applicability_approved: false`. Его source hash, authored flags и исходные
applicability-декларации сохранены в manifest. Профиль требует отдельного
явного выбора metamodel, mapping revision, source-bound решения о применимости
и versioned report/freshness support. Физический selection-интерфейс для этого
нового профиля в данной версии ещё не определён. Domain context не заменяет
metamodel context; `sources`, prose и review_examples не становятся evidence.

## Воспроизводимость и сохранённые evidence

[results.json](evidence/sgcore-applicability-3131f3c1/results.json) содержит
сводку, findings, producer identity и SHA-256 пяти полных отчётов в соседних
JSON-файлах. [inputs.json](evidence/sgcore-applicability-3131f3c1/inputs.json)
содержит source/IR pins, точные argv, exit codes, frozen commit и размещение
производных копий. Все семь JSON-файлов намеренно сохранены в проектном Git;
они не являются каноническими спецификациями.

Для повторения:

1. Проверить TB5 через проектный `tb5_paths.py`, выбрать новый каталог на нём.
2. Выполнить `rtk proxy git clone --no-hardlinks` из локального GitView в этот
   каталог и checkout зафиксированного commit `815405d7fc4707afee8c66ba7f8972d15cc3d86c`.
3. Для default и composition подготовить отдельные workspace: скопировать
   `ontology/`, `.specgraph/`, `specgraph.project.yaml`; создать `specs/nodes/`
   и скопировать туда исходный draft без редактирования. Сверить его SHA-256.
4. Использовать установленный runtime и compiler с указанными pins. Повторить
   argv из `inputs.json` → `execution.cases`, заменив только `--workspace` и
   путь к тому же compiler при необходимости. Сохранить stdout/stderr и exit.
   В окружении установить `PYTHONDONTWRITEBYTECODE=1`, а временные файлы и
   поддерживаемые caches направить на проверенный TB5.
5. Сверить target digest, package pins, producer, scope outcomes и findings.
   Абсолютный workspace path будет другим, поэтому побайтовое совпадение всего
   нового JSON не требуется. Hash исходного сохранённого отчёта проверяет его
   целостность, а не идентичность нового запуска.

Исходные локальные прогоны сохранены в
`/Volumes/TB5/Developer/Builds/GitHub/GitView-a40d73ccf162f8d8/specgraph-runtime/sgcore-applicability-3131f3c1-k38z_okn/`.
Проверки читали продуктовые входы и писали только производные отчёты в
изолированных workspace. Оригинальные draft, ontology selections, package/IR,
canonical specs и история заметок не менялись.

## Открытые решения для SpecGraph

1. Разрешает ли авторская applicability `sgcore` интерпретировать внешний
   документ **как артефакт внутри SpecGraph**, сохраняя GitView отдельным
   product domain? Если нет — изменение source scope требует отдельного
   предложения; adapter не вправе обходить exclusion.
2. После этого решения определить явный opt-in выбор metamodel и минимальный
   mapping Spec-artifact identity/class, с привязкой к profile/source/IR,
   document digest и applicability disposition в freshness.
3. Сохранять отсутствие acceptance как отсутствие наблюдаемых критериев;
   возможное требование зрелости вводить отдельной policy, не приписывать sgcore.
4. Содержательное обновление root draft и построение продуктового графа остаются
   работой GitView после сверки онтологии. Они не должны неявно происходить
   внутри инфраструктурного пилота.

Следующий шаг — source-bound решение по пункту 1 в SpecGraph, затем поддержанная
opt-in реализация и потребительский пилот на этих же замороженных байтах.
