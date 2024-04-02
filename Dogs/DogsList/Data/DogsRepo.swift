//
//  DogsRepo.swift
//  Dogs
//
//  Created by Youssef Ghattas on 31/03/2024.
//

import Foundation
import SwiftData

protocol DogsNetworkService: Sendable {
    func fetchDogs(breed: BreedModel) async throws -> [DogModel]
}

protocol DogsDatabaseService: Sendable {
    func addToFavorites(dog: DogModel) async
    func removeFromFavorites(dog: DogModel) async
    func getFavoriteDogs() async -> [DogModel]
}

struct DogsRepoImpl: DogsRepo {
    private let network: DogsNetworkService
    private let database: DogsDatabaseService?
    
    init(
        network: DogsNetworkService = DogsNetworkServiceImpl(),
        database: DogsDatabaseService? = DogsDatabaseServiceImpl()
    ) {
        self.network = network
        self.database = database
    }
    
    func fetchDogs(breed: BreedModel) async throws -> [DogModel] {
        try await network.fetchDogs(breed: breed).sorted { $0.id < $1.id }
    }
    
    func addToFavorites(dog: DogModel) async {
        await database?.addToFavorites(dog: dog)
    }
    
    func removeFromFavorites(dog: DogModel) async {
        await database?.removeFromFavorites(dog: dog)
    }
    
    func getFavoriteDogs() async -> [DogModel] {
        await database?.getFavoriteDogs().sorted { $0.id < $1.id } ?? []
    }
}
