//
//  DogDetailsReducer.swift
//  Dogs
//
//  Created by Youssef Ghattas on 07/04/2024.
//

struct DogDetailsReducer {
    func reduce(_ state: DogDetailsState, _ action: DogDetailsAction, _ environment: DogDetailsEnvironment) async -> DogDetailsState {
        switch action {
        case .tapFavorite:
            await tapFavorite(state, environment)
        case .tapShare:
            share(state)
        }
    }
    
    private func tapFavorite(_ state: DogDetailsState, _ environment: DogDetailsEnvironment) async -> DogDetailsState {
        var newState = state
        if newState.dog.isFavorite {
            newState.dog.isFavorite = false
            await environment.removeFromFavorites(dog: newState.dog)
            return newState
        }
        newState.dog.isFavorite = true
        await environment.addToFavorites(dog: newState.dog)
        return newState
    }
    
    private func share(_ state: DogDetailsState) -> DogDetailsState {
        var newState = state
        newState.isSharing = true
        return newState
    }
}
