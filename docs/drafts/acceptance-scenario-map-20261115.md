# 0043: карта сценариев приёмки

Авторская навигационная классификация 97 сценариев [0043](GITVIEW-SPEC-0043.yaml) на SHA-256 `4c83f509cb69a8ebce23d6675315b1da4f2faadb9c6200ebcbe4a7b0619c88c8`.
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
- `github_issue_representation_of_pr`
- `partially_approved_github_data_categories`
- `identity_changes_during_inspection_and_refresh`
- `partial_check_capability`
- `address_conflict_recheck`
- `same_id_address_uncertain`
- `local_retention_failure_restart`
- `offline_and_denial`
- `result_after_denial`
- `deferred_and_coalesced_refresh`
- `retry_with_unresolved_conflict`

## История и время

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
- `today_event_with_older_ci`
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

- `stale_source_link_and_later_denial`
- `github_token_rotation_response_lost`
- `share_boundary_then_denial`
- `preview_late_response_after_denial`
- `disconnect_during_credential_replacement`
- `credential_expiry_then_denial`

## Процесс и evidence

- `required_format_unverified_path`
- `cross_cutting_evidence`
- `description_edit_after_assessment`
- `format_and_external_objects`

Следующий проход: проверить пары внутри каждой группы с исходными
родителями, а затем выделить минимальный сквозной набор и сохранить
отдельно уникальные negative cases и их идентификаторы.
