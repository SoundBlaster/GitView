import Foundation
import Testing
@testable import ProjectStore

@MainActor struct ProjectStoreTests {
    @Test func pauseIsProjectScopedAndSurvivesMetadataReconciliation() throws {
        let store = try ProjectStore(inMemory: true)
        let repo = RepositoryReference(id: 11, fullName: "owner/old", isPrivate: true)
        let first = try store.create(accountID: 1, name: "First", repositories: [repo])
        let second = try store.create(accountID: 1, name: "Second", repositories: [repo])
        let paused = RepositoryReference(id: 11, fullName: "owner/old", isPrivate: true, syncPaused: true)
        _ = try store.updateRepositories(accountID: 1, projectID: first.id, repositories: [paused])
        try store.reconcile(accountID: 1, observed: [.init(id: 11, fullName: "team/new", isPrivate: false)])
        let projects = try store.projects(accountID: 1)
        let firstRepository = try #require(projects.first { $0.id == first.id }?.repositories.first)
        let secondRepository = try #require(projects.first { $0.id == second.id }?.repositories.first)
        #expect(firstRepository.syncPaused)
        #expect(!secondRepository.syncPaused)
        #expect(firstRepository.fullName == "team/new")
    }

    @Test func legacyRepositoryDefaultsToSyncEnabled() throws {
        let old = #"{"id":11,"fullName":"owner/repo","isPrivate":true}"#
        let repository = try JSONDecoder().decode(RepositoryReference.self, from: Data(old.utf8))
        #expect(!repository.syncPaused)
    }
    @Test func reconcilesOnlyMatchingIdentitiesAcrossProjects() throws {
        let store = try ProjectStore(inMemory: true)
        let old = RepositoryReference(id: 11, fullName: "owner/old", isPrivate: true, nodeID: "R_node")
        let reused = RepositoryReference(id: 99, fullName: "owner/old", isPrivate: false)
        let transferred = RepositoryReference(id: 11, fullName: "team/new", isPrivate: false)
        let expected = RepositoryReference(id: 11, fullName: "team/new", isPrivate: false, nodeID: "R_node")
        let first = try store.create(accountID: 1, name: "First", repositories: [old])
        let second = try store.create(accountID: 1, name: "Second", repositories: [old, reused])
        let otherAccount = try store.create(accountID: 2, name: "Other", repositories: [old])
        try store.reconcile(accountID: 1, observed: [transferred])
        let projects = try store.projects(accountID: 1)
        #expect(projects.first(where: { $0.id == first.id })?.repositories == [expected])
        #expect(projects.first(where: { $0.id == second.id })?.repositories == [expected, reused])
        #expect(try store.projects(accountID: 2) == [otherAccount])
        #expect(throws: ProjectStoreError.invalidProject) { try store.reconcile(accountID: 1, observed: [old, transferred]) }
        #expect(try store.projects(accountID: 1).first(where: { $0.id == first.id })?.repositories == [expected])
    }
    @Test func updatesMembershipWithoutAffectingOtherProjectsOrAccounts() throws {
        let store = try ProjectStore(inMemory: true)
        let a = RepositoryReference(id: 11, fullName: "org/a", isPrivate: false)
        let b = RepositoryReference(id: 12, fullName: "other/b", isPrivate: true)
        let project = try store.create(accountID: 1, name: "Project", repositories: [a])
        let other = try store.create(accountID: 1, name: "Other", repositories: [a])
        let updated = try store.updateRepositories(accountID: 1, projectID: project.id, repositories: [a, b])
        #expect(updated.repositories == [a, b])
        #expect(try store.projects(accountID: 1).first(where: { $0.id == other.id })?.repositories == [a])
        #expect(throws: ProjectStoreError.invalidProject) { try store.updateRepositories(accountID: 2, projectID: project.id, repositories: [b]) }
        #expect(throws: ProjectStoreError.invalidProject) { try store.updateRepositories(accountID: 1, projectID: project.id, repositories: []) }
        #expect(try store.projects(accountID: 1).first(where: { $0.id == project.id })?.repositories == [a, b])
        _ = try store.updateRepositories(accountID: 1, projectID: project.id, repositories: [b])
        #expect(try store.projects(accountID: 1).first(where: { $0.id == other.id })?.repositories == [a])
        #expect(try store.projects(accountID: 1).first(where: { $0.id == project.id })?.repositories == [b])
    }
    @Test func savesAProjectAndKeepsAccountsSeparate() throws {
        let store = try ProjectStore(inMemory: true)
        let repo = RepositoryReference(id: 11, fullName: "org/repo", isPrivate: true)
        let project = try store.create(accountID: 1, name: "Project", repositories: [repo])
        #expect(try store.projects(accountID: 1) == [project])
        #expect(try store.projects(accountID: 2).isEmpty)
    }

    @Test func sameRepositoryMayBelongToMultipleProjects() throws {
        let store = try ProjectStore(inMemory: true)
        let repo = RepositoryReference(id: 11, fullName: "a/repo", isPrivate: false)
        let one = try store.create(accountID: 1, name: "One", repositories: [repo])
        let two = try store.create(accountID: 1, name: "Two", repositories: [repo])
        #expect(one.id != two.id)
        #expect(try store.projects(accountID: 1).count == 2)
    }

    @Test func emptyProjectAndDuplicateMembersAreRejected() throws {
        let store = try ProjectStore(inMemory: true)
        let repo = RepositoryReference(id: 11, fullName: "a/repo", isPrivate: false)
        #expect(throws: ProjectStoreError.invalidProject) { try store.create(accountID: 1, name: "Empty", repositories: []) }
        #expect(throws: ProjectStoreError.invalidProject) { try store.create(accountID: 1, name: "Duplicate", repositories: [repo, repo]) }
        #expect(try store.projects(accountID: 1).isEmpty)
    }

    @Test func sqliteReopensSavedProject() throws {
        let directory = FileManager.default.temporaryDirectory.appendingPathComponent(UUID().uuidString, isDirectory: true)
        try FileManager.default.createDirectory(at: directory, withIntermediateDirectories: true)
        defer { try? FileManager.default.removeItem(at: directory) }
        let url = directory.appendingPathComponent("projects.sqlite")
        let repo = RepositoryReference(id: 12, fullName: "a/repo", isPrivate: true)
        let first = try ProjectStore(url: url)
        let project = try first.create(accountID: 7, name: "Saved", repositories: [repo])
        let second = try ProjectStore(url: url)
        #expect(try second.projects(accountID: 7) == [project])
        let paused = RepositoryReference(id: 12, fullName: "a/repo", isPrivate: true, syncPaused: true)
        _ = try first.updateRepositories(accountID: 7, projectID: project.id, repositories: [paused])
        let reopened = try ProjectStore(url: url)
        #expect(try reopened.projects(accountID: 7).first?.repositories.first?.syncPaused == true)
    }
}
