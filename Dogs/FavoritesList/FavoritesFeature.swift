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
    var container: ModelContainer? = nil
    var goNext = PassthroughSubject<DogViewModel, Never>()
    var subscriptions = Set<AnyCancellable>()
    
    init() {
        do {
            container = try ModelContainer(for: Dog.self)
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func addToFavorites(dog: DogViewModel) async {
        guard let data = dog.image.pngData() else { return }
        await container?.mainContext.insert(Dog(id: dog.id,data: data))
    }
    
    func removeFromFavorites(dog: DogViewModel) async {
        guard let data = dog.image.pngData() else { return }
        guard let dogToDelete = try? await container?.mainContext.fetch(FetchDescriptor<Dog>()).first(where: { $0.id == dog.id }) else { return }
        await container?.mainContext.delete(dogToDelete)
    }
    
    func getFavoriteDogs() async -> [DogViewModel] {
        let dogs = try? await container?.mainContext.fetch(FetchDescriptor<Dog>())
        return dogs?.compactMap { $0.data.toDog(id: $0.id) } ?? []
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
