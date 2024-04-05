//
//  FavoritesListAction.swift
//  Dogs
//
//  Created by Youssef Ghattas on 02/04/2024.
//

enum FavoritesListAction {
    case onAppear
    case loaded([DogModel])
    case tapDog(DogModel)
    case tapFavorite(DogModel)
}
