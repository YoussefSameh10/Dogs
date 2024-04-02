//
//  BreedsNetworkService.swift
//  Dogs
//
//  Created by Youssef Ghattas on 01/04/2024.
//

import Foundation

protocol BreedsNetworkService: Sendable {
    func fetchBreeds()  async throws -> [BreedModel]
}

struct BreedsNetworkServiceImpl: BreedsNetworkService {
    func fetchBreeds()  async throws -> [BreedModel] {
        let (data, _) = try await URLSession.shared.data(from: URL(string: "https://dog.ceo/api/breeds/list/all")!)
        return try JSONDecoder().decode(BreedsResponse.self, from: data)
            .breeds
            .map { BreedModel(name: $0.key) }
            .sorted(by: { $0.name < $1.name })
    }
}
