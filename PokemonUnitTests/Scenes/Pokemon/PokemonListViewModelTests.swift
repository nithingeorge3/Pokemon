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
    private var remotePagination: RemotePaginationHandlerType!
    private var localPagination: LocalPaginationHandlerType!
    
    override func setUp() {
        super.setUp()
        service = MockPokemonServiceImp()
        userService = MockPokemonUserServiceImp()
        remotePagination = MockRemotePaginationHandler()
        localPagination = MockLocalPaginationHandler()
    }
    
    override func tearDown() {
        super.tearDown()
        viewModel = nil
        service = nil
        userService = nil
        remotePagination = nil
    }

    func testInitialStateIsLoading() {
        viewModel = PokemonListViewModel(service: service, userService: userService, remotePagination: remotePagination, localPagination: localPagination)
        XCTAssertEqual(viewModel.state, .loading, "Initial state should be .loading")
        XCTAssertTrue(viewModel.pokemon.isEmpty, "Initially, pokemon should be empty")
    }
    
    func testFetchLocalPokemon_withNoData() async throws {
        viewModel = PokemonListViewModel(service: service, userService: userService, remotePagination: remotePagination, localPagination: localPagination)
                
        try await Task.sleep(nanoseconds: 100_000_000)
        
        XCTAssertEqual(viewModel.state, .loading)
        XCTAssertTrue(viewModel.pokemon.isEmpty)
        XCTAssertEqual(viewModel.pokemon.first?.id, nil)
        
        viewModel.send(.refresh)
        
        try await Task.sleep(nanoseconds: 100_000_000)
        
        XCTAssertEqual(viewModel.state, .success)
        XCTAssertEqual(viewModel.pokemon.count, 3)
        XCTAssertEqual(viewModel.pokemon.last?.name, "venusaur")
    }
    
    func testPokemonAPISuccess() async throws {
        viewModel = PokemonListViewModel(service: service, userService: userService, remotePagination: remotePagination, localPagination: localPagination)
        
        viewModel.send(.refresh)
        
        try await Task.sleep(nanoseconds: 100_000_000)
        
        XCTAssertEqual(viewModel.state, .success)
        XCTAssertEqual(viewModel.pokemon.count, 3)
        XCTAssertEqual(viewModel.pokemon.last?.name, "venusaur")
    }
}
