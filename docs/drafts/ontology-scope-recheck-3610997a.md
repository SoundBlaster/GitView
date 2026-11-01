# GitView: повторная проверка после разделения domain и meta

Статус: локальная проверка, не принятие спецификации или онтологии.
SpecGraph [PR #860](https://github.com/0al-spec/SpecGraph/pull/860) зафиксировал
предложение по областям проверки; [PR #862](https://github.com/0al-spec/SpecGraph/pull/862)
реализовал их разделение. Установлен отдельный native runtime commit
`3610997a9555a6347a23f9980f5b87eb95bbbf14`; прежний `0f0a056a` сохранён.

Проверена побайтовая копия реального черновика
[GITVIEW-SPEC-0001](GITVIEW-SPEC-0001.yaml), SHA-256
`56fd32cf5118687e2b14d8058fa35ca644e19b91f67b2091bb09b5fcd3ca7d4f`,
с реальной project ID policy и выбранными пакетами. Копия помещалась в
`specs/nodes/` только изолированных workspace на TB5: target-scoped check
ожидает этот путь. Черновик и ontology selection GitView не изменялись и не
были перенесены в канонический граф. Использован ранее проверенный release
`ontologyc` 0.5.0 с SHA-256
`dcdc37216246f9acebca7387e14b61300d9dec4367f7c1630445b97280c80168`.

## Обычный запрос: domain vocabulary

Оба runtime проверяли один и тот же файл в одном и том же workspace для
каждого контекста. На новом runtime в обоих контекстах context `verified`,
target `checked`, domain `analyzed`, meta `not_requested`. Старый отчёт
смешивал domain и structural findings; новый считает только domain warnings.
Поэтому разница в числах отражает изменение области проверки, а не устранение
проверенных ошибок metamodel.

| Контекст | `0f0a056a` | `3610997a` | Остаются в domain inventory и validation |
| --- | --- | --- | --- |
| Основной `ontology/context.yaml` | 5 warnings | 2 warnings | `Activity`, `motivcore:Motive` |
| Составной pilot | 4 warnings | 1 warning | `Activity` |

`motivcore:Motive` неизвестен основному контексту, поскольку тот не включает
motivation-core. В составном контексте ссылка разрешается как структурный
кандидат. `Activity` встречается в discovery и остаётся неизвестным словом;
это не означает, что его необходимо оформлять отдельной сущностью.
Три прежних служебных `sgcore` warning больше не попадают в domain findings.

## Явный запрос metamodel и свежесть отчётов

- При запросе **обоих** scope в обоих контекстах domain остаётся `analyzed`
  со своими findings, а metamodel и общий target — `unavailable`: источник,
  применимость и поддерживаемая проверка metamodel ещё не установлены.
- При запросе **только** metamodel в составном контексте target `unavailable`,
  domain `not_requested`, inventory и domain binding/validation отсутствуют.
- Для обоих контекстов явное сравнение со старым combined report возвращает
  `previous_freshness: unavailable` с диагностикой `scoped advisory bundle
  version unavailable`. Старые отчёты надо пересчитать; это не `fresh`.
- Повторение нового domain-прогона с теми же входами даёт `fresh` для
  **binding/validation bundle**. Свежесть предыдущего inventory остаётся
  `not_assessed`, независимо от текущего пересчитанного inventory.

`checked` означает завершение запрошенного advisory scope. Он не подтверждает
отсутствие gaps, корректность свободного текста, семантическое утверждение,
применимость metamodel или реализацию приложения. Составной контекст остаётся
пилотным и не выбран по умолчанию.

## Воспроизведение

Полные отчёты и входные hash сохранены на TB5:
`/Volumes/TB5/Developer/Builds/GitHub/GitView-a40d73ccf162f8d8/ontology/gitview-scoped-check-3610997a-jletnm2t/`.
В `default/` и `composition/` находятся `old.json`, `new.json` и `both.json`;
дополнительно в первом — `fresh.json`, во втором — `meta.json`. `summary.json`
содержит проверенные результаты. Эти диагностические каталоги не являются
резервной копией заметок.

Например, повторный запрос обоих scope в сохранённом составном workspace:

```sh
SPECGRAPH=/Users/egor/.local/share/specgraph/runtime-3610997a/specgraph-runtime
WORKSPACE=/Volumes/TB5/Developer/Builds/GitHub/GitView-a40d73ccf162f8d8/ontology/gitview-scoped-check-3610997a-jletnm2t/composition
ONTOLOGYC=/Volumes/TB5/Developer/Builds/GitHub/GitView-a40d73ccf162f8d8/ontology/motivation-composition-je20hetf/release-0.5.0/ontologyc-0.5.0-macos-arm64/ontologyc
"$SPECGRAPH" --workspace "$WORKSPACE" supervisor -- \
  --build-project-ontology-context-check --ontology-context-project-id gitview \
  --target-spec GITVIEW-SPEC-0001 \
  --ontology-context-selection ontology/pilots/motivation-composition/context.yaml \
  --ontology-context-check-scope domain_vocabulary \
  --ontology-context-check-scope specification_metamodel \
  --ontologyc "$ONTOLOGYC" \
  --ontologyc-sha256 dcdc37216246f9acebca7387e14b61300d9dec4367f7c1630445b97280c80168 \
  --output-mode full > "$WORKSPACE/recheck-both.json"
```

Для этого запроса exit 1 ожидаем: metamodel `unavailable`, при этом domain
данные сохраняются в JSON.
