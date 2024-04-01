//
//  BreedModels.swift
//  Dogs
//
//  Created by Youssef Ghattas on 01/04/2024.
//

import Foundation

struct BreedsResponse: Codable {
    var breeds: [String: [String]]
    var status: String
    
    enum CodingKeys: String, CodingKey {
        case breeds = "message"
        case status
    }
}

struct BreedModel: Codable {
    let name: String
}
