//
//  BreedsState.swift
//  Dogs
//
//  Created by Youssef Ghattas on 02/04/2024.
//

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
