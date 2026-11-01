# GitView: пилот композиции Motive

Это отдельный **draft-пилот** после [SpecGraph PR #855](https://github.com/0al-spec/SpecGraph/pull/855). Он проверяет явную
композицию существующего словаря GitView и двух общих Ontology packages. Он не
принимает онтологию, не меняет canonical specs и не включает gate.

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

## Ограничение для будущих спецификаций GitView

Текущий target-scoped Supervisor принимает только `SG-SPEC-NNNN`. На отдельном
synthetic файле с ID `GITVIEW-SPEC-0001`, соответствующим
`.specgraph/spec-id-policy.json`, команда вернула exit 2 и
`--target-spec must be SG-SPEC-NNNN`. Это отдельное от отсутствующего
multi-member inventory ограничение; настоящие узлы GitView пока не создавались.
