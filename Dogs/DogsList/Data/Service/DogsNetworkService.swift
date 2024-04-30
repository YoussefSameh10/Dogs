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
        do {
            return try await tryFetchDogs(breed: breed)
        } catch is DecodingError {
            throw DogsNetworkError.decode
        } catch {
            throw DogsNetworkError.fetch
        }
    }
    
    func cancelFetch() {
        task?.cancel()
    }
    
    private func tryFetchDogs(breed: String) async throws -> [DogNetworkEntity] {
        task = Task {
            let dogsURLs = try await fetchDogsURLs(breed: breed)
            return try await withThrowingTaskGroup(of: DogNetworkEntity?.self) { group in
                var dogs = [DogNetworkEntity?]()
                for url in dogsURLs {
                    group.addTask { [weak self] in
                        try await self?.fetchDog(url: url)
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
    
    private func fetchDogsURLs(breed: String) async throws -> [URL] {
        let (data, _) = try await URLSession.shared.data(from: URL(string: "https://dog.ceo/api/breed/\(breed)/images")!)
        return try JSONDecoder().decode(DogsResponse.self, from: data).images.map { URL(string: $0)! }
    }
    
    private func fetchDog(url: URL) async throws -> DogNetworkEntity? {
        let (data, _) = try await URLSession.shared.data(from: url)
        return data.toDog(id: url.relativePath)
    }
}
