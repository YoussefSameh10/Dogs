//
//  DogDetailsEnvironment.swift
//  Dogs
//
//  Created by Youssef Ghattas on 07/04/2024.
//

struct DogDetailsEnvironment {
    private let repo: FavoritesRepo
    
    init(repo: FavoritesRepo = FavoritesRepoImpl()) {
        self.repo = repo
    }
    
    func addToFavorites(dog: DogModel) async {
        await repo.addToFavorites(dog: dog)
    }
    
    func removeFromFavorites(dog: DogModel) async {
        await repo.removeFromFavorites(dog: dog)
    }
}
