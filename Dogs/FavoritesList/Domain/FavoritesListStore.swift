//
//  FavoritesListStore.swift
//  Dogs
//
//  Created by Youssef Ghattas on 28/03/2024.
//

import Foundation

@MainActor
@Observable class FavoritesListStore {
    var state: FavoritesListState
    private let environment: FavoritesListEnvironment
    private let reducer: FavoritesListReducer
    
    init(
        state: FavoritesListState = FavoritesListState(),
        reducer: FavoritesListReducer = FavoritesListReducer(),
        environment: FavoritesListEnvironment
    ) {
        self.state = state
        self.reducer = reducer
        self.environment = environment        
    }
    
    func send(_ action: FavoritesListAction) {
        Task {
            state = await reducer.reduce(state, action, environment)
        }
    }
    
    func isFavorite(dog: DogModel) -> Bool {
        return state.favoriteDogs.contains(where: { $0 == dog })
    }
}
