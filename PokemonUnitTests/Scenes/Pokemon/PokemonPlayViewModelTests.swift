//
//  PokemonPlayViewModelTests.swift
//  PokemonTests
//
//  Created by Nitin George on 10/03/2025.
//

import XCTest
import PokemonNetworking

@testable import Pokemon

@MainActor
final class PokemonPlayViewModelTests: XCTestCase {
    private var viewModel: PokemonPlayViewModelType!
    private var service: PokemonServiceProvider!
    private var userService: PokemonUserServiceType!
    private var answerService: PokemonAnswerServiceType!
    
    override func setUp() {
        super.setUp()
        service = MockPokemonServiceImp()
        userService = MockPokemonUserServiceImp()
        answerService = MockPokemonAnswerServiceImp()
    }
    
    override func tearDown() {
        super.tearDown()
        viewModel = nil
        service = nil
        userService = nil
        answerService = nil
    }
    
    func testInvalidPokemonFetch() {
        let invalidPokemonID: Pokemon.ID = 101000
        viewModel = PokemonPlayViewModel(pokemonID: invalidPokemonID, service: service, userService: userService, answerService: answerService)
        
        XCTAssertEqual(viewModel.pokemon?.name, nil)
        XCTAssertEqual(viewModel.pokemon?.id, nil)
    }
}
