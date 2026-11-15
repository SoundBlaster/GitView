# Repository identity: rename и transfer

Актуализация: последующий draft.12 и кандидат 0123 предлагают сравнивать
подтверждённый numeric REST Repository ID в пределах source instance и отдельно
хранить подтверждённые Node ID associations. Это рабочее решение агента, а не
live-проверка transfer или новое утверждение владельца; вопросы source evidence,
alias и cross-instance identity остаются открытыми. Историческая таблица и
список технических вопросов ниже относятся к исходному решению владельца.

Статус на 2026-11-03: пользователь выбрал вариант A в указанном ниже объёме.
Это одно предметное решение, не принятие всей онтологии, specs или реализации.

## Вопрос и решение

Вопрос агента `conversation:gitview/excerpt-54-proposal`: GitHub подтверждает
тот же объект при `egor/OldName` → `egor/NewName` → `team/NewName`.
Как GitView должен вести его учёт?

Ответ пользователя `conversation:gitview/excerpt-54-reply`:

> A — один Repository: сохранить историю и членство в Projects при rename и transfer (рекомендую)

Оба источника и связь ответа с вопросом сохранены в SpecDraft:
`7fa3afce25204e24ae8b11fc1fec618f`, узлы `repository-identity-options` и
`repository-identity-continuity`. Локальные excerpt refs не являются
аттестованными message IDs. Whole-sketch approval не записывался.

## Рассмотренные варианты

| Вариант | Rename | Transfer | Статус |
| --- | --- | --- | --- |
| A: один Repository, если источник подтверждает тот же объект | Сохраняются история и членство | Сохраняются история и членство | Выбран пользователем |
| B: отдельный учёт после transfer | Тот же учёт | Новый период/контекст учёта, связанный с прежним, хотя GitHub-объект тот же | Не выбран; не введена новая сущность |
| Не принимать решение | Правило открыто | Правило открыто | Вопрос о непрерывности закрыт выбором A |

Механизм ID, alias migration, хранения и сверки доступных данных не выбирался
вместе с A. Не выбран и автоматический rename самого Project: его название
отдельно от имени репозитория.

## Конкретные примеры

Номера 42 и 99 ниже вымышлены. Это модельные примеры, не выполненные операции
или API-тесты; для transfer совпадение объекта является условием сценария.

| Наблюдение | Source repository ID | Адрес | По выбранному A |
| --- | --- | --- | --- |
| Исходное | 42 | github.com/egor/OldName | Repository R, состоит в Projects P и Q |
| Rename | 42 | github.com/egor/NewName | Тот же R, P/Q и история сохраняются |
| Transfer, источник подтверждает тот же объект | 42 | github.com/team/NewName | Тот же R, меняются наблюдаемые owner/name/адрес |
| Позже старый адрес занят другим объектом | 99 | github.com/egor/OldName | Предложение агента: не приклеивать историю R по совпадению URL; требуется различение объектов источника |

Ссылки Project указывают на тот же Repository, а не на неизменную пару owner/name.
История наблюдений не переписывается задним числом новым owner. Внешние старые
URL могут перестать вести к R; механизм актуальных ссылок и aliases ещё требует
specification. Если после transfer доступ потерян, это не доказательство удаления
или нового Repository: состояние наблюдения неизвестно. Эти условия обработки
неопределённости — выводы/предложения агента для дальнейшей спецификации.

GitHub остаётся управляющей платформой при смене owner внутри GitHub.
Смена owner сама по себе не создаёт второй Repository и не требует нового
класса GitHubRepository. Другие провайдеры этим решением не включены.

## Проверяемые внешние основания

Источники проверены 2026-11-03; ниже пересказ, не архив полных страниц.

- GitHub описывает redirects при rename и предупреждает об их потере при
  повторном использовании прежнего имени. Это основание различать адрес и объект.
  [Renaming a repository](https://docs.github.com/en/repositories/creating-and-managing-repositories/renaming-a-repository).
- При transfer GitHub переносит PR/Issues и сохраняет commit information;
  прежние ссылки перенаправляются, пока старый путь не занят другим объектом.
  Правила доступа и часть метаданных могут измениться, даже когда объект тот же.
  [Transferring a repository](https://docs.github.com/en/repositories/creating-and-managing-repositories/transferring-a-repository).
- Официальный GitHub Blog отдельно указывает, что числовой repository ID
  не меняется при rename, а замена репозитория меняет ID. Эта публикация не
  является проведённой нами проверкой transfer и не выбирает GitView API binding.
  [Using repo ID](https://github.blog/security/supply-chain-security/how-to-stay-safe-from-repo-jacking/).
- REST `node_id` соответствует GraphQL Node `id`; доступен lookup по ID.
  Это другой идентификатор, чем REST numeric repository ID.
  [Using global node IDs](https://docs.github.com/en/graphql/guides/using-global-node-ids).
- Формат GraphQL global ID может мигрировать; GitHub требует opaque treatment
  и обновление сохранённых references. Из смены строкового представления нельзя
  автоматически выводить новый предметный объект.
  [Migrating global IDs](https://docs.github.com/en/graphql/guides/migrating-graphql-global-node-ids).
- Schema отдельно предоставляет Repository `id`, `databaseId`, `name`,
  `nameWithOwner`, `owner`, `url`. Наличие полей не определяет политику GitView.
  [Repository reference](https://docs.github.com/en/graphql/reference/repos#repository).

Без записи в GitHub, rename/transfer на реальном аккаунте не выполнялись.
Вывод о выбранном поведении GitView основан на ответе пользователя, а не
автоматически принят из vendor documentation.

## Технические вопросы остаются

Выбор REST numeric ID или GraphQL Node ID, область host/provider, точное
представление ключей/aliases, подтверждение equivalence при миграции ID,
неполный доступ и кэширование требуют отдельного binding/specification.
Ни UUID локального хранения, ни literal ID format, ни правила объединения
независимых GitHub-объектов этим решением не утверждены.

Выбранная непрерывность отражается в отдельной draft-ревизии candidate как
manual policy и contextual contract. Policy declaration не является выполненным
rename/transfer test, проверкой исторических данных или canonical publication.
