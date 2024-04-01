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
    private let breed: BreedModel
    private let reducer: DogsReducer
    private let environment: DogsEnvironment
    
    init(breed: BreedModel, reducer: DogsReducer = DogsReducer(), environment: DogsEnvironment = DogsEnvironment()) {
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
    
    func isFavorite(dog: DogModel) -> Bool {
        return state.favoriteDogs.contains(where: { $0 == dog })
    }
}

struct DogsState {
    let breed: BreedModel
    var dogs = [DogModel]()
    var favoriteDogs = [DogModel]()
    var isLoading = true
}

enum DogsAction {
    case onAppear
    case loaded(dogs: [DogModel], favoriteDogs: [DogModel])
    case tapDog(DogModel)
    case tapFavorites(DogModel)
}

struct DogsEnvironment {
    let repo: DogsRepo
    
    var goNext = PassthroughSubject<DogModel,Never>()
    var subscriptions = Set<AnyCancellable>()
    
    init(repo: DogsRepo = DogsRepoImpl()) {
        self.repo = repo
    }
    
    func fetchDogs(breed: BreedModel) async throws -> [DogModel] {
        try await repo.fetchDogs(breed: breed)
    }
    
    func addToFavorites(dog: DogModel) async {
        await repo.addToFavorites(dog: dog)
    }
    
    func removeFromFavorites(dog: DogModel) async {
        await repo.removeFromFavorites(dog: dog)
    }
    
    func getFavoriteDogs() async -> [DogModel] {
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

extension Data {
    func toDog(id: String, breed: BreedModel) -> DogModel? {
        guard let image = UIImage(data: self) else { return nil }
        return DogModel(id: id, breed: breed, image: image)
    }
}
