import UIKit
import RealmSwift

extension RMObject {

    class func type(from className: String?) -> RMObject {
        let dictionary = Bundle.main.infoDictionary
        let name = dictionary?["CFBundleName"] as? String
        let cName = "\(name ?? "").\(className ?? "")"
        let aClass = NSClassFromString(cName) as? RMObject.Type
        return aClass?.init() ?? RMObject()
    }

}

class RMManager: Interface {

    private var realm: Realm {
        return SharedRealm.shared.realm
    }

    private func realm(_ block: (Realm) -> Void) {
        if realm.isInWriteTransaction == true {
            block(realm)
        } else {
            try? realm.write {
                block(realm)
            }
        }
    }

    override func create<T>(object: T.Type, result: @escaping (T) -> Void) {
        let object = RMObject.type(from: (object as? Object.Type)?.className())
        object.execute(selector: .create, { response in
            self.realm { _ in
                object.changeSent(to: true)
                self.realm.add(object, update: true)
            }
            result(object as! T)
        })
    }

    override func get<T>(objects: T.Type) -> [T] {
        if let objectType = objects as? Object.Type {
            return realm.objects(objectType).value(forKey: "self") as? [T] ?? []
        }
        return []
    }

    override func edit<T>(object: T) -> T? {
        if let object = object as? RMObject {
            object.execute(selector: .edit, { response in
                self.realm { realm in
                    object.changeEdited(to: true)
                    object.changeSent(to: true)
                    realm.add(object, update: true)
                }
            })
            return object as? T
        }
        return nil
    }

    override func delete<T>(objects: T) -> Bool {
        if let object = objects as? RMObject {
            object.execute(selector: .delete, { response in
                self.realm { realm in
                    realm.delete(object)
                }
            })
            return true
        }
        return false
    }

    override func getBy<T, O>(id: T, object: O.Type) -> O? {
        if let object = object as? Object.Type {
            return realm.object(ofType: object, forPrimaryKey: id) as? O
        }
        return nil
    }

    override func deleteBy<T>(id: T, object: T.Type) -> Bool {
        if let object = object as? Object.Type {
            let some = realm.object(ofType: object, forPrimaryKey: id)
            if some == nil {
                return false
            }
            realm { realm in
                realm.delete(some!)
            }
            return true
        }
        return false
    }

}
