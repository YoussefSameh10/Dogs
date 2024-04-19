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
        guard let data = UIImage(systemName: "dog")?.pngData() else { return [] }
        return [
            DogModel(id: "3", breed: breed, data: data, isFavorite: true),
            DogModel(id: "5", breed: breed, data: data, isFavorite: true)
        ]
    }
    
    func addToFavorites(dog: DogModel) { }
    
    func removeFromFavorites(dog: DogModel) { }
    
    func getFavoriteDogs(breed: BreedModel?) -> [DogModel] {
        favoriteDogs
    }
}
