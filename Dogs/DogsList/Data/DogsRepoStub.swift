//
//  DogsRepoStub.swift
//  Dogs
//
//  Created by Youssef Ghattas on 03/04/2024.
//

import UIKit

struct DogsRepoStub: DogsRepo {
    let breed = BreedModel(name: "Husky")
    var dogs: [DogModel] {
        guard let data = UIImage(systemName: "dog.fill")?.pngData() else { return [] }
        return [
            DogModel(id: "1", breed: breed, data: data, isFavorite: false),
            DogModel(id: "2", breed: breed, data: data, isFavorite: false),
            DogModel(id: "3", breed: breed, data: data, isFavorite: true),
            DogModel(id: "4", breed: breed, data: data, isFavorite: false),
            DogModel(id: "5", breed: breed, data: data, isFavorite: true)
        ]
    }
    
    func fetchDogs(breed: BreedModel) -> [DogModel] {
        dogs
    }
    
    func cancelFetch() async { }
    
    func addToFavorites(dog: DogModel) { }
    
    func removeFromFavorites(dog: DogModel) { }
    
    func getFavoriteDogs() -> [DogModel] {
        dogs.filter { $0.isFavorite }
    }
}
