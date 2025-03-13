//
//  SwiftDataError.swift
//  PokemonDataStore
//
//  Created by Nitin George on 09/03/2025.
//

@frozen
public enum SDError: Error, Equatable {
    case userNotFound
    case pokemonNotFound
    case countOperationFailed
    case noUnplayedPokemon
    case modelObjNotFound
    case invalidRequest(reason: String)
}
