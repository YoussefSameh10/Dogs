//
//  DogsListReducer.swift
//  Dogs
//
//  Created by Youssef Ghattas on 02/04/2024.
//

struct DogsListReducer {
    func reduce(_ state: DogsListState, _ action: DogsListAction, _ environment: DogsListEnvironment) async -> DogsListState {
        switch action {
        case .onAppear:
            return await fetchDogs(state, environment)
        case .loaded(let dogs):
            return setDogs(dogs, state)
        case .tapDog(let dog):
            return await tapDog(dog, state, environment)
        case .tapFavorites(let dog):
            return await tapFavorite(dog, state, environment)
        case .onDisappear:
            return await cancel(state, environment)
        }
    }
    
    private func fetchDogs(_ state: DogsListState, _ environment: DogsListEnvironment) async -> DogsListState {
        var newState = state
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
    }
    
    private func setDogs(_ dogs: [DogModel], _ state: DogsListState) -> DogsListState {
        var newState = state
        newState.dogs = dogs.sorted(by: { $0.id < $1.id })
        newState.isLoading = false
        return newState
    }
    
    private func tapDog(_ dog: DogModel, _ state: DogsListState, _ environment: DogsListEnvironment) async -> DogsListState {
        await environment.goNext(dog: dog)
        return state
    }
    
    private func tapFavorite(_ dog: DogModel, _ state: DogsListState, _ environment: DogsListEnvironment) async -> DogsListState {
        var newState = state
        guard let index = newState.dogs.firstIndex(where: { $0 == dog }) else { return newState }
        if dog.isFavorite {
            newState.dogs[index].isFavorite = false
            await environment.removeFromFavorites(dog: dog)
            return newState
        }
        newState.dogs[index].isFavorite = true
        await environment.addToFavorites(dog: dog)
        return newState
    }
    
    private func cancel(_ state: DogsListState, _ environment: DogsListEnvironment) async -> DogsListState {
        await environment.cancelFetch()
        return state
    }
}
