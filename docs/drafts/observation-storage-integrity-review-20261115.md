# Хранение и восстановление observation evidence

Авторская сверка [0105](GITVIEW-SPEC-0105.yaml), [0113](GITVIEW-SPEC-0113.yaml), [0114](GITVIEW-SPEC-0114.yaml), [0122](GITVIEW-SPEC-0122.yaml), [0123](GITVIEW-SPEC-0123.yaml) и [0124](GITVIEW-SPEC-0124.yaml). Проверенный 0123 имеет SHA-256 `07f242237bee696a6c1199a18c9c1ea8410305f53b940d5abd97e11671e13637`; все документы — `idea / pre_canonical`.

| Граница | Что требуется сохранить или установить | Остаётся до реализации |
| --- | --- | --- |
| Subject и источник | Typed identity и source instance, подтверждённая связь с Repository и конкретным полем или событием; неподтверждённый alias остаётся неопределённым. | Точное кодирование и source-specific доказательства association. |
| Значение и время | Значение или поддержанное source absence связано с собственным observation context; event time, observation time и local commit time не взаимозаменяемы. | Физическая schema, теги, ограничения и migrations. |
| Согласованность ссылок | Новое уточнение: существование foreign key или записи контекста не подтверждает, что контекст относится к тому же source observation, субъекту и соответствующей Repository association. | Проверяемые операции provider и конкретные consistency constraints, включая случай смены Repository association во времени. |
| Доступ | Сохранённый account context описывает происхождение; текущая eligibility определяется отдельно. Отдельные границы SQLite и Keychain не считаются атомарными. | Выбрать и проверить file protection, backup и точный порядок согласования данных и credential. |
| Coverage и исход | Coverage, source attempt, retention outcome и progress восстанавливаются независимо; receipt не заменяет читаемый факт. | Реальный crash/restart, provider errors, схема и evidence для полноты конкретного источника. |

Сценарий в 0123 описывает ошибочно связанную запись контекста при совпадении номера и времени, сохраняя отдельный допустимый CI fact. Он не выполнялся. Наличие логической модели и структурного `checked` не доказывает semantic consistency, свойства SQLite/Keychain или implementation readiness. Оценивать хранение целиком можно только после решений о физической схеме, миграциях и координации доступа, перечисленных в соответствующих specs.
