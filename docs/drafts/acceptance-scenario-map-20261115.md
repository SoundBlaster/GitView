# 0043: карта сценариев приёмки

Авторская навигационная классификация 96 сценариев [0043](GITVIEW-SPEC-0043.yaml) на SHA-256 `9e2311c67ad1afbf13a5d0d377cddd827f30cc6fcfdabeb92a1add0be038bb70`.
Каждый сценарий указан один раз по основной теме; он может проверять и другие ветви.
Это не semantic approval, не доказательство полноты и не выполненные тесты.

## Установленное пересечение

`selected_fields_after_compact_preview` объединял более общие ожидания двух
уже существовавших случаев для PR и Issue. Перед удалением его уникальные
ограничения перенесены в `pr_selected_facts_after_compact_preview` и
`issue_selected_facts_after_compact_preview`: milestone, отсутствие требования
показывать отдельные checks/threads/comments и невыведение мотива из связи.
Прежняя формулировка сохраняется в Git-истории; автоматических ссылок на ID
в текущем рабочем дереве найдено не было.

Другие похожие случаи оставлены: `work_completes` проверяет явное исключение
merged, а `complete_multi_repository_today_journey` — переход и возврат через
два Repository; `offline_and_denial` и `credential_expiry_then_denial`
используют разные исходные причины. Их нельзя считать точными дублями.

При нормализации пробелов и регистра полей given/when/then точных дубликатов
до изменения не найдено; это слабая текстовая проверка, не семантическое
сравнение. Дальнейшая консолидация требует просмотра исходных условий.

## Setup и создание

Содержательная сверка группы с [0022](GITVIEW-SPEC-0022.yaml),
[0045](GITVIEW-SPEC-0045.yaml) и [0108](GITVIEW-SPEC-0108.yaml):

| Обязательство | Сценарии 0043 | Граница сравнения |
| --- | --- | --- |
| Частичный GitHub scope и доступный выбор | `first_setup_partial_github_installation`, `authorization_and_missing_installation` | Первый проверяет сохранение одного default Project и отсутствие наблюдений работы; второй — доступность выбора и сохранность уже существующих Projects. Pending approval не тождественен произвольной неустановленной причине. |
| Поиск и намерение | `discovery_search_and_custom_intent` | Поздний результат другого поиска не подменяет текущий запрос или custom intent; пустая видимая выдача не доказывает пустой источник. |
| Custom Project из общих Repository | `create_custom_project_from_shared_repositories` | Один новый Project не меняет существующие defaults и состав других Projects. Это не default batch. |
| Конкурирующий default | `default_setup_review_changes_in_flight` | Проверяется смена результата *после* review; это отличается от заранее известного default, который повторный setup может переиспользовать по 0022. |
| Смена аккаунта и прерывание записи | `setup_changes_account`, `interrupted_setup_restart` | Первый проверяет неподходящий source account и unsubmitted entry; второй — уже неизвестный исход после перезапуска. Отмена авторизации до создания описана отдельно в 0022. |

Удалять сценарии этой группы по признаку схожего названия не обосновано.
Оценка не устанавливает полноту all-paths setup и не доказывает выполнение
приёмки: источники, durable recovery и native UX требуют собственных проверок.

- `first_setup_partial_github_installation`
- `discovery_search_and_custom_intent`
- `create_custom_project_from_shared_repositories`
- `authorization_and_missing_installation`
- `default_setup_review_changes_in_flight`
- `setup_changes_account`
- `interrupted_setup_restart`

## Project и membership

Содержательная сверка с [0025](GITVIEW-SPEC-0025.yaml),
[0082](GITVIEW-SPEC-0082.yaml), [0084](GITVIEW-SPEC-0084.yaml) и
[0091](GITVIEW-SPEC-0091.yaml):

