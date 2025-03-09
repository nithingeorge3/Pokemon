//
//  PokemonServiceType.swift
//  PokemonNetworking
//
//  Created by Nitin George on 08/03/2024.
//

import Foundation
import PokemonDomain
import Combine

public typealias PokemonServiceProvider = PokemonServiceType & PokemonSDServiceType

public protocol PokemonServiceType: Sendable {
    func fetchPokemon(endPoint: EndPoint) async throws -> [PokemonDomain]
}

//gaming specific
public protocol PokemonAnswerServiceType: Sendable {
    func fetchRandomOptions(excluding id: Int, count: Int) async throws -> [PokemonDomain]
}


public protocol PokemonSDServiceType: Sendable {
    var favoritesDidChange: AsyncStream<Int> { get }
    func fetchPokemon(for pokemonID: Int) async throws -> PokemonDomain
    func fetchRandomUnplayedPokemon() async throws -> PokemonDomain
    func fetchPokemon(offset: Int, pageSize: Int) async throws -> [PokemonDomain]
    func updateFavouritePokemon(_ pokemonID: Int) async throws -> Bool
    func fetchPokemonPagination(_ type: EntityType) async throws -> PaginationDomain
}

/*
//just added for showing combine
public protocol PokemonListServiceType {
    func fetchPokemon(endPoint: EndPoint) -> Future<[PokemonDomain], Error>
}
*/
