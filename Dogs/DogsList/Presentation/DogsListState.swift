//
//  DogsListState.swift
//  Dogs
//
//  Created by Youssef Ghattas on 02/04/2024.
//

struct DogsListState {
    let breed: BreedModel
    var dogs = [DogModel]()
    var favoriteDogs = [DogModel]()
    var isLoading = true
    
    func isFavorite(dog: DogModel) -> Bool {
        return favoriteDogs.contains(where: { $0 == dog })
    }
}
