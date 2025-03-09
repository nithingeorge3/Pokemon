//
//  Error.swift
//  PokemonDomain
//
//  Created by Nitin George on 07/03/2025.
//

import Foundation

@frozen
public enum PokemonError: Error {
    case invalidPokemonURL(url: String)
    case invalidIDFormat(url: String)
    case emptyPathComponents(url: String)
    case notFound(pokemonID: Int)
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
        case .notFound(let id):
            return "Pokemon with ID \(id) not found."
        }
    }
}
