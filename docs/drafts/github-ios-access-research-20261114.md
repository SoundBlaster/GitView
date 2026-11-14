# GitView: предварительная проверка authorization и discovery

Проверено по официальной документации GitHub и Apple 14 ноября 2026 года.
Это исследование возможностей для candidates 0019, 0036, 0058 и 0059;
оно не выбирает authorization architecture и не подтверждает интеграцию.

## Что известно из источников

- GitHub различает OAuth App и GitHub App. Документация OAuth описывает
  authorization code flow и device flow. Для native public client GitHub
  предупреждает, что встроенный client secret нельзя защитить; его best
  practices рекомендуют PKCE и отдельно предостерегают от лишнего включения
  device flow. Та же документация указывает, что client secret требуется для
  получения токена, кроме device flow. Следовательно, наличие PKCE само по
  себе не доказывает возможность безопасного обмена без confidential
  компонента: архитектуру обмена и актуальные условия выбранного типа
  приложения нужно проверить отдельно. [GitHub: OAuth best practices](https://docs.github.com/en/apps/oauth-apps/building-oauth-apps/best-practices-for-creating-an-oauth-app),
  [OAuth authorization](https://docs.github.com/en/apps/oauth-apps/building-oauth-apps/authorizing-oauth-apps).
- Для GitHub App user access ограничен одновременно доступом пользователя,
  permissions приложения и установками на соответствующих аккаунтах.
  Authorization пользователя само по себе не означает, что App установлено
  во всех его организациях. Поэтому отсутствие Repository в discovery не
  означает, что сам пользователь не имеет к нему доступа. [GitHub: user access](https://docs.github.com/en/apps/creating-github-apps/authenticating-with-a-github-app/authenticating-with-a-github-app-on-behalf-of-a-user).
- GitHub документирует отдельные операции получения установок, доступных
  user access token, и репозиториев внутри конкретной установки. Это
  показывает возможную многоступенчатую область discovery, а не требует
  выбирать эти endpoints для GitView. [GitHub: installations](https://docs.github.com/en/rest/apps/installations).
- `404` может скрывать существующий private resource при проблеме с
  authentication; неверный адрес тоже может дать `404`. GitHub также
  документирует `403` для разных причин, включая rate limit, и отдельно
  описывает insufficient permissions. Следовательно, один status code не
  является универсальным доказательством удаления или repository-level
  denial; диагностика должна учитывать контекст и конкретный source contract.
  [GitHub: troubleshooting REST](https://docs.github.com/en/rest/using-the-rest-api/troubleshooting-the-rest-api).
- Apple предоставляет `ASWebAuthenticationSession` для входа через web
  service и доставки callback вызывающей session. Это возможный системный
  элемент интерфейса, но он сам не выбирает GitHub flow и не заменяет
  проверку полученного результата. [Apple: ASWebAuthenticationSession](https://developer.apple.com/documentation/authenticationservices/aswebauthenticationsession).
- Apple описывает Keychain для пользовательских секретов и удаление через
  Keychain Services с проверкой результата, включая отсутствие записи.
  Это поддерживает требование различать ошибку удаления и завершённый
  disconnect; конкретные item attributes, доступность после блокировки,
  migration и synchronisation пока не выбраны. [Apple: user secrets](https://developer.apple.com/documentation/security/using-the-keychain-to-manage-user-secrets),
  [updating and deleting items](https://developer.apple.com/documentation/security/updating-and-deleting-keychain-items).

## Следствия для кандидатов

1. Discovery должен различать источник, установку/разрешённый scope и
   покрытие; «нет в списке приложения» не равно «у пользователя нет доступа».
2. Разбор ошибки не может опираться только на `403` или `404`; source-specific
   evidence и неопределённость сохраняются.
3. Прежде чем выбрать GitHub App, OAuth App или другой поддерживаемый путь,
   нужно сопоставить установку в организациях, доступ к выбранным полям,
   публичный клиент, жизненный цикл credentials и предполагаемую эксплуатацию.
4. Документация не устанавливает минимальный набор прав для всех полей GitView,
   не доказывает согласованность страниц и не проверяет работу на устройстве.
   Для каждого выбранного контракта понадобятся отдельные source mapping и
   интеграционное evidence.
