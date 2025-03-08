//
//  EndPoint.swift
//  RecipeNetworking
//
//  Created by Nitin George on 01/03/2024.
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

//https://pokeapi.co/api/v2/pokemon?offset=1&limit=1

extension EndPoint: URLBuilder {
    func url() throws -> URL {
        var components = URLComponents()
        components.scheme = "https"
        components.path = path
        
        switch self {
        case .pokemon:
            components.host = pokemonBaseURL
        }
        
        if case let .pokemon(offset, limit) = self {
            components.queryItems = [
                URLQueryItem(name: "from", value: "\(offset)"),
                URLQueryItem(name: "size", value: "\(limit)"),
                URLQueryItem(name: "tags", value: "under_30_minutes")
                ]
        }
        
        guard let url = components.url else {
            throw NetworkError.invalidURL(message: "Sorry, unable to constrcut URL for \(self)", debugInfo: components.debugDescription)
        }
        
        return url
    }
    
    var pokemonBaseURL: String {
        "tasty.p.rapidapi.com"
    }
    
    var path: String {
        switch self {
        case .pokemon:
            "/recipes/list"
        }
    }
}

extension EndPoint {
    var pokemonFetchInfo: (Int, Int) {
        guard case let .pokemon(offset, limit) = self else { return (0, 40) }
        return (offset, limit)
        }
}

