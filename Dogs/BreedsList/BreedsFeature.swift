//
//  BreedsFeature.swift
//  Dogs
//
//  Created by Youssef Ghattas on 25/03/2024.
//

import Foundation
import Combine

@Observable
@MainActor final class BreedsStore {
    var state: BreedsState
    private var reducer: BreedsReducer
    private var environment: BreedsEnvironment
    
    init(state: BreedsState = BreedsState(), reducer: BreedsReducer = BreedsReducer(), environment: BreedsEnvironment) {
        self.state = state
        self.reducer = reducer
        self.environment = environment
    }
    
    func send(_ action: BreedsAction) {
        Task {
            do {
                state = try await reducer.reduce(state, action, environment)
            } catch {
                print(error.localizedDescription)
            }
        }
    }
}

struct BreedsState {
    var breeds = [Breed]()
    var isLoading = true
}

enum BreedsAction {
    case onAppear
    case loaded([Breed])
    case open(Breed)
}

class BreedsEnvironment {
    var goNext = PassthroughSubject<Breed, Never>()
    var subscriptions = Set<AnyCancellable>()
    func fetchBreeds() async throws -> [Breed] {
        let (data, _) = try await URLSession.shared.data(from: URL(string: "https://dog.ceo/api/breeds/list/all")!)
        return try JSONDecoder().decode(BreedsResponse.self, from: data).breeds.sorted(by: { $0.name < $1.name })
    }
}

struct BreedsReducer {
    func reduce(_ state: BreedsState, _ action: BreedsAction, _ environment: BreedsEnvironment) async throws -> BreedsState {
        switch action {
        case .onAppear:
            let breeds = try await environment.fetchBreeds()
            return try await reduce(state, .loaded(breeds), environment)
        case .loaded(let breeds):
            var newState = state
            newState.breeds = breeds
            newState.isLoading = false
            return newState
        case .open(let breed):
            environment.goNext.send(breed)
            return state
        }
    }
}
