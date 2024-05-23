//
//  FavoritesListReducer.swift
//  Dogs
//
//  Created by Youssef Ghattas on 02/04/2024.
//

struct FavoritesListReducer {
    func reduce(_ state: FavoritesListState, _ action: FavoritesListAction, _ environment: FavoritesListEnvironment) async -> FavoritesListState {
        switch action {
        case .onAppear:
            await fetchFavoriteDogs(state, environment)
        case .loaded(let dogs):
            setDogs(dogs, state)
        case .tapDog(let dog):
            await tapDog(dog, state, environment)
        case .tapFavorite(let dog):
            await tapFavorite(dog, state, environment)
        }
    }
    
    private func fetchFavoriteDogs(_ state: FavoritesListState, _ environment: FavoritesListEnvironment) async -> FavoritesListState {
        var newState = state
        let dogs = await environment.getFavoriteDogs()
        newState.isLoading = true
        return await reduce(newState, .loaded(dogs), environment)
    }
    
    private func setDogs(_ dogs: [DogModel], _ state: FavoritesListState) -> FavoritesListState {
        var newState = state
        newState.isLoading = false
        newState.favoriteDogs = dogs
        return newState
    }
    
    private func tapDog(_ dog: DogModel, _ state: FavoritesListState, _ environment: FavoritesListEnvironment) async -> FavoritesListState {
        var newState = state
        await environment.goNext(dog: dog)
        return newState
    }
    
    private func tapFavorite(_ dog: DogModel, _ state: FavoritesListState, _ environment: FavoritesListEnvironment) async -> FavoritesListState {
        var newState = state
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
