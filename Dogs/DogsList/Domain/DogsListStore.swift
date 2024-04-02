//
//  DogsListStore.swift
//  Dogs
//
//  Created by Youssef Ghattas on 24/03/2024.
//

import Foundation
import UIKit
import SwiftData
import Combine

@MainActor
@Observable final class DogsListStore {
    var state: DogsListState
    private let breed: BreedModel
    private let reducer: DogsListReducer
    private let environment: DogsListEnvironment
    
    init(breed: BreedModel, reducer: DogsListReducer = DogsListReducer(), environment: DogsListEnvironment) {
        self.breed = breed
        self.state = DogsListState(breed: breed)
        
        self.reducer = reducer
        self.environment = environment
        
        send(.onAppear)
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
    
    func isFavorite(dog: DogModel) -> Bool {
        return state.favoriteDogs.contains(where: { $0 == dog })
    }
}
