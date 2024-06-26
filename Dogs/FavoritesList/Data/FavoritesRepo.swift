//
//  FavoritesRepo.swift
//  Dogs
//
//  Created by Youssef Ghattas on 31/03/2024.
//

struct FavoritesRepoImpl: FavoritesRepo {
    private let database: DogsDatabaseService?
    
    init(database: DogsDatabaseService? = DogsDatabaseServiceImpl()) {
        self.database = database
    }
    
    func addToFavorites(dog: DogModel) async {
        await database?.addToFavorites(dog: dog)
    }
    
    func removeFromFavorites(dog: DogModel) async {
        await database?.removeFromFavorites(dog: dog)
    }
    
    func getFavoriteDogs(breed: BreedModel?) async -> [DogModel] {
        await database?.getFavoriteDogs(breed: breed) ?? []
    }
}
