//
//  Error.swift
//  RecipeDomain
//
//  Created by Nitin George on 07/03/2025.
//

import Foundation

@frozen
public enum PokemonError: Error {
    case invalidPokemonURL(url: String)
    case invalidIDFormat(url: String)
    case emptyPathComponents(url: String)
}

extension PokemonError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .invalidPokemonURL(let url):
            return "Invalid Pokemon URL: \(url)"
        case .invalidIDFormat(let url):
            return "Invalid Pokemon ID format: \(url)"
        case .emptyPathComponents(let url):
            return "Empty path components in URL: \(url)"
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
