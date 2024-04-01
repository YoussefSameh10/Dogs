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
        case dog(DogModel)
        
        static func == (lhs: Screen, rhs: Screen) -> Bool {
            switch (lhs, rhs) {
            case (.favoritesList, .dog): false
            case (.dog, .favoritesList): false
            case (.favoritesList, .favoritesList): true
            case (.dog(let lhsDog), .dog(let rhsDog)):
                lhsDog == rhsDog
            }
        }
        
        func hash(into hasher: inout Hasher) { }
    }
}
