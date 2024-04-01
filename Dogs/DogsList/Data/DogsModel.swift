//
//  DogsModel.swift
//  Dogs
//
//  Created by Youssef Ghattas on 01/04/2024.
//

import Foundation
import SwiftData
import UIKit

struct DogResponse: Codable {
    var images: [String]
    var status: String
    
    private enum CodingKeys: String, CodingKey {
        case images = "message"
        case status
    }
}

@Model
class Dog: Identifiable, Equatable {
    let id: String
    let data: Data
    let breed: Breed
    init(id: String, breed: Breed, data: Data) {
        self.id = id
        self.breed = breed
        self.data = data
    }
}

struct DogViewModel: Identifiable, Equatable {
    static func == (lhs: DogViewModel, rhs: DogViewModel) -> Bool {
        lhs.id == rhs.id
    }
    
    let id: String
    let breed: Breed
    let image: UIImage
    
    init(id: String, breed: Breed, image: UIImage) {
        self.id = id
        self.breed = breed
        self.image = image
    }
}
