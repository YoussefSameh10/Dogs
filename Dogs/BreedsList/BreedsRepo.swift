//
//  BreedsRepo.swift
//  Dogs
//
//  Created by Youssef Ghattas on 31/03/2024.
//

import Foundation

struct BreedsRepo {
    func fetchBreeds()  async throws -> [Breed] {
        let (data, _) = try await URLSession.shared.data(from: URL(string: "https://dog.ceo/api/breeds/list/all")!)
        return try JSONDecoder().decode(BreedsResponse.self, from: data).breeds.sorted(by: { $0.name < $1.name })
    }
}
