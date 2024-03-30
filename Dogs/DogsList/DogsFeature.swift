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
        self.environment = environment
        self.state = DogsState(breed: breed)
        self.breed = breed
        self.reducer = reducer
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
        return state.favoriteDogs.contains(where: { $0.id == dog.id })
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
    var container: ModelContainer? = nil
    
    var goNext = PassthroughSubject<DogViewModel,Never>()
    var subscriptions = Set<AnyCancellable>()
    
    init() {
        do {
            container = try ModelContainer(for: Dog.self)
        } catch {
            print(error.localizedDescription)
        }
    }
    func fetchDogs(breed: Breed) async throws -> [DogViewModel] {
        let (data, _) = try await URLSession.shared.data(from: URL(string: "https://dog.ceo/api/breed/\(breed.name)/images")!)
        let dogsURLs = try JSONDecoder().decode(DogResponse.self, from: data).images.map { URL(string: $0)! }
        
        return try await withThrowingTaskGroup(of: Data.self) { group in
            var dogs = [DogViewModel?]()
            for url in dogsURLs {
                let data = try await URLSession.shared.data(from: url).0
                dogs.append(data.toDog(id: url.absoluteString, breed: breed))
            }
            
            return dogs.compactMap { $0 }
        }
    }
    
    func addToFavorites(dog: DogViewModel) async {
        guard let data = dog.image.pngData() else { return }
        await container?.mainContext.insert(Dog(id: dog.id, breed: dog.breed, data: data))
    }
    
    func removeFromFavorites(dog: DogViewModel) async {
        guard let data = dog.image.pngData() else { return }
        guard let dogToDelete = try? await container?.mainContext.fetch(FetchDescriptor<Dog>()).first(where: { $0.id == dog.id }) else { return }
        await container?.mainContext.delete(dogToDelete)
    }
    
    func getFavoriteDogs() async -> [DogViewModel] {
        let dogs = try? await container?.mainContext.fetch(FetchDescriptor<Dog>())
        return dogs?.compactMap { $0.data.toDog(id: $0.id, breed: $0.breed) } ?? []
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
