//
//  DogsListEnvironment.swift
//  Dogs
//
//  Created by Youssef Ghattas on 02/04/2024.
//

import Foundation

protocol DogsRepo: Sendable {
    func fetchDogs(breed: BreedModel) async throws -> [DogModel]
    func addToFavorites(dog: DogModel) async
    func removeFromFavorites(dog: DogModel) async
    func getFavoriteDogs() async -> [DogModel]
}

protocol DogsRouterDelegate: Sendable {
    func goNext(dog: DogModel) async
}

struct DogsListEnvironment: Sendable {
    private let repo: DogsRepo
    private let router: DogsRouterDelegate
    
    init(
        repo: DogsRepo = DogsRepoImpl(),
        router: DogsRouterDelegate
    ) {
        self.repo = repo
        self.router = router
    }
    
    func fetchDogs(breed: BreedModel) async throws -> [DogModel] {
        try await repo.fetchDogs(breed: breed)
    }
    
    func addToFavorites(dog: DogModel) async {
        await repo.addToFavorites(dog: dog)
    }
    
    func removeFromFavorites(dog: DogModel) async {
        await repo.removeFromFavorites(dog: dog)
    }
    
    func getFavoriteDogs() async -> [DogModel] {
        await repo.getFavoriteDogs()
    }
    
    func goNext(dog: DogModel) async {
        await router.goNext(dog: dog)
    }
}
