import CoreData
import Foundation

public struct WorkSnapshot: Equatable, Sendable {
    public let payload: Data
    public let observedAt: Date
    public let complete: Bool
}

public enum WorkCacheError: Error, Equatable { case invalidAccount, invalidStoredData }

@MainActor public final class WorkCache {
    private let container: NSPersistentContainer

    public convenience init(inMemory: Bool) throws {
        precondition(inMemory)
        try self.init(storeType: NSInMemoryStoreType, url: nil)
    }
    public convenience init(url: URL) throws { try self.init(storeType: NSSQLiteStoreType, url: url) }

    private init(storeType: String, url: URL?) throws {
        let model = NSManagedObjectModel()
        let entity = NSEntityDescription()
        entity.name = "WorkSnapshot"
        entity.managedObjectClassName = NSStringFromClass(NSManagedObject.self)
        entity.properties = [Self.attribute("accountID", .integer64AttributeType), Self.attribute("projectID", .UUIDAttributeType), Self.attribute("payload", .binaryDataAttributeType), Self.attribute("observedAt", .dateAttributeType), Self.attribute("complete", .booleanAttributeType)]
        entity.uniquenessConstraints = [["accountID", "projectID"]]
        model.entities = [entity]
        container = NSPersistentContainer(name: "GitGridWorkCache", managedObjectModel: model)
        try container.persistentStoreCoordinator.addPersistentStore(ofType: storeType, configurationName: nil, at: url)
    }

    @discardableResult
    public func save(accountID: Int64, projectID: UUID, payload: Data, observedAt: Date, complete: Bool) throws -> Bool {
        guard accountID > 0 else { throw WorkCacheError.invalidAccount }
        let existing = try object(accountID: accountID, projectID: projectID)
        if let existing {
            container.viewContext.refresh(existing, mergeChanges: false)
            guard let oldDate = existing.value(forKey: "observedAt") as? Date else { throw WorkCacheError.invalidStoredData }
            if oldDate > observedAt || !complete { return false }
        }
        let entry = existing ?? NSEntityDescription.insertNewObject(forEntityName: "WorkSnapshot", into: container.viewContext)
        entry.setValue(accountID, forKey: "accountID")
        entry.setValue(projectID, forKey: "projectID")
        entry.setValue(payload, forKey: "payload")
        entry.setValue(observedAt, forKey: "observedAt")
        entry.setValue(complete, forKey: "complete")
        do { try container.viewContext.save() }
        catch { container.viewContext.rollback(); throw error }
        return true
    }

    public func load(accountID: Int64, projectID: UUID) throws -> WorkSnapshot? {
        guard accountID > 0 else { throw WorkCacheError.invalidAccount }
        guard let entry = try object(accountID: accountID, projectID: projectID) else { return nil }
        container.viewContext.refresh(entry, mergeChanges: false)
        guard let payload = entry.value(forKey: "payload") as? Data,
              let date = entry.value(forKey: "observedAt") as? Date,
              let complete = entry.value(forKey: "complete") as? Bool else { throw WorkCacheError.invalidStoredData }
        return WorkSnapshot(payload: payload, observedAt: date, complete: complete)
    }

    /// Enriches an unchanged snapshot without changing its original coverage or observation time.
    @discardableResult
    public func replacePayload(accountID: Int64, projectID: UUID, expected: WorkSnapshot, payload: Data) throws -> Bool {
        guard accountID > 0 else { throw WorkCacheError.invalidAccount }
        guard let entry = try object(accountID: accountID, projectID: projectID) else { return false }
        container.viewContext.refresh(entry, mergeChanges: false)
        guard let current = try load(accountID: accountID, projectID: projectID), current == expected else { return false }
        entry.setValue(payload, forKey: "payload")
        do { try container.viewContext.save() }
        catch { container.viewContext.rollback(); throw error }
        return true
    }

    private func object(accountID: Int64, projectID: UUID) throws -> NSManagedObject? {
        let request = NSFetchRequest<NSManagedObject>(entityName: "WorkSnapshot")
        request.predicate = NSPredicate(format: "accountID == %lld AND projectID == %@", accountID, projectID as CVarArg)
        request.fetchLimit = 1
        return try container.viewContext.fetch(request).first
    }
    private static func attribute(_ name: String, _ type: NSAttributeType) -> NSAttributeDescription {
        let attribute = NSAttributeDescription(); attribute.name = name; attribute.attributeType = type; attribute.isOptional = false
        return attribute
    }
}
