# GitView domain candidate 0.2.0-draft.1

Статус: предложение агента на 2026-11-03 по уже выбранному объёму. Это не
принятие онтологии и не замена основного контекста 0.1.0. Смысловые вопросы
и технические варианты ниже не объявлены новыми решениями пользователя.

## Ограниченный срез

Основание — sketch `0bbeb16ed68e4cd6a5e660743e225325`,
`ontology/domain-model.md`, выбранные checklist Project/PR/Issue и root draft
с SHA-256 `e3b75460f71a8946267132037d051f4a33b76030b2a3692528a3c9c2573cd09f`.
Локальные excerpt refs сохраняют происхождение, но не являются аттестованными
message IDs.

Предложение агента отдельно сохранено в SpecDraft revision
`bc92164b9c924f738d5d37801a67363f`, узел `ontology-02-contracts-proposal`.
Это добавление не утверждает package или весь sketch; исходные пользовательские
решения остаются привязаны к прежней ревизии выше.

- 10 исходных классов сохранены; классы User, GitHubRepository и GitView не добавлены.
- Добавлены 45 предложенных scalar fields: Project — 2, PR — 27, Issue — 16.
- Добавлены 2 предложенных protocol-contracts и 2 manual review policies.
- Всего 12 compiler relations в foundation-варианте: прежние candidate
  declarations управления/контроля кода плюс выбранные membership/source links.
- В композиции дополнительно сохранён прежний экспериментальный issueMotiveLink.
  Локального класса Motive нет.

Типизация и имя YAML-поля являются предложением агента. Наличие выбранного
свойства не означает, что пользователь уже выбрал его serialization или API binding.

## User и GitHubRepository без новых сущностей

User и GitHubRepository предложены как контекстные contracts без новых классов сущностей.

`protocols.User` описывает роль оператора GitView (`excerpt-53-reply`).
Он не создаёт Person/Account, не выбирает login, operator ID, владение Project
или автоматически выполненное действие. Автор/reviewer/assignee в GitHub не
становится User по совпадению имени.

`protocols.GitHubRepository` описывает Repository в контексте управления GitHub
(`excerpt-31`, `excerpt-32`). Сохраняется исходный Repository; нет второго ID,
наследования или обязательного программного Decorator. Project и PR/Issue
ссылаются на Repository с этим контекстным условием.

Это именно **технический вариант для review**, не утверждённая роль реализации.
Repository не объявлен глобально `implements: GitHubRepository`: вне текущего
scope репозиторий может управляться другой системой. Само имя protocol не
доказывает наблюдённое отношение управления или действия GitHub.

Protocol в доступной схеме — декларация contract; его применение к контексту,
участнику или instance не выведено автоматически. Схема не предоставляет здесь
проверяемый relation-qualified тип. Контекстные условия остаются manual review
constraints, а не исполненными проверками.

## Свойства, связи и неизвестность

[coverage.yaml](coverage.yaml) содержит все 59 выбранных checklist-пунктов:
12 Project, 24 PR, 23 Issue. У 36 есть частичная структурная привязка; 23
помечены как не кодируемые этим срезом или относящиеся к specs/UX. Это не
процент полноты и не 59 атомарных требований.

Scalar fields покрывают названия/текст, исходные номера, draft flag, счётчики,
строковые отображения некоторых исходных состояний и разделы описаний.
Все поля optional **для частичного наблюдения**. Это не правило создания
полного объекта: обязательность имени Project или наличие source ID не
отменены молча. Не выбран mapping встроенного compiler `id` в локальный или
GitHub ID. Отсутствие поля не превращается в ноль/false/пустую коллекцию.

Коллекции labels/reviewers/assignees, ссылки на участников/milestone и временные
значения не упакованы в JSON-строки и не породили фиктивные классы. Для Instants,
reference types, причин отсутствия и observation/freshness contract остаются
отдельные gaps. Строковые lifecycle/review/type значения пока не проверяемые
enums; диапазоны счётчиков не обеспечиваются одним типом integer.

