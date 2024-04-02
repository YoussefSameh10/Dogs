//
//  DogModels.swift
//  Dogs
//
//  Created by Youssef Ghattas on 01/04/2024.
//

import Foundation
import SwiftData
import UIKit

struct DogsResponse: Codable {
    var images: [String]
    var status: String
    
    private enum CodingKeys: String, CodingKey {
        case images = "message"
        case status
    }
}

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
