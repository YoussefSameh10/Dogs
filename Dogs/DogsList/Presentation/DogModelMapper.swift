//
//  DogModelMapper.swift
//  Dogs
//
//  Created by Youssef Ghattas on 05/04/2024.
//

import UIKit

extension DogModel {
    var toDogViewModel: DogViewModel {
        let image = UIImage(data: self.data)!
        return DogViewModel(id: self.id, breed: self.breed.toBreedViewModel, image: image)
    }
}

extension DogViewModel {
    var toDogModel: DogModel {
        let data = self.image.pngData()!
        return DogModel(id: self.id, breed: self.breed.toBreedModel, data: data)
    }
}
