//
//  DogsRepo.swift
//  Dogs
//
//  Created by Youssef Ghattas on 31/03/2024.
//

import Foundation
import SwiftData

protocol DogsRepo {
    func fetchDogs(breed: Breed) async throws -> [DogViewModel]
    func addToFavorites(dog: DogViewModel) async
    func removeFromFavorites(dog: DogViewModel) async
    func getFavoriteDogs() async -> [DogViewModel]
}

struct DogsRepoReal: DogsRepo {
    private let database: DatabaseService
    
    init(database: DatabaseService) {
        self.database = database
    }
    
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
    
    func addToFavorites(dog: DogViewModel) async {
        await database.addToFavorites(dog: dog)
    }
    
    func removeFromFavorites(dog: DogViewModel) async {
        await database.removeFromFavorites(dog: dog)
    }
    
    func getFavoriteDogs() async -> [DogViewModel] {
        await database.getFavoriteDogs()
    }
}
