//
//  BreedsScreens.swift
//  Dogs
//
//  Created by Youssef Ghattas on 29/03/2024.
//

extension BreedsRouterImpl {
    enum Screen: Hashable {
        case breedsList
        case dogsList(BreedModel)
        case dog(DogModel)
        case breedsError(BreedsError)
        case dogsError(DogsError)
        
        static func == (lhs: Screen, rhs: Screen) -> Bool {
            switch (lhs, rhs) {
            case (.breedsList, .breedsList):
                true
            case let(.dogsList(lhsBreed), .dogsList(rhsBreed)):
                lhsBreed.name == rhsBreed.name
            case (.dogsList, .breedsList):
                false
            case (.breedsList, .dogsList):
                false
            case (.dog, _):
                true
            case (_, .dog):
                true
            case (.breedsError(_), .breedsList):
                false
            case (.breedsError(_), .dogsList(_)):
                false
            case (.breedsError(_), .breedsError(_)):
                true
            case (.dogsList(_), .breedsError(_)):
                false
            case (.breedsList, .breedsError(_)):
                false
            case (.dogsError(_), .breedsList):
                false
            case (.dogsError(_), .dogsList(_)):
                false
            case (.dogsError(_), .breedsError(_)):
                false
            case (.dogsError(_), .dogsError(_)):
                true
            case (.breedsError(_), .dogsError(_)):
                false
            case (.dogsList(_), .dogsError(_)):
                false
            case (.breedsList, .dogsError(_)):
                false
            }
        }
        
        func hash(into hasher: inout Hasher) { }
    }
}
