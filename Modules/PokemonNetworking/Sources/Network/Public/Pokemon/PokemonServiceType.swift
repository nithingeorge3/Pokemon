//
//  RecipeServiceType.swift
//  RecipeNetworking
//
//  Created by Nitin George on 01/03/2024.
//

import Foundation
import PokemonDomain
import Combine

public protocol RecipeKeyServiceType {
    @discardableResult
    func deleteRecipeAPIkey() -> Bool
}

public typealias PokemonServiceProvider = PokemonServiceType & PokemonSDServiceType

public protocol PokemonServiceType: Sendable {
    func fetchPokemon(endPoint: EndPoint) async throws -> [PokemonDomain]
}

public protocol PokemonSDServiceType: Sendable {
    var favoritesDidChange: AsyncStream<Int> { get }
    func fetchRecipe(for recipeID: Int) async throws -> RecipeDomain
    func fetchRecipes(page: Int, pageSize: Int) async throws -> [RecipeDomain]
    func updateFavouriteRecipe(_ recipeID: Int) async throws -> Bool
    func fetchRecipePagination(_ type: EntityType) async throws -> PaginationDomain
}

//just added for showing combine
public protocol RecipeListServiceType {
    func fetchPokemon(endPoint: EndPoint) -> Future<[RecipeDomain], Error>
}
