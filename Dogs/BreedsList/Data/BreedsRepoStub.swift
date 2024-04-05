//
//  BreedsRepoStub.swift
//  Dogs
//
//  Created by Youssef Ghattas on 03/04/2024.
//

struct BreedsRepoStub: BreedsRepo {
    func fetchBreeds() async throws -> [BreedModel] {
        return [
            BreedModel(name: "Boxer"),
            BreedModel(name: "Cooker"),
            BreedModel(name: "German Shepherd"),
            BreedModel(name: "Golden Retriever"),
            BreedModel(name: "Husky"),
            BreedModel(name: "Labrador"),
            BreedModel(name: "Pitbul"),
        ]
    }
}
