# GitView: поузловая оценка первого подключения

Авторская сверка девяти candidates на 14 ноября. Это не независимое принятие,
не полный аудит всех транзитивных зависимостей и не результат реальной
авторизации. Все рассмотренные узлы остаются `idea / pre_canonical`; их SHA
указаны ниже и требуют повторной оценки после изменения.

| Узел | Определённый результат | Что требуется до реализации соответствующей границы | Отдельная последующая проверка |
| --- | --- | --- | --- |
| [0022](GITVIEW-SPEC-0022.yaml): первый запуск | Различены пустой локальный Project collection, ошибка чтения, соединение, discovery и подтверждённое создание по одному Repository. | Уточнить доступный native путь setup и восстановление незавершённых сохранений на основе подключённых границ. | Реальная последовательность на устройстве и accessibility. |
| [0036](GITVIEW-SPEC-0036.yaml): доступ к сохранённому | Offline, explicit denial, disconnect и неоднозначный 404 не смешиваются; partial reconnect подтверждает только поддержанные факты. | Подтвердить применимую классификацию ошибок и явно принять offline tradeoff: ограничение, известное только завершившемуся процессу, может не пережить сбой. | Реальные ошибки GitHub и изменения доступа; UI и защищённое хранение. |
| [0059](GITVIEW-SPEC-0059.yaml): выбор Repository | Поиск, частичные результаты, сохранение pending selection, identity и отделение default от custom intent. | Определить выбранные discovery operations, достаточность identity/access и конкретный вариант presentation и retry. | Пагинация, частичные grants, смена аккаунта и UI. |
| [0086](GITVIEW-SPEC-0086.yaml): замена credential | Разделены source identity, local write, возможная remote rotation, indeterminate outcome и поздний disconnect. | Завершить protocol и recovery evidence совместно с 0098, 0113 и 0114; выбрать observable ошибки и recovery. | Real Keychain, restart, concurrent refresh и provider behavior. |
| [0098](GITVIEW-SPEC-0098.yaml): авторизация | Кандидат GitHub App user-token, external session и authorization code с S256 PKCE, одна identity. | Определить callback, регистрацию, жизненный цикл extractable registration value, identity binding и renewal. Проверить актуальность документации до реализации. | Авторизация, token rotation, повторные callbacks и безопасное восстановление на GitHub и iOS. |
| [0099](GITVIEW-SPEC-0099.yaml): installations | Account authorization, installation, organization approval, grants и observation — самостоятельные факты. | Выбрать точные discovery и access-review routes; разделить результаты по installation и не придумывать причину отказа. | Частичный grant и organization approval на реальном источнике. |
| [0100](GITVIEW-SPEC-0100.yaml): permissions | Предложен read-only профиль по категориям, не выдаваемый за минимальный или полный grant. | Связать каждую выбранную source operation с фактическими GitHub App permissions и возвращаемыми полями; не запрашивать write из-за read-only обзора. | Проверить частичные permissions и ошибки на разрешённом аккаунте. |
| [0112](GITVIEW-SPEC-0112.yaml): access evidence | Discovery eligibility не равна доступу ко всем полям; после denial отдельные данные восстанавливаются только по применимому evidence. | Выбрать source mapping, область и время witness, семантику выбора и отображение ограничений. | Реальные field errors, visibility и гонки источника. |
| [0114](GITVIEW-SPEC-0114.yaml): локальная binding | Кандидатные изолированные Keychain slots и согласование с database generation без предположения единой транзакции двух stores. | Выбрать item attributes, protection/backup policy, границы coordinator, cleanup и recovery при потере remote rotation response. | Реальный Keychain, устройство до первого unlock, restart и fault injection. |

## Подтверждённая граница public client

[GitHub документирует](https://docs.github.com/en/apps/creating-github-apps/authenticating-with-a-github-app/generating-a-user-access-token-for-a-github-app)
`client_secret` как обязательный для обмена authorization code; для
[refresh](https://docs.github.com/en/apps/creating-github-apps/authenticating-with-a-github-app/refreshing-user-access-tokens)
он также обязателен для токена, полученного этим flow. При этом
[GitHub прямо указывает](https://docs.github.com/en/apps/creating-github-apps/about-creating-github-apps/best-practices-for-creating-a-github-app),
что native public client не может обеспечить конфиденциальность такого значения.
Поэтому no-backend candidate имеет явный операционный tradeoff: extractable
registration value не является доказательством подлинности экземпляра GitView.
PKCE защищает flow в пределах его назначения и не превращает приложение в
confidential client. Настоящие значения регистрации и user credentials здесь
не создавались и не записывались.

## Порядок завершения

1. Свести окончательно выбранные product data и операции с permission profile
   и поведенческими ограничениями, не объявляя все категории доступными по
   факту входа в аккаунт.
2. Определить callback, identity binding и жизненный цикл registration value;
   затем формализовать recovery удалённой rotation и локальной записи.
3. Согласовать setup и доступность экранов с partial grants, потерей storage
   и отдельной конфигурацией Project. Существующие local Projects не считать
   пустыми из-за отменённой авторизации.
4. Проверить значения и зависимости в общем графе; отдельные реальные проверки
   GitHub, storage и iOS остаются последующими видами evidence.

```text
0022  bc7d8a6337e5dbfcaafaad71e11fe267be2c5354bcf3062d3f443bc6cf727318
0036  a705fe9ac00aae3a96f681561df07383d938d3133515f355761fcaef5d0cceb9
0059  729088ee0ffdc9a3c23453e33313a758ad4bd71c7209581bc1d8b80c11e05d6a
0086  bfa5d3d11dbac3d68b1888617925ec0796d7eba70a41571ed90f7ff48288a255
0098  1f3584aff4c619a278ba5afa3f206001b8fc18f271d4a4a2704afccf45e19891
0099  1baef15696f195e7b853d9524a448cb336be4d4a4d4b57f17b6da71551b2bbff
0100  7f9d1a28d07e7e39374d48191b88e1fbbb4e2d53edfacd575d9e0199ccc34533
0112  b9424cc96374f380b59eb1cc2765e3d5672d01f80552279b73d95707770692f8
0114  4f8defdc5704d30d219dabcde6dac1095d9ab0832a495f05e1af609d09c499fc
```
