//
//  DogsUIErrorMapper.swift
//  Dogs
//
//  Created by Youssef Ghattas on 26/04/2024.
//

import Foundation

extension DogsError {
    var toUIError: DogsUIError {
        switch self {
        case .network: .network
        case .unknown: .unknown
        }
    }
}
