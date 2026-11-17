# GitHub App for GitGrid

GitGrid uses a GitHub App user access token, web authorization with PKCE, and a custom URL scheme. It does not require a GitGrid backend. The registration below is a starting permission set; validate the GraphQL fields against real installations and adjust only if GitHub reports a missing permission.

1. Open [New GitHub App](https://github.com/settings/apps/new) under the account that will own the registration. Pick a unique name, such as `GitGrid-Egor`.
2. Set **Homepage URL** to `https://github.com/SoundBlaster/GitView` and **Callback URL** to `gitview://oauth/callback`. Leave **Request user authorization during installation** and **Device Flow** off; the app initiates authorization separately.
3. Turn off **Webhook → Active**. No webhook URL is needed.
4. Under **Repository permissions**, select **Read-only** for **Issues**, **Pull requests**, **Checks**, and **Commit statuses**. GitHub grants **Metadata** read access automatically. Leave write permissions disabled.
5. Under **Where can this GitHub App be installed?**, select **Any account** to allow installations on the intended organizations as well as the personal account. This does not by itself list the app in Marketplace.
6. Create the GitHub App. On its settings page, use **Generate a new client secret**, then place the **Client ID** and **Client secret** in the untracked local file `Config/Local.xcconfig`:

   ```xcconfig
   GITHUB_CLIENT_ID = your_client_id
   GITHUB_CLIENT_SECRET = your_client_secret
   ```

   Do not commit the file or send the secret in chat. These build settings are bundled into the native app: the secret is extractable and cannot serve as proof that a client is trusted.
7. If GitHub requires a private key before installation, generate one from the app settings and store the downloaded `.pem` securely outside the repository. The current GitGrid user OAuth flow does not use this private key; do not commit it or send it in chat.
8. Use **Install App** in the GitHub App settings to install it on the personal account and each intended organization, selecting the repositories to expose. Organization policies may require administrator approval.
9. Build GitGrid using the local configuration and select **Connect GitHub**. Confirm that authorization returns to the app, then verify repository discovery and access to PRs, issues, checks, and statuses. Registration and these live checks are separate; neither is implied by passing mock tests.

References: [GitHub App registration](https://docs.github.com/en/apps/creating-github-apps/registering-a-github-app/registering-a-github-app), [permissions](https://docs.github.com/en/apps/creating-github-apps/registering-a-github-app/choosing-permissions-for-a-github-app), and [user authorization callback](https://docs.github.com/en/apps/creating-github-apps/registering-a-github-app/about-the-user-authorization-callback-url).
