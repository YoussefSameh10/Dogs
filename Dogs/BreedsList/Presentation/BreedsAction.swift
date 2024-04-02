//
//  BreedsAction.swift
//  Dogs
//
//  Created by Youssef Ghattas on 02/04/2024.
//

import Foundation

enum BreedsAction {
    case onAppear
    case loaded([BreedModel])
    case open(BreedModel)
    case search(String)
}
