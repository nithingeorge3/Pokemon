//
//  MockPokemonAnswerServiceImp.swift
//  Pokemon
//
//  Created by Nitin George on 10/03/2025.
//

import Foundation
import PokemonNetworking
import PokemonDataStore
import PokemonDomain

public final class MockPokemonAnswerServiceImp: PokemonAnswerServiceType, @unchecked Sendable {
    public func fetchRandomOptions(excluding id: Int, count: Int) async throws -> [PokemonDomain] {
        try await MockPokemonServiceImp().fetchPokemon(endPoint: .pokemon(offset: 0, limit: 3))
    }
    
    public func updateScore(_ points: Int) async throws {
        
    }
}
