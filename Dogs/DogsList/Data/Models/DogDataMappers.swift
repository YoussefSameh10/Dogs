//
//  DogDataMappers.swift
//  Dogs
//
//  Created by Youssef Ghattas on 05/04/2024.
//

import Foundation

extension DogNetworkEntity {
    func toDogModel(with breed: String) -> DogModel {
        DogModel(id: self.id, breed: BreedModel(name: breed), data: data, isFavorite: false)
    }
}

extension DogEntity {
    var toDogModel: DogModel {
        DogModel(id: self.id, breed: BreedModel(name: self.breed), data: self.data, isFavorite: true)
    }
}

extension DogModel {
    var toDogEntity: DogEntity {
        DogEntity(id: self.id, breed: self.breed.name, data: self.data)
    }
}
