//
//  AbstractCDObject.swift
//  dbLayer
//
//  Created by Woxapp on 27.10.17.
//  Copyright © 2017 Woxapp. All rights reserved.
//

import UIKit
import CoreData

class CDObject: NSManagedObject {
    @NSManaged private var sent: Bool
    @NSManaged private var edited: Bool
    @NSManaged private var id: String?
    var isSent: Bool {
        return sent
    }
    
    var isEdited: Bool {
        return edited
    }
    
    func changeID(to value: String) {
        id = value
    }
    
    func changeSent(to value: Bool) {
        sent = value
    }
    
    func changeEdited(to value: Bool) {
        edited = value
    }
    
    func execute(selector: Executor, _ block: block) {
        switch selector {
        case .create: initWith(dictionary: [:], block)
        case .edit: edit(block)
        case .delete: delete(block)
        }
    }
    
    func initWith(dictionary: [String: Any], _ block: block) {
        block?(true)
    }
    
    func edit(_ block: block) {
        block?(true)
    }
    
    func delete(_ block: block) {
        block?(true)
    }
    
}
