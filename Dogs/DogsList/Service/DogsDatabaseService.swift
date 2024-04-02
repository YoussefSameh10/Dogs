//
//  DogsDatabaseService.swift
//  Dogs
//
//  Created by Youssef Ghattas on 01/04/2024.
//

import Foundation
import SwiftData

@ModelActor
actor DogsDatabaseServiceImpl: DogsDatabaseService {
    init?() {
        guard let container = try? ModelContainer(for: DogEntity.self) else { return nil }
        let modelContext = ModelContext(container)
        modelExecutor = DefaultSerialModelExecutor(modelContext: modelContext)
        modelContainer = container
    }
    func addToFavorites(dog: DogModel) async {
        guard let data = dog.image.pngData() else { return }
        modelContext.insert(DogEntity(id: dog.id, breed: dog.breed, data: data))
    }
    
    func removeFromFavorites(dog: DogModel) async {
        guard let dogToDelete = try? modelContext
            .fetch(FetchDescriptor<DogEntity>())
            .first(where: { $0.id == dog.id})
        else { return }
        modelContext.delete(dogToDelete)
    }
    
    func getFavoriteDogs() async -> [DogModel] {
        let dogs = try? modelContext.fetch(FetchDescriptor<DogEntity>())
        return dogs?.compactMap { $0.data.toDog(id: $0.id, breed: $0.breed) } ?? []
    }
}
