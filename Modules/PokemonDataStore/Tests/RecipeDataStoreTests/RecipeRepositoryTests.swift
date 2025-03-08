//
//  RecipeRepositoryTests.swift
//  RecipeDataSource
//
//  Created by Nitin George on 06/03/2025.
//

import XCTest
import SwiftData
import PokemonDomain

@testable import PokemonDataStore

final class RecipeRepositoryTests: XCTestCase {
    private var repository: RecipeSDRepositoryType!
    private var container: ModelContainer!
    
    override func setUp() async throws {
        container = DataStoreManagerFactory.makeSharedContainer(for: "TestContainer")
        repository = RecipeSDRepository(container: container)
    }
    
    @MainActor
    override func tearDown() async throws {
        try await clearData()
        container = nil
        repository = nil
    }
    
    @MainActor
    private func clearData() async throws {
        let context = ModelContext(container)
        try context.delete(model: SDRecipe.self)
        try context.save()
    }
}

extension RecipeRepositoryTests {
    func testSaveAndFetchRecipesWithPagination() async throws {
        let recipe = RecipeDomain(id: 1, name: "Kerala Chicken Curry")
        
        try await repository.saveRecipes([recipe])
        let fetchedRecipes = try await repository.fetchRecipes(page: 0, pageSize: 1)
        
        XCTAssertEqual(fetchedRecipes.count, 1)
        XCTAssertEqual(fetchedRecipes.first?.id, 1)
        XCTAssertEqual(fetchedRecipes.first?.name, "Kerala Chicken Curry")
    }
    
    func testSaveAndFetchRecipes() async throws {
        let recipe = RecipeDomain(id: 1, name: "Kerala Chicken Curry")
        
        try await repository.saveRecipes([recipe])
        let fetchedRecipe = try await repository.fetchRecipe(for: recipe.id)
        
        XCTAssertEqual(fetchedRecipe.id, 1)
        XCTAssertEqual(fetchedRecipe.name, "Kerala Chicken Curry")
    }
    
    func testFetchRecipesPagination() async throws {
        let recipes = (1...10).map {
            RecipeDomain(
                id: $0,
                name: "Chicken Curry\($0)",
                createdAt: $0
            )
        }
        try await repository.saveRecipes(recipes)
        
        let page0 = try await repository.fetchRecipes(page: 0, pageSize: 2)
        let page1 = try await repository.fetchRecipes(page: 1, pageSize: 2)
        
        XCTAssertEqual(page0.count, 2)
        XCTAssertEqual(page0.map(\.id), [10, 9])
        
        XCTAssertEqual(page1.count, 2)
        XCTAssertEqual(page1.map(\.id), [8, 7])
    }
    
    func testUpdateFavoriteRecipe() async throws {
        let recipe = RecipeDomain(id: 1, name: "Biriyani", isFavorite: false)
        try await repository.saveRecipes([recipe])
        
        let isFavoriteAfterFirstUpdate = try await repository.updateFavouriteRecipe(1)
        XCTAssertTrue(isFavoriteAfterFirstUpdate)
        
        let isFavoriteAfterSecondUpdate = try await repository.updateFavouriteRecipe(1)
        XCTAssertFalse(isFavoriteAfterSecondUpdate)
    }
    
    func testUpdateFavoriteRecipeNotFound() async {
        do {
            _ = try await repository.updateFavouriteRecipe(100)
            XCTFail("Expected an error because the recipe does not exist, but no error found")
        } catch {
            XCTAssertEqual(error as? SDError, SDError.modelObjNotFound)
        }
    }
}
