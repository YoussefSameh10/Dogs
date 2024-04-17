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
    func addToFavorites(dog: DogModel) async
    func removeFromFavorites(dog: DogModel) async
    func getFavoriteDogs(breed: BreedModel?) async -> [DogModel]
}

protocol NetworkMonitor: Sendable {
    var isConnected: Bool { get }
}

struct DogsRepoImpl: DogsRepo {
    private let network: DogsNetworkService
    private let database: DogsDatabaseService?
    private let networkMonitor: NetworkMonitor
    
    init(
        network: DogsNetworkService = DogsNetworkServiceImpl(),
        database: DogsDatabaseService? = DogsDatabaseServiceImpl(),
        networkMonitor: NetworkMonitor = NetworkMonitorImpl()
    ) {
        self.network = network
        self.database = database
        self.networkMonitor = networkMonitor
    }
    
    func fetchDogs(breed: BreedModel) async throws -> [DogModel] {
        if networkMonitor.isConnected {
            return try await network.fetchDogs(breed: breed.name)
                .map { $0.toDogModel(with: breed.name) }
        }
        return await getFavoriteDogs(breed: breed)
    }
    
    func cancelFetch() async {
        await network.cancelFetch()
    }
    
    func addToFavorites(dog: DogModel) async {
        await database?.addToFavorites(dog: dog)
    }
    
    func removeFromFavorites(dog: DogModel) async {
        await database?.removeFromFavorites(dog: dog)
    }
    
    func getFavoriteDogs(breed: BreedModel) async -> [DogModel] {
        await database?.getFavoriteDogs(breed: breed) ?? []
    }
}