| Обязательство | Сценарии 0043 | Почему случаи различаются |
| --- | --- | --- |
| Меняется состав при открытом маршруте | `sole_member_replacement_preserves_route_and_scope`, `single_project_expands_while_open` | Замена A на B снимает прежнюю default association и исключает A из текущего scope; добавление B сохраняет A. Оба сохраняют identity открытого объекта, но имеют разный итог membership. |
| Сохранение иных свойств | `project_purpose_across_edit` | Проверяет, что edit состава не изменяет локальное описание назначения или описание GitHub Repository. |
| Membership и default | `membership_readded_after_removal` | Повторное включение R не восстанавливает ранее снятую default association без отдельного действия. |
| Удаление и конкурирующая правка | `project_deletion_review_and_shared_repository`, `project_delete_after_configuration_change` | Первый случай — подтверждённое удаление рассмотренной версии, второй — запрет применить устаревшее подтверждение к новой версии. |
| Конфликт редактирования | `conflicting_project_edits`, `review_conflicting_project_edit` | Сначала stale edit не должен затереть новое состояние; затем отдельное рассмотренное повторное намерение может применить удаление без потери уже добавленного C. |
| Совместное использование | `shared_repository` | Один PR учитывается в каждом Project и один раз в уникальном portfolio; это отдельное правило от изменения состава или удаления. |
| Изменение во время наблюдения и после остановки | `membership_changes_during_refresh`, `restart_after_membership_edit` | Первый случай имеет подтверждённый новый состав и старый in-flight refresh; во втором сам сохранённый состав ещё неизвестен после прерывания. |

В 0082 также есть отдельный случай, когда подтверждённое удаление опережает
старую правку: старый edit не должен восстановить удалённый Project. Его
наличие в дочернем контракте не означает, что он уже выполнен как сквозной
тест 0043. Прямых содержательных дублей среди рассмотренных случаев не
установлено; это не доказывает полноту остальных сочетаний.

- `sole_member_replacement_preserves_route_and_scope`
- `project_purpose_across_edit`
- `single_project_expands_while_open`
- `membership_readded_after_removal`
- `project_deletion_review_and_shared_repository`
- `project_delete_after_configuration_change`
- `review_conflicting_project_edit`
- `conflicting_project_edits`
- `shared_repository`
- `membership_changes_during_refresh`
- `restart_after_membership_edit`

## Source, cache и восстановление

Дополнение: `resolved_pr_association_survives_restart` связывает ранее
раздельные контракты нормализации source representation и устойчивого
восстановления association по 0124. Потерянное подтверждение, восстановленное
evidence и оригинальные времена не заменяют population coverage или текущий
access. Это новый план сквозной проверки, не выполненный тест.

Сверка с [0003](GITVIEW-SPEC-0003.yaml), [0036](GITVIEW-SPEC-0036.yaml),
[0105](GITVIEW-SPEC-0105.yaml), [0112](GITVIEW-SPEC-0112.yaml) и
[0122](GITVIEW-SPEC-0122.yaml) обнаружила одно пересечение:
`partial_check_capability` проверял те же доступные PR/Issue и недоступный CI,
что `partially_approved_github_data_categories`. Условие об отдельно доступном
Issue и обнаруживаемость ограничения сохранены во втором сценарии; прежняя
формулировка сохранена в Git-истории. В текущем дереве иных ссылок на удалённый
ID до изменения не найдено.

Остальные похожие сценарии проверяют разные результаты. В частности,
`retention_recovery_after_restart` допускает последующее подтверждение одного
history sample, `retention_recovery_still_unreadable` запрещает выдумывать
baseline или rollback, а `local_recovery_without_assumed_baseline` проверяет
состояние самого обзора. `address_conflict_recheck` дополнительно проверяет,
что успешный recheck не разрешает конфликт без порядка; `same_id_address_uncertain`
проверяет представление существующего конфликта до такого результата.
`upgrade_and_recover_portfolio` и `unsupported_schema_at_startup` относятся к
поддержанной миграции и неподдерживаемой более новой схеме соответственно.
Это авторская выборочная оценка, не доказательство минимальности всех случаев.

- `discovery_gap_after_scope_and_access_change`
- `portfolio_configuration_recovers_during_refresh`
- `upgrade_and_recover_portfolio`
- `unsupported_schema_at_startup`
- `source_revoked_between_admission_and_save`
- `empty_status_rollup_on_fork`
- `source_labels_do_not_imply_other_facts`
- `preview_reopened_while_old_request_finishes`
- `portfolio_return_with_partial_local_read`
- `retention_recovery_after_restart`
- `retention_recovery_still_unreadable`
- `local_recovery_without_assumed_baseline`
- `resolved_pr_association_survives_restart`
- `github_issue_representation_of_pr`
- `partially_approved_github_data_categories`
- `identity_changes_during_inspection_and_refresh`
- `address_conflict_recheck`
- `same_id_address_uncertain`
- `local_retention_failure_restart`
- `offline_and_denial`
- `result_after_denial`
- `deferred_and_coalesced_refresh`
- `retry_with_unresolved_conflict`

