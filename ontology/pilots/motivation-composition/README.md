# GitView: пилот композиции Motive

Это отдельный **draft-пилот** после [SpecGraph PR #855](https://github.com/0al-spec/SpecGraph/pull/855). Он проверяет явную
композицию существующего словаря GitView и двух общих Ontology packages. Он не
принимает онтологию, не меняет canonical specs и не включает gate.

Обновление после PR #858 и анализ служебных предупреждений `sgcore`:
[отдельный отчёт](../../../docs/drafts/sgcore-applicability-0f0a056a.md).
Результаты ниже сохранены как история пилота для конкретных runtime-версий.

## Состав

| Участник | Версия | Статус и происхождение |
| --- | --- | --- |
| `local.gitview.domain` | `0.2.0-pilot.1` | Кандидат, полученный из [основного draft 0.1.0](../../packages/gitview/domain-ontology-package.yaml) с SHA-256 `c869adb2c0188dfc9eba1f8ccc419791588117137586f0e69a144c4ea89bc1bc`. |
| `org.0al.motivation.core` / `motivcore` | `0.1.0` | Неизменённая копия draft package Ontology 0.5.0. |
| `org.0al.events.core` / `eventcore` | `0.2.0` | Неизменённая копия draft package Ontology 0.5.0 из `versions/0.2.0`. |
| `specgraph.foundation` / `sg` | `0.1.0` | Закреплённый каталог foundation, предоставляемый профилем SpecGraph. |

Точные источники и хеши двух импортированных пакетов указаны в
[`dependencies/origins.json`](dependencies/origins.json); их MIT license
сохранена в [`dependencies/LICENSE`](dependencies/LICENSE). Из compiler output
в Git добавлены только нормализованные IR, необходимые для воспроизводимого
выбора контекста; SDK и отчёты остались на TB5.

Проектный кандидат отличается от 0.1.0 только версией, прямым импортом
`motivcore` и экспериментальной декларацией `issueMotiveLink`:

```text
Issue ── кандидатная типизированная ссылка ──→ motivcore:Motive
```

Это проверка выразимости ссылки на **существующий** `Motive` без локального
дубликата. Синтаксическое поле compiler `relations` здесь не доказывает
действие Issue, отношения в пользовательском смысле или причинность. Сама
декларация не указывает актора, действие, объект, PR, источник подтверждения или
конкретный мотив. Подходит ли такое представление для нашей цепочки «Issue —
мотив → актор — меняет → Code → последствие PR», ещё нужно решить.
Источник этой цепочки — локальные ссылки `conversation:gitview/excerpt-22` и
`conversation:gitview/excerpt-23` в SpecDraft sketch; конкретная YAML-связь
является предложением агента для пилота, а не утверждённой пользователем моделью.

## Выбор и проверка

[`context.yaml`](context.yaml) выбирает проектный кандидат и обе зависимости по
точным source/IR SHA-256 с профилем `ontologyc-motivation-composition-v1`.
Основной `ontology/context.yaml` остаётся выбранным по умолчанию и не изменён.
Он также проверен новым runtime и release-компилятором: `verified`, exit 0.

```sh
specgraph-runtime --workspace /path/to/GitView ontology-context -- \
  --selection ontology/pilots/motivation-composition/context.yaml \
  --ontologyc /path/to/ontologyc --compiler-sha256 <sha256-исполняемого-файла>
```

Наблюдение 1 ноября 2026 года: runtime SpecGraph commit `8e39d784` и
macOS arm64 `ontologyc` [Ontology 0.5.0](https://github.com/0al-spec/Ontology/releases/tag/0.5.0) проверили все три пакета и composition closure:
`verified`, exit 0. Release archive SHA-256
`83d99b865b0979450a47998438eb1ff07229f2142e0658d8acd24765b69a2079`
совпал с метаданными GitHub release и `ontologyc-SHA256SUMS`. SHA-256
использованного executable:
`dcdc37216246f9acebca7387e14b61300d9dec4367f7c1630445b97280c80168`.
Он воспроизвёл все три сохранённых IR побайтно; foundation export совпал с
каталогом, закреплённым в runtime.
Имя `motivcore:Motive` разрешилось в
`ontology://org.0al.motivation.core/0.1.0/classes/Motive`. Отчёт содержит 178
проверок, `semantic_approval: not_established` и
`canonical_mutations_allowed: false`. Несмотря на сравнение release archive,
сам отчёт SpecGraph сохраняет `compiler_provenance: not_verified`: он не
проверяет подпись или соответствие бинарника исходникам.

Контроли выполнялись на отдельных копиях, не изменяя рабочий пакет:

| Контроль | Наблюдение |
| --- | --- |
| `motivcore:UnknownMotive` с заново собранным release compiler IR | `invalid`, exit 2; указан путь и неизвестное имя. |
| Неверная версия прямого импорта | `invalid`, exit 2; несовместимый импорт. |
| Отсутствует выбранный `events-core` | `invalid`, exit 2; отсутствующая зависимость. |
| Нет executable `ontologyc` | `unavailable`, exit 1. |
| Поменять порядок участников selection | `verified`; context revision не изменилась. |
| Совместный inventory для synthetic spec | Контекст `verified`, но target и inventory `unavailable`: `multiple-member inventory is unsupported`. |

Проверка `ontologyc check` и компиляция прошли отдельно для каждого из трёх
пакетов. Вместе с этим composition проверяет замыкание и разрешение имён;
она не проверяет смысл естественного языка, реальные графы экземпляров или
готовность PR. Исходные файлы, SDK, полный отчёт и отрицательные контроли этого
запуска сохранены на TB5:
`/Volumes/TB5/Developer/Builds/GitHub/GitView-a40d73ccf162f8d8/ontology/motivation-composition-je20hetf/`.

## Повторная проверка project spec ID после [PR #856](https://github.com/0al-spec/SpecGraph/pull/856)

На runtime `8e39d784` target-scoped Supervisor отклонил отдельный synthetic
файл `GITVIEW-SPEC-0001.yaml` с exit 2 и сообщением
`--target-spec must be SG-SPEC-NNNN`. После обновления до `710c4f60` тот же
файл, побайтно совпадающий с исходным контрольным примером, был повторно
проверен в отдельных временных workspace на TB5. В каждый также скопирована
реальная политика `.specgraph/spec-id-policy.json` с префиксом `GITVIEW-SPEC`.

| Контекст | Результат для `GITVIEW-SPEC-0001` |
| --- | --- |
| Основной `ontology/context.yaml` | ID принят, context `verified`, target `checked`, inventory `analyzed`, exit 0. |
| Композиция из этого пилота | ID принят, context `verified`; target и inventory `unavailable`, exit 1, поскольку совместный multi-member inventory пока не поддержан. |

Это проверка **synthetic** файла, а не созданная или утверждённая спецификация
GitView. Дополнительный synthetic контроль с перечисленными терминами дал
`Project`, `Repository`, `Issue`, `PullRequest` и `Metric` как кандидатов
совпадения, а намеренно добавленный `Group` — как неизвестный термин. Проверки
не изменили исходный файл или политику ID; смысл терминов не утверждён.
Несовпадение ID в имени и YAML и недопустимый путь были отдельно отклонены с
exit 2. Полные отчёты и контрольные данные сохранены на TB5:
`/Volumes/TB5/Developer/Builds/GitHub/GitView-a40d73ccf162f8d8/ontology/gitview-target-retest-710c4f60/`.

## Проектный черновик после [PR #857](https://github.com/0al-spec/SpecGraph/pull/857)

У GitView ещё не было spec-файла: предыдущий `GITVIEW-SPEC-0001` был только
synthetic fixture. Для этой проверки создан содержательный
[проектный черновик](../../../docs/drafts/GITVIEW-SPEC-0001.yaml) по root intent,
discovery и сохранённым заметкам. Его ID предварительный, он не принят и не
перенесён в канонический граф. `spec_yaml_lint.py` установленного runtime
прошёл; этот lint не проверяет полноту или правильность содержания.

Побайтовая копия черновика с SHA-256
`56fd32cf5118687e2b14d8058fa35ca644e19b91f67b2091bb09b5fcd3ca7d4f`
помещалась в `specs/nodes/` только **изолированных** workspace на TB5: сейчас
target-scoped check читает именно этот путь. Каждый workspace получил реальные
project ID policy и выбранные файлы онтологии. Использован тот же release
`ontologyc` и SHA-256, что указаны выше.

| Runtime и контекст | Результат для одинакового черновика |
| --- | --- |
| `710c4f60`, составной | Context `verified`, target и inventory `unavailable`, exit 1. |
| `54db6fb9`, составной | Context `verified`, target `checked`, bundle и inventory `analyzed`, exit 0. |
| `54db6fb9`, основной | Context `verified`, target `checked`, bundle и inventory `analyzed`, exit 0; см. ограничение для `motivcore` ниже. |

В составном контексте inventory нашёл 10 совпадений имён с проектным пакетом
`local.gitview.domain` `0.2.0-pilot.1` как `spelling_candidate`, разрешил
`motivcore:Motive` из `org.0al.motivation.core` `0.1.0` как
`structurally_resolved_candidate` и оставил `Activity` как `unknown`. `Activity`
здесь обозначает используемое в discovery слово, а не автоматически новую
доменную сущность. Для каждого кандидата отчёт сохраняет происхождение и версию
пакета. В `validation_report` при этом **четыре warning**: отсутствует binding
`sgcore:Spec`, неизвестны служебные `spec` и `node`, а также `Activity`. Пакет
`sgcore` не выбран в этом проектном контексте. Имя `accepted_bindings` в legacy
binding index не означает семантическое принятие; весь отчёт `report_only`.

### Наблюдение для SpecGraph

Основной контекст не включает `motivcore`: его inventory корректно показывает
`motivcore:Motive` как `unknown`. При этом для **того же** файла в single-member
binding index и validation report эта ссылка не появляется ни в bindings, ни в
gaps/findings. Результат остаётся `checked` с четырьмя перечисленными выше
warning. При отдельном отрицательном контроле в составном контексте замена на
`motivcore:DefinitelyMissing` дала `unknown` в inventory, `missing_ontology_ref`
в binding index и дополнительный warning в validation report; target и тогда
остался `checked`. Контроль менял только отдельную копию файла на TB5.

Это расхождение важно при просмотре отдельных частей отчёта: отсутствие ссылки
в single-member validation не доказывает, что она разрешена. Общий результат
`checked` подтверждает выполнение advisory-процесса, не отсутствие gaps и не
семантическое соответствие. Prose не анализируется, `semantic_approval` остаётся
`not_established`, `full_spec_conformance` — `not_assessed`, canonical mutation
и активация policy не разрешены. Переход к составному контексту по умолчанию не
производился.

Для воспроизведения нужен установленный runtime `54db6fb9`, проверенный выше
`ontologyc` и новый пустой `SCRATCH` на TB5. Команда ниже показывает
single-member расхождение; чтобы повторить составной вариант, замените путь
selection на `ontology/pilots/motivation-composition/context.yaml`:

```sh
PRODUCT=/Users/egor/Development/GitHub/GitView
SPECGRAPH=/Users/egor/.local/share/specgraph/runtime-54db6fb9/specgraph-runtime
SCRATCH=/path/to/a/new/empty/tb5-workspace
ONTOLOGYC=/path/to/ontologyc-0.5.0-macos-arm64/ontologyc
mkdir -p "$SCRATCH/.specgraph" "$SCRATCH/specs/nodes"
cp -R "$PRODUCT/ontology" "$SCRATCH/ontology"
cp "$PRODUCT/.specgraph/spec-id-policy.json" "$SCRATCH/.specgraph/"
cp "$PRODUCT/specgraph.project.yaml" "$SCRATCH/"
cp "$PRODUCT/docs/drafts/GITVIEW-SPEC-0001.yaml" "$SCRATCH/specs/nodes/"
"$SPECGRAPH" --workspace "$SCRATCH" supervisor -- \
  --build-project-ontology-context-check --ontology-context-project-id gitview \
  --target-spec GITVIEW-SPEC-0001 --ontology-context-selection ontology/context.yaml \
  --ontologyc "$ONTOLOGYC" \
  --ontologyc-sha256 dcdc37216246f9acebca7387e14b61300d9dec4367f7c1630445b97280c80168 \
  --output-mode full > "$SCRATCH/report.json"
```

Отчёты всех четырёх прогонов и проверенные входные hash сохранены на TB5:
`/Volumes/TB5/Developer/Builds/GitHub/GitView-a40d73ccf162f8d8/ontology/gitview-real-spec-check-54db6fb9-utcdqqc5/`.
Они являются локальными диагностическими результатами, а не резервной копией
проектных заметок.
