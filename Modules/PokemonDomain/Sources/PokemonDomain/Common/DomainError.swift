//
//  Error.swift
//  RecipeDomain
//
//  Created by Nitin George on 07/03/2025.
//

import Foundation

@frozen
public enum PokemonError: Error {
    case invalidURL(url: String)
}

extension PokemonError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .invalidURL(let url):
            return "Invalid Pokemon URL: \(url)"
        }
    }
}

@frozen
public enum RecipeError: Error {
    case notFound(recipeID: Int)
}

extension RecipeError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .notFound(let id):
            return "Recipe with ID \(id) not found."
        }
    }
}