## История и время

Содержательная сверка с [0056](GITVIEW-SPEC-0056.yaml),
[0064](GITVIEW-SPEC-0064.yaml), [0065](GITVIEW-SPEC-0065.yaml),
[0067](GITVIEW-SPEC-0067.yaml) и [0069](GITVIEW-SPEC-0069.yaml):

| Обязательство | Сценарии 0043 | Сохраняемое различие |
| --- | --- | --- |
| Исторический scope | `late_history_for_former_members`, `historical_point_access_and_return` | Поздний ответ на старый состав не заменяет новый; отдельно проверяется ограничение доступа при возврате к точке истории. |
| Долгий review как ограниченный proxy | `aged_comment_signal_navigation_at_new_time`, `aged_comment_with_incomplete_thread_history`, `attention_history_units` | Новый reference time, частичное свидетельство возраста и разные единицы threads/PR — разные условия; возраст комментария не доказывает непрерывную длительность треда. |
| События и календарные периоды | `closure_chart_distinct_period_and_navigation`, `captured_chart_period_after_zone_change` | Повторные закрытия одного Issue не равны разным Issues; сохранённые границы календарных buckets не меняются от смены часового пояса. |
| Повтор и очистка | `history_retry_across_restart`, `clear_then_late_response_and_backfill`, `shared_history_clear_is_explicit` | Lost acknowledgement, запоздавшая работа после clear и раскрытие общего для Projects scope проверяют разные гарантии. |
| Пропущенные данные | `current_refresh_with_missing_history` | Успешное текущее наблюдение и отсутствие сохранённой исторической точки не превращаются в ноль или непрерывный ряд. |
| Закрытие и reopening | `issue_reopens_across_day`, `issue_reopens_missing_closure_time`, `historical_outcome_reopened` | Известное время у границы дня, неизвестное время и самостоятельный недельный исторический фильтр нельзя отождествлять. |

Дословно совпадающих или полностью взаимозаменяемых случаев в этой группе при
данной ручной сверке не установлено. Источник может не предоставить достаточно
истории; наличие формулировок не доказывает source coverage или исполнение.

- `late_history_for_former_members`
- `aged_comment_signal_navigation_at_new_time`
- `aged_comment_with_incomplete_thread_history`
- `attention_history_units`
- `historical_point_access_and_return`
- `closure_chart_distinct_period_and_navigation`
- `captured_chart_period_after_zone_change`
- `history_retry_across_restart`
- `clear_then_late_response_and_backfill`
- `shared_history_clear_is_explicit`
- `current_refresh_with_missing_history`
- `issue_reopens_across_day`
- `issue_reopens_missing_closure_time`
- `historical_outcome_reopened`

## Обзор, фильтры и навигация

Сверка с [0027](GITVIEW-SPEC-0027.yaml), [0031](GITVIEW-SPEC-0031.yaml),
[0042](GITVIEW-SPEC-0042.yaml), [0074](GITVIEW-SPEC-0074.yaml),
[0092](GITVIEW-SPEC-0092.yaml) и [0110](GITVIEW-SPEC-0110.yaml):

