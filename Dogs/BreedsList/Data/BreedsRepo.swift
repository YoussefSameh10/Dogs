//
//  BreedsRepo.swift
//  Dogs
//
//  Created by Youssef Ghattas on 31/03/2024.
//

protocol BreedsNetworkService: Sendable {
    func fetchBreeds()  async throws -> BreedsNetworkEntity
}

struct BreedsRepoImpl: BreedsRepo {
    private let network: BreedsNetworkService
    private let networkMonitor: NetworkMonitor
    
    init(
        network: BreedsNetworkService = BreedsNetworkServiceImpl(),
        networkMonitor: NetworkMonitor = NetworkMonitorImpl()
    ) {
        self.network = network
        self.networkMonitor = networkMonitor
    }
    
    func fetchBreeds() async throws -> [BreedModel] {
        if networkMonitor.isConnected {
            do {
                return try await network.fetchBreeds()
                    .toBreedModels
            } catch let error as BreedsNetworkError {
                throw error.toBreedsError
            } catch {
                throw BreedsError.unknown
            }
        }
        throw BreedsError.network
    }
}
