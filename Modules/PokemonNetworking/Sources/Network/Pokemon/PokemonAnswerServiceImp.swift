//
//  PokemonAnswerServiceImp.swift
//  PokemonNetworking
//
//  Created by Nitin George on 09/03/2024.
//

import Combine
import Foundation
import PokemonDomain

final class PokemonAnswerServiceImp: PokemonAnswerServiceType {
    private let pokemonRepository: PokemonRepositoryType
    private let (favoritesDidChangeStream, favoritesDidChangeContinuation) = AsyncStream.makeStream(of: Int.self)
            
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
}
