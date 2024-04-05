//
//  DogsNetworkService.swift
//  Dogs
//
//  Created by Youssef Ghattas on 01/04/2024.
//

import Foundation

actor DogsNetworkServiceImpl: DogsNetworkService {
    private var task: Task<[DogNetworkEntity], Error>?
    
    func fetchDogs(breed: String) async throws -> [DogNetworkEntity] {
        task = Task {
            let (data, _) = try await URLSession.shared.data(from: URL(string: "https://dog.ceo/api/breed/\(breed)/images")!)
            let dogsURLs = try JSONDecoder().decode(DogsResponse.self, from: data).images.map { URL(string: $0)! }
            
            return try await withThrowingTaskGroup(of: DogNetworkEntity?.self) { group in
                var dogs = [DogNetworkEntity?]()
                for url in dogsURLs {
                    group.addTask {
                        try await URLSession.shared.data(from: url)
                            .0
                            .toDog(id: url.relativePath)
                    }
                }
                
                for try await dog in group {
                    try Task.checkCancellation()
                    dogs.append(dog)
                }
                
                return dogs.compactMap { $0 }
            }
        }
        
        return try await task?.value ?? []
    }
    
    func cancelFetch() {
        task?.cancel()
    }
    
}
