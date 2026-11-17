import Foundation
import Testing
@testable import ProjectStore

@MainActor struct ProjectStoreTests {
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
    }
}
