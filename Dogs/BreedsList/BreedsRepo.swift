//
//  BreedsRepo.swift
//  Dogs
//
//  Created by Youssef Ghattas on 31/03/2024.
//

import Foundation

protocol BreedsRepo {
    func fetchBreeds()  async throws -> [Breed]
}

struct BreedsRepoReal: BreedsRepo {
    private let network: BreedsNetworkService
    
    init(network: BreedsNetworkService = BreedsNetworkServiceImpl()) {
        self.network = network
    }
    
    func fetchBreeds()  async throws -> [Breed] {
        try await network.fetchBreeds()
    }
}
