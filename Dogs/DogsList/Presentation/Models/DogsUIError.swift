//
//  DogsUIError.swift
//  Dogs
//
//  Created by Youssef Ghattas on 26/04/2024.
//

enum DogsUIError {
    case network
    case unknown
    
    var description: String {
        switch self {
        case .network:
            "It seems there is a connection error. Please check your network and try restarting the app."
        case .unknown:
            "Unknown error occurred. Please try restarting the app."
        }
    }
}
