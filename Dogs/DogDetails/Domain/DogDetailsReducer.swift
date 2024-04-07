//
//  DogDetailsReducer.swift
//  Dogs
//
//  Created by Youssef Ghattas on 07/04/2024.
//

struct DogDetailsReducer {
    func reduce(_ state: DogDetailsState, _ action: DogDetailsAction, _ environment: DogDetailsEnvironment) async -> DogDetailsState {
        var newState = state
        switch action {
        case .onAppear:
            let favoriteDogs = await environment.getFavorites()
            if favoriteDogs.contains(where: { $0 == newState.dog }) {
                newState.isFavorite = true
            } else {
                newState.isFavorite = false
            }
            return newState
        case .tapFavorite:
            if newState.isFavorite {
                newState.isFavorite = false
                await environment.removeFromFavorites(dog: newState.dog)
                return newState
            }
            newState.isFavorite = true
            await environment.addToFavorites(dog: newState.dog)
            return newState
        }
    }
}
