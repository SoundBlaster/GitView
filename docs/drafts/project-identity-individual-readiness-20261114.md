# GitView: оценка Project и Repository identity

Авторская сверка 11 указанных candidates на 14 ноября; это не независимое
принятие и не полный аудит транзитивных зависимостей. Все рассматриваемые
узлы — `idea / pre_canonical`. Версии зафиксированы ниже; после изменения
их содержательную оценку нужно повторить.

| Узел | Определено | До реализации границы требуется | Будущее независимое evidence |
| --- | --- | --- | --- |
| [0025](GITVIEW-SPEC-0025.yaml): lifecycle | Локальная identity Project, состав 1+ Repository, общий Repository в нескольких Projects, отдельные default и custom setup, сохранение и удаление. | Содержательно проверить агентский default-association lifecycle, поведение при неизвестной записи, UX удаления и разрешение конфликтов. | Реальная атомарность, restart и accessibility. |
| [0038](GITVIEW-SPEC-0038.yaml): identity/address | При подтверждённой той же identity rename/transfer не создаёт другой Repository; address reuse и unordered observations не сливают объекты. | Определить source-supported association и ordering адреса; 404 и redirect не использовать как доказательство тождества или удаления. | Реальный source adapter и точные source representations. |
| [0045](GITVIEW-SPEC-0045.yaml): setup | Явное подтверждение и поэлементные результаты; подтверждённое намерение для изменяющей Project операции подлежит durable recovery. | Конкретизировать admission, operation identity, per-entry recovery и account-change coordination. | Fault injection, реальный storage/restart и частичный доступ. |
| [0052](GITVIEW-SPEC-0052.yaml): default save | Одна активная default association для подтверждённого Repository; неизвестный commit не является rollback. | Выбрать механизм согласования записи, uniqueness и recovery вместе с 0103/0104/0113. | Конкурентные writes, потерянные acknowledgements и crash recovery. |
| [0080](GITVIEW-SPEC-0080.yaml): сравнение ID | Сравниваются точные подтверждённые REST numeric IDs внутри source instance; виды ID и адреса не подменяют друг друга. | Определить типизированный adapter, диапазон и precision-safe storage и проверяемую связь с другими ID kinds. | Реальная source association, decoding и round-trip storage. |
| [0081](GITVIEW-SPEC-0081.yaml): адресный конфликт | Неразрешённый конфликт адресов сохраняет identity и не доказывает deletion; повторный ответ сам не устанавливает порядок. | Определить доказательства разрешения конфликта и пользовательский recovery, включая неразрешимый случай. | Source ordering и native accessibility. |
| [0082](GITVIEW-SPEC-0082.yaml): конкурирующая правка | Stale whole-state save не перезаписывает подтверждённое изменение; поздняя правка не восстанавливает удалённый Project. | Завершить сравнение базы на effect boundary и решить применимую merge/conflict policy. | Реальный concurrent storage и multi-scene поведение. |
| [0083](GITVIEW-SPEC-0083.yaml): review конфликта | Поддержан агентский сценарий review сохранённого состояния и pending intention с новым подтверждением. | Выбрать ясное и доступное сравнение, поведение draft при restart и точный способ повторной валидации. | Native focus, interrupted save и конфликтующая повторная правка. |
| [0084](GITVIEW-SPEC-0084.yaml): membership | Membership — состояние конкретного Project; повторное добавление не стирает подтверждённое прошлое удаление и само не восстанавливает default association. | Содержательно оценить агентские правила восстановления/создания default и нужность локальной истории membership. | Source identity, атомарность и actual saved state. |
| [0104](GITVIEW-SPEC-0104.yaml): storage boundary | Разделены confirmed effect, reuse, conflict и indeterminate; operation outcome не заменяет актуальное чтение. | Выбрать provider, versioning, commit/recovery и migration; согласовать cleanup с общими Repository и сохранённой историей. | Реальный store, конкурентные операции и restart. |
| [0111](GITVIEW-SPEC-0111.yaml): validity policy | Pure decision различает valid, invalid и insufficient evidence; общая membership не является конфликтом. | Определить точные правила текста, типы и версию SpecificationCore, а также applicable source eligibility. | TDD policy и независимые source/storage boundaries. |

## Source evidence и продуктовая граница

Пользователь выбрал сохранять identity и membership при подтверждении того же
Repository после rename или transfer. [Сверка источников](github-repository-identity-evidence-20261114.md)
подтверждает документальный ориентир для rename, но не устанавливает numeric-ID
инвариант для каждого варианта transfer или универсальный порядок обновлений
адреса. Это не основание отступать от выбранного поведения: без доказанной
тождественности результат остаётся uncertain, история не переносится по имени.

GitView Project — локальная композиция, не GitHub organization или GitHub
Projects. Сохранение и удаление Project не записывают изменения в GitHub.
Проверяемая source identity, локальная операция и наблюдаемое состояние
membership не доказывают сами по себе мотив или конкретное действие актора в
Ontology.

## Следующие зависимости

1. Согласовать exact source-ID association и обработку неопределённого address
   ordering с доступом и navigation; не требовать source mutation как условия
   этого спецификационного прохода.
2. Завершить продуктовые правила изменения default association, допустимости
   Project name и конфликтного editing, затем определить интерфейс pure decision.
3. Выбрать storage ownership и достаточные durable invariants для 0045, 0052 и
   0104; отдельно определить UI для confirmed, failed и indeterminate outcomes.
4. Повторить review родительских требований и cross-cutting DI/TDD/accessibility
   после конкретизации зависимостей; тесты приложения сейчас не выполнялись.

```text
0025  48aeeec0a8a095387b84a587eeeae68be1175e46c16c6c4781555f62b277b744
0038  106e7e0a6d4f14eeb0443aa56d8a2e2c620a421ada86f93d89773015913a8b35
0045  537675ff9d9a29fcaa6bc268b0199561048cdb400d7caa79400af598815fe9ec
0052  aa961517e13cf6483538637fdeadfa5e54d669ea0c4127fccd14ab2c5821a77c
0080  5fd374c1f147fe90de14f6335594af7bd06c7a5706f9f70c0a32c5ca3de839fb
0081  d3dcd32779bcfde0c7c16ffe9bfbf77127412dda0db175cd605e2c68f9605548
0082  967750381c2c5f9edf0fbce31b0593120aa459622a13e54d306044211d1982c9
0083  b615cf1faf2e98809f1205435abde02ab2da6fcd4cb78dc4b9a57c09f053d67d
0084  c6379f07ae977c009800f40014c30f1ee78a9875bf872d7a23fd9974f7f96d35
0104  c1dd9594c23fc1f6dc7dbbfc5a2b8c849f6db209f9fd38d69eee7f15f67c2439
0111  e6c540367db4d7461c726c44ac7222719be6e6439507efb110f62f6d6f2fe208
```
