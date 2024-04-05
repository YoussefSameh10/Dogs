//
//  BreedModelMapper.swift
//  Dogs
//
//  Created by Youssef Ghattas on 05/04/2024.
//

extension BreedModel {
    var toBreedViewModel: BreedViewModel {
        BreedViewModel(name: self.name)
    }
}

extension BreedViewModel {
    var toBreedModel: BreedModel {
        BreedModel(name: self.name)
    }
}
