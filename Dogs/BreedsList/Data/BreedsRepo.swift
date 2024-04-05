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
    
    init(network: BreedsNetworkService = BreedsNetworkServiceImpl()) {
        self.network = network
    }
    
    func fetchBreeds()  async throws -> [BreedModel] {
        try await network.fetchBreeds()
            .toBreedModels
    }
}
