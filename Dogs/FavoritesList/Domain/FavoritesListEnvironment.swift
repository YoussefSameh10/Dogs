//
//  FavoritesListEnvironment.swift
//  Dogs
//
//  Created by Youssef Ghattas on 02/04/2024.
//

protocol FavoritesRepo: Sendable {
    func addToFavorites(dog: DogModel) async
    func removeFromFavorites(dog: DogModel) async
    func getFavoriteDogs(breed: BreedModel?) async -> [DogModel]
}

protocol FavoritesRouterDelegate: Sendable{
    func goNext(dog: DogModel) async
}

struct FavoritesListEnvironment: Sendable {
    private let repo: FavoritesRepo
    private let router: FavoritesRouterDelegate
    
    init(
        repo: FavoritesRepo = FavoritesRepoImpl(),
        router: FavoritesRouterDelegate
    ) {
        self.repo = repo
        self.router = router
    }
    
    func addToFavorites(dog: DogModel) async {
        await repo.addToFavorites(dog: dog)
    }
    
    func removeFromFavorites(dog: DogModel) async {
        await repo.removeFromFavorites(dog: dog)
    }
    
    func getFavoriteDogs(breed: BreedModel? = nil) async -> [DogModel] {
        await repo.getFavoriteDogs(breed: breed)
    }
    
    func goNext(dog: DogModel) async {
        await router.goNext(dog: dog)
    }
}
