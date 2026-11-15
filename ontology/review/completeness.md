# Полнота онтологии GitView: аудит 2026-11-02

Сверка конкретно Issue, PR и их связей с текущими спецификациями:
[issue-pr-spec-alignment-20261115.md](issue-pr-spec-alignment-20261115.md).
Сверка Project, Repository и membership:
[project-repository-spec-alignment-20261115.md](project-repository-spec-alignment-20261115.md).

**Текущий контекст, 15 ноября:** `specgraph.project.yaml` выбирает
[составной draft.12](../candidates/domain-v0.2.0-draft.12/README.md), а не
исторические draft.5 или draft.6. Пакет остаётся `draft`; последующие
структурные проверки не утверждают его смысл. Таблицы и выводы ниже относятся
к обозначенным в них историческим снимкам, не к текущему составу пакета.


В корневом 0001 рабочие значения Project, CIStatus и Metric теперь отделены
от правил членства, счётчиков и контекста измерения. Общая формулировка Project
остаётся открытой; пользовательское правило состава сохранено в спецификации.
Formal package не менялся, смысловое утверждение не производится.

Дополнение 14 ноября: для удаления membership подготовлен и выбран рабочим
[candidate draft.6](../candidates/domain-v0.2.0-draft.6/README.md) с проверкой
компилятора, композиции и тестового обработчика. Выбор не закрывает вопрос
семантического принятия действия или lifecycle отношения. Раздел о «текущем»
draft.5 ниже фиксирует исторический снимок до этого выбора.

Основание: приоритет пользователя — полнота онтологии, затем граф спецификаций
на ней (`excerpt-52`). Визуальная проверка review-отметок пока отложена.
Исходная рабочая копия: `main` `1fc7876`. Аудит не изменяет выбранный package,
не утверждает новые термины и не создаёт canonical specs.

## Проверяемые факты

| Проверка `local.gitview.domain` 0.1.0 | Результат |
| --- | --- |
| Классы | 10 |
| Кандидатные декларации отношений | 2 |
| Локальные поля классов | 0 |
| Локальные protocols / policies / stateMachines | 0 / 0 / 0 |
| Source/IR SHA-256 совпадают с selection | Да, оба |
| Package approvalStatus | draft |
| YAML/YML spec-файлы в `specs/nodes/` | 0 |
| Содержательный root draft | `docs/drafts/GITVIEW-SPEC-0001.yaml`, idea, pre-canonical |

У Project 12 выбранных checklist-пунктов, PR — 24, Issue — 23. Это не число
атомарных свойств и не процент полноты: часть пунктов — ссылки, роли и UX.
Они ещё не выражены полями/связями выбранного compiler package.

Факты проверены чтением YAML установленным Python environment, подсчётом
деклараций и SHA-256. Полный compiler/semantic pipeline не повторялся:
package/IR не менялись. Hash не доказывает полноту. Live schema в checkout
Ontology поддерживает scalar fields string/boolean/integer/number, relations,
policies и stateMachines. Совместимость новых расширений с закреплённым
compiler/runtime отдельно не проверена; ограничения типов не заполняем строками
JSON или вымышленными классами ради прохождения проверки.

## Матрица пробелов

