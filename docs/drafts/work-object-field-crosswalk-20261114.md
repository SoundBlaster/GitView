# GitView: выбранные поля PR и Issue по уровням просмотра

Основа — выбор владельца для [PR](pull-request-ontology-options.md) и
[Issue](issue-ontology-options.md). Приведённые уровни не требуют помещать все
поля в каждый квадрат и не добавляют просмотр diff, отдельных проверок,
комментариев или review thread contents.

| Поле | Где доступно | Граница значения |
| --- | --- | --- |
| Тип, Repository, номер и title | Компактная клетка показывает то, что помещается; полный разрешённый контекст доступен через accessibility, preview и overview. | Номер уникален только в Repository; неизвестная identity не заменяется совпавшим названием. |
| Описание и источник | Preview может показать короткий оригинальный excerpt; полное доступное описание и source action — в overview. | Авторская `Validation` не равна наблюдаемому CI; отсутствующий раздел не дописывается. |
| Lifecycle, draft, labels, Issue type/reason | Подходящие признаки видны в preview; весь доступный выбранный набор — в overview. | Draft и lifecycle PR различны; закрытая Issue не обязательно completed. |
| Автор, assignees/reviewers, ветки и revision | В overview; preview может показать подмножество. | Роли не делают человека User или coding agent; имя head branch само по себе не подтверждает существование ref. |
| Связанные PR/Issues, direct children, blockers, milestone | Доступные endpoints и их смысл — в соответствующем overview. | Mention не доказывает closing link или мотив; неполная связь не является пустой. |
| CI: red/yellow/green/total | Счётчики доступны в PR overview, выбранные сигналы — в preview, компактный CI tone — в PR cell. | Считаются актуальные отдельные проверки в установленном revision context; skipped/neutral и другие special outcomes не превращаются в успешное выполнение. Недоступное не равно нулю. |
| Review assessment, total/unresolved thread counts | Независимые факты доступны в PR overview и, при наличии места, в preview; клетка может нести краткий review mark. | Changes requested может существовать без unresolved thread; ноль threads не доказывает approval. |
| PR additions/deletions, files, commits | Раздельные счётчики в PR overview; необязательное подмножество в preview. | Без file list, commit list или diff. Старое измерение не становится новым от обновления title. |
| Issue comments/participants, direct children/closed children | Независимые счётчики в Issue overview, часть может быть в preview. | Комментарии не review threads, а `completed` из source summary нельзя без доказательства заменить на количество всех closed children. |
| Creation/update/close/merge, observation, last comment | Соответствующие известные времена доступны в overview и при необходимости preview. | Событие, последнее обновление объекта и время наблюдения — разные значения; source update не равен последнему комментарию. |

Все поля отдельно сохраняют источник, доступность, coverage и применимый
временной или revision context. Known zero, частичные данные, неизвестность и
ограниченный доступ нельзя сводить к одному значению. Доступный overview
остаётся маршрутом ко всем выбранным разрешённым фактам, даже если плотная
сетка и preview показывают только часть. Этот документ сверяет содержание
кандидатов и не устанавливает доступность полей в конкретном GitHub response.
