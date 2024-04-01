//
//  BreedsModel.swift
//  Dogs
//
//  Created by Youssef Ghattas on 01/04/2024.
//

import Foundation

struct BreedsResponse: Codable {
    private var message: [String: [String]]
    var status: String
    
    var breeds: [Breed] {
        message.map { Breed(name: $0.key) }
    }
}

struct Breed: Codable {
    let name: String
}
