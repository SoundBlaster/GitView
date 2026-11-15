# Project validity: оценка leaf 0111

Авторская сверка [0111](GITVIEW-SPEC-0111.yaml) SHA-256 `cd71754b50b5129fa74da1d5552e6b3e3c7cee876adce86ebc59945492178212`
с 0025, 0084, 0104 и 0112. Статус — `idea / pre_canonical`; это не
независимое review и не разрешение реализации до готовности предков.

| Граница | Что описано | Что ещё нужно определить или проверить |
| --- | --- | --- |
| Вход | Proposed name и optional purpose, состав, подтверждённые и неизвестные identities, access, базовая конфигурация и default association. | Выбрать согласованные типы и интерфейсы с source и storage, определить применимость evidence. |
| Результат | Valid, invalid или insufficient evidence; подтверждённое нарушение не скрывает отдельный unknown. | Согласовать конкретный typed result и SpecificationCore version; неожиданный no-result остаётся integration limitation. |
| Дубликаты | Подтверждённо одинаковые references дают одно membership; разные или неразрешённые identities не объединяются по имени. Valid proposal передаёт нормализованный состав. | Проверить фактическое source association и coordinated storage; валидность не означает успешную запись. |
| Default и конкурентность | Удаление default member предлагает отдельный association effect; stale base не разрешает overwrite. | Конкретные preconditions, транзакции и восстановление по 0104 требуют выбранного provider и отдельных проверок. |
| Имя и purpose | Предложен фиксированный Unicode whitespace rule; текст сохраняется без неявного trimming, clear и unknown различаются. | Review допустимости невидимых символов, text-entry и хранения, migration старого empty purpose. |

Новый сценарий проверяет предложенную логическую нормализацию двух подтверждённо
одинаковых references до одного membership; сохранение и source identity он не
исполняет. Поведенческие TDD и проверка durable restart остаются будущей работой.
