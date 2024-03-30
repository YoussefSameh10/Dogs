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
        
        send(.onAppear)
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
    var breeds = [String: [Breed]]() {
        didSet {
            filteredBreeds = breeds
        }
    }
    var filteredBreeds = [String: [Breed]]()
    var isLoading = true
    var searchText = ""
}

enum BreedsAction {
    case onAppear
    case loaded([Breed])
    case open(Breed)
    case search(String)
}

struct BreedsEnvironment {
    var goNext = PassthroughSubject<Breed, Never>()
    var subscriptions = Set<AnyCancellable>()
    func fetchBreeds() async throws -> [Breed] {
        let (data, _) = try await URLSession.shared.data(from: URL(string: "https://dog.ceo/api/breeds/list/all")!)
        return try JSONDecoder().decode(BreedsResponse.self, from: data).breeds.sorted(by: { $0.name < $1.name })
    }
}

struct BreedsReducer {
    func reduce(_ state: BreedsState, _ action: BreedsAction, _ environment: BreedsEnvironment) async throws -> BreedsState {
        var newState = state
        switch action {
        case .onAppear:
            let breeds = try await environment.fetchBreeds()
            return try await reduce(newState, .loaded(breeds), environment)
        case .loaded(let breeds):
            newState.breeds = group(breeds)
            newState.isLoading = false
            return try await reduce(newState, .search(newState.searchText), environment)
        case .open(let breed):
            environment.goNext.send(breed)
            return newState
        case .search(let text):
            newState.filteredBreeds = filter(newState.breeds, by: text)
            return newState
        }
    }
    
    private func group(_ breeds: [Breed]) -> [String: [Breed]] {
        var result = [String: [Breed]]()
        
        for breed in breeds {
            let firstLetter = String(breed.name.prefix(1)).uppercased()
            if var group = result[firstLetter] {
                group.append(breed)
                result[firstLetter] = group
            } else {
                result[firstLetter] = [breed]
            }
        }
        
        return result
    }
    
    private func filter(_ breeds: [String: [Breed]], by searchText: String) -> [String: [Breed]] {
        let breedsArray = breeds.flatMap { $0.value }
        let filteredBreeds = breedsArray.filter { breed in
            breed.name.lowercased().hasPrefix(searchText.lowercased())
        }
        
        return group(filteredBreeds)
    }
}
