# Ready: ограниченный кандидат и границы

[0125](GITVIEW-SPEC-0125.yaml) — агентский кандидат `idea / pre_canonical`. Исторический срез этой сверки имел SHA-256 `dcd1c4d8381522e762d0c830842534d2e27833d2eae4fe1de01e0034486ea01e`; текущий файл изменён. Фильтр open non-draft сохранён как необязательный кандидат, его включение в выпуск не выбрано. Это не утверждает, что исходное «что готово» уже полностью определено.

| Смысл | Предлагаемое представление | Что не следует из факта |
| --- | --- | --- |
| Завершившийся PR | Merged или closed without merge как разные подтверждённые lifecycle состояния. | Closed without merge не равно merged; текущий state не доказывает событие в выбранном периоде. |
| Закрытая Issue | Closed и отдельно доступная причина, если она подтверждена. | Неизвестная причина не доказывает выполненную работу. |
| PR в review stage | Кандидатная фильтрация **open non-draft**, где оба факта применимы к текущему контексту. | Это не требование review конкретному пользователю, завершённый review, passing CI или возможность merge. |
| Возможность merge | Отдельной процедуры сейчас нет. | Комбинация наблюдаемых counters и approval не заменяет применимые правила, права и source evidence. |

[GitHub описывает draft и переход ready for review](https://docs.github.com/en/pull-requests/how-tos/create-pull-requests/changing-the-stage-of-a-pull-request), а [branch protection](https://docs.github.com/en/repositories/configuring-branches-and-merges-in-your-repository/managing-protected-branches/about-protected-branches) может содержать разнообразные дополнительные условия. Эти страницы не устанавливают availability, permissions или точную реализацию GitView; интерпретация `open non-draft` как отдельной предлагаемой выборки принадлежит агенту.

0110 уже сохраняет unknown для недоступного draft при активном draft restriction; 0092 и 0119 задают независимые origin, selection и coverage. 0125 не утверждает, что соответствующий native filter, source mapping или графическая метрика уже существуют, и требует ограничение, если destination не умеет выразить условие. `next-move --candidate-file` проверяет YAML, kind и ID; ontology-context проверка не является semantic approval или выполнением сценариев. Вопрос первого выпуска и достаточности этой выборки для исходной цели остаётся открытым.
