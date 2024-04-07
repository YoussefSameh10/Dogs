//
//  DogModel.swift
//  Dogs
//
//  Created by Youssef Ghattas on 05/04/2024.
//

import Foundation

struct DogModel: Identifiable, Equatable {
    let id: String
    let breed: BreedModel
    let data: Data
    var isFavorite: Bool
    
    init(id: String, breed: BreedModel, data: Data, isFavorite: Bool) {
        self.id = id
        self.breed = breed
        self.data = data
        self.isFavorite = isFavorite
    }
    
    static func == (lhs: DogModel, rhs: DogModel) -> Bool {
        lhs.id == rhs.id
    }
}
