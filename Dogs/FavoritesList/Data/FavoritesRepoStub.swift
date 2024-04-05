//
//  FavoritesRepoStub.swift
//  Dogs
//
//  Created by Youssef Ghattas on 03/04/2024.
//

import UIKit

struct FavoritesRepoStub: FavoritesRepo {
    let breed = BreedModel(name: "Husky")
    var favoriteDogs: [DogModel] {
        guard let image = UIImage(systemName: "dog") else { return [] }
        return [
            DogModel(id: "3", breed: breed, image: image),
            DogModel(id: "5", breed: breed, image: image)
        ]
    }
    
    func addToFavorites(dog: DogModel) { }
    
    func removeFromFavorites(dog: DogModel) { }
    
    func getFavoriteDogs() -> [DogModel] {
        favoriteDogs
    }
}
