//
//  BreedDataMappers.swift
//  Dogs
//
//  Created by Youssef Ghattas on 05/04/2024.
//

extension BreedsNetworkEntity {
    var toBreedModels: [BreedModel] {
        self.breeds.map { BreedModel(name: $0.key) }
    }
}
