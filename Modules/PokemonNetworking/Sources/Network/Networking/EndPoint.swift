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
    case recipes(page: Int, limit: Int)
}

//https://pokeapi.co/api/v2/pokemon?offset=1&limit=1

extension EndPoint: URLBuilder {
    func url() throws -> URL {
        var components = URLComponents()
        components.scheme = "https"
        components.path = path
        
        switch self {
        case .recipes:
            components.host = pokemonBaseURL
        }
        
        if case let .recipes(page, limit) = self {
            components.queryItems = [
                URLQueryItem(name: "from", value: "\(page)"),
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
        case .recipes:
            "/recipes/list"
        }
    }
}

extension EndPoint {
    var recipeFetchInfo: (Int, Int) {
        guard case let .recipes(page, limit) = self else { return (0, 40) }
        return (page, limit)
        }
}