`projectIncludesRepository` сохраняет согласованные 1..* и допускает повторное
использование Repository в Projects. PR/Issue имеют source Repository links.
Issue/PR closing link, mention, hierarchy и blockers различаются; конкретные
source instances, inverse consistency и верхняя граница parent link ещё не
проверены. Compiler `relations` для этих ссылок не означает отношения,
возникшие через действие актора в пользовательском смысле Ontology.

## Проверки и наблюдение tooling

Использован закреплённый runtime `dc35597b` и ontologyc 0.5.0, SHA-256
`dcdc37216246f9acebca7387e14b61300d9dec4367f7c1630445b97280c80168`.
Compiler provenance остаётся `not_verified`.

Оба source package прошли `ontologyc check` и `compile`. В проект сохранены
только source, normalized IR, явные selection и review evidence; SDK/build
outputs остались на проверенном TB5. Source/IR hashes закреплены в selections.

Закреплённый SpecGraph проверил оба candidate contexts и тот же root draft
в изолированных workspace: context `verified`, target `checked`, domain
`analyzed`, meta `not_requested`. Проверка не изменяла source `specs/nodes/`.

При этом protocol names остались `unknown_legacy_term`: текущий vocabulary
projection перечисляет только classes/relations. Compiler IR содержит оба
qualified protocol names. Минимальный контроль с `gitview:Project` и двумя
protocol refs подтвердил, что class разрешается, а protocols — нет.
Это не исправлялось добавлением entity classes или подавлением warnings.
См. [source-bound observation](../../review/protocol-vocabulary-observation/observation.json),
связанный с proposal 0232 / SG-SPEC-0072. Upstream fix/closure не заявляется.

В обоих contexts GitView остаётся непривязанным названием продукта. Motive
остаётся gap в foundation-варианте и разрешается из общего пакета в composition.
Нормализованный IR protocol сохраняет имя/описание; его source semanticConstraints
не проверены и не воспроизведены полностью в IR. Поэтому compilation не
подтверждает выполнение контекстных условий.

[verification.json](verification.json) содержит точные compiler/native argv,
pins, findings и hashes полных отчётов на TB5. [Foundation selection](foundation-context.yaml)
и [composition selection](composition-context.yaml) используются только явно.

## Источники и подготовка

- User: `excerpt-53-reply`.
- Repository/GitHubRepository: `excerpt-24`, `excerpt-25`, `excerpt-31`, `excerpt-32`.
- Project: `excerpt-10`–`excerpt-12`, `excerpt-40`, `excerpt-41`.
- PR: `excerpt-34`, `excerpt-35-reply`; Issue/description: `excerpt-37`, `excerpt-38`.
- Приоритет и граница UX: `excerpt-17`, `excerpt-52-reply`.

Редактируемый source — [domain-ontology-package.yaml](domain-ontology-package.yaml).
Composition source является производным: меняются версия, импорт motivation-core
и добавляется тот же issueMotiveLink из старого пилота. Остальные class/protocol/
policy/field/link declarations должны совпадать. Не редактировать варианты
независимо. Для нового изменения: check/compile на TB5, перенести новый IR,
пересчитать source/IR pins обоих candidate contexts и повторить native check.
Основные 0.1.0 package/selection и прежний HC/HCS остаются контрольными.

## Решения, которые ещё нужны

1. Сохраняет ли Repository идентичность при переименовании/переносе owner?
   Предложение «да» вынесено отдельным вопросом; ответа пока нет. Ни GitHub ID,
   ни URL не объявлены окончательным identity rule.
2. Достаточен ли предложенный contextual contract для User/GitHubRepository,
   или нужен другой binding contextual role? Имя выбранного понятия не
   обосновывает global class inheritance.
3. Как типизировать reference collections, time, observation availability и
   source/project identities без подмены их произвольными строками?
4. Какие поля/состояния нужны уже для первого ограниченного spec graph, а какие
   могут оставаться явно отложенными? Не нужна модель всего GitHub.

Ontology ещё не объявлена достаточно готовой для canonical graph. Следующий
ограниченный шаг — решение об identity/context и затем typed observation/reference
contract для текущего обзора. Протоколы и scalar typing этого среза не заменяют
такое решение.
