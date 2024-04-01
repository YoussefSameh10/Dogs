//
//  DogsRepo.swift
//  Dogs
//
//  Created by Youssef Ghattas on 31/03/2024.
//

import Foundation
import SwiftData

protocol DogsRepo {
    func fetchDogs(breed: Breed) async throws -> [DogViewModel]
    func addToFavorites(dog: DogViewModel) async
    func removeFromFavorites(dog: DogViewModel) async
    func getFavoriteDogs() async -> [DogViewModel]
}

struct DogsRepoImpl: DogsRepo {
    private let network: DogsNetworkService
    private let database: DatabaseService
    
    init(
        network: DogsNetworkService = DogsNetworkServiceImpl(),
        database: DatabaseService = DatabaseServiceImpl()
    ) {
        self.network = network
        self.database = database
    }
    
    func fetchDogs(breed: Breed) async throws -> [DogViewModel] {
        try await network.fetchDogs(breed: breed)
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
