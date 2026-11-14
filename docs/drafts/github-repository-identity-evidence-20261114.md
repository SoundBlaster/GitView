# GitHub: evidence для identity и адреса Repository

Документальная сверка 14 ноября 2026 года для кандидатов 0002, 0038 и 0080.
Использованы первичные источники GitHub. Это не проверка живого аккаунта,
не доказательство актуального доступа, полного API mapping или постоянного
порядка source observations. Выбор пользователя относительно identity остаётся
продуктовым правилом GitView, а не автоматически утверждается документацией.

| Основание | Что документировано | Чего оно не устанавливает |
| --- | --- | --- |
| [GitHub Security Lab: repository ID](https://github.blog/security/supply-chain-security/how-to-stay-safe-from-repo-jacking/) | Numeric repository ID сохраняется при rename; замена Repository другим меняет ID. | Этот материал не доказывает конкретный порядок двух асинхронных ответов или неизменность ID для всех возможных миграций и сценариев transfer. |
| [Rename](https://docs.github.com/en/repositories/creating-and-managing-repositories/renaming-a-repository) и [transfer](https://docs.github.com/en/repositories/creating-and-managing-repositories/transferring-a-repository) | GitHub описывает перенос данных и redirects старого расположения; повторное использование старого имени может прекратить redirect. Есть и описанные исключения для некоторых URL. | Старый адрес и redirect не являются постоянной identity и не гарантируют, что адрес позже нельзя занять другим объектом. Документация transfer в просмотренном разделе не утверждает отдельно инвариант numeric ID. |
| [REST: Get a repository](https://docs.github.com/en/rest/repos/repos#get-a-repository) | Запрос использует owner/name, пример ответа содержит характеристики Repository; среди ответов перечислены 200, 301, 403 и 404. Для указанных fine-grained token types перечислен `Metadata: read`. | Это не полный permission set для GitView. Сам 301 не доказывает тождество конечного объекта прежнему; 404 не является доказательством удаления или отзыва доступа. |
| [GraphQL Repository](https://docs.github.com/en/graphql/reference/repos#repository) | У Repository описаны `name`, `nameWithOwner`, `owner`, `url`, `updatedAt` и `fullDatabaseId`. | Описание `updatedAt` не устанавливает в просмотренном материале, что оно является монотонной версией адреса или позволяет упорядочить любые rename/transfer. `fullDatabaseId` здесь не считается автоматически подтверждённым REST binding. |
| [Global node IDs](https://docs.github.com/en/graphql/guides/using-global-node-ids) | REST `node_id` и GraphQL Node `id` являются связанными представлениями global node ID; описан direct lookup. | Global ID не равен просто по написанию numeric REST repository ID; применимость к конкретному доступному объекту и migration требуют отдельного evidence. |
| [Conditional requests](https://docs.github.com/en/rest/using-the-rest-api/best-practices-for-using-the-rest-api#use-conditional-requests) | Для поддерживающих endpoint условный запрос может вернуть `304`, когда запрошенное representation не изменилось относительно валидатора. | `304` без доступного соответствующего baseline не сообщает numeric ID, owner/name или новое тело. Документация не превращает ETag в универсальную упорядочиваемую версию отдельных полей или другого запроса. |

## Следствие для GitView

Допустимо сохранять source-confirmed identity и разрешённое адресное наблюдение
с их context и затем уточнять адрес, когда новая source evidence действительно
его устанавливает. Это **предложение продукта**, а не доказанная GitHub гарантия
линеаризуемости. Запоздавший ответ, redirect, отсутствие ошибки или более новое
время получения сами по себе не разрешают конфликт несовместимых адресов.
Conditional validation применима только к соответствующему сохранённому
representation и его source/request/access context; её нельзя переносить на
другой Repository, поле или отсутствующее тело.

Не исследованы или не подтверждены: стабильность numeric ID при каждом варианте
transfer; доступность прямого lookup по numeric ID в выбранном будущем adapter;
эквивалентность GraphQL database ID и выбранного REST ID в конкретном ответе;
полное source ordering и мгновенная актуальность при конкурентных изменениях.
Число запросов, размер страниц, polling interval и механизм хранения здесь не
выбираются. Никаких запросов к частным данным пользователя не выполнялось.
