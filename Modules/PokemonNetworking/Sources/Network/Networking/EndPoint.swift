//
//  EndPoint.swift
//  RecipeNetworking
//
//  Created by Nitin George on 01/03/2024.
//

import Foundation

protocol URLBuilder {
    var recipeBaseURL: String { get }
    var path: String { get }
    func url() throws -> URL
}

public enum EndPoint: Sendable {
    case recipes(page: Int, limit: Int)
}

extension EndPoint: URLBuilder {
    func url() throws -> URL {
        var components = URLComponents()
        components.scheme = "https"
        components.path = path
        
        switch self {
        case .recipes:
            components.host = recipeBaseURL
        }
        
        //https://tasty.p.rapidapi.com/recipes/list?from=0&size=20&tags=under_30_minutes
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
    
    var recipeBaseURL: String {
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

