//
//  RecipeSDRepository.swift
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

public protocol RecipeSDRepositoryType: Sendable {
    func fetchRecipe(for recipeID: Int) async throws -> RecipeDomain
    func fetchRecipes(page: Int, pageSize: Int) async throws -> [RecipeDomain]
    func saveRecipes(_ recipes: [RecipeDomain]) async throws
    func updateFavouriteRecipe(_ recipeID: Int) async throws -> Bool
}
