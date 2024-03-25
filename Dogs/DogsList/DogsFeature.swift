//
//  DogsFeature.swift
//  Dogs
//
//  Created by Youssef Ghattas on 24/03/2024.
//

import Foundation
import UIKit

@MainActor
@Observable final class DogsStore {
    var state: DogsState
    private let breed: Breed
    private let reducer: DogsReducer
    private var environment: DogsEnvironment
    
    init(breed: Breed, reducer: DogsReducer = DogsReducer(), environment: DogsEnvironment = DogsEnvironment()) {
        self.state = DogsState(breed: breed)
        self.breed = breed
        self.reducer = reducer
        self.environment = environment
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
}

struct DogsState {
    let breed: Breed
    var dogs = [UIImage]()
    var isLoading = true
}

enum DogsAction {
    case onAppear
    case loaded([UIImage])
//    case addToFavorites(Data)
}

struct DogsEnvironment {
    func fetchDogs(breed: Breed) async throws -> [Data] {
        let (data, _) = try await URLSession.shared.data(from: URL(string: "https://dog.ceo/api/breed/\(breed.name)/images")!)
        let dogsURLs = try JSONDecoder().decode(DogResponse.self, from: data).images.map { URL(string: $0)! }
        
        return try await withThrowingTaskGroup(of: Data.self) { group in
            var dogs = [Data]()
            for url in dogsURLs {
                group.addTask {
                    try await URLSession.shared.data(from: url).0
                }
            }
            for try await data in group {
                dogs.append(data)
            }
            return dogs
        }
    }
}

struct DogsReducer {
    func reduce(_ state: DogsState, _ action: DogsAction, _ environment: DogsEnvironment) async throws -> DogsState {
        switch action {
        case .onAppear:
            var newState = state
            newState.isLoading = true
            let dogs = try await environment.fetchDogs(breed: state.breed).compactMap { UIImage(data: $0) }
            return try await reduce(newState, .loaded(dogs), environment)
        case .loaded(let dogs):
            var newState = state
            newState.dogs = dogs
            newState.isLoading = false
            return newState
        }
    }
}
