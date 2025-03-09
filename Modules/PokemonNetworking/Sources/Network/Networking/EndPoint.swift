//
//  EndPoint.swift
//  PokemonNetworking
//
//  Created by Nitin George on 08/03/2024.
//

import Foundation

protocol URLBuilder {
    var pokemonBaseURL: String { get }
    var path: String { get }
    func url() throws -> URL
}

public enum EndPoint: Sendable {
    case pokemon(offset: Int, limit: Int)
}

extension EndPoint: URLBuilder {
    func url() throws -> URL {
        var components = URLComponents()
        components.scheme = "https"
        components.host = pokemonBaseURL
        components.path = path
        
        switch self {
        case .pokemon(let offset, let limit):
            components.queryItems = [
                URLQueryItem(name: "offset", value: "\(offset)"),
                URLQueryItem(name: "limit", value: "\(limit)")
            ]
        }
        
        guard let url = components.url else {
            throw NetworkError.invalidURL(
                message: "Failed to construct URL for \(self)",
                debugInfo: "Components: \(components)"
            )
        }
        
        return url
    }
    
     var pokemonBaseURL: String {
        "pokeapi.co"
    }
    
     var path: String {
        switch self {
        case .pokemon:
            return "/api/v2/pokemon"
        }
    }
}

extension EndPoint {
    var pokemonFetchInfo: (Int, Int) {
        guard case let .pokemon(offset, limit) = self else { return (0, 40) }
        return (offset, limit)
        }
}

