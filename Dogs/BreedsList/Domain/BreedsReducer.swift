//
//  BreedsReducer.swift
//  Dogs
//
//  Created by Youssef Ghattas on 02/04/2024.
//

struct BreedsReducer {
    func reduce(_ state: BreedsState, _ action: BreedsAction, _ environment: BreedsEnvironment) async -> BreedsState {
        switch action {
        case .onAppear:
            await fetchBreeds(state, environment)
        case .loaded(let breeds):
            await setBreeds(breeds, state, environment)
        case .open(let breed):
            await tapBreed(breed, state, environment)
        case .search(let text):
            await applySearch(text, state)
        }
    }
    
    private func fetchBreeds(_ state: BreedsState, _ environment: BreedsEnvironment) async -> BreedsState {
        var newState = state
        do {
            let breeds = try await environment.fetchBreeds()
            return await reduce(newState, .loaded(breeds), environment)
        } catch let error as BreedsError {
            await environment.handleError(error)
            newState.isLoading = false
            return newState
        } catch {
            await environment.handleError(BreedsError.unknown)
            newState.isLoading = false
            return newState
        }
    }
    
    private func setBreeds(_ breeds: [BreedModel], _ state: BreedsState, _ environment: BreedsEnvironment) async -> BreedsState {
        var newState = state
        newState.breeds = group(breeds)
        newState.isLoading = false
        return await reduce(newState, .search(newState.searchText), environment)
    }
    
    private func tapBreed(_ breed: BreedModel, _ state: BreedsState, _ environment: BreedsEnvironment) async -> BreedsState {
        await environment.goNext(breed: breed)
        return state
    }
    
    private func applySearch(_ searchText: String, _ state: BreedsState) async -> BreedsState {
        var newState = state
        newState.filteredBreeds = filter(newState.breeds, by: searchText)
        return newState
    }
    
    private func group(_ breeds: [BreedModel]) -> [String: [BreedModel]] {
        var result = [String: [BreedModel]]()
        
        for breed in breeds.sorted(by: { $0.name < $1.name }) {
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
