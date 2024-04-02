//
//  DogsListState.swift
//  Dogs
//
//  Created by Youssef Ghattas on 02/04/2024.
//

import Foundation

struct DogsListState {
    let breed: BreedModel
    var dogs = [DogModel]()
    var favoriteDogs = [DogModel]()
    var isLoading = true
}
