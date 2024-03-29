//
//  BreedsScreens.swift
//  Dogs
//
//  Created by Youssef Ghattas on 29/03/2024.
//

import Foundation

extension BreedsRouter {
    enum Screen: Hashable {
        case breedsList
        case dogsList(Breed)
        case dog(DogViewModel)
        
        static func == (lhs: Screen, rhs: Screen) -> Bool {
            switch (lhs, rhs) {
            case (.breedsList, .breedsList):
                return true
            case let(.dogsList(lhsBreed), .dogsList(rhsBreed)):
                return lhsBreed.name == rhsBreed.name
            case (.dogsList, .breedsList):
                return false
            case (.breedsList, .dogsList):
                return false
            case (.dog, _):
                return false
            case (_, .dog):
                return false
            }
        }
        
        func hash(into hasher: inout Hasher) { }
    }
}
