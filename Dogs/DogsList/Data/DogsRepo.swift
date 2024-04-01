//
//  DogsRepo.swift
//  Dogs
//
//  Created by Youssef Ghattas on 31/03/2024.
//

import Foundation
import SwiftData

protocol DogsRepo {
    func fetchDogs(breed: Breed) async throws -> [DogModel]
    func addToFavorites(dog: DogModel) async
    func removeFromFavorites(dog: DogModel) async
    func getFavoriteDogs() async -> [DogModel]
}

struct DogsRepoImpl: DogsRepo {
    private let network: DogsNetworkService
    private let database: DogsDatabaseService
    
    init(
        network: DogsNetworkService = DogsNetworkServiceImpl(),
        database: DogsDatabaseService = DogsDatabaseServiceImpl()
    ) {
        self.network = network
        self.database = database
    }
    
    func fetchDogs(breed: Breed) async throws -> [DogModel] {
        try await network.fetchDogs(breed: breed)
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