| Область | Сценарии и их разные гарантии |
| --- | --- |
| Основной Today | `work_completes` проверяет сохранение 95 merge и явное исключение; `complete_multi_repository_today_journey` добавляет два Repository, preview и возврат; `today_breakdown_changes_without_cohort` проверяет новый объект без фиксации cohort. |
| Фильтр и данные | `check_count_to_changed_project_selection` различает checks и PR при изменении данных; `signal_filter_changed_after_entry` проверяет явное снятие условия; `summary_to_incomplete_destination` не выводит полноту из успешной пагинации. |
| Масштаб и доступность | `dense_grid_zoom_preview_round_trip`, `accessible_dense_grid_equivalent`, `grid_pinch_not_preview` и `targeted_zoom_single_member_return` различают обычное масштабирование, альтернативный путь, конфликт жестов и предложенный переход scope. |
| Предметные детали | `pr_selected_facts_after_compact_preview`, `issue_selected_facts_after_compact_preview`, `partial_issue_discussion`, `issue_link_denied` сохраняют разные поля, ограничения и правила раскрытия. |
| Навигация и focus | `direct_signal_return`, `accessible_focus_after_refresh`, `portfolio_return_after_refresh` и `preview_and_source` различают origin, identity/focus и переход к источнику. |
| Сигналы | `partial_signal_navigation`, `timeout_signal_to_preview`, `review_signal_to_preview`, `old_thread_partial_signal` и `blocked_issue_external_source` проверяют независимые predicate и единицы, а не один общий статус здоровья. |

`today_event_with_older_ci` пересекался с `today_typed_decision_to_overview`:
оба проверяли merged Today при неизвестной применимости CI. В оставшийся случай
перенесены старая revision R1 и её время; одновременно сохранены отдельная
неполнота другого Repository и граница отсутствующего результата policy.
Прежний сценарий доступен в Git-истории; иных ссылок на его ID в текущем
дереве до изменения не найдено. Другие перечисленные случаи намеренно сохранены:
их условия или наблюдаемые результаты различаются. Это не доказательство
полноты всех 31 оставшихся случаев группы или поведения устройства.

- `check_count_to_changed_project_selection`
- `today_typed_decision_to_overview`
- `confirmed_setup_to_offline_work`
- `summary_to_incomplete_destination`
- `today_breakdown_changes_without_cohort`
- `today_partial_refresh_and_membership_change`
- `complete_multi_repository_today_journey`
- `project_summary_at_dense_scale`
- `project_summary_mixed_category_coverage`
- `targeted_zoom_single_member_return`
- `old_thread_partial_signal`
- `signal_filter_changed_after_entry`
- `day_change_denies_uncertain_candidate`
- `issue_link_denied`
- `partial_issue_discussion`
- `pr_selected_facts_after_compact_preview`
- `issue_selected_facts_after_compact_preview`
- `grid_pinch_not_preview`
- `dense_grid_zoom_preview_round_trip`
- `accessible_dense_grid_equivalent`
- `direct_signal_return`
- `accessible_focus_after_refresh`
- `portfolio_return_after_refresh`
- `first_overview`
- `work_completes`
- `preview_and_source`
- `partial_signal_navigation`
- `timeout_signal_to_preview`
- `review_signal_to_preview`
- `blocked_issue_external_source`
- `denied_preview_and_share`

## Доступ и передача

Сверка с [0033](GITVIEW-SPEC-0033.yaml), [0036](GITVIEW-SPEC-0036.yaml),
[0098](GITVIEW-SPEC-0098.yaml), [0114](GITVIEW-SPEC-0114.yaml) и
[0121](GITVIEW-SPEC-0121.yaml): `stale_source_link_and_later_denial` и
`preview_late_response_after_denial` различают устаревшую ссылку и поздний
ответ preview; `share_boundary_then_denial` относится к данным, уже переданным
за пределы приложения. `github_token_rotation_response_lost` касается
неизвестного исхода удалённой rotation, а `disconnect_during_credential_replacement`
— локальной отмены и поздней записи. `credential_expiry_then_denial` отдельно
различает локальное истечение срока и последующий подтверждённый отказ.
Достаточного основания считать их взаимозаменяемыми не найдено.

- `stale_source_link_and_later_denial`
- `github_token_rotation_response_lost`
- `share_boundary_then_denial`
- `preview_late_response_after_denial`
- `disconnect_during_credential_replacement`
- `credential_expiry_then_denial`

## Процесс и evidence

Сверка с [0054](GITVIEW-SPEC-0054.yaml), [0076](GITVIEW-SPEC-0076.yaml),
[0079](GITVIEW-SPEC-0079.yaml) и [0090](GITVIEW-SPEC-0090.yaml):
`required_format_unverified_path` проверяет непокрытый путь создания,
`description_edit_after_assessment` — неприменимость старой оценки к новому
тексту, `format_and_external_objects` — одновременное чтение внешнего Issue и
внешний процесс для PR. `cross_cutting_evidence` относится к границе самих
результатов проверки, а не к формату тела. Эти различия сохраняются.

