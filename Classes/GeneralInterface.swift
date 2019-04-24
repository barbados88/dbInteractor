import UIKit

enum Executor: Int {
    case create = 1
    case edit = 2
    case delete = 3
}

public typealias block = ((Any?) -> Void)?

protocol APIExecutor {
    static func execute<T>(object: T, _ block: block)
}

protocol GeneralInterface {
    func get<T>(objects: T.Type) -> [T]
    func edit<T>(object: T) -> T?
    func create<T>(object: T.Type, result: @escaping (T) -> Void)
    func delete<T>(objects: T.Type) -> Bool
}
