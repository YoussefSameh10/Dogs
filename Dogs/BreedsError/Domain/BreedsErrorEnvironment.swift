//
//  BreedsErrorEnvironment.swift
//  Dogs
//
//  Created by Youssef Ghattas on 26/04/2024.
//

import Foundation

protocol BreedsErrorRouterDelegate: Sendable {
    func dismissBreedsError() async
}

struct BreedsErrorEnvironment: Sendable {
    private let networkMonitor: NetworkMonitor
    private let router: BreedsErrorRouterDelegate
    
    init(
        networkMonitor: NetworkMonitor = NetworkMonitorImpl(),
        router: BreedsErrorRouterDelegate
    ) {
        self.networkMonitor = networkMonitor
        self.router = router
        
        observeNetworkStateChanges()
    }
    
    private func observeNetworkStateChanges() {
        Task {
            for await isConnected in networkMonitor.networkStates {
                if isConnected {
                    await router.dismissBreedsError()
                }
            }
        }
    }
}
