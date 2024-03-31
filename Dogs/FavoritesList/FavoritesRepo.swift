//
//  FavoritesRepo.swift
//  Dogs
//
//  Created by Youssef Ghattas on 31/03/2024.
//

import Foundation
import SwiftData

protocol FavoritesRepo {
    func addToFavorites(dog: DogViewModel) async
    func removeFromFavorites(dog: DogViewModel) async
    func getFavoriteDogs() async -> [DogViewModel]
}

struct FavoritesRepoReal: FavoritesRepo {
    private var container: ModelContainer? = nil
    
    init() {
        do {
            container = try ModelContainer(for: Dog.self)
        } catch {
            print(error.localizedDescription)
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
