# Development

GitGrid is an iOS 26 SwiftUI application under development, with a labeled offline demo and modular packages for authentication, GitHub API access, project storage, work caching and domain rules. `project.yml` is the XcodeGen source of the committed Xcode project.

Generate the project with `xcodegen generate --spec project.yml`. The app target depends on `Modules/WorkDomain`, which pins SpecificationCore 2.1.0. The app does not require a local checkout of either FSD or SpecificationCore.

Run the architecture linter and module contract checks from the repository root:

```sh
swift tools/fsd-lint.swift --root GitView --strict --architecture
specpm validate .
specpm validate Modules/WorkDomain
```

The copied FSD linter is from FSD iOS commit `21731b9dd7d5008b832af5caca6d19f7a36fe54f`; its MIT license is retained in `third-party-licenses/FSD-iOS-MIT.txt`. Test `WorkDomain` with `swift test --package-path Modules/WorkDomain`. Select build and package cache locations according to the local environment; on the author's machine the TB5 build-cache policy applies.

See [implementation status](status.md) for the scope and product-spec links.

For a locally registered GitHub App, configure its callback URL as `gitview://oauth/callback` and create an untracked `Config/Local.xcconfig` with `GITHUB_CLIENT_ID` and `GITHUB_CLIENT_SECRET` build settings. These values become part of the app; the client secret is extractable and must not be treated as a confidential credential. Do not commit the local file. A development GitHub App is registered, but real OAuth and repository access through it remain to be verified.

`LiveGitHubTests` in `Modules/GitHubAPI` are disabled by default. To run the read-only probes deliberately, supply `GITGRID_LIVE_PROBE=1`, a short-lived `GITGRID_LIVE_TOKEN`, the numeric and node IDs for `SoundBlaster/GitView` as `GITGRID_LIVE_REPOSITORY_ID` and `GITGRID_LIVE_REPOSITORY_NODE_ID`, and a public Issue node ID as `GITGRID_LIVE_ISSUE_ID`. Supply credentials through a controlled process environment; do not put them in tracked files or logs. A probe using a separate CLI token does not verify GitGrid's OAuth or GitHub App permissions.

See [GitHub App setup](github-app-setup.md) for the registration and installation steps.
