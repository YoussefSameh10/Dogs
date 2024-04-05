//
//  DogsDatabaseService.swift
//  Dogs
//
//  Created by Youssef Ghattas on 01/04/2024.
//

import SwiftData

@ModelActor
actor DogsDatabaseServiceImpl: DogsDatabaseService {
    init?() {
        guard let container = try? ModelContainer(for: DogEntity.self) else { return nil }
        let modelContext = ModelContext(container)
        modelExecutor = DefaultSerialModelExecutor(modelContext: modelContext)
        modelContainer = container
    }
    func addToFavorites(dog: DogEntity) async {
        modelContext.insert(dog)
    }
    
    func removeFromFavorites(dog: DogEntity) async {
        guard let dogToDelete = try? modelContext
            .fetch(FetchDescriptor<DogEntity>())
            .first(where: { $0.id == dog.id})
        else { return }
        modelContext.delete(dogToDelete)
    }
    
    func getFavoriteDogs() async -> [DogEntity] {
        let dogs = try? modelContext.fetch(FetchDescriptor<DogEntity>())
        return dogs?.compactMap { $0 } ?? []
    }
}
