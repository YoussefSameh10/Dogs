//
//  DogsDatabaseService.swift
//  Dogs
//
//  Created by Youssef Ghattas on 01/04/2024.
//

import Foundation
import SwiftData

protocol DogsDatabaseService {
    func addToFavorites(dog: DogModel) async
    func removeFromFavorites(dog: DogModel) async
    func getFavoriteDogs() async -> [DogModel]
}

struct DogsDatabaseServiceImpl: DogsDatabaseService {
    private var container: ModelContainer? = nil
    
    init() {
        do {
            container = try ModelContainer(for: DogEntity.self)
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func addToFavorites(dog: DogModel) async {
        guard let data = dog.image.pngData() else { return }
        await container?.mainContext.insert(DogEntity(id: dog.id, breed: dog.breed, data: data))
    }
    
    func removeFromFavorites(dog: DogModel) async {
        guard let data = dog.image.pngData() else { return }
        guard let dogToDelete = try? await container?.mainContext.fetch(FetchDescriptor<DogEntity>()).first(where: { $0.id == dog.id}) else { return }
        await container?.mainContext.delete(dogToDelete)
    }
    
    func getFavoriteDogs() async -> [DogModel] {
        let dogs = try? await container?.mainContext.fetch(FetchDescriptor<DogEntity>())
        return dogs?.compactMap { $0.data.toDog(id: $0.id, breed: $0.breed) } ?? []
    }
}
