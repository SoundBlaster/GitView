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

## Кандидат публичной границы

[0126](GITVIEW-SPEC-0126.yaml) SHA-256 `64749791be985000b54f6318efb437e1c5f69839a0703ce8f3d73d0b2c194c7f` уточняет три логические операции: сохранить один связанный факт, прочитать область с независимыми ограничениями и согласовать прежнюю операцию. Он разделяет immutable intent и источник, cache и history outcomes, чтение и текущий доступ, результат прошлой операции и фактическую доступность записи. Это не обязательство создавать ровно три метода и не выбор Swift API.

[0043](GITVIEW-SPEC-0043.yaml) зависит от этого уточнения как потребитель сквозной приёмки; карта его сценариев проверяется отдельно. Выбор конкретных сигнатур, сериализации, provider, локальной координации и миграций остаётся необходимым до реализации; YAML-сценарии и structural checks не являются TDD или restart evidence.

## Сборка Today

[0115](GITVIEW-SPEC-0115.yaml) SHA-256 `f5621aa9309e6d878ab45821bc5d0730c70e2789a5cae87f86a1c3a4bd9a10e5` явно зависит от 0126 и обрабатывает applied, rejection, conflict и indeterminate отдельно от source и coverage. Исправлена двусмысленность 0126: storage operation не делает сетевой запрос, тогда как higher-level caller может запустить отдельный refresh вне storage transaction. Сценарий обработки cache и history outcomes описан, но не исполнялся. Конкретные Swift APIs, provider, concurrency и device behavior остаются открытыми.
