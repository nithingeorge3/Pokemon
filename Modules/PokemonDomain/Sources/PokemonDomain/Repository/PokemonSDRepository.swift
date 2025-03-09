//
//  PokemonSDRepository.swift
//  RecipeDomain
//
//  Created by Nitin George on 02/03/2025.
//

import Foundation
import SwiftData

public protocol PaginationSDRepositoryType: Sendable {
    func fetchRecipePagination(_ entityType: EntityType) async throws -> PaginationDomain
    func updateRecipePagination(_ pagination: PaginationDomain) async throws
}

public protocol PokemonSDRepositoryType: Sendable {
    func fetchPokemon(for pokemonID: Int) async throws -> RecipeDomain
    func fetchRecipes(page: Int, pageSize: Int) async throws -> [RecipeDomain]
//    func fetchRecipes(page: Int, pageSize: Int) async throws -> [RecipeDomain]
    func savePokemon(_ pokemon: [PokemonDomain]) async throws
    func updateFavouriteRecipe(_ recipeID: Int) async throws -> Bool
}
