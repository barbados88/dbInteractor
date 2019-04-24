//
//  DataManager.swift
//  dbLayer
//
//  Created by Woxapp on 27.10.17.
//  Copyright © 2017 Woxapp. All rights reserved.
//

import UIKit
import RealmSwift
import CoreData

class DataManager: Interface {
    private var cdManager: CDManager? = nil
    private var rmManager: RMManager = RMManager()
    
    override func provideCoreData(context: NSManagedObjectContext) {
        cdManager = CDManager(context: context)
    }
    // TODO: remove generic comparing
    
    override func create<T>(object: T.Type, result: @escaping (T) -> Void) {
        isRealmInUse(object) == true ? rmManager.create(object: object, result: result) : cdManager?.create(object: object, result: result)
    }
    
    override func get<T>(objects: T.Type) -> [T] {
        return isRealmInUse(objects) == true ? rmManager.get(objects: objects) : cdManager?.get(objects: objects) ?? []
    }
    
    override func edit<T>(object: T) -> T? {
        return isRealmInUse(object) == true ? rmManager.edit(object: object) : cdManager?.edit(object: object)
    }
    
    override func delete<T>(objects: T) -> Bool {
        return isRealmInUse(objects) == true ? rmManager.delete(objects: objects) : cdManager?.delete(objects: objects) ?? false
    }
    
    override func getBy<T, O>(id: T, object: O.Type) -> O? {
        return isRealmInUse(object) == true ? rmManager.getBy(id: id, object: object) : cdManager?.getBy(id: id, object: object)
    }
    
    override func deleteBy<T>(id: T, object: T.Type) -> Bool {
        return isRealmInUse(object) == true ? rmManager.deleteBy(id: id, object: object) : cdManager?.deleteBy(id: id, object: object) ?? false
    }
    
    private func isRealmInUse<T>(_ val: T) -> Bool {
        let value = val as AnyObject
        return NSManagedObject.Type.self != value.superclass??.superclass()
    }
    
}
