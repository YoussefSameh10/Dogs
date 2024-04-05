//
//  BreedsResponse.swift
//  Dogs
//
//  Created by Youssef Ghattas on 01/04/2024.
//

struct BreedsResponse: Codable {
    let breeds: [String: [String]]
    let status: String
    
    enum CodingKeys: String, CodingKey {
        case breeds = "message"
        case status
    }
}
