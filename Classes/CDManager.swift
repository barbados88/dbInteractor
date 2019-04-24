//
//  CDManager.swift
//  dbLayer
//
//  Created by Woxapp on 27.10.17.
//  Copyright © 2017 Woxapp. All rights reserved.
//

import UIKit
import CoreData

class CDManager: Interface {
    var context: NSManagedObjectContext
    init(context ctx: NSManagedObjectContext) {
        context = ctx
        super.init()
    }
    
    override func create<T>(object: T.Type, result: @escaping (T) -> Void) {
        let some = NSEntityDescription.insertNewObject(forEntityName: String(describing: object.self), into: context) as? CDObject
        some?.execute(selector: .create, { response in
            some?.changeSent(to: true)
            self.commitChanges()
            result(some as! T)
        })
    }
    
    override func get<T>(objects: T.Type) -> [T] {
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: String(describing: objects.self))
        fetchRequest.returnsObjectsAsFaults = false
        do {
            let result = try self.context.fetch(fetchRequest)
            return result as? [T] ?? []
        } catch {
            print(error.localizedDescription)
        }
        return []
    }
    
    override func edit<T>(object: T) -> T? {
        commitChanges()
        return object
    }
    
    override func delete<T>(objects: T) -> Bool {
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "\(objects)")
        do {
            let result = try self.context.fetch(fetchRequest)
            for obj in result {
                if obj is NSManagedObject {
                    context.delete(obj as! NSManagedObject)
                }
            }
        } catch {
            print(error.localizedDescription)
            return false
        }
        commitChanges()
        return true
    }
    
    override func getBy<T, O>(id: T, object: O.Type) -> O? {
        return managedObject(object: object, with: id) as? O
    }
    
    override func deleteBy<T>(id: T, object: T.Type) -> Bool {
        let obj: NSManagedObject? = managedObject(object: object, with: id)
        if obj == nil {
            return false
        }
        context.delete(obj!)
        commitChanges()
        return true
    }
    
    private func managedObject<T, O>(object: O.Type, with id: T) -> NSManagedObject? {
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: String(describing: object.self))
        let id: Any = id
        fetchRequest.predicate = NSPredicate(format: "id == %@", id as? CVarArg ?? "")
        do {
            let result = try self.context.fetch(fetchRequest)
            return result.count == 0 ? nil : result.first as? NSManagedObject
        } catch {
            print(error.localizedDescription)
            return nil
        }
    }
    
    private func commitChanges() {
        if context.hasChanges == false {
            return
        }
        do {
            try context.save()
        } catch {
            let nserror = error as NSError
            NSLog("Unresolved error \(nserror), \(nserror.userInfo)")
            abort()
        }
    }

}
