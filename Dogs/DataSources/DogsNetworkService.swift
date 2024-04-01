//
//  DogsNetworkService.swift
//  Dogs
//
//  Created by Youssef Ghattas on 01/04/2024.
//

import Foundation

protocol DogsNetworkService {
    func fetchDogs(breed: Breed) async throws -> [DogViewModel]
}

struct DogsNetworkServiceImpl: DogsNetworkService {
    func fetchDogs(breed: Breed) async throws -> [DogViewModel] {
        let (data, _) = try await URLSession.shared.data(from: URL(string: "https://dog.ceo/api/breed/\(breed.name)/images")!)
        let dogsURLs = try JSONDecoder().decode(DogResponse.self, from: data).images.map { URL(string: $0)! }
        
        return try await withThrowingTaskGroup(of: DogViewModel?.self) { group in
            var dogs = [DogViewModel?]()
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
