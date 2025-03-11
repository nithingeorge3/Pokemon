//
//  MockPokemonAnswerServiceImp.swift
//  Pokemon
//
//  Created by Nitin George on 10/03/2025.
//

import XCTest
import Foundation
import PokemonNetworking
import PokemonDataStore
import PokemonDomain

@testable import Pokemon

final class MockPokemonAnswerServiceImp: PokemonAnswerServiceType, @unchecked Sendable {
    func fetchRandomOptions(excluding id: Int, count: Int) async throws -> [PokemonDomain] {
        try await MockPokemonServiceImp().fetchPokemon(endPoint: .pokemon(offset: 0, limit: 3))
    }
    
    func updateScore(_ points: Int) async throws {
        
    }
}
