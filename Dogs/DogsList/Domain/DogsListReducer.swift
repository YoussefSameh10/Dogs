//
//  DogsListReducer.swift
//  Dogs
//
//  Created by Youssef Ghattas on 02/04/2024.
//

struct DogsListReducer {
    func reduce(_ state: DogsListState, _ action: DogsListAction, _ environment: DogsListEnvironment) async -> DogsListState {
        var newState = state
        switch action {
        case .onAppear:
            newState.isLoading = true
            do {
                var dogs = try await environment.fetchDogs(breed: state.breed)
                let favoriteDogs = await environment.getFavoriteDogs(breed: state.breed)
                
                for i in dogs.indices {
                    dogs[i].isFavorite = favoriteDogs.contains(where: { $0 == dogs[i] })
                }
                
                return await reduce(newState, .loaded(dogs: dogs), environment)
            } catch let error as DogsError {
                await environment.handleError(error)
                newState.isLoading = false
                return newState
            } catch {
                await environment.handleError(DogsError.unknown)
                newState.isLoading = false
                return newState
            }
        case .loaded(let dogs):
            newState.dogs = dogs.sorted(by: { $0.id < $1.id })
            newState.isLoading = false
            return newState
        case .tapDog(let dog):
            await environment.goNext(dog: dog)
            return newState
        case .tapFavorites(let dog):
            guard let index = newState.dogs.firstIndex(where: { $0 == dog }) else { return newState }
            if dog.isFavorite {
                newState.dogs[index].isFavorite = false
                await environment.removeFromFavorites(dog: dog)
                return newState
            }
            newState.dogs[index].isFavorite = true
            await environment.addToFavorites(dog: dog)
            return newState
        case .onDisappear:
            await environment.cancelFetch()
            return newState
        }
    }
}
