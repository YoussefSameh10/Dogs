//
//  DogsRepo.swift
//  Dogs
//
//  Created by Youssef Ghattas on 31/03/2024.
//

protocol DogsNetworkService: Sendable {
    func fetchDogs(breed: String) async throws -> [DogNetworkEntity]
    func cancelFetch() async
}

protocol DogsDatabaseService: Sendable {
    func addToFavorites(dog: DogEntity) async
    func removeFromFavorites(dog: DogEntity) async
    func getFavoriteDogs() async -> [DogEntity]
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
        try await network.fetchDogs(breed: breed.name)
            .map { $0.toDogModel(with: breed.name) }
            .sorted { $0.id < $1.id }
    }
    
    func cancelFetch() async {
        await network.cancelFetch()
    }
    
    func addToFavorites(dog: DogModel) async {
        await database?.addToFavorites(dog: dog.toDogEntity)
    }
    
    func removeFromFavorites(dog: DogModel) async {
        await database?.removeFromFavorites(dog: dog.toDogEntity)
    }
    
    func getFavoriteDogs() async -> [DogModel] {
        await database?.getFavoriteDogs().map { $0.toDogModel }.sorted { $0.id < $1.id } ?? []
    }
}
