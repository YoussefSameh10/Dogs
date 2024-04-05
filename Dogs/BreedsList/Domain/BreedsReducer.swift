//
//  BreedsReducer.swift
//  Dogs
//
//  Created by Youssef Ghattas on 02/04/2024.
//

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