| Область | Содержательная основа | Выбранный package | Осталось |
| --- | --- | --- | --- |
| GitView | Контекст, единый корень HC | Нет класса | Решить, нужен ли compiler concept; не создавать entity ради экспорта. |
| User | Подтверждён: оператор GitView; идентичности GitHub отдельно | Не представлен | Нужная идентичность/границы, техническая роль. |
| Project | Состав, ID, имя, описание, пересечения согласованы | Только класс | Поля/состав, изменение состава, ошибки. |
| Code / VCS / Repository | Пользовательские рабочие формулировки | Три класса, candidate relation | Достаточные границы и идентичность для обзора. |
| GitHubRepository | Контекст Repository в отношении управления | Не представлен | Роль/классификация без искусственного дубликата. |
| GitHub | Актор управления в выбранной интерпретации | Класс и candidate relation | Действие, возникающее свойство, scope. |
| PullRequest | Поля и формат описания выбраны | Только класс | Сверить значение; типы, состояния, роли/ссылки, источники. |
| Issue | Все предложенные поля и формат выбраны | Только класс | Сверить значение; типы связей, состояния, unknown. |
| Review / threads | Итог review и два счётчика | Только ReviewThread | Семантические границы; значки остаются UX. |
| CI | Актуальные отдельные проверки по образцу GitHub | Рабочий CIStatus | Единица, ревизия/попытка, особые/неполные состояния. |
| Metric | Семейства измерений и несмешение сигналов | Только общее имя | Область, единица, период, история, полнота каждого показателя. |
| Description | Problem/Motivation/Expected outcome/References; PR Changes/Validation | Не выражены | Свойства содержания и источники, без шести лишних entities. |
| Мотив / актор / последствие | Пример владельца, ссылка ≠ отношение | Foundation; opt-in composition отдельно | Роли/интерпретация/основания; PR-ссылка не доказывает causal attribution. |
| Activity | Намеренно гипотеза | Не объявлена | Не обязательный blocker; не заполнять искусственным классом. |
| Сводки / zoom / preview | Требования и направление UX сохранены | Не обязаны быть классами | Будущие specs используют словарь, не ontology entity для каждого контрола. |

## Достаточная полнота для начала spec graph

Полнота ограничена текущим продуктом, не всем GitHub. До материализации нужны:

1. Смысл, источник, статус и различие соседних понятий; обязательные gaps
   видны, отложенные понятия не выданы за определённые.
2. Размещение всех выбранных свойств Project/PR/Issue, типы, принадлежность,
   неизвестность и происхождение значений.
3. Различение состава, принадлежности, Issue/PR links и ролей участников;
   подтверждённые кардинальности отдельно от предположений.
4. Нужные действия с актором/объектом, изменением состояния и последствиями.
   Полная state machine для каждой сущности не требуется.
5. Различение исходного состояния, наблюдения, вычисленной оценки и отображения.
6. Versioned technical binding без выдуманных классов; проверка не заменяет
   принятие смысла. Нет требования «одна ontology entity = один code class».
7. Для будущего spec определены цель, ontology references и проверяемые
   ограничения; примеры не объявлены выполненными тестами.

## Порядок работы

1. Сверить [предметную модель](../domain-model.md), прежде всего значение и
   идентичность GitHubRepository, PR и Issue. User уже уточнён.
2. Типизировать выбранные свойства, связи и необходимые действия; unknown
   сохраняется, не подменяется нулём/пустым набором.
3. Подготовить versioned compiler candidate; проверить tooling, затем обновить
   IR, selection и HC/HCS согласованно по проектному процессу.
4. После этого материализовать [каркас spec graph](../../docs/drafts/specification-coverage-map.md)
   и проверить покрытие требований и ontology gaps.

Вывод: содержательная основа значительно полнее выбранного package, но ещё
не замкнута. Канонический spec graph не построен. Процент полноты и статус
«онтология завершена» этому аудиту не присваиваются.

## Продолжение 2026-11-03

Root draft уже обновлён до подтверждённых решений; его frozen digest —
`e3b75460f71a8946267132037d051f4a33b76030b2a3692528a3c9c2573cd09f`.
Основной пакет/selection 0.1.0 сохраняются как контроль.

Отдельный [candidate](../candidates/domain-v0.2.0-draft.1/README.md) содержит
10 прежних классов, 45 предложенных scalar fields, 2 protocol-contracts,
12 compiler links/relations и 2 manual policies. Оба варианта source/IR и
candidate selections согласованы; check/compile и native context/target checks
выполнены. Это структурная проверка предложения, не принятие типов или смысла.

