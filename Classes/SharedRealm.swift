import UIKit
import RealmSwift

typealias RealmObserver = ((Realm.Notification, Realm) -> Void)

class SharedRealm: NSObject {

    static let shared: SharedRealm = SharedRealm()
    private var instance: Realm? = nil
    private var notificationToken: NotificationToken? = nil
    var types: [Object.Type] = []
    var observer: RealmObserver? = nil

    var realm: Realm {
        if instance == nil {
            instance = try! Realm()
        }
        return instance!
    }

    func migrate(to version: UInt64) {
        let config = Realm.Configuration(
            schemaVersion: version,
            migrationBlock: { migration, oldSchemaVersion in
                if oldSchemaVersion < version {
                }
        })
        Realm.Configuration.defaultConfiguration = config
        instance = try! Realm()
    }

    func authorizeWith(userName login: String, and password: String) {
        if let user = SyncUser.current {
            configureRealm(with: user)
        } else {
            SyncUser.logIn(with: .usernamePassword(username: login, password: password, register: false), server: Constants.syncAuthURL) { user, error in
                guard let user = user
                    else {
                        fatalError("Error syncing data: \(error?.localizedDescription ?? "Error")")
                }
                DispatchQueue.main.async {
                    self.configureRealm(with: user)
                }
            }
        }
    }

    private func configureRealm(with user: SyncUser) {
        Realm.Configuration.defaultConfiguration = Realm.Configuration(
            syncConfiguration: SyncConfiguration(user: user, realmURL: Constants.syncServerURL!),
            objectTypes: types
        )
        instance = try! Realm()
        notificationToken = realm.observe { notification, realm in
            self.observer?(notification, realm)
        }
    }

}
