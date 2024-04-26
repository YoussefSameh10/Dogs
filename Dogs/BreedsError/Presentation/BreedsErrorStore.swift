//
//  BreedsErrorStore.swift
//  Dogs
//
//  Created by Youssef Ghattas on 26/04/2024.
//

import Foundation

@Observable @MainActor
class BreedsErrorStore {
    let state: BreedsErrorState
    private var environment: BreedsErrorEnvironment
    
    init(
        error: BreedsUIError,
        environment: BreedsErrorEnvironment
    ) {
        self.state = BreedsErrorState(error: error.toDomainError)
        self.environment = environment
    }
}
