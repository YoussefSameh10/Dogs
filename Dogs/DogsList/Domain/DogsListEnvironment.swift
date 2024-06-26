//
//  DogsListEnvironment.swift
//  Dogs
//
//  Created by Youssef Ghattas on 02/04/2024.
//

protocol DogsRepo: Sendable {
    func fetchDogs(breed: BreedModel) async throws -> [DogModel]
    func cancelFetch() async
    func addToFavorites(dog: DogModel) async
    func removeFromFavorites(dog: DogModel) async
    func getFavoriteDogs(breed: BreedModel) async -> [DogModel]
}

protocol DogsRouterDelegate: Sendable {
    func goNext(dog: DogModel) async
    func showDogsError(_ error: DogsError) async
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
    
    func cancelFetch() async {
        await repo.cancelFetch()
    }
    
    func addToFavorites(dog: DogModel) async {
        await repo.addToFavorites(dog: dog)
    }
    
    func removeFromFavorites(dog: DogModel) async {
        await repo.removeFromFavorites(dog: dog)
    }
    
    func getFavoriteDogs(breed: BreedModel) async -> [DogModel] {
        await repo.getFavoriteDogs(breed: breed)
    }
    
    func goNext(dog: DogModel) async {
        await router.goNext(dog: dog)
    }
    
    func handleError(_ error: DogsError) async {
        await router.showDogsError(error)
    }
}
