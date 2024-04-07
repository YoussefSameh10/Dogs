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
        case .tapFavorite:
            if newState.dog.isFavorite {
                newState.dog.isFavorite = false
                await environment.removeFromFavorites(dog: newState.dog)
                return newState
            }
            newState.dog.isFavorite = true
            await environment.addToFavorites(dog: newState.dog)
            return newState
        }
    }
}
