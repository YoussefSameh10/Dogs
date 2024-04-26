//
//  NetworkMonitor.swift
//  Dogs
//
//  Created by Youssef Ghattas on 18/04/2024.
//

import Network

protocol NetworkMonitor: Sendable {
    var isConnected: Bool { get }
    var networkStates: AsyncStream<Bool> { get }
}

struct NetworkMonitorImpl: NetworkMonitor {
    private let monitor = NWPathMonitor()
    private let queue = DispatchQueue.global()
    
    init() {
        monitor.start(queue: queue)
    }
    
    var isConnected: Bool {
        monitor.currentPath.status == .satisfied
    }
    
    var networkStates: AsyncStream<Bool> {
        AsyncStream { cont in
            monitor.pathUpdateHandler = { path in
                cont.yield(path.status == .satisfied)
            }
        }
    }
}
