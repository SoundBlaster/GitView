import Foundation
import Observation
import ProjectStore

@MainActor @Observable final class ProjectLibrary {
    private let store: ProjectStore
    let accountID: Int64
    private(set) var projects: [StoredProject] = []

    init(accountID: Int64, store: ProjectStore) throws {
        self.accountID = accountID
        self.store = store
        try reload()
    }

    static func open(accountID: Int64) throws -> ProjectLibrary {
        let base = try FileManager.default.url(for: .applicationSupportDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
        let directory = base.appendingPathComponent("GitGrid", isDirectory: true)
        try FileManager.default.createDirectory(at: directory, withIntermediateDirectories: true)
        return try ProjectLibrary(accountID: accountID, store: ProjectStore(url: directory.appendingPathComponent("Projects.sqlite")))
    }

    func reload() throws { projects = try store.projects(accountID: accountID) }

    func create(name: String, repository: RepositoryReference) throws {
        let project = try store.create(accountID: accountID, name: name, repositories: [repository])
        projects.append(project)
        projects.sort { $0.name.localizedCaseInsensitiveCompare($1.name) == .orderedAscending }
    }
}
