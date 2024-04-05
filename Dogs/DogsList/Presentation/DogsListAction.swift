//
//  DogsListAction.swift
//  Dogs
//
//  Created by Youssef Ghattas on 02/04/2024.
//

import Foundation

enum DogsListAction {
    case onAppear
    case loaded(dogs: [DogModel], favoriteDogs: [DogModel])
    case tapDog(DogModel)
    case tapFavorites(DogModel)
    case onDisappear
}
