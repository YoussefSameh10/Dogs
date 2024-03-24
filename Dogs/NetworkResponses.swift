//
//  NetworkResponses.swift
//  Dogs
//
//  Created by Youssef Ghattas on 24/03/2024.
//

import Foundation

struct BreedsResponse: Codable {
    private var message: [String: [String]]
    var status: String
    
    var breeds: [Breed] {
        message.map { Breed(name: $0.key) }
    }
}

struct DogResponse: Codable {
    var images: [String]
    var status: String
    
    private enum CodingKeys: String, CodingKey {        
        case images = "message"
        case status
    }
}

struct Breed: Codable {
    var name: String
}
