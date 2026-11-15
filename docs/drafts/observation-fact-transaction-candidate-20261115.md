# Наблюдение: кандидат SQLite-границы записи одного факта

Авторское предложение к [0123](GITVIEW-SPEC-0123.yaml), [0126](GITVIEW-SPEC-0126.yaml), [0113](GITVIEW-SPEC-0113.yaml); `idea / pre_canonical`. Ограниченный срез — один уже нормализованный факт существующего подтверждённого work subject. Это не полная схема приложения, не миграция, не готовый SQL и не подтверждённое поведение SQLite на iOS.

## Логические записи и инварианты

| Запись | Минимальная информация | Ограничение |
| --- | --- | --- |
| Observation context | Локальный opaque context reference; source instance, подтверждённая account/Repository association, source attempt и interpretation context; фактически поддержанные времена, revision и scope. | Контекст от другой попытки или account не подставляется из-за совпадения времени или имени. Один контекст может разделяться только между фактами, которым он действительно соответствует. |
| Field or event fact | Локальный opaque fact reference; confirmed typed subject и Repository association; значение field/event meaning и версии интерпретации; ссылка на context; tagged supported value либо supported semantic absence. При событии — источник event identity и event time либо их явное ограничение. | Несовместимые tag/payload/context не принимаются как факт; отсутствие записи, пропущенное поле и ошибочный null не становятся semantic absence. Несколько наблюдений сохраняют свои контексты. |
| Retention operation | Opaque operation ID, полная неизменяемая привязка intent к субъекту, факту, контексту, запрошенному эффекту и applicable generation; подтверждённый исход. | Один operation ID не может быть успешно применён к несовместимому intent. Digest может помогать поиску, но сам по себе не заменяет проверку полного binding. |
| Admission fence | Подтверждённая локальная generation connection/access и, для исторического эффекта, history-clear generation и версия схемы, которые применимы на commit boundary. | Старый контекст не отменяет более новую локально установленную блокировку; fence не подтверждает неизвестное изменение прав на сервере. |

`Unknown`, `not requested`, source field error и отсутствие durable record не являются фактами типа semantic absence. Если принято хранить safe limitation, для неё создаётся отдельный связанный с source attempt результат и собственная операция; конкретная permission-причина и raw private response не выдумываются. Logical references, exact source ID, event identity и context обязаны round-trip без lossy conversion; для Repository numeric ID уже предложена decimal text representation в 0123. Другие кодировки и размерные ограничения пока не выбраны.

## Предлагаемая атомарная операция

1. За пределами write transaction source adapter проверяет supported interpretation и собирает immutable intent без токенов, raw authorization и лишнего source payload. Caller идентифицирует cache и/или history effects, не выдавая один за другой.
2. На каждом используемом SQLite connection до транзакции устанавливаются и проверяются выбранные integrity settings; в частности, если схема полагается на foreign keys, их enforcement включается и проверяется на этом connection по 0123.
3. В одном local transaction для **одного выбранного эффекта** проверить schema и актуальные локальные admission fences, проверить существующий operation ID и полный binding, проверить обязательные reference и совместимость существующего context, записать недостающие допустимые context/fact references и terminal applied outcome. Не передавать сеть, Keychain или UI внутрь транзакции. Другие факты того же ответа, coverage и отдельный history effect не считаются атомарно подтверждёнными этим commit.
4. При уже подтверждённом compatible binding вернуть прежний результат без нового source observation или второго эффекта. При доказанно несовместимом binding вернуть conflict без замены старого intent. Не использовать arrival time для разрешения несовместимых source фактов.
5. Сообщить applied только после поддержанного commit и необходимого durable binding. Если commit мог произойти, но outcome не установлен, вернуть indeterminate и сверить ту же операцию через recoverable evidence. Нельзя объявить rollback только по потере acknowledgement или создать новый конкурирующий intent, пока исход может проявиться позднее.

Согласованное чтение после restart должно независимо извлечь субъект, факт, контекст и необходимые association evidence; receipt описывает прошлый эффект и не доказывает текущее чтение, source access или наличие истории. При недоступном необходимом evidence соответствующая claim остаётся ограниченной; другие корректно восстановленные факты не обязаны исчезать. Before disclosure применяются текущие ограничения. Coverage, portion progress и field limitations имеют собственные evidence и результаты.

## Проверяемые случаи и незакрытые решения

- Повтор того же operation и intent возвращает один эффект; тот же ID с другим subject конфликтует.
- Потерянный acknowledgement после возможного commit даёт indeterminate до reconciliation, а не фиктивный rollback или второй source факт.
- История очищена между подготовкой и commit: старый history effect не проходит fence; отдельно допустимый cache effect оценивается по своей политике.
- Контекст найден, но принадлежит другому Repository или account: наличие foreign key не доказывает семантическую совместимость, поэтому факт не принимается.
- Source field error не записывается как отсутствующее значение; отдельно восстановимый старый факт сохраняет своё время и правила доступа.

До implementation readiness нужно определить физические типы и ограничения всех обязательных полей, кодирование tagged values и времени, конкретный transaction/coordinator API, поведение при нехватке места, multi-connection ordering, migration и компакцию. Deterministic TDD с doubles должен проверять контракт; реальный SQLite crash/restart, защита файлов и Keychain нуждаются в собственных проверках после появления реализации.
