//
//  DogsListReducer.swift
//  Dogs
//
//  Created by Youssef Ghattas on 02/04/2024.
//

struct DogsListReducer {
    func reduce(_ state: DogsListState, _ action: DogsListAction, _ environment: DogsListEnvironment) async throws -> DogsListState {
        var newState = state
        switch action {
        case .onAppear:
            newState.isLoading = true
            let dogs = try await environment.fetchDogs(breed: state.breed)
            let favoriteDogs = await environment.getFavoriteDogs()
            return try await reduce(newState, .loaded(dogs: dogs, favoriteDogs: favoriteDogs), environment)
        case .loaded(let dogs, let favoriteDogs):
            newState.dogs = dogs
            newState.favoriteDogs = favoriteDogs
            newState.isLoading = false
            return newState
        case .tapDog(let dog):
            await environment.goNext(dog: dog)
            return newState
        case .tapFavorites(let dog):
            if newState.favoriteDogs.contains(where: { $0 == dog }) {
                newState.favoriteDogs.removeAll(where: { $0 == dog })
                await environment.removeFromFavorites(dog: dog)
                
                return newState
            }
            newState.favoriteDogs.append(dog)
            await environment.addToFavorites(dog: dog)
            return newState
        case .onDisappear:
            await environment.cancelFetch()
            return newState
        }
    }
}
