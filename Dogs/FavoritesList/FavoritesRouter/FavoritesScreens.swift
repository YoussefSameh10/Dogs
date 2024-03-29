//
//  FavoritesScreens.swift
//  Dogs
//
//  Created by Youssef Ghattas on 29/03/2024.
//

import Foundation

extension FavoritesRouter {
    enum Screen: Hashable {
        case favoritesList
        case dog(DogViewModel)
        
        static func == (lhs: Screen, rhs: Screen) -> Bool {
            false
        }
        
        func hash(into hasher: inout Hasher) { }
    }
}
