import AuthenticationServices
import GitHubAuth
import OSLog
import SwiftUI

struct ConnectionPage: View {
    @Environment(\.webAuthenticationSession) private var webSession
    @State private var isConnecting = false
    @State private var status: String?
    @State private var identity: GitHubIdentity?
    @State private var credential: SavedGitHubCredential?
    @State private var library: ProjectLibrary?

    private let redirectURI = URL(string: "gitview://oauth/callback")!
    private let store = KeychainCredentialStore(service: "ru.egormerkushev.gitview.github", account: "current")

    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                Image(systemName: "square.stack.3d.up")
                    .font(.largeTitle)
                Text("GitGrid")
                    .font(.largeTitle.bold())
                if let identity {
                    Text("Connected as \(identity.login)")
                } else {
                    Text("Connect GitHub to see your work across projects.")
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(.center)
                }
                if let status {
                    Text(status).font(.footnote).foregroundStyle(.secondary)
                }
                Button("Connect GitHub") {
                    Task { await connect() }
                }
                .buttonStyle(.borderedProminent)
                .disabled(isConnecting)
                if let credential {
                    if let library {
                        NavigationLink("Projects") { ProjectsPage(library: library, accessToken: credential.accessToken) }
                    }
                    if let expiry = credential.accessTokenExpiresAt, expiry <= .now {
                        Text("Saved session expired. Connect again to refresh access.")
                            .font(.footnote).foregroundStyle(.secondary)
                    } else {
                        NavigationLink("Browse repositories") {
                            RepositoryDiscoveryPage(accessToken: credential.accessToken, account: credential.identity.login, library: library)
                        }
                    }
                }
                NavigationLink("View demo") {
                    TodayPage(items: DemoWork.items())
                }
            }
            .padding()
            .task {
                do {
                    credential = try store.load()
                    if let credential { openLibrary(accountID: credential.identity.id) }
                } catch let CredentialStoreError.keychain(code) {
                    Logger(subsystem: "ru.egormerkushev.gitview", category: "credentials").error("Keychain read failed with status \(code, privacy: .public)")
                    status = "Could not read the saved session."
                } catch { status = "Could not read the saved session." }
            }
        }
    }

    @MainActor private func openLibrary(accountID: Int64) {
        do {
            library = try ProjectLibrary.open(accountID: accountID)
            status = nil
        } catch {
            library = nil
            status = "Could not open saved projects."
        }
    }

    @MainActor private func connect() async {
        guard let id = Bundle.main.object(forInfoDictionaryKey: "GitHubClientID") as? String,
              let secret = Bundle.main.object(forInfoDictionaryKey: "GitHubClientSecret") as? String,
              !id.isEmpty, !secret.isEmpty, !id.contains("$("), !secret.contains("$(") else {
            status = "GitHub App is not configured yet."
            return
        }
        isConnecting = true
        defer { isConnecting = false }
        do {
            let attempt = try OAuthAttempt.make(clientID: id, redirectURI: redirectURI)
            let coordinator = GitHubConnectionService(identityClient: GitHubIdentityClient()) { identity, token in
                try store.save(identity: identity, token: token)
            }
            let attemptID = await coordinator.begin()
            do {
                let callback = try await webSession.authenticate(using: attempt.authorizationURL, callback: .customScheme("gitview"), additionalHeaderFields: [:])
                let code = try attempt.receiveCallback(callback)
                let token = try await OAuthClient(clientID: id, clientSecret: secret, redirectURI: redirectURI).exchange(code)
                identity = try await coordinator.confirm(token, attempt: attemptID)
                do {
                    credential = try store.load()
                    if let credential { openLibrary(accountID: credential.identity.id) }
                    else { status = "Connected, but the saved session could not be found." }
                } catch {
                    status = "Connected, but the saved session could not be read."
                }
            } catch {
                await coordinator.cancel(attemptID)
                throw error
            }
        } catch {
            status = "Could not complete GitHub connection. Please try again."
        }
    }
}
