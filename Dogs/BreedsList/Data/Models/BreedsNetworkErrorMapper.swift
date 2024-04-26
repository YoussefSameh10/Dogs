//
//  BreedsNetworkErrorMapper.swift
//  Dogs
//
//  Created by Youssef Ghattas on 26/04/2024.
//

import Foundation

extension BreedsNetworkError {
    var toBreedsError: BreedsError {
        switch self {
        case .fetch: .network
        case .decode: .unknown
        }
    }
}
