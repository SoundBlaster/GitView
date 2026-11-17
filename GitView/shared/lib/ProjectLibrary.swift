import Foundation
import BackgroundTasks
import GitHubAPI
import GitHubAuth
import Observation
import OSLog
import ProjectStore
import WorkCache

@MainActor enum BackgroundRefreshRuntime {
    static let identifier = "ru.egormerkushev.gitview.refresh"
    private static let lastProjectKey = "GitGrid.background.lastProject"

    @discardableResult static func schedule() -> Bool {
        do {
            try BGTaskScheduler.shared.submit(BGAppRefreshTaskRequest(identifier: identifier))
            return true
        } catch {
            Logger(subsystem: "ru.egormerkushev.gitview", category: "refresh").debug("Background refresh request not scheduled: \(error.localizedDescription, privacy: .public)")
            return false
        }
    }

    static func run() async {
        defer { schedule() }
        let store = KeychainCredentialStore(service: "ru.egormerkushev.gitview.github", account: "current")
        let defaults = UserDefaults.standard
        let coordinator = BackgroundRefreshCoordinator(session: {
            guard let value = try store.load() else { return nil }
            return BackgroundRefreshSession(accountID: value.identity.id, token: value.accessToken, expiresAt: value.accessTokenExpiresAt)
        }, projects: { account in
            try ProjectLibrary.open(accountID: account).projects
        }, fetch: { token, project, repositories in
            let base = try FileManager.default.url(for: .applicationSupportDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
            let directory = base.appendingPathComponent("GitGrid", isDirectory: true)
            try FileManager.default.createDirectory(at: directory, withIntermediateDirectories: true)
            let cache = try WorkCache(url: directory.appendingPathComponent("WorkCache.sqlite"))
            let continuations = try ProjectRefreshPersistence.continuations(cache: cache, project: project)
            let service = GitHubProjectRefresh(tracksOpenContinuation: true, continuations: continuations) { token, repository in
                try await GitHubWorkClient().load(token: token, repositoryID: repository.id, fullName: repository.fullName,
                                                  nodeID: repository.nodeID, maxRequests: 2, openContinuation: continuations[repository.id])
            }
            return try await service.fetch(token: token, repositories: repositories.map {
                RefreshRepository(id: $0.id, fullName: $0.fullName, nodeID: $0.nodeID)
            }).observations
        }, save: { project, observations in
            let base = try FileManager.default.url(for: .applicationSupportDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
            let directory = base.appendingPathComponent("GitGrid", isDirectory: true)
            try FileManager.default.createDirectory(at: directory, withIntermediateDirectories: true)
            let cache = try WorkCache(url: directory.appendingPathComponent("WorkCache.sqlite"))
            let result = try ProjectRefreshPersistence.commit(cache: cache, accountID: project.accountID, projectID: project.id,
                observations: observations, fallback: nil, at: .now, scope: Set(project.repositories.map(\.id)))
            guard result.saved else { throw BackgroundRefreshCoordinator.Failure.couldNotSave }
        })
        do {
            let previous = defaults.string(forKey: lastProjectKey).flatMap(UUID.init(uuidString:))
            let result = try await coordinator.run(after: previous, repositoryAfter: { projectID in
                let value = defaults.object(forKey: "GitGrid.background.repository.\(projectID.uuidString)") as? Int64
                return value
            })
            if case let .updated(projectID, repositoryID) = result {
                defaults.set(projectID.uuidString, forKey: lastProjectKey)
                defaults.set(repositoryID, forKey: "GitGrid.background.repository.\(projectID.uuidString)")
            }
        } catch is CancellationError { }
        catch { Logger(subsystem: "ru.egormerkushev.gitview", category: "refresh").debug("Background refresh failed: \(error.localizedDescription, privacy: .public)") }
    }
}

struct BackgroundRefreshSession: Equatable {
    let accountID: Int64
    let token: String
    let expiresAt: Date?
}

/// Refreshes the visible project overview sequentially, sharing a repository observation
/// between projects during one pass. Stale account or membership results are discarded.
@MainActor struct ForegroundOverviewRefreshCoordinator {
    let projects: () -> [StoredProject]
    let isCurrent: () async throws -> Bool
    let needsRefresh: (StoredProject) throws -> Bool
    let fetch: (RepositoryReference) async throws -> RepositoryWorkRefresh
    let save: (StoredProject, [RepositoryWorkRefresh]) throws -> Void

    func run() async throws {
        let initial = projects()
        var observations: [Int64: RepositoryWorkRefresh] = [:]
        for project in initial where project.repositories.contains(where: { !$0.syncPaused }) {
            try Task.checkCancellation()
            guard try await isCurrent() else { return }
            guard try needsRefresh(project) else { continue }
            var batch: [RepositoryWorkRefresh] = []
            for repository in project.repositories where !repository.syncPaused {
                try Task.checkCancellation()
                let observation: RepositoryWorkRefresh
                if let existing = observations[repository.id] { observation = existing }
                else {
                    observation = try await fetch(repository)
                    observations[repository.id] = observation
                }
                batch.append(observation)
            }
            try Task.checkCancellation()
            guard try await isCurrent() else { return }
            guard projects().contains(where: { $0.id == project.id && $0.repositories == project.repositories }) else { continue }
            try save(project, batch)
        }
    }
}

@MainActor struct BackgroundRefreshCoordinator {
    enum Outcome: Equatable { case updated(UUID, lastRepository: Int64), unavailable, superseded }
    enum Failure: Error { case inconsistentObservations, couldNotSave }

    let session: () throws -> BackgroundRefreshSession?
    let projects: (Int64) throws -> [StoredProject]
    let fetch: (String, StoredProject, [RepositoryReference]) async throws -> [RepositoryWorkRefresh]
    let save: (StoredProject, [RepositoryWorkRefresh]) throws -> Void

    func run(after previous: UUID?, repositoryAfter: (UUID) -> Int64? = { _ in nil }, now: Date = .now) async throws -> Outcome {
        guard let initial = try session(), initial.expiresAt.map({ $0 > now }) ?? true else { return .unavailable }
        let candidates = try projects(initial.accountID).filter { $0.repositories.contains(where: { !$0.syncPaused }) }
            .sorted { $0.id.uuidString < $1.id.uuidString }
        guard !candidates.isEmpty else { return .unavailable }
        let selected = candidates.first { candidate in previous.map { candidate.id.uuidString > $0.uuidString } ?? false } ?? candidates[0]
        let sorted = selected.repositories.filter { !$0.syncPaused }.sorted { $0.id < $1.id }
        let remaining = sorted.filter { repository in repositoryAfter(selected.id).map { repository.id > $0 } ?? true }
        let batch = Array((remaining.isEmpty ? sorted : remaining).prefix(3))
        let observations = try await fetch(initial.token, selected, batch)
        try Task.checkCancellation()
        guard try session() == initial,
              try projects(initial.accountID).contains(where: { $0.id == selected.id && $0.repositories == selected.repositories }) else { return .superseded }
        guard Set(observations.map(\.id)) == Set(batch.map(\.id)), observations.count == batch.count else {
            throw Failure.inconsistentObservations
        }
        try save(selected, observations)
        return .updated(selected.id, lastRepository: batch[batch.count - 1].id)
    }
}

@MainActor enum ProjectRefreshPersistence {
    struct Result {
        let archive: ProjectWorkArchive
        let saved: Bool
        let complete: Bool
    }

    static func continuations(cache: WorkCache, project: StoredProject) throws -> [Int64: GitHubOpenContinuation] {
        guard let snapshot = try cache.load(accountID: project.accountID, projectID: project.id) else { return [:] }
        let archive = try ProjectWorkArchive.decode(snapshot.payload).restricting(to: Set(project.repositories.map(\.id)))
        return Dictionary(archive.repositories.compactMap { observation in
            observation.openContinuation.map { (observation.id, $0) }
        }, uniquingKeysWith: { first, _ in first })
    }

    static func commit(cache: WorkCache?, accountID: Int64, projectID: UUID, observations: [RepositoryWorkRefresh],
                       fallback: ProjectWorkArchive?, at date: Date, scope: Set<Int64>? = nil) throws -> Result {
        let snapshot = try cache?.load(accountID: accountID, projectID: projectID)
        let previous = try snapshot.map { try ProjectWorkArchive.decode($0.payload) } ?? fallback ?? ProjectWorkArchive()
        let partial = scope.map { Set(observations.map(\.id)) != $0 } ?? false
        let updated: ProjectWorkArchive
        if partial, let scope { updated = previous.applyingPartial(observations, in: scope, at: date) }
        else { updated = previous.applying(observations, at: date) }
        let complete = !partial && !updated.hasRefreshProblems
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
    enum SavedWorkError: Error { case cacheChanged }
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
            repositories[index] = RepositoryReference(id: repository.id, fullName: repository.fullName, isPrivate: repository.isPrivate,
                                                       nodeID: repository.nodeID ?? current.nodeID, syncPaused: current.syncPaused)
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

    func setSyncPaused(_ paused: Bool, repositoryID: Int64, projectID: UUID) throws {
        guard let project = projects.first(where: { $0.id == projectID }),
              project.repositories.contains(where: { $0.id == repositoryID }) else { throw ProjectStoreError.invalidProject }
        let updated = project.repositories.map { repository in
            guard repository.id == repositoryID else { return repository }
            return RepositoryReference(id: repository.id, fullName: repository.fullName, isPrivate: repository.isPrivate,
                                       nodeID: repository.nodeID, syncPaused: paused)
        }
        _ = try store.updateRepositories(accountID: accountID, projectID: projectID, repositories: updated)
        try reload()
    }

    /// Pauses first so an in-flight refresh cannot restore the deleted observation.
    func eraseSavedWork(repositoryID: Int64, from projectID: UUID, cache: WorkCache) throws {
        guard let project = projects.first(where: { $0.id == projectID }),
              project.repositories.contains(where: { $0.id == repositoryID }) else { throw ProjectStoreError.invalidProject }
        let snapshot = try cache.load(accountID: accountID, projectID: projectID)
        let replacement = try snapshot.map { try JSONEncoder().encode(ProjectWorkArchive.decode($0.payload).forgetting(repositoryID: repositoryID)) }
        try setSyncPaused(true, repositoryID: repositoryID, projectID: projectID)
        if let snapshot, let replacement {
            guard try cache.replacePayload(accountID: accountID, projectID: projectID, expected: snapshot, payload: replacement) else {
                throw SavedWorkError.cacheChanged
            }
        }
    }

    func reconcile(observed: [RepositoryReference]) throws {
        try store.reconcile(accountID: accountID, observed: observed)
        try reload()
    }
}