| Gap | Продвижение | Что остаётся |
| --- | --- | --- |
| User | Смысл оператора сохранён; предложен contextual protocol, без Person/Account. | Role binding/identity не выбраны; vocabulary tooling не включает protocols. |
| GitHubRepository | Предложен contextual contract на тот же Repository. | Правило identity при rename/transfer, основания management, применение contract. |
| Project/PR/Issue | 59 выбранных пунктов внесены в coverage; у 36 частичные structural mappings. | 23 unencoded/spec-behavior entries, enums/ranges/source bindings, review. |
| Коллекции/время/наблюдения | Явно выделены без фиктивных классов или JSON-строк. | Typed reference/time/availability contract. |
| Motive | Не дублируется; composition разрешает общий термин. | Основной context его не выбирает; смысл Issue-to-Motive остаётся candidate. |
| Tooling | Protocol vocabulary fix проверен на влитом runtime b1583e58 в обоих candidate contexts. | Структурное разрешение protocols не подтверждает смысл contextual contracts; см. merged consumer receipt. |

Ни отсутствие новых классов, ни сохранение warnings не означают провал предметной
модели. Но данный срез также не замыкает обязательные gaps. Materialization
canonical graph остаётся отложенной до достаточной готовности выбранного объёма
и соответствующего разрешения пользователя.

## Выбор identity и source triage — 2026-11-03

В `excerpt-54-reply` выбран вариант A: same-source-object rename/transfer
сохраняют Repository, историю и членство в Projects. Вопрос о непрерывности
закрыт в этом scope; concrete key/encoding/aliases остаются открыты.
Новый [draft.2](../candidates/domain-v0.2.0-draft.2/README.md) добавляет manual
policy без новых классов и сохраняет draft.1 как контроль.

Оба новых contexts проходят check/compile и native target check нового root
draft. [Source triage](remaining-findings.md) объясняет GitView как product label
без exported symbol, а Motive — как существующий общий термин вне foundation
selection, разрешённый в composition. Generic warning не диктует добавление entity.

Rule selection не завершает typed reference/time/availability contract и
не утверждает все прочие решения candidate. Canonical graph остаётся отложенным.

## Сверка с текущим графом — 2026-11-14

Таблица 0.1.0 и промежуточные draft.1–draft.2 выше описывают исторические
снимки, а не текущий выбранный пакет. `specgraph.project.yaml` выбирает
[составной draft.5](../candidates/domain-v0.2.0-draft.5/composition-context.yaml):
`local.gitview.domain@0.2.0-draft-composition.5`, status `draft`, вместе с
импортированными motivation-core и events-core. При чтении локального source
пакета обнаружены 13 class declarations (включая действия `RegisterRepository`
и `AddRepository`), 14 relation/link declarations, один protocol и четыре
manual policies. Число declarations не является мерой смысловой полноты.

| Область | Состояние draft.5 и граница |
| --- | --- |
| User и действие над Project | `User` и `AddRepository` объявлены; action несёт типизированную ссылку на Repository, а `addsRepositoryTo` связывает оператора и Project. Проверка декларации не доказывает выполнения действия или мотива конкретного оператора. |
| GitHub и Repository | `RegisterRepository`, `managesRepository` и contextual protocol `GitHubRepository` представлены; это контекст того же Repository, не новый объект. Источник и время возникновения фактического управления остаются отдельным вопросом. |
| Состав и source links | `projectIncludesRepository`, связи PR/Issue с Repository и Issue/PR links объявлены. Часть выражена как `domain/range` links: не следует выдавать их за установленные актором action-derived отношения или доказательство причинности. |
| Выбранные свойства | Project, PR и Issue имеют частичную типизированную проекцию; политика `PartialObservationBoundary` прямо запрещает считать missing значением zero/false/empty. Поля и связи не равны полному состоянию GitHub или доказанной доступности API. |
| Identity | `RepositoryIdentityContinuity` и `ProjectMembershipScope` фиксируют рабочие правила в manual policies; реализуемая логика и источник наблюдений требуют соответствующих specs и evidence. |
| Motive и Activity | Ссылка использует импортированный `motivcore:Motive`; Issue link не доказывает мотив или причинную цепь. `Activity` по-прежнему не вводится как самостоятельная сущность без основания. |
| Новые UX и application state | Loading, coverage, focus, pending selection и default association описаны в спецификациях как состояние или правила приложения. Их появление не является основанием добавлять ontology class. Если дальнейший review обнаружит отдельный устойчивый смысл или недостающий актор/action, нужен отдельный candidate с источником и разбором последствий. |

