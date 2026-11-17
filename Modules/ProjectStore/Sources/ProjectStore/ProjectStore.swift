import CoreData
import Foundation

public struct RepositoryReference: Codable, Hashable, Sendable {
    public let id: Int64
    public let fullName: String
    public let isPrivate: Bool
    public init(id: Int64, fullName: String, isPrivate: Bool) {
        self.id = id; self.fullName = fullName; self.isPrivate = isPrivate
    }
}

public struct StoredProject: Hashable, Sendable, Identifiable {
    public let id: UUID
    public let accountID: Int64
    public let name: String
    public let repositories: [RepositoryReference]
}

public enum ProjectStoreError: Error, Equatable {
    case invalidProject
    case invalidStoredData
}

@MainActor public final class ProjectStore {
    private let container: NSPersistentContainer

    public convenience init(inMemory: Bool) throws {
        precondition(inMemory)
        try self.init(storeType: NSInMemoryStoreType, url: nil)
    }

    public convenience init(url: URL) throws {
        try self.init(storeType: NSSQLiteStoreType, url: url)
    }

    private init(storeType: String, url: URL?) throws {
        let model = NSManagedObjectModel()
        let entity = NSEntityDescription()
        entity.name = "ProjectRecord"
        entity.managedObjectClassName = NSStringFromClass(NSManagedObject.self)
        entity.properties = [
            Self.attribute("id", .UUIDAttributeType),
            Self.attribute("accountID", .integer64AttributeType),
            Self.attribute("name", .stringAttributeType),
            Self.attribute("repositories", .binaryDataAttributeType)
        ]
        entity.uniquenessConstraints = [["id"]]
        model.entities = [entity]
        container = NSPersistentContainer(name: "GitGridProjects", managedObjectModel: model)
        try container.persistentStoreCoordinator.addPersistentStore(ofType: storeType, configurationName: nil, at: url)
    }

    public func create(accountID: Int64, name: String, repositories: [RepositoryReference]) throws -> StoredProject {
        let name = name.trimmingCharacters(in: .whitespacesAndNewlines)
        guard accountID > 0, !name.isEmpty, !repositories.isEmpty,
              repositories.allSatisfy({ $0.id > 0 && !$0.fullName.isEmpty }),
              Set(repositories.map(\.id)).count == repositories.count else { throw ProjectStoreError.invalidProject }
        let record = StoredProject(id: UUID(), accountID: accountID, name: name, repositories: repositories)
        let encodedRepositories = try JSONEncoder().encode(repositories)
        let object = NSEntityDescription.insertNewObject(forEntityName: "ProjectRecord", into: container.viewContext)
        object.setValue(record.id, forKey: "id")
        object.setValue(accountID, forKey: "accountID")
        object.setValue(name, forKey: "name")
        object.setValue(encodedRepositories, forKey: "repositories")
        do { try container.viewContext.save() }
        catch { container.viewContext.rollback(); throw error }
        return record
    }

    public func projects(accountID: Int64) throws -> [StoredProject] {
        let request = NSFetchRequest<NSManagedObject>(entityName: "ProjectRecord")
        request.predicate = NSPredicate(format: "accountID == %lld", accountID)
        request.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true), NSSortDescriptor(key: "id", ascending: true)]
        return try container.viewContext.fetch(request).map { object in
            guard let id = object.value(forKey: "id") as? UUID,
                  let account = object.value(forKey: "accountID") as? Int64,
                  let name = object.value(forKey: "name") as? String,
                  let data = object.value(forKey: "repositories") as? Data,
                  let repositories = try? JSONDecoder().decode([RepositoryReference].self, from: data) else { throw ProjectStoreError.invalidStoredData }
            return StoredProject(id: id, accountID: account, name: name, repositories: repositories)
        }
    }

    private static func attribute(_ name: String, _ type: NSAttributeType) -> NSAttributeDescription {
        let attribute = NSAttributeDescription()
        attribute.name = name; attribute.attributeType = type; attribute.isOptional = false
        return attribute
    }
}
