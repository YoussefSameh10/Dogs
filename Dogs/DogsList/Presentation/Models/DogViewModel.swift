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
    
    init(id: String, breed: BreedViewModel, image: UIImage) {
        self.id = id
        self.breed = breed
        self.image = image
    }
    
    static func == (lhs: DogViewModel, rhs: DogViewModel) -> Bool {
        lhs.id == rhs.id
    }
}
