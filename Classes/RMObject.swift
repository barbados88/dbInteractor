import UIKit
import RealmSwift

open class RMObject: Object {
    @objc private dynamic var sent: Bool = false
    @objc private dynamic var edited: Bool = false
    @objc open dynamic var id: Int = 0
    
    var isSent: Bool {
        return sent
    }
    
    var isEdited: Bool {
        return edited
    }
    
    @objc override open class func primaryKey() -> String {
        return "id"
    }
    
    @objc override open class func indexedProperties() -> [String] {
        return ["id"]
    }
    
    @objc override open class func ignoredProperties() -> [String] {
        return []
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
    
    open func initWith(dictionary: [String: Any], _ block: block) {
        block?(true)
    }
    
    open func edit(_ block: block) {
        block?(true)
    }
    
    open func delete(_ block: block) {
        block?(true)
    }
    
}
