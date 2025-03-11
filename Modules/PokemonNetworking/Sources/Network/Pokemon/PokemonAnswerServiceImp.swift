//
//  PokemonAnswerServiceImp.swift
//  PokemonNetworking
//
//  Created by Nitin George on 09/03/2024.
//

import Combine
import Foundation
import PokemonDomain

//ToDo: update to GameService
final class PokemonAnswerServiceImp: PokemonAnswerServiceType {
    private let pokemonRepository: PokemonRepositoryType
            
    init(pokemonRepository: PokemonRepositoryType) {
        self.pokemonRepository = pokemonRepository
    }

    func fetchRandomOptions(excluding id: Int, count: Int) async throws -> [PokemonDomain] {
        do {
            let allPokemon = try await pokemonRepository.fetchRandomOptions(excluding: id, count: count)
            return allPokemon
                .filter { $0.id != id }
                .shuffled()
                .prefix(count)
                .map { $0 }
            
        } catch {
            throw NetworkError.failedToDecode // add sepearte error later
        }
    }
    
    func updateScore(_ points: Int) async throws {
        try await pokemonRepository.updateScore(points)
    }
    
    func updatePlayedStatus(pokemonId: Int, outcome: GameOutcome) async throws {
        try await pokemonRepository.updatePlayedStatus(pokemonId: pokemonId, outcome: outcome)
    }
}
