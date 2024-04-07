//
//  DogViewModel.swift
//  Dogs
//
//  Created by Youssef Ghattas on 05/04/2024.
//

import UIKit

struct DogViewModel: Identifiable, Equatable {
    let id: String
    let breed: BreedViewModel
    let image: UIImage
    var isFavorite: Bool
    
    init(id: String, breed: BreedViewModel, image: UIImage, isFavorite: Bool) {
        self.id = id
        self.breed = breed
        self.image = image
        self.isFavorite = isFavorite
    }
    
    static func == (lhs: DogViewModel, rhs: DogViewModel) -> Bool {
        lhs.id == rhs.id
    }
}
