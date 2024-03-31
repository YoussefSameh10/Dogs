//
//  FavoritesFeature.swift
//  Dogs
//
//  Created by Youssef Ghattas on 28/03/2024.
//

import Foundation
import SwiftData
import Combine

@MainActor
@Observable class FavoritesStore {
    var state: FavoritesState
    private let environment: FavoritesEnvironment
    private let reducer: FavoritesReducer
    
    init(
        state: FavoritesState = FavoritesState(),
        reducer: FavoritesReducer = FavoritesReducer(),
        environment: FavoritesEnvironment = FavoritesEnvironment()
    ) {
        self.state = state
        self.reducer = reducer
        self.environment = environment        
    }
    
    func send(_ action: FavoritesAction) {
        Task {
            state = await reducer.reduce(state, action, environment)
        }
    }
    
    func isFavorite(dog: DogViewModel) -> Bool {
        return state.favoriteDogs.contains(where: { $0.id == dog.id })
    }
}

struct FavoritesState {
    var favoriteDogs = [DogViewModel]()
    var isLoading = true
}

enum FavoritesAction {
    case onAppear
    case loaded([DogViewModel])
    case tapDog(DogViewModel)
    case tapFavorite(DogViewModel)
}

struct FavoritesEnvironment {
    let repo: FavoritesRepo
    var goNext = PassthroughSubject<DogViewModel, Never>()
    var subscriptions = Set<AnyCancellable>()
    
    init(repo: FavoritesRepo = FavoritesRepoReal()) {
        self.repo = repo
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

struct FavoritesReducer {
    func reduce(_ state: FavoritesState, _ action: FavoritesAction, _ environment: FavoritesEnvironment) async -> FavoritesState {
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
            environment.goNext.send(dog)
            return newState
        case .tapFavorite(let dog):
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
