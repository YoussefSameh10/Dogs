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
        case error(BreedsError)
        
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
            case (.error(_), .breedsList):
                false
            case (.error(_), .dogsList(_)):
                false
            case (.error(_), .error(_)):
                true
            case (.dogsList(_), .error(_)):
                false
            case (.breedsList, .error(_)):
                false
            }
        }
        
        func hash(into hasher: inout Hasher) { }
    }
}
