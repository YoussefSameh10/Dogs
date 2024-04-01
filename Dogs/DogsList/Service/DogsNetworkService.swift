//
//  DogsNetworkService.swift
//  Dogs
//
//  Created by Youssef Ghattas on 01/04/2024.
//

import Foundation

protocol DogsNetworkService {
    func fetchDogs(breed: BreedModel) async throws -> [DogModel]
}

struct DogsNetworkServiceImpl: DogsNetworkService {
    func fetchDogs(breed: BreedModel) async throws -> [DogModel] {
        let (data, _) = try await URLSession.shared.data(from: URL(string: "https://dog.ceo/api/breed/\(breed.name)/images")!)
        let dogsURLs = try JSONDecoder().decode(DogsResponse.self, from: data).images.map { URL(string: $0)! }
        
        return try await withThrowingTaskGroup(of: DogModel?.self) { group in
            var dogs = [DogModel?]()
            for url in dogsURLs {
                group.addTask {
                    try await URLSession.shared.data(from: url).0.toDog(id: url.relativePath, breed: breed)
                }
            }
            
            for try await dog in group {
                dogs.append(dog)
            }
            
            return dogs.compactMap { $0 }
        }
    }
}
