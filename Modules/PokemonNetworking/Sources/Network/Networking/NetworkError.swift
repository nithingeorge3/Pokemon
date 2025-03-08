//
//  NetworkError.swift
//  RecipeNetworking
//
//  Created by Nitin George on 01/03/2024.
//

import Foundation

@frozen
public enum NetworkError: Error {
    case invalidURL(message: String, debugInfo: String)
    case responseError
    case failedToDecode
    case noKeyAvailable
    case contextDeallocated
    case noNetworkAndNoCache(context: Error)
    case unKnown
}

extension NetworkError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .invalidURL:
            "Invalid URL, pleas echeck the url and try again"
        case .responseError:
            "Failed to fetch data from server, please try again later"
        case .failedToDecode:
            "Failed to decode teh data. Error"
        case .noKeyAvailable:
            "Failed to fetch key from server, please try again later"
        case .unKnown:
            "An Unknown occured, please contact support"
        case .contextDeallocated:
            "Context Deallocated"
        case .noNetworkAndNoCache(let error):
            "No network and no cache available: \(error)"
        }
    }
}
