# GitView: выбор направления для локального хранилища

**Уточнение 15 ноября:** SQLite остаётся исследованным вариантом, но не
обязательным provider первой версии. Ранее предложенное направление и профиль
ниже сохранены для сравнения. До реализации нужно выбрать конкретное хранилище
и показать, что оно удовлетворяет применимым требованиям 0106 к сохранению,
согласованности, доступу и восстановлению. SQLite-specific настройки и проверки
применяются, только если выбран соответствующий вариант; другой provider требует
своих обоснований и проверок. Утверждение выше не доказывает, что какая-либо
альтернатива проще или уже удовлетворяет контракту.

В 0123 добавлены условия для schema, использующей SQLite constraints: проверка
foreign-key enforcement на каждом connection до транзакции, обязательные
ненулевые компоненты подтверждённых ключей и явная проверка tagged values.
SQLite документирует, что `NULL` может обходить ожидаемую проверку UNIQUE,
composite foreign key или CHECK. См. [foreign keys](https://www.sqlite.org/foreignkeys.html)
и [CREATE TABLE](https://www.sqlite.org/lang_createtable.html). Это условия
будущего provider, не проверка конкретной iOS SQLite-сборки или схемы GitView.

Это оценка кандидатов по опубликованной документации и требованиям GitView;
она не является испытанием на iOS и не заменяет спецификацию recovery. Оценка
сделана до реализации приложения, по указанию владельца сначала построить
общий граф. Предлагаемый выбор — рабочее решение агента.

| Кандидат | Что документировано | Что остаётся доказать для GitView |
| --- | --- | --- |
| SQLite через локальный адаптер | [Транзакции](https://www.sqlite.org/lang_transaction.html), изолированная видимость commit и [сериализация записей](https://www.sqlite.org/isolation.html); [уникальные частичные индексы](https://www.sqlite.org/partialindex.html) позволяют выражать определённые ограничения. [Atomic commit](https://www.sqlite.org/atomiccommit.html) зависит от документированных допущений к файловой системе и конфигурации. | Реальную доступность и версию на целевом iOS SDK, выбранные режим журнала и настройки durability, связывание локального access admission с commit, миграции, поведение при ошибке и restart. Сам факт использования SQLite не доказывает контракт приложения. |
| SwiftData | Apple документирует [ModelContext, save, transaction и rollback](https://developer.apple.com/documentation/swiftdata/modelcontext) и [unique constraints](https://developer.apple.com/documentation/swiftdata/unique(_:)). | Описания API сами по себе не доказывают нужную GitView семантику конкурирующих записей, operation receipts и recovery; также нужно исследовать implicit save и конкретную storage configuration. Это остаётся возможной альтернативой. |
| Core Data | Apple документирует [optimistic locking и merge policies](https://developer.apple.com/library/archive/documentation/Cocoa/Conceptual/CoreData/ChangeManagement.html), а также [uniqueness constraints](https://developer.apple.com/documentation/coredata/nsentitydescription/uniquenessconstraints). | Надо отдельно спроектировать merge policy, координацию effect с receipt и recovery в используемом persistent store. Документация по change management архивная, её применимость к целевому SDK следует проверить. |

Рабочее направление: один локальный SQLite transactional boundary для Project
configuration, operation evidence и связанных подтверждённых локальных
изменений, с заменяемым domain-facing adapter. Это позволяет выразить нужные
инварианты непосредственно, не предполагая, что SwiftData или Core Data их не
поддерживают. Выбор не закрепляет Swift wrapper, schema, библиотечную версию,
journal mode или политику синхронизации между устройствами. В 0113 отдельно
предложен начальный профиль для проверки: системная SQLite, `DELETE` и
`synchronous=EXTRA`. Это ещё не подтверждённый выбор runtime на iOS. Для
rollback journal документация SQLite указывает, что `FULL` может не сохранить
последнюю транзакцию после потери питания, а `EXTRA` добавляет синхронизацию
каталога; результат всё равно зависит от VFS и файловой системы. Режим нужно
проверять по возвращённому значению, поскольку запрос изменения может не
сработать. См. [journal mode и synchronous](https://www.sqlite.org/pragma.html).

SQLite отдельно сообщает о [WAL-reset bug](https://www.sqlite.org/wal.html#the_wal_reset_bug),
исправленном в версии 3.51.3 и отдельных backport-версиях. Подверженность
конкретной поставки и применимость исправления нужно установить до выбора WAL;
версию на пользовательском iOS мы здесь не проверяли. WAL также имеет
сопутствующий файл, который входит в состояние базы, поэтому копирование только
основного файла не является общей стратегией backup. Конкретный backup и
восстановление не определены этим сравнением.

Credential остаётся в platform secure storage. SQLite или замена файла не
делает операцию с Keychain атомарной: состояние связи между ними должно быть
отдельно согласовано и восстанавливаться. Защиту файлов базы и возможных
служебных файлов, доступность при блокировке устройства и задачи фонового
обновления нужно выбрать совместно; например, Apple документирует ограничения
[completeUntilFirstUserAuthentication](https://developer.apple.com/documentation/foundation/fileprotectiontype/completeuntilfirstuserauthentication).
Нельзя обещать обновление до первого unlock только на основании выбора базы.
