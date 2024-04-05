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
    
    init(id: String, breed: BreedModel, data: Data) {
        self.id = id
        self.breed = breed
        self.data = data
    }
    
    static func == (lhs: DogModel, rhs: DogModel) -> Bool {
        lhs.id == rhs.id
    }
}
