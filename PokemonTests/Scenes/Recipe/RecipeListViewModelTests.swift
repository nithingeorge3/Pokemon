//
//  RecipeListViewModelTests.swift
//  RecipesTests
//
//  Created by Nitin George on 05/03/2025.
//

import XCTest
import RecipeNetworking

@testable import Recipes

@MainActor
final class RecipeListViewModelTests: XCTestCase {
    private var viewModel: RecipesListViewModelType!
    private var service: RecipeServiceProvider!
    private var paginationHandler: PaginationHandlerType!
    
    override func setUp() {
        super.setUp()
        service = MockRecipeServiceImp()
        paginationHandler = MockPaginationHandler()
        
        viewModel = RecipeListViewModel(service: service, paginationHandler: paginationHandler)
    }
    
    override func tearDown() {
        super.tearDown()
        viewModel = nil
        service = nil
        paginationHandler = nil
    }

    func testInitialStateIsLoading() {
        XCTAssertEqual(viewModel.state, .loading, "Initial state should be .loading")
        XCTAssertTrue(viewModel.recipes.isEmpty, "Initially, recipes should be empty")
    }
}
