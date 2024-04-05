//
//  DogsResponse.swift
//  Dogs
//
//  Created by Youssef Ghattas on 05/04/2024.
//

struct DogsResponse: Codable {
    let images: [String]
    let status: String
    
    private enum CodingKeys: String, CodingKey {
        case images = "message"
        case status
    }
}
