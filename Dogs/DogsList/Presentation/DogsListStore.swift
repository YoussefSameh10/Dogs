//
//  DogsListStore.swift
//  Dogs
//
//  Created by Youssef Ghattas on 24/03/2024.
//

import Foundation

@MainActor
@Observable final class DogsListStore {
    var state: DogsListState
    private let breed: BreedViewModel
    private let reducer: DogsListReducer
    private let environment: DogsListEnvironment
    
    init(breed: BreedViewModel, reducer: DogsListReducer = DogsListReducer(), environment: DogsListEnvironment) {
        self.breed = breed
        self.state = DogsListState(breed: breed.toBreedModel)
        
        self.reducer = reducer
        self.environment = environment        
    }
    
    func send(_ action: DogsListAction) {
        Task {
            do {
                state = try await reducer.reduce(state, action, environment)
            } catch {
                print(error.localizedDescription)
            }
        }
    }
}
