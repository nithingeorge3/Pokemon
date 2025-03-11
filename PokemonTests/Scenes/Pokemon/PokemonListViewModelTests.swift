//
//  PokemonListViewModelTests.swift
//  PokemonTests
//
//  Created by Nitin George on 05/03/2025.
//

import XCTest
import PokemonNetworking

@testable import Pokemon

@MainActor
final class PokemonListViewModelTests: XCTestCase {
    private var viewModel: PokemonListViewModelType!
    private var service: PokemonServiceProvider!
    private var userService: PokemonUserServiceType!
    private var paginationHandler: PaginationHandlerType!
    
    override func setUp() {
        super.setUp()
        service = MockPokemonServiceImp()
        userService = MockPokemonUserServiceImp()
        paginationHandler = MockPaginationHandler()
        
        viewModel = PokemonListViewModel(service: service, userService: userService, paginationHandler: paginationHandler)
    }
    
    override func tearDown() {
        super.tearDown()
        viewModel = nil
        service = nil
        userService = nil
        paginationHandler = nil
    }

    func testInitialStateIsLoading() {
        XCTAssertEqual(viewModel.state, .loading, "Initial state should be .loading")
        XCTAssertTrue(viewModel.pokemon.isEmpty, "Initially, pokemon should be empty")
    }
}
