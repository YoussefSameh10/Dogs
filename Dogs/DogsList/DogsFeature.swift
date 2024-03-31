//
//  DogsFeature.swift
//  Dogs
//
//  Created by Youssef Ghattas on 24/03/2024.
//

import Foundation
import UIKit
import SwiftData
import Combine

@MainActor
@Observable final class DogsStore {
    var state: DogsState
    private let breed: Breed
    private let reducer: DogsReducer
    private let environment: DogsEnvironment
    
    init(breed: Breed, reducer: DogsReducer = DogsReducer(), environment: DogsEnvironment = DogsEnvironment()) {
        self.breed = breed
        self.state = DogsState(breed: breed)
        
        self.reducer = reducer
        self.environment = environment
        
        send(.onAppear)
    }
    
    func send(_ action: DogsAction) {
        Task {
            do {
                state = try await reducer.reduce(state, action, environment)
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    func isFavorite(dog: DogViewModel) -> Bool {
        return state.favoriteDogs.contains(where: { $0 == dog })
    }
}

struct DogsState {
    let breed: Breed
    var dogs = [DogViewModel]()
    var favoriteDogs = [DogViewModel]()
    var isLoading = true
}

enum DogsAction {
    case onAppear
    case loaded(dogs: [DogViewModel], favoriteDogs: [DogViewModel])
    case tapDog(DogViewModel)
    case tapFavorites(DogViewModel)
}

struct DogsEnvironment {
    let repo: DogsRepo
    
    var goNext = PassthroughSubject<DogViewModel,Never>()
    var subscriptions = Set<AnyCancellable>()
    
    init(repo: DogsRepo = DogsRepoReal()) {
        self.repo = repo
    }
    
    func fetchDogs(breed: Breed) async throws -> [DogViewModel] {
        try await repo.fetchDogs(breed: breed)
    }
    
    func addToFavorites(dog: DogViewModel) async {
        await repo.addToFavorites(dog: dog)
    }
    
    func removeFromFavorites(dog: DogViewModel) async {
        await repo.removeFromFavorites(dog: dog)
    }
    
    func getFavoriteDogs() async -> [DogViewModel] {
        await repo.getFavoriteDogs()
    }
}

struct DogsReducer {
    func reduce(_ state: DogsState, _ action: DogsAction, _ environment: DogsEnvironment) async throws -> DogsState {
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
            environment.goNext.send(dog)
            return newState
        case .tapFavorites(let dog):
            if newState.favoriteDogs.contains(where: { $0.id == dog.id }) {
                newState.favoriteDogs.removeAll(where: { $0.id == dog.id })
                await environment.removeFromFavorites(dog: dog)
                
                return newState
            }
            newState.favoriteDogs.append(dog)
            await environment.addToFavorites(dog: dog)
            return newState
        }
    }
}

extension Data {
    func toDog(id: String, breed: Breed) -> DogViewModel? {
        guard let image = UIImage(data: self) else { return nil }
        return DogViewModel(id: id, breed: breed, image: image)
    }
}
