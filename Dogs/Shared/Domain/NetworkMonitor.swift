//
//  NetworkMonitor.swift
//  Dogs
//
//  Created by Youssef Ghattas on 18/04/2024.
//

import Network

struct NetworkMonitorImpl: NetworkMonitor {
    private let monitor = NWPathMonitor()
    private let queue = DispatchQueue.global()

    var isConnected: Bool {
        return monitor.currentPath.status == .satisfied
    }

    init() {
        monitor.start(queue: queue)
    }
}
