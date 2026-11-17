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
    @State private var sessionManager: GitHubSessionManager?

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
                if let credential, let sessionManager {
                    if let library {
                        NavigationLink("Projects") { ProjectsPage(library: library, sessionManager: sessionManager) }
                    }
                    if let expiry = credential.accessTokenExpiresAt, expiry <= .now {
                        Text("Saved session expired. Reconnect or retry to refresh access.")
                            .font(.footnote).foregroundStyle(.secondary)
                        Button("Retry session refresh") { Task { await restoreSession() } }
                            .disabled(isConnecting)
                    } else {
                        NavigationLink("Browse repositories") {
                            RepositoryDiscoveryPage(sessionManager: sessionManager, accountID: credential.identity.id, account: credential.identity.login, library: library)
                        }
                    }
                    Button("Disconnect GitHub on this device", role: .destructive) {
                        Task { await disconnect() }
                    }
                    .disabled(isConnecting)
                }
                NavigationLink("View demo") {
                    TodayPage(items: DemoWork.items())
                }
            }
            .padding()
            .onAppear { Task { await restoreSession() } }
        }
    }

    @MainActor private func disconnect() async {
        guard !isConnecting else { return }
        isConnecting = true
        defer { isConnecting = false }
        do {
            if let sessionManager {
                try await sessionManager.disconnect { try store.remove() }
            } else {
                try store.remove()
            }
            credential = nil
            identity = nil
            library = nil
            sessionManager = nil
            status = "Disconnected on this device. Saved projects remain on this device."
        } catch {
            status = "Could not remove the saved GitHub session."
        }
    }

    @MainActor private func restoreSession() async {
        guard !isConnecting else { return }
        isConnecting = true
        defer { isConnecting = false }
        do {
            credential = try store.load()
            guard let saved = credential else { return }
            identity = saved.identity
            openLibrary(accountID: saved.identity.id)
            if sessionManager == nil { sessionManager = makeSessionManager() }
            guard let expiry = saved.accessTokenExpiresAt, expiry <= .now else { return }
            guard let sessionManager else { return }
            do {
                credential = try await sessionManager.usableSession(for: saved.identity.id)
            } catch {
                status = "Could not refresh the GitHub session. Saved projects remain available."
            }
        } catch let CredentialStoreError.keychain(code) {
            Logger(subsystem: "ru.egormerkushev.gitview", category: "credentials").error("Keychain read failed with status \(code, privacy: .public)")
            status = "Could not read the saved session."
        } catch { status = "Could not read the saved session." }
    }

    private func makeSessionManager() -> GitHubSessionManager {
        let id = Bundle.main.object(forInfoDictionaryKey: "GitHubClientID") as? String ?? ""
        let secret = Bundle.main.object(forInfoDictionaryKey: "GitHubClientSecret") as? String ?? ""
        let client = OAuthClient(clientID: id, clientSecret: secret, redirectURI: redirectURI)
        return GitHubSessionManager(load: { try store.load() },
            save: { identity, token, date in try store.save(identity: identity, token: token, now: date) },
            refresh: { token in
                guard !id.isEmpty, !secret.isEmpty, !id.contains("$("), !secret.contains("$(") else {
                    throw SessionRefreshError.reauthorizationRequired
                }
                return try await client.refresh(token)
            })
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
        status = nil
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
                sessionManager = makeSessionManager()
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
        } catch is CancellationError {
            status = nil
        } catch let error as ASWebAuthenticationSessionError where error.code == .canceledLogin {
            status = nil
        } catch {
            status = "Could not complete GitHub connection. Please try again."
        }
    }
}
