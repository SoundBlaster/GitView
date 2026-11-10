# GitView ontology draft.5 — членство и типизированная ссылка

Рабочая композиция GitView. Основа — draft.4, который сохранён как контроль.
Пакет остаётся `draft`; смена selection и структурная проверка не означают,
что каждое возможное техническое уточнение завершено.

## Изменения

- `User → AddRepository(repository: Ref<Repository>) → Project` указывает
  на существующий Repository типизированной ссылкой. Это тот же объект,
  а не копия репозитория. Успешная проверка типа не означает, что экземпляр
  найден: разрешение ссылки остаётся ответственностью приложения.
- `ProjectMembershipScope` фиксирует состав из одного или нескольких
  GitHub-managed repositories, возможность членства одного Repository в
  нескольких Projects, состав из разных organizations и default 1:1.
- `RepositoryIdentityContinuity` фиксирует выбранное правило числового
  GitHub REST ID в пределах одного GitHub instance, rename/transfer, повторное
  использование адреса и unknown при HTTP 404. Технический local key открыт.
- Существующие `projectIncludesRepository`, `pullRequestRepository` и
  `issueRepository` сохранены без дублирования. Происхождение каждого
  исторического членства и порождающее действие `versionControlsCode`
  не выдуманы.

## Toolchain и проверка

10 ноября 2026 выполнен fetch обоих origin; SpecGraph checkout и установленный
runtime соответствовали `8303a681d8f2b33989b004de6954dc371c86da51`,
Ontology checkout — `4c5027b`. Компилятор собран из этого checkout с SwiftPM,
с scratch и cache на проверенном TB5; его SHA-256 —
`30dd324aa1f641e7274a49fd6f158cced5ed95d810b6b275353d3d10f19a27cb`.
Это локальная сборка, а не независимо подтверждённый release binary.
Путь установлен в локальный `gitview.ontologyc`; предыдущий compiler
сохранён. Старый 0.7.0 не поддерживает `type: ref` и `target`.

Оба варианта package прошли `ontologyc check` без диагностик и `compile`.
Установленный runtime проверил оба context: `verified`, semantic approval не
устанавливается. Проверен generated SDK для обоих вариантов: strict TypeScript,
схема отклоняет неправильный target и отсутствующее поле; две формы известной
ссылки разрешаются, неизвестные ссылки не меняют членство в тестовом consumer.
Это не проверка приложения GitView.

В отдельном workspace все 18 существующих spec drafts проверены на
`domain_vocabulary`: 18 `checked`, ранее существовавшее предупреждение
`GitView` в 0001 сохраняется; прочих findings/gaps нет. Отчёты относятся к
снимку до переключения selection в `specgraph.project.yaml`; после переключения
повторно проверяются изменённые узлы. Полные временные отчёты и SDK-прогон —
на TB5, не являются резервной копией данных.

## Воспроизведение

```sh
COMPILER="$(git config --get gitview.ontologyc)"
RUNTIME=/Users/egor/.local/share/specgraph/runtime-3593bd75/specgraph-runtime
"$COMPILER" check ontology/candidates/domain-v0.2.0-draft.5/domain-ontology-package.yaml
"$COMPILER" check ontology/candidates/domain-v0.2.0-draft.5/composition/domain-ontology-package.yaml
"$RUNTIME" --workspace "$PWD" ontology-context -- --project-id gitview \
  --selection ontology/candidates/domain-v0.2.0-draft.5/composition-context.yaml \
  --ontologyc "$COMPILER" \
  --compiler-sha256 30dd324aa1f641e7274a49fd6f158cced5ed95d810b6b275353d3d10f19a27cb
```

Если бинарник отсутствует или его SHA-256 изменился, воспроизвести сборку из
зафиксированного checkout на TB5 и явно обновить привязку: путь к бинарнику
сам по себе не доказывает происхождение. Draft.4 и его старые pins остаются
доступны для сравнения.
