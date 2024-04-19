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
    func addToFavorites(dog: DogModel) async {
        modelContext.insert(dog.toDogEntity)
    }
    
    func removeFromFavorites(dog: DogModel) async {
        guard let dogToDelete = try? modelContext
            .fetch(FetchDescriptor<DogEntity>())
            .first(where: { $0.id == dog.id})
        else { return }
        modelContext.delete(dogToDelete)
    }
    
    func getFavoriteDogs(breed: BreedModel?) async -> [DogModel] {
        let dogs = try? modelContext.fetch(FetchDescriptor<DogEntity>())
        if let breed {
            return dogs?
                .compactMap { $0.toDogModel }
                .filter { $0.breed == breed } ?? []
        }
        return dogs?
            .compactMap { $0.toDogModel } ?? []
    }
}
