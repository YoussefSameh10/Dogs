//
//  DogModels.swift
//  Dogs
//
//  Created by Youssef Ghattas on 01/04/2024.
//

import SwiftData
import Foundation

@Model
class DogEntity: Identifiable, Equatable {
    let id: String
    let data: Data
    let breed: BreedModel
    init(id: String, breed: BreedModel, data: Data) {
        self.id = id
        self.breed = breed
        self.data = data
    }
}
