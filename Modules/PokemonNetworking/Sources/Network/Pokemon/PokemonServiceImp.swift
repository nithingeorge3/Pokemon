//
//  PokemonServiceImp.swift
//  PokemonNetworking
//
//  Created by Nitin George on 08/03/2024.
//

import Combine
import Foundation
import PokemonDomain

final class PokemonServiceImp: PokemonServiceProvider {
    private let pokemonRepository: PokemonRepositoryType
    private let (favoritesDidChangeStream, favoritesDidChangeContinuation) = AsyncStream.makeStream(of: Int.self)
            
    init(pokemonRepository: PokemonRepositoryType) {
        self.pokemonRepository = pokemonRepository
    }

    func fetchPokemon(endPoint: EndPoint) async throws(NetworkError) -> [PokemonDomain] {
        do {
            return try await pokemonRepository.fetchPokemon(endPoint: endPoint)
//            let allPokemon = try await pokemonRepository.fetchPokemon(endPoint: endPoint)
//            return allPokemon
//                .shuffled()
//                .map { $0 }
            
        } catch {
            throw NetworkError.failedToDecode
        }
    }
}

//SwiftData
extension PokemonServiceImp {        
    var favoritesDidChange: AsyncStream<Int> { favoritesDidChangeStream }

    func fetchPokemon(for pokemonID: Int) async throws -> PokemonDomain {
        try await pokemonRepository.fetchPokemon(for: pokemonID)
    }
    
    func fetchRandomUnplayedPokemon() async throws -> PokemonDomain {
        try await pokemonRepository.fetchRandomUnplayedPokemon()
    }
    
    func fetchPokemon(offset: Int = 0, pageSize: Int = 40) async throws -> [PokemonDomain] {
        return try await pokemonRepository.fetchPokemon(offset: offset, pageSize: pageSize)
        
//        let allPokemon = try await pokemonRepository.fetchPokemon(offset: offset, pageSize: pageSize)
//        return allPokemon
//            .shuffled()
//            .map { $0 }
    }
    
    func updateFavouritePokemon(_ pokemonID: Int) async throws -> Bool {
        let isUpdated = try await pokemonRepository.updateFavouritePokemon(pokemonID)
        favoritesDidChangeContinuation.yield(pokemonID)
        return isUpdated
    }
    
    func fetchPokemonPagination(_ entityType: EntityType) async throws -> PaginationDomain {
        return try await pokemonRepository.fetchPokemonPagination(entityType)
    }
}
