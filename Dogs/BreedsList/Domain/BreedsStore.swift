//
//  BreedsStore.swift
//  Dogs
//
//  Created by Youssef Ghattas on 25/03/2024.
//

import Foundation
import Combine

@Observable
@MainActor final class BreedsStore {
    var state: BreedsState
    private var reducer: BreedsReducer
    private var environment: BreedsEnvironment
    
    init(state: BreedsState = BreedsState(), reducer: BreedsReducer = BreedsReducer(), environment: BreedsEnvironment) {
        self.state = state
        self.reducer = reducer
        self.environment = environment        
    }
    
    func send(_ action: BreedsAction) {
        Task {
            do {
                state = try await reducer.reduce(state, action, environment)
            } catch {
                print(error.localizedDescription)
            }
        }
    }
}
