# Влияние открытых ontology gaps на граф GitView

Сверка актуального на 14 ноября графа с рабочим draft.10 и границами новых
product terms находится в [отдельном обзоре](specification-alignment-20261114.md).
Таблица ниже сохраняет исторический scope draft.5 и не является текущим
инвентарём деклараций.

Исторический срез: после этой матрицы рабочая композиция переключена с
draft.5 на [draft.6](../candidates/domain-v0.2.0-draft.6/README.md), который
декларирует candidate action удаления. При этом actor/action evidence и
lifecycle принадлежности по-прежнему не установлены.

Рабочая оценка на 14 ноября, по текущим candidate specs и выбранной композиции
`local.gitview.domain@0.2.0-draft-composition.5` (`draft`). Она не утверждает
ontology package, не доказывает готовность графа и не выдаёт candidate review
documents за компилируемые определения. «Не блокирует описание» ниже не
означает готовности конкретного leaf к реализации.

| Предметный gap | Затронутые specs | Можно ли уточнять поведение сейчас | Что требуется до соответствующего утверждения |
| --- | --- | --- | --- |
| Гранулярность `CIStatus`: одна check или aggregate | 0011, 0028, 0041, 0046 | Да: счётчики checks и их coverage уже определяются отдельно от review и threads. | Не объявлять точную типизацию `CIStatus` или готовность source mapping, пока гранулярность и источник не установлены. |
| Смысл `Metric` и контекст значения | 0012–0013, 0029–0030, 0046, 0055 | Да: для отдельного измерения можно описать subject, unit, scope и время, не вводя класс для графика. | Для формального принятия значения и использования в bindings нужно решить значение `Metric`, типы и происхождение конкретных измерений. |
| Удаление Repository из Project как actor/action | 0005, 0025, 0045 | Да: 0025 задаёт результат membership и сохраняет другие Projects. | Нельзя объявить существующим формальный action-derived contract удаления или его историческое отношение, пока способ прекращения membership не определён. |
| `versionControlsCode`: связь и действующая система | 0002, 0005, 0021 | Да: для обзора GitView достаточно различать source identity и membership, не моделируя каждый Git action. | До утверждения происхождения данной связи нужен обоснованный actor/action и смысл возникающего свойства; простого domain/range link недостаточно. |
| Issue, authored Motivation и imported `Motive` | 0010, 0034, 0039, 0051, 0054 | Да: GitView может сохранять авторский текст и тип source link без причинного вывода. | Нельзя утверждать, что `issueMotiveLink` установил мотив конкретного актора или что связь Issue–PR доказывает действие и последствие. |
| Repository identity и адрес | 0002, 0038, 0033 | Да: согласованы continuity, выбранное сравнение numeric REST ID на одном GitHub instance, различение повторно занятого адреса и unknown при 404. | Технические гарантии конкретного source adapter, migration ID и ordering conflicting observations требуют доказательств и не следуют из имени поля. |
| Неполная проекция полей | 0003, 0026, 0044, 0049 | Да: unknown, partial и stale уже можно описывать без новых domain classes. | Достаточность конкретного source scope и typed bindings остаются отдельными обязательствами, не закрытыми `required: false`. |

## Происхождение identity-решений

[Исторический разбор](repository-identity.md) фиксирует ответ `excerpt-54-reply`
о сохранении одной identity при rename/transfer и справедливо указывает, что
формат ID **не выбирался вместе с тем ответом**. Позднее в сохранённом sketch
`excerpt-60-proposal` предложено сравнение numeric REST ID на одном GitHub,
а `excerpt-60-reply` содержит согласие с предложенными правилами. Это отражено
в [0002](../../docs/drafts/GITVIEW-SPEC-0002.yaml) и draft.5. Старый раздел
«технические вопросы остаются» описывает более ранний срез; он не отменяет
позднейшего решения в его ограниченном scope. Локальные excerpt references не
являются аттестованными ID сообщений.

## Приоритет дальнейшей работы

1. Разрабатывать конкретные user-visible контракты, не требующие недоказанных
   actor relationships; явно сохранять unknown и source provenance.
2. Отдельно уточнять формальный смысл CIStatus, Metric и снятия membership до
   утверждения соответствующих ontology bindings; не добавлять классы только
   ради прохождения проверки.
3. Позднее проверить source-specific scope и native behavior там, где они
   меняют acceptance; не делать вывод об их работоспособности по `checked`.

Источники: [аудит полноты](completeness.md),
[CI/review](ci-review-boundaries-candidate.md),
[Metric](metric-meaning-candidate.md),
[Issue/PR](issue-pr-meaning-candidate.md),
[Repository](repository-boundary-candidate.md) и
[удаление membership](remove-repository-action-candidate.md).
