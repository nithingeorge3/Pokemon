//
//  RecipeDetailViewModelTests.swift
//  RecipesTests
//
//  Created by Nitin George on 07/03/2025.
//

import XCTest
import RecipeNetworking

@testable import Recipes

@MainActor
final class RecipeDetailViewModelTests: XCTestCase {
    private var viewModel: RecipeDetailViewModelType!
    private var service: RecipeServiceProvider!
    
    override func setUp() {
        super.setUp()
        service = MockRecipeServiceImp()
    }
    
    override func tearDown() {
        super.tearDown()
        viewModel = nil
        service = nil
    }

    func testInvalidRecipeFetch() {
        let invalidRecipeID: Recipe.ID = 101000
        viewModel = RecipeDetailViewModel(recipeID: invalidRecipeID, service: service)
        
        XCTAssertEqual(viewModel.recipe?.name, nil)
        XCTAssertEqual(viewModel.recipe?.id, nil)
    }
}
