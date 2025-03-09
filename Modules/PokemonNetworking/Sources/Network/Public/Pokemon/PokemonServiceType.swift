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

public protocol PokemonSDServiceType: Sendable {
    var favoritesDidChange: AsyncStream<Int> { get }
    func fetchPokemon(for pokemonID: Int) async throws -> RecipeDomain
    func fetchRecipes(page: Int, pageSize: Int) async throws -> [RecipeDomain]
    func updateFavouriteRecipe(_ recipeID: Int) async throws -> Bool
    func fetchRecipePagination(_ type: EntityType) async throws -> PaginationDomain
}

//just added for showing combine
public protocol RecipeListServiceType {
    func fetchPokemon(endPoint: EndPoint) -> Future<[RecipeDomain], Error>
}
