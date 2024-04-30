//
//  BreedsNetworkService.swift
//  Dogs
//
//  Created by Youssef Ghattas on 01/04/2024.
//

import Foundation

actor BreedsNetworkServiceImpl: BreedsNetworkService {
    func fetchBreeds()  async throws -> BreedsNetworkEntity {
        do {
            return try await tryFetchBreeds()
        } catch is DecodingError {
            throw BreedsNetworkError.decode
        } catch {
            throw BreedsNetworkError.fetch
        }
    }
}

private func tryFetchBreeds() async throws -> BreedsNetworkEntity {
    let (data, _) = try await URLSession.shared.data(from: URL(string: "https://dog.ceo/api/breeds/list/all")!)
    return try JSONDecoder().decode(BreedsNetworkEntity.self, from: data)
}
