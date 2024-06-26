//
//  DogsListAction.swift
//  Dogs
//
//  Created by Youssef Ghattas on 02/04/2024.
//

enum DogsListAction {
    case onAppear
    case loaded(dogs: [DogModel])
    case tapDog(DogModel)
    case tapFavorites(DogModel)
    case onDisappear
}
