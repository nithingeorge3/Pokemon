//
//  PokemonUserServiceImp.swift
//  PokemonNetworking
//
//  Created by Nitin George on 09/03/2024.
//

import Combine
import Foundation
import PokemonDomain

final class PokemonUserServiceImp: PokemonUserServiceType {
    private let pokemonRepository: PokemonRepositoryType
    private let (favoritesDidChangeStream, favoritesDidChangeContinuation) = AsyncStream.makeStream(of: Int.self)
            
    init(pokemonRepository: PokemonRepositoryType) {
        self.pokemonRepository = pokemonRepository
    }

    func getCurrentUser() async throws -> UserDomain {
        try await pokemonRepository.getOrCreateGuest()
    }
}
