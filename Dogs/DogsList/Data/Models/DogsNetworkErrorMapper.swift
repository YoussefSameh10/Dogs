//
//  DogsNetworkErrorMapper.swift
//  Dogs
//
//  Created by Youssef Ghattas on 26/04/2024.
//

extension DogsNetworkError {
    var toDogsError: DogsError {
        switch self {
        case .decode: .unknown
        case .fetch: .network
        }
    }
}
