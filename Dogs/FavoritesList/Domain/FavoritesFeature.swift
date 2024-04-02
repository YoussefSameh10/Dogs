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
        environment: FavoritesEnvironment
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
    
    func isFavorite(dog: DogModel) -> Bool {
        return state.favoriteDogs.contains(where: { $0 == dog })
    }
}

struct FavoritesState {
    var favoriteDogs = [DogModel]()
    var isLoading = true
}

enum FavoritesAction {
    case onAppear
    case loaded([DogModel])
    case tapDog(DogModel)
    case tapFavorite(DogModel)
}

struct FavoritesEnvironment: Sendable {
    private let repo: FavoritesRepo
    private let router: FavoritesRouterDelegate
    
    init(
        repo: FavoritesRepo = FavoritesRepoImpl(),
        router: FavoritesRouterDelegate
    ) {
        self.repo = repo
        self.router = router
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
    
    func goNext(dog: DogModel) async {
        await router.goNext(dog: dog)
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

protocol FavoritesRouterDelegate: Sendable{
    func goNext(dog: DogModel) async
}
