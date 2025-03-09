//
//  PokemonRepositoryTests.swift
//  PokemonDataSource
//
//  Created by Nitin George on 06/03/2025.
//

import XCTest
import SwiftData
import PokemonDomain

@testable import PokemonDataStore

final class PokemonRepositoryTests: XCTestCase {
    private var repository: PokemonSDRepositoryType!
    private var container: ModelContainer!
    
    override func setUp() async throws {
        container = DataStoreManagerFactory.makeSharedContainer(for: "TestContainer")
        repository = PokemonSDRepository(container: container)
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
        try context.delete(model: SDPokemon.self)
        try context.delete(model: SDPagination.self)
        try context.save()
    }
}

extension PokemonRepositoryTests {
    func testSaveAndFetchPokemonWithPagination() async throws {
        let pokemon = PokemonDomain(id: 1, name: "bulbasaur", url: URL(string: "https://pokeapi.co/api/v2/pokemon/1/")!)
        
        try await repository.savePokemon([pokemon])
        let fetchedPokemon = try await repository.fetchPokemon(offset: 0, pageSize: 1)
        
        XCTAssertEqual(fetchedPokemon.count, 1)
        XCTAssertEqual(fetchedPokemon.first?.id, 1)
        XCTAssertEqual(fetchedPokemon.first?.name, "bulbasaur")
    }
    
    func testSaveAndFetchPokemon() async throws {
        let pokemon = PokemonDomain(id: 1, name: "bulbasaur", url: URL(string: "https://pokeapi.co/api/v2/pokemon/1/")!)
        
        try await repository.savePokemon([pokemon])
        let fetchedPokemon = try await repository.fetchPokemon(for: pokemon.id)
        
        XCTAssertEqual(fetchedPokemon.id, 1)
        XCTAssertEqual(fetchedPokemon.name, "bulbasaur")
    }
    
    func testFetchPokemonPagination() async throws {
        let pokemon = (1...10).map {
            
            PokemonDomain(
                id: $0,
                name: "bulbasaur\($0)",
                url: URL(string: "https://pokeapi.co/api/v2/pokemon/\($0)/")!
            )
        }
        try await repository.savePokemon(pokemon)
        
        let page0 = try await repository.fetchPokemon(offset: 0, pageSize: 2)
        let page1 = try await repository.fetchPokemon(offset: 1, pageSize: 2)
        
        XCTAssertEqual(page0.count, 2)
        XCTAssertEqual(page0.map(\.id), [10, 9])
        
        XCTAssertEqual(page1.count, 2)
        XCTAssertEqual(page1.map(\.id), [8, 7])
    }
     
    func testUpdateFavoritePokemon() async throws {
        let pokemon = PokemonDomain(id: 1, name: "bulbasaur", url: URL(string: "https://pokeapi.co/api/v2/pokemon/1/")!)
        try await repository.savePokemon([pokemon])
        
        let isFavoriteAfterFirstUpdate = try await repository.updateFavouritePokemon(1)
        XCTAssertTrue(isFavoriteAfterFirstUpdate)
        
        let isFavoriteAfterSecondUpdate = try await repository.updateFavouritePokemon(1)
        XCTAssertFalse(isFavoriteAfterSecondUpdate)
    }
    
    func testUpdateFavoritePokemonNotFound() async {
        do {
            _ = try await repository.updateFavouritePokemon(100)
            XCTFail("Expected an error because the pokemon does not exist, but no error found")
        } catch {
            XCTAssertEqual(error as? SDError, SDError.modelObjNotFound)
        }
    }
}
