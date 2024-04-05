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
        guard let image = UIImage(systemName: "dog.fill") else { return [] }
        return [
            DogModel(id: "1", breed: breed, image: image),
            DogModel(id: "2", breed: breed, image: image),
            DogModel(id: "3", breed: breed, image: image),
            DogModel(id: "4", breed: breed, image: image),
            DogModel(id: "5", breed: breed, image: image)
        ]
    }
    
    var favoriteDogs: [DogModel] {
        guard let image = UIImage(systemName: "dog") else { return [] }
        return [
            DogModel(id: "3", breed: breed, image: image),
            DogModel(id: "5", breed: breed, image: image)
        ]
    }
    
    func fetchDogs(breed: BreedModel) -> [DogModel] {
        dogs
    }
    
    func cancelFetch() async { }
    
    func addToFavorites(dog: DogModel) { }
    
    func removeFromFavorites(dog: DogModel) { }
    
    func getFavoriteDogs() -> [DogModel] {
        favoriteDogs
    }
}
