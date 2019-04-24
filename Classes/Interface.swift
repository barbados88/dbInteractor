import UIKit
import CoreData

open class Interface: GeneralInterface {

    public static let shared: Interface = Interface()
    lazy var dataManager: DataManager = {
        return DataManager()
    }()
    
    public func provideCoreData(context: NSManagedObjectContext) {
        dataManager.provideCoreData(context: context)
    }

    public func migrateDB(toVersion version: UInt64) {
        SharedRealm.shared.migrate(to: version)
    }

    public func get<T>(objects: T.Type) -> [T] {
        return dataManager.get(objects: objects)
    }

    public func create<T>(object: T.Type, result: @escaping (T) -> Void) {
        dataManager.create(object: object) { obj in
            result(obj)
        }
    }

    public func edit<T>(object: T) -> T? {
        return dataManager.edit(object: object)
    }
    
    public func delete<T>(objects: T) -> Bool {
        return dataManager.delete(objects: objects)
    }

    public func getBy<T, O>(id: T, object: O.Type) -> O? {
        return dataManager.getBy(id: id, object: object)
    }

    public func deleteBy<T>(id: T, object: T.Type) -> Bool {
        return dataManager.deleteBy(id: id, object: object)
    }

}
