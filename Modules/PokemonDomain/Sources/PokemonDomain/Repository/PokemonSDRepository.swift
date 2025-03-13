//
//  PokemonSDRepository.swift
//  PokemonDomain
//
//  Created by Nitin George on 02/03/2025.
//

import Foundation
import SwiftData

public protocol PaginationSDRepositoryType: Sendable {
    func fetchPokemonPagination(_ entityType: EntityType) async throws -> PaginationDomain
    func updatePokemonPagination(_ pagination: PaginationDomain) async throws
}

public protocol PokemonSDRepositoryType: Sendable {
    func fetchPokemon(for pokemonID: Int) async throws -> PokemonDomain
    func fetchPokemonCount() async throws -> Int
    func fetchRandomUnplayedPokemon(excluding excludedID: Int?) async throws -> PokemonDomain
    func fetchPokemon(offset: Int, pageSize: Int) async throws -> [PokemonDomain]
    func fetchRandomOptions(excluding id: Int, count: Int) async throws -> [PokemonDomain]
    func savePokemon(_ pokemon: [PokemonDomain]) async throws
}

public protocol UserSDRepositoryType: Sendable {
    func getOrCreateGuest() async throws -> UserDomain
    func updateScore(_ points: Int) async throws
    func getCurrentUser() async throws -> UserDomain
    
    
    //ToDo: later use WritableKeyPath and inject userID
    func updatePreferences(_ newPref: PreferenceDomain) async throws
    func getCurrentPreferences() async throws -> PreferenceDomain
    
    //Game
    func updatePlayedStatus(pokemonId: Int, outcome: GameOutcome) async throws
}
