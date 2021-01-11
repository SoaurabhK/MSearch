//
//  Connectivity.swift
//  MSearch
//
//  Created by Soaurabh Kakkar on 11/01/21.
//

import Network

/// Connectivity wraps network reachability using NWPathMonitor
final class Connectivity {
    private let monitor = NWPathMonitor()
    
    // isConnetedToNetwork will be false if accessed before start is invoked.
    var isConnetedToNetwork: Bool {
        return monitor.currentPath.status == .satisfied
    }
    
    func startNetworkUpdates(callback: @escaping (Bool) -> Void) {
        monitor.pathUpdateHandler = { path in
            callback(path.status == .satisfied)
        }
        monitor.start(queue: .main)
    }
    
    // Once we have called cancel on our NWPathMonitor we cannot start it again. Instead, we need to instantiate a new NWPathMonitor instance.
    func stopNetworkUpdates() {
        monitor.cancel()
    }
}

