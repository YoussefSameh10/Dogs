//
//  BreedsNetworkService.swift
//  Dogs
//
//  Created by Youssef Ghattas on 01/04/2024.
//

import Foundation

actor BreedsNetworkServiceImpl: BreedsNetworkService {
    func fetchBreeds()  async throws -> BreedsNetworkEntity {
        let task = Task {
            let (data, _) = try await URLSession.shared.data(from: URL(string: "https://dog.ceo/api/breeds/list/all")!)
            return try JSONDecoder().decode(BreedsNetworkEntity.self, from: data)
        }
        
        return try await task.value
    }
}