- `required_format_unverified_path`
- `cross_cutting_evidence`
- `description_edit_after_assessment`
- `format_and_external_objects`

## Начальный набор для содержательного ревью

Это удобный порядок обсуждения, **не минимальное доказанное покрытие** и не
разрешение пропустить другие сценарии или их дочерние условия:

1. Первый вход и Project: `first_overview`, `first_setup_partial_github_installation`,
   `create_custom_project_from_shared_repositories`.
2. Обзор работы: `complete_multi_repository_today_journey`, `work_completes`,
   `dense_grid_zoom_preview_round_trip`, `accessible_dense_grid_equivalent`.
3. Изменение состава и восстановление: `sole_member_replacement_preserves_route_and_scope`,
   `project_delete_after_configuration_change`, `retention_recovery_after_restart`.
4. Данные и доступ: `partially_approved_github_data_categories`, `offline_and_denial`,
   `preview_late_response_after_denial`.
5. Метрики и история: `check_count_to_changed_project_selection`,
   `closure_chart_distinct_period_and_navigation`, `clear_then_late_response_and_backfill`.
6. Переход к источнику и формат: `preview_and_source`, `share_boundary_then_denial`,
   `required_format_unverified_path`.

Каждый маршрут нужно сверять с применимыми родителями, всеми существенными
ограничениями и отдельными уровнями evidence по 0079. Этот список не заменяет
source integration, persistent restart, native accessibility или TDD evidence;
исторические и отложенные ветви сохраняют собственные решения о применимости.

### Применимость и оставшиеся решения

Авторская выборочная сверка с [исходным намерением](../../.specgraph/root_intent.md)
и связанными кандидатами; это не независимое review и не проверка всего графа.

| Маршрут | Уже задано в продуктовых кандидатах | Что препятствует самостоятельной реализации соответствующих листьев |
| --- | --- | --- |
| Первый вход и Project | 0022, 0025, 0099 и 0108 разделяют авторизацию, установку, выбор и сохранение; default и custom intent различны. | Нужны подтверждённые callback/registration и конкретные source permissions, границы secure storage, Project persistence и их согласованные интерфейсы. |
| Обзор работы | 0027, 0031, 0074, 0075 и 0110 задают Today, фильтры, плотность, preview и сохранение контекста. | Нужны выбранные source inputs и способы установить их применимость, интерфейс сборки, а также проверяемая native композиция и доступные действия. 0120 остаётся предложением для перехода между scope. |
| Изменение и восстановление | 0024, 0025, 0082, 0091 и 0105 различают подтверждённый edit, conflict и неизвестный результат и сохраняют реальный origin. | Не определены окончательно provider, физическая схема, сравнение версии, координация и recovery protocol; интерфейсы и гарантии реализации ещё не установлены. |
| Частичный доступ | 0036, 0088, 0100 и 0112 позволяют показывать независимые разрешённые факты, не превращая отказ или неизвестное в ноль. | Нужен mapping выбранных полей и source errors на реальные операции и grants; формальное наличие локального access context не доказывает текущий доступ GitHub. |
| Метрики и история | 0056, 0057, 0067, 0069, 0092 и 0119 различают единицы, событие, наблюдение, период и собственный охват destination. | Нужны implementable source/history mappings, форматы и границы retention, а также согласованный способ строить и проверять каждый выбранный series. Нет гарантии восстановления прошлой истории из GitHub. |
| Source link и формат | 0033, 0076, 0090 и 0121 разделяют собственный link payload, platform handoff и внешний процесс структурного описания. | Не выбран проверенный iOS handoff boundary; внешний процесс ещё не настроен, его path coverage и authority не установлены. GitView не выполняет GitHub writes. |

В каждой строке нужны TDD с подменяемыми зависимостями там, где они есть,
и отдельная применимость accessibility по 0040/0079. Реальные GitHub,
SQLite/Keychain, устройство и assistive experience проверяются на своих
уровнях после реализации; отсутствие их исполнения сейчас не превращается в
положительное evidence. Проектные решения агента остаются предложениями,
а не автоматически утверждёнными пользователем деталями.
