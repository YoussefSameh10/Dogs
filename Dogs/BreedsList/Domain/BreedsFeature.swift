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
    var breeds = [String: [BreedModel]]() {
        didSet {
            filteredBreeds = breeds
        }
    }
    var filteredBreeds = [String: [BreedModel]]()
    var isLoading = true
    var searchText = ""
}

enum BreedsAction {
    case onAppear
    case loaded([BreedModel])
    case open(BreedModel)
    case search(String)
}

struct BreedsEnvironment: Sendable {
    private let repo: BreedsRepo
    private let router: BreedsRouterDelegate
    
    init(
        repo: BreedsRepo = BreedsRepoImpl(),
        router: BreedsRouterDelegate
    ) {
        self.repo = repo
        self.router = router
    }
    
    func fetchBreeds() async throws -> [BreedModel] {
        try await repo.fetchBreeds()
    }
    
    func goNext(breed: BreedModel) async {
        await router.goNext(breed: breed)
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
            await environment.goNext(breed: breed)
            return newState
        case .search(let text):
            newState.filteredBreeds = filter(newState.breeds, by: text)
            return newState
        }
    }
    
    private func group(_ breeds: [BreedModel]) -> [String: [BreedModel]] {
        var result = [String: [BreedModel]]()
        
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
    
    private func filter(_ breeds: [String: [BreedModel]], by searchText: String) -> [String: [BreedModel]] {
        let breedsArray = breeds.flatMap { $0.value }
        let filteredBreeds = breedsArray.filter { breed in
            breed.name.lowercased().hasPrefix(searchText.lowercased())
        }
        
        return group(filteredBreeds)
    }
}

protocol BreedsRouterDelegate: Sendable{
    func goNext(breed: BreedModel) async
}
