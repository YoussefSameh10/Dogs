//
//  FavoritesRepo.swift
//  Dogs
//
//  Created by Youssef Ghattas on 31/03/2024.
//

import Foundation
import SwiftData

protocol FavoritesRepo {
    func addToFavorites(dog: DogModel) async
    func removeFromFavorites(dog: DogModel) async
    func getFavoriteDogs() async -> [DogModel]
}

struct FavoritesRepoImpl: FavoritesRepo {
    private let database: DogsDatabaseService
    
    init(database: DogsDatabaseService = DogsDatabaseServiceImpl()) {
        self.database = database
    }
    
    func addToFavorites(dog: DogModel) async {
        await database.addToFavorites(dog: dog)
    }
    
    func removeFromFavorites(dog: DogModel) async {
        await database.removeFromFavorites(dog: dog)
    }
    
    func getFavoriteDogs() async -> [DogModel] {
        await database.getFavoriteDogs()
    }
}
