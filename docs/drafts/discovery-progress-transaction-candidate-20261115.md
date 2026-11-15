# Discovery progress и coverage: кандидат границы сохранения

Авторский срез для [0102](GITVIEW-SPEC-0102.yaml), [0105](GITVIEW-SPEC-0105.yaml) и [0123](GITVIEW-SPEC-0123.yaml), `idea / pre_canonical`. Он дополняет [границу одного факта](observation-fact-transaction-candidate-20261115.md) и не задаёт готовую physical schema, GitHub snapshot guarantee или код приложения.

## Области и отдельные записи

| Запись | Содержимое | Не доказывает |
| --- | --- | --- |
| Portion context | Source instance и account, подтверждённый Repository, тип объекта, discovery purpose, actual operation и effective query predicates, period, access и attempt context. | Членство в любом другом Project, непрерывность доступа или полноту источника. |
| Page disposition | Идентичность конкретной обработанной страницы в контексте traversal, поддержанный её результат и ссылки на recoverable evidence принятой части; отдельно scoped limitation/gap, когда нужные данные или подтверждение отсутствуют. | Число неизвестных объектов, точную причину скрытого узла, стабильный snapshot или факт, что весь source охвачен. |
| Progress | Ссылка на portion и текущую границу traversal: допустимый continuation или терминальное состояние; связь с disposition, supported outcome и retention operation. | Полноту популяции, успешную запись всех фактов или coverage другой portion. |
| Coverage claim | Отдельный scope, predicate, interval/reference, access и достаточное recoverable evidence, показывающее, что именно обосновано. | Материализованные object identities, которых доказательство не содержит, или более свежий контекст. |

Локальная page identity относится к конкретной попытке и не заменяет GitHub work identity. Cursor непрозрачен: его строка, page index или совпавшее название не идентифицируют Issue или PR. Если невозможно безопасно записать точную причину или endpoint, сохранить только допустимую scoped limitation либо не делать более сильное утверждение о coverage. Не помещать токены и raw private error paths в records и diagnostics.

## Кандидат commit и recovery

1. Source boundary передаёт факты, actual page outcome и supported continuation независимо; запись фактов по [0123](GITVIEW-SPEC-0123.yaml) может иметь самостоятельный исход.
2. Прежде чем сообщить, что **новая сохранённая граница traversal** применяется к portion, локальная согласованная граница проверяет operation binding, исходный portion context, schema и applicable access fences. В том же transaction либо отдельно доказанном recoverable protocol она связывает progress с disposition и уже восстановимым evidence обработанной страницы или с явной безопасной отметкой о недостающем evidence. Если ни то ни другое надёжно записать нельзя, новая durable граница не подтверждается. Частично успешные fact writes сохраняют свои результаты.
3. Прогресс за страницу с gap может сохраняться как прогресс **с ограничением**, если связь с ним восстановима; это не complete coverage и не разрешение удалить gap после успешной следующей страницы. Null node без identity не превращается в fabricated work record. Покрытие, основанное на другом достаточном aggregate evidence, оценивается отдельно и не материализует идентичности.
4. Coverage claim и его operation outcome коммитятся совместно только после проверки восстановимости всех необходимых доказательств для этого claim; это может быть source-supported aggregate, а не все объектные записи. Terminal cursor и успешная запись страницы сами не доказывают coverage. Локальный operation ID с compatible binding безопасно воспроизводится, несовместимый binding конфликтует, неизвестный commit outcome остаётся indeterminate до reconciliation.
5. При restart читаются связанный portion, progress, disposition и доступное supporting evidence. Если association повреждена или missing, сохраняется только поддержанный факт, а соответствующая coverage остаётся unproven; отсутствие gap record не доказывает отсутствие gap и не позволяет придумывать конкретную причину. Использование cursor требует совместимых source, account, Repository, predicates, периода и текущего access. Иначе старая запись остаётся в своей области, а новый scope не наследует её прогресс.
6. Допустимый repair запускается отдельно по 0102/0048, с новой source attempt identity. Поздняя страница или повторный запрос не обязаны воспроизводить старую страницу, не закрывают gap автоматически и не доказывают, что GitHub предоставил единый snapshot. При невозможности repair сохраняется доступная общая limitation, без обещания срока.

Если проект, access, query или local day меняются, новые evaluation и disclosure применяются отдельно. Старый progress не переносится в другой Repository или interval; неактуальный scope не раскрывается через описание ошибки. Это не требует длительной DB transaction во время сети или Keychain.

Если один сохранённый progress использовался двумя Projects, он остаётся
свидетельством своей source portion, а не двумя независимыми source attempts.
После restart каждый потребитель заново устанавливает свой Project, текущий
membership, account и применимость query. Удаление Repository из одного Project
само по себе не удаляет его допустимый progress для другого, но наличие другого
Project не обходит текущий access restriction. Для восстановления статуса
каждого исходного пользовательского refresh дополнительно необходим его
собственный recoverable request context; один общий cursor не доказывает, что
обе Project-wide операции завершились. Недоступный контекст одного потребителя
не превращается в успешный или пустой результат другого.

## Проверяемые примеры

- Факты страницы сохранены, disposition и progress совместно committed, acknowledgement потерян: сверять прежний operation binding; до восстановления outcome indeterminate.
- Одна из accepted записей не восстановима: cursor может существовать вместе с gap, но ни терминальный результат, ни сохранённые соседи не подтверждают complete population.
- Не удалось записать ни disposition, ни безопасный gap: новая durable граница не подтверждается; отдельно подтверждённые факты остаются пригодны в своём контексте.
- Две части открытых и недавно изменённых PR возвращают один подтверждённый объект: он может быть одной карточкой, но progress, attempt и coverage остаются раздельными.
- Смена local day до восстановления recent-work cursor не превращает старую portion в новую; для старых открытых объектов применимость оценивается отдельно.

До implementation readiness нужно выбрать физическую схему, форматы page/portion identity и evidence references, точный coordinator/transaction API, политику retention/compaction и поведение при недоступном provider. TDD с контролируемыми outcomes не заменяет реальных crash/restart, concurrency и source pagination checks.
