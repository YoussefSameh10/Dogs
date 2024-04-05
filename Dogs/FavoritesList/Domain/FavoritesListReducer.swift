//
//  FavoritesListReducer.swift
//  Dogs
//
//  Created by Youssef Ghattas on 02/04/2024.
//

struct FavoritesListReducer {
    func reduce(_ state: FavoritesListState, _ action: FavoritesListAction, _ environment: FavoritesListEnvironment) async -> FavoritesListState {
        var newState = state
        switch action {
        case .onAppear:
            let dogs = await environment.getFavoriteDogs()
            newState.isLoading = true
            return await reduce(newState, .loaded(dogs), environment)
        case .loaded(let dogs):
            newState.isLoading = false
            newState.favoriteDogs = dogs
            return newState
        case .tapDog(let dog):
            await environment.goNext(dog: dog)
            return newState
        case .tapFavorite(let dog):
            if newState.favoriteDogs.contains(where: { $0 == dog }) {
                newState.favoriteDogs.removeAll(where: { $0 == dog })
                await environment.removeFromFavorites(dog: dog)
                return newState
            }
            newState.favoriteDogs.append(dog)
            await environment.addToFavorites(dog: dog)
            return newState
        }
    }
}