Для узлов 0022–0047 выполнены выборочные проверки `domain_vocabulary` в
изолированных копиях. Отчёты и SHA-256 приведены в [оценке качества](../../docs/drafts/autonomous-quality-review.md);
они проверяют структурные bindings к выбранной композиции, а не истинность
определений, полноту связей, runtime behavior или canonical acceptance.
Аудит смысловой полноты не завершён: остаются определения PR/Issue и CIStatus,
значение Metric и его единиц, основания action-derived отношений и provenance
источника. Обновление аудита не изменяет пакет или его статус.

При уточнении Project lifecycle выявлен также [candidate gap удаления Repository](remove-repository-action-candidate.md):
действие добавления в draft.5 есть, а соответствующее удаление из одного Project
в specs описано отдельно. Формальное действие и семантика снятия membership пока
не приняты и package не менялся.

Смысл `Metric` уточнён в отдельном [кандидате для review](metric-meaning-candidate.md):
разведены единица, измеряемый предмет, контекст и конкретное значение; actor/action
отношение для графика не выдумывается. Draft.5 и его технические поля при этом не
менялись, а смысловое принятие и полнота ontology остаются неустановленными.

Для CI и review подготовлен [кандидат смысловых границ](ci-review-boundaries-candidate.md):
отдельно рассмотрены состояние checks, counts, review assessment и ReviewThread.
Гранулярность `CIStatus` остаётся открытой; новые классы или actor/action
отношения без предметного основания не добавлялись.

Подготовлен [кандидат значений Issue и PullRequest](issue-pr-meaning-candidate.md),
в котором свойства и source links отделены от определений, а связь с
`motivcore:Motive` не выдаётся за доказанную причинность. Формальное
сопоставление пользовательской идеи «Issue — мотив» с `issueMotiveLink`
остаётся открытым; выбранный package не менялся.

Сверены [границы Repository и Code](repository-boundary-candidate.md) и
[кандидат удаления membership](remove-repository-action-candidate.md). Последний
различает прекращение конкретного членства, удаление Project и удаление
источника; формальная модель изменения отношения во времени остаётся открытой.
Ни одно новое action или отношение в package не добавлено.

[Матрица влияния на specs](specification-impact-matrix.md) разделяет gaps,
мешающие утверждать конкретные ontology bindings, и вопросы, не мешающие
продолжать поведенческую детализацию. Она также уточняет хронологию выбора
numeric REST ID: исторический ответ A и последующее согласие на конкретные
правила — разные решения.


## Выборочная сверка значений с верхними specs — 15 ноября

Авторская смысловая сверка текущего исходного package
`local.gitview.domain@0.2.0-draft-composition.12` с 0001, 0005, 0008,
0009, 0011 и 0012. Это не независимое semantic review или исчерпывающая
проверка всех свойств, bindings и связей.

| Понятие или связь | Совпадающая граница | Что остаётся открытым |
| --- | --- | --- |
| User и GitHub identity | User — оператор, GitHub author/reviewer/assignee не приравниваются к нему автоматически. | Физическое представление оператора и подтверждение конкретного действия. |
| Repository и GitHubRepository | GitHubRepository — контекст того же Repository под управлением GitHub; Project membership и source association выражены отдельно. | Evidence конкретного управления; contextual protocol сам по себе не устанавливает его occurrence. |
| Project и membership | Один или несколько Repository, один Repository в нескольких Projects, организации не задают Project. | Подтверждение action, история изменений состава и достаточность информации при частичном чтении. |
| PR и Issue | Различные source objects; ссылки не доказывают мотив или результат действия. | Связывание конкретных source identity и полные значения/доступность каждого выбранного поля. |
| CIStatus и Metric | CIStatus — состояние одной записи проверки; Metric — результат измерения с правилом и контекстом. Сводные счётчики — отдельные результаты. | Применимая revision и attempts, source semantics и полнота конкретных измерений. |

`ontology-doctor` с выбранным compiler подтвердил структурный контекст и
оставил `semantic_approval: not_established`; provenance compiler остаётся
неподтверждённым. Сама сверка не доказывает семантику действий, identity
binding, source access или полноту графа. Activity не добавлена как сущность.
