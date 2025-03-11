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
        
        try await insertTestPokemon()
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
        try context.save()
    }
}

extension PokemonRepositoryTests {
    func testSaveAndFetchPokemonWithPagination() async throws {
        let fetchedPokemon = try await repository.fetchPokemon(offset: 0, pageSize: 1)
        
        XCTAssertEqual(fetchedPokemon.count, 1)
        XCTAssertEqual(fetchedPokemon.first?.id, 1)
        XCTAssertEqual(fetchedPokemon.first?.name, "bulbasaur")
    }
    
    func testSaveAndFetchPokemon() async throws {
        let fetchedPokemon = try await repository.fetchPokemon(for: 1)
        
        XCTAssertEqual(fetchedPokemon.id, 1)
        XCTAssertEqual(fetchedPokemon.name, "bulbasaur")
    }
    
    func testFetchPokemonPagination() async throws {
        let page0 = try await repository.fetchPokemon(offset: 0, pageSize: 2)
        let page1 = try await repository.fetchPokemon(offset: 1, pageSize: 2)
        
        XCTAssertEqual(page0.count, 2)
        XCTAssertEqual(page0.map(\.id), [1, 2])
        
        XCTAssertEqual(page1.count, 2)
        XCTAssertEqual(page1.map(\.id), [3, 4])
    }
    
    func test_fetchRandomOptions_returnsCorrectCount() async throws {
        try await insertTestPokemon()
        let result = try await repository.fetchRandomOptions(excluding: 3, count: 2)
        
        XCTAssertEqual(result.count, 2)
        XCTAssertFalse(result.contains { $0.id == 3 }, "Excluded ID should not be present")
    }
    
    func test_fetchRandomOptions_sortsByIdDescending() async throws {
        let result = try await repository.fetchRandomOptions(excluding: 5, count: 3)
        
        let ids = result.map(\.id)
        XCTAssertEqual(ids, [4, 3, 2].filter { $0 != 5 }.prefix(3).sorted(by: >))
    }
    
    func test_fetchRandomOptions_returnsAllAvailableWhenCountExceeds() async throws {
        let result = try await repository.fetchRandomOptions(excluding: 1, count: 5)
        
        XCTAssertEqual(result.count, 4)
    }
    
    func test_fetchRandomOptions_withZeroCount() async {
        do {
            _ = try await repository.fetchRandomOptions(excluding: 1, count: 0)
            XCTFail("Should throw error for zero count")
        } catch {
            XCTAssertEqual(error as? SDError, .invalidRequest(reason: "Count must be greater than zero"))
        }
    }
    
    func test_fetchRandomOptions_withNonExistentExclusion() async throws {
        let result = try await repository.fetchRandomOptions(excluding: 999, count: 3)
        
        XCTAssertEqual(result.count, 3)
    }
}

extension PokemonRepositoryTests {
    private func insertTestPokemon() async throws {
        let pokemon = [
            PokemonDomain(id: 1, name: "bulbasaur", url: URL(string: "https://pokeapi.co/api/v2/pokemon/1/")!),
            PokemonDomain(id: 2, name: "bulbasaur", url: URL(string: "https://pokeapi.co/api/v2/pokemon/2/")!),
            PokemonDomain(id: 3, name: "bulbasaur", url: URL(string: "https://pokeapi.co/api/v2/pokemon/3/")!),
            PokemonDomain(id: 4, name: "bulbasaur", url: URL(string: "https://pokeapi.co/api/v2/pokemon/4/")!),
            PokemonDomain(id: 5, name: "bulbasaur", url: URL(string: "https://pokeapi.co/api/v2/pokemon/5/")!)
        ]
                
        try await repository.savePokemon(pokemon)
    }
}
