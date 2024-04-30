//
//  BreedsUIErrorMapper.swift
//  Dogs
//
//  Created by Youssef Ghattas on 26/04/2024.
//

extension BreedsError {
    var toUIError: BreedsUIError {
        switch self {
        case .network: .network
        case .unknown: .unknown
        }
    }
}

extension BreedsUIError {
    var toDomainError: BreedsError {
        switch self {
        case .network: .network
        case .unknown: .unknown
        }
    }
}
