import Foundation

struct Constants {

    static let syncRealmPath = "SharedRealm"
    static let syncServerURL = URL(string: "realm://\(syncHost):9080/~/\(syncRealmPath)")
    static let syncAuthURL = URL(string: "http://\(syncHost):9080")!
    
    static let appID = Bundle.main.bundleIdentifier!

    static var syncHost: String {
        var address: String = "0.0.0.0"
        var ifaddr: UnsafeMutablePointer<ifaddrs>?
        guard getifaddrs(&ifaddr) == 0 else { return address }
        guard let firstAddr = ifaddr else { return address }
        for ifptr in sequence(first: firstAddr, next: { $0.pointee.ifa_next }) {
            let interface = ifptr.pointee
            let addrFamily = interface.ifa_addr.pointee.sa_family
            if addrFamily == UInt8(AF_INET) || addrFamily == UInt8(AF_INET6) {
                let name = String(cString: interface.ifa_name)
                if  name == "en0" {
                    var hostname = [CChar](repeating: 0, count: Int(NI_MAXHOST))
                    getnameinfo(interface.ifa_addr, socklen_t(interface.ifa_addr.pointee.sa_len), &hostname, socklen_t(hostname.count), nil, socklen_t(0), NI_NUMERICHOST)
                    address = String(cString: hostname)
                print("\(name) - \(address)")
                }
            }
        }
        freeifaddrs(ifaddr)
        return address
    }

}
