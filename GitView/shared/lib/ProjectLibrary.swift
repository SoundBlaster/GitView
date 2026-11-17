import Foundation
import GitHubAPI
import Observation
import ProjectStore
import WorkCache

@MainActor enum ProjectRefreshPersistence {
    struct Result {
        let archive: ProjectWorkArchive
        let saved: Bool
        let complete: Bool
    }

    static func commit(cache: WorkCache?, accountID: Int64, projectID: UUID, observations: [RepositoryWorkRefresh],
                       fallback: ProjectWorkArchive?, at date: Date) throws -> Result {
        let snapshot = try cache?.load(accountID: accountID, projectID: projectID)
        let previous = try snapshot.map { try ProjectWorkArchive.decode($0.payload) } ?? fallback ?? ProjectWorkArchive()
        let updated = previous.applying(observations, at: date)
        let complete = !updated.hasRefreshProblems
        var saved = false
        if let cache {
            do {
                let data = try JSONEncoder().encode(updated)
                if let snapshot, snapshot.observedAt > date { saved = false }
                else if complete || snapshot == nil {
                    saved = try cache.save(accountID: accountID, projectID: projectID, payload: data, observedAt: date, complete: complete)
                } else if let snapshot {
                    saved = try cache.replacePayload(accountID: accountID, projectID: projectID, expected: snapshot, payload: data)
                }
            } catch { saved = false }
        }
        return Result(archive: updated, saved: saved, complete: complete)
    }
}

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

    func add(repository: RepositoryReference, to projectID: UUID) throws {
        guard let project = projects.first(where: { $0.id == projectID }) else { throw ProjectStoreError.invalidProject }
        var repositories = project.repositories
        if let index = repositories.firstIndex(where: { $0.id == repository.id }) {
            let current = repositories[index]
            repositories[index] = RepositoryReference(id: repository.id, fullName: repository.fullName, isPrivate: repository.isPrivate, nodeID: repository.nodeID ?? current.nodeID)
        }
        else { repositories.append(repository) }
        _ = try store.updateRepositories(accountID: accountID, projectID: projectID, repositories: repositories)
        try reload()
    }

    func remove(repositoryID: Int64, from projectID: UUID) throws {
        guard let project = projects.first(where: { $0.id == projectID }),
              project.repositories.contains(where: { $0.id == repositoryID }) else { throw ProjectStoreError.invalidProject }
        let remaining = project.repositories.filter { $0.id != repositoryID }
        _ = try store.updateRepositories(accountID: accountID, projectID: projectID, repositories: remaining)
        try reload()
    }

    func reconcile(observed: [RepositoryReference]) throws {
        try store.reconcile(accountID: accountID, observed: observed)
        try reload()
    }
}
