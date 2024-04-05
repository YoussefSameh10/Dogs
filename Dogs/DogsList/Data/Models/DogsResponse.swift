//
//  DogsResponse.swift
//  Dogs
//
//  Created by Youssef Ghattas on 05/04/2024.
//

import Foundation

struct DogsResponse: Codable {
    let images: [String]
    let status: String
    
    private enum CodingKeys: String, CodingKey {
        case images = "message"
        case status
    }
}

struct DogNetworkEntity {
    let id: String
    let data: Data
}

extension Data {
    func toDog(id: String) -> DogNetworkEntity? {
        return DogNetworkEntity(id: id, data: self)
    }
}
