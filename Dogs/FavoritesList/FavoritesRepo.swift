//
//  FavoritesRepo.swift
//  Dogs
//
//  Created by Youssef Ghattas on 31/03/2024.
//

import Foundation
import SwiftData

protocol FavoritesRepo {
    func addToFavorites(dog: DogViewModel) async
    func removeFromFavorites(dog: DogViewModel) async
    func getFavoriteDogs() async -> [DogViewModel]
}

struct FavoritesRepoReal: FavoritesRepo {
    private let database: DatabaseService
    
    init(database: DatabaseService) {
        self.database = database
    }
    
    func addToFavorites(dog: DogViewModel) async {
        await database.addToFavorites(dog: dog)
    }
    
    func removeFromFavorites(dog: DogViewModel) async {
        await database.removeFromFavorites(dog: dog)
    }
    
    func getFavoriteDogs() async -> [DogViewModel] {
        await database.getFavoriteDogs()
    }
}
