//
//  DogDetailsStore.swift
//  Dogs
//
//  Created by Youssef Ghattas on 07/04/2024.
//

import Foundation

@MainActor
@Observable class DogDetailsStore {
    var state: DogDetailsState
    private let reducer: DogDetailsReducer
    private let environment: DogDetailsEnvironment
    
    init(dog: DogViewModel, reducer: DogDetailsReducer = DogDetailsReducer(), environment: DogDetailsEnvironment) {
        self.state = DogDetailsState(dog: dog.toDogModel)
        self.reducer = reducer
        self.environment = environment
    }
    
    func send(_ action: DogDetailsAction) {
        Task {
            state = await reducer.reduce(state, action, environment)
        }
    }
}
