//
//  BreedsEnvironment.swift
//  Dogs
//
//  Created by Youssef Ghattas on 02/04/2024.
//

protocol BreedsRepo: Sendable {
    func fetchBreeds()  async throws -> [BreedModel]
}


protocol BreedsRouterDelegate: Sendable{
    func goNext(breed: BreedModel) async
    func showBreedsError(_ error: BreedsError) async
}

struct BreedsEnvironment: Sendable {
    private let repo: BreedsRepo
    private let router: BreedsRouterDelegate
    
    init(
        repo: BreedsRepo = BreedsRepoImpl(),
        router: BreedsRouterDelegate
    ) {
        self.repo = repo
        self.router = router
    }
    
    func fetchBreeds() async throws -> [BreedModel] {
        try await repo.fetchBreeds()
    }
    
    func goNext(breed: BreedModel) async {
        await router.goNext(breed: breed)
    }
    
    func handleError(_ error: BreedsError) async {
        await router.showBreedsError(error)
    }
}
