//
//  DogsRepo.swift
//  Dogs
//
//  Created by Youssef Ghattas on 31/03/2024.
//

import Foundation
import SwiftData

struct DogsRepo {
    var container: ModelContainer? = nil
    
    init() {
        do {
            container = try ModelContainer(for: Dog.self)
        } catch {
            print(error.localizedDescription)
        }
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
        guard let data = dog.image.pngData() else { return }
        await container?.mainContext.insert(Dog(id: dog.id, breed: dog.breed, data: data))
    }
    
    func removeFromFavorites(dog: DogViewModel) async {
        guard let data = dog.image.pngData() else { return }
        guard let dogToDelete = try? await container?.mainContext.fetch(FetchDescriptor<Dog>()).first(where: { $0.id == dog.id }) else { return }
        await container?.mainContext.delete(dogToDelete)
    }
    
    func getFavoriteDogs() async -> [DogViewModel] {
        let dogs = try? await container?.mainContext.fetch(FetchDescriptor<Dog>())
        return dogs?.compactMap { $0.data.toDog(id: $0.id, breed: $0.breed) } ?? []
    }
}
