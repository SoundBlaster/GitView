import Foundation
import Security

public struct SavedGitHubCredential: Codable, Sendable {
    public let identity: GitHubIdentity
    public let accessToken: String
    public let refreshToken: String?
    public let accessTokenExpiresAt: Date?
    public let refreshTokenExpiresAt: Date?
}

public enum CredentialStoreError: Error, Equatable {
    case keychain(OSStatus)
    case invalidData
}

/// A single account credential. Keychain updates do not delete the previous item first.
public struct KeychainCredentialStore: Sendable {
    private let service: String
    private let account: String

    public init(service: String, account: String) {
        self.service = service
        self.account = account
    }

    public func save(identity: GitHubIdentity, token: OAuthToken, now: Date = .now) throws {
        let record = SavedGitHubCredential(identity: identity, accessToken: token.accessToken,
            refreshToken: token.refreshToken,
            accessTokenExpiresAt: token.expiresIn.map { now.addingTimeInterval(TimeInterval($0)) },
            refreshTokenExpiresAt: token.refreshTokenExpiresIn.map { now.addingTimeInterval(TimeInterval($0)) })
        let data = try JSONEncoder().encode(record)
        let query: [String: Any] = [kSecClass as String: kSecClassGenericPassword, kSecAttrService as String: service, kSecAttrAccount as String: account]
        let status = SecItemUpdate(query as CFDictionary, [kSecValueData as String: data] as CFDictionary)
        if status == errSecItemNotFound {
            var attributes = query
            attributes[kSecValueData as String] = data
            attributes[kSecAttrAccessible as String] = kSecAttrAccessibleAfterFirstUnlockThisDeviceOnly
            let added = SecItemAdd(attributes as CFDictionary, nil)
            guard added == errSecSuccess else { throw CredentialStoreError.keychain(added) }
        } else if status != errSecSuccess {
            throw CredentialStoreError.keychain(status)
        }
    }

    public func load() throws -> SavedGitHubCredential? {
        let query: [String: Any] = [kSecClass as String: kSecClassGenericPassword, kSecAttrService as String: service, kSecAttrAccount as String: account, kSecReturnData as String: true, kSecMatchLimit as String: kSecMatchLimitOne]
        var result: CFTypeRef?
        let status = SecItemCopyMatching(query as CFDictionary, &result)
        if status == errSecItemNotFound { return nil }
        guard status == errSecSuccess else { throw CredentialStoreError.keychain(status) }
        guard let data = result as? Data, let credential = try? JSONDecoder().decode(SavedGitHubCredential.self, from: data) else { throw CredentialStoreError.invalidData }
        return credential
    }

    public func remove() throws {
        let query: [String: Any] = [kSecClass as String: kSecClassGenericPassword, kSecAttrService as String: service, kSecAttrAccount as String: account]
        let status = SecItemDelete(query as CFDictionary)
        guard status == errSecSuccess || status == errSecItemNotFound else { throw CredentialStoreError.keychain(status) }
    }
}
