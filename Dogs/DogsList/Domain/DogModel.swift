//
//  DogModel.swift
//  Dogs
//
//  Created by Youssef Ghattas on 05/04/2024.
//

import UIKit

struct DogModel: Identifiable, Equatable {
    let id: String
    let breed: BreedModel
    let image: UIImage
    
    init(id: String, breed: BreedModel, image: UIImage) {
        self.id = id
        self.breed = breed
        self.image = image
    }
    
    static func == (lhs: DogModel, rhs: DogModel) -> Bool {
        lhs.id == rhs.id
    }
}

extension Data {
    func toDog(id: String, breed: BreedModel) -> DogModel? {
        guard let image = UIImage(data: self) else { return nil }
        return DogModel(id: id, breed: breed, image: image)
    }
}
