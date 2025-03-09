//
//  PokemonDomainTests.swift
//  PokemonNetworking
//
//  Created by Nitin George on 08/03/2025.
//

import XCTest
import PokemonDomain
@testable import PokemonNetworking

class PokemonDomainTests: XCTestCase {
        
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testValidURLWithTrailingSlash() {
        let dto = PokemonDTO(
            name: "bulbasaur",
            url: "https://pokeapi.co/api/v2/pokemon/1/"
        )
        
        XCTAssertNoThrow(try PokemonDomain(from: dto))
        let domain = try? PokemonDomain(from: dto)
        XCTAssertEqual(domain?.id, 1)
    }
    
    func testValidURLWithoutTrailingSlash() {
        let dto = PokemonDTO(
            name: "pikachu",
            url: "https://pokeapi.co/api/v2/pokemon/25"
        )
        
        XCTAssertNoThrow(try PokemonDomain(from: dto))
        let domain = try? PokemonDomain(from: dto)
        XCTAssertEqual(domain?.id, 25)
    }
    
    func testValidURLWithLeadingZeros() {
        let dto = PokemonDTO(
            name: "mewtwo",
            url: "https://pokeapi.co/api/v2/pokemon/0150"
        )
        
        XCTAssertNoThrow(try PokemonDomain(from: dto))
        let domain = try? PokemonDomain(from: dto)
        XCTAssertEqual(domain?.id, 150)
    }
    
    func testEmptyURLString() {
        let dto = PokemonDTO(name: "empty", url: "")
        
        XCTAssertThrowsError(try PokemonDomain(from: dto)) { error in
            guard case let PokemonError.invalidPokemonURL(url) = error else {
                return XCTFail("Unexpected error type: \(error)")
            }
            XCTAssertEqual(url, "")
        }
    }
    
    func testURLWithNonNumericID() {
        let dto = PokemonDTO(
            name: "charizard",
            url: "https://pokeapi.co/api/v2/pokemon/charizard"
        )
        
        XCTAssertThrowsError(try PokemonDomain(from: dto)) { error in
            guard case let PokemonError.invalidIDFormat(url) = error else {
                return XCTFail("Unexpected error type: \(error)")
            }
            XCTAssertTrue(url.contains("charizard"))
        }
    }
    
    func testURLWithSpecialCharacters() {
        let dto = PokemonDTO(
            name: "special",
            url: "https://pokeapi.co/api/v2/pokemon/100%25"
        )
        
        XCTAssertThrowsError(try PokemonDomain(from: dto)) { error in
            guard case let PokemonError.invalidIDFormat(url) = error else {
                return XCTFail("Unexpected error type: \(error)")
            }
            XCTAssertTrue(url.contains("100%25"))
        }
    }
        
    func testMinimumValidID() {
        let dto = PokemonDTO(
            name: "min-id",
            url: "https://pokeapi.co/api/v2/pokemon/0"
        )
        
        XCTAssertNoThrow(try PokemonDomain(from: dto))
        let domain = try? PokemonDomain(from: dto)
        XCTAssertEqual(domain?.id, 0)
    }
    
    func testMultipleTrailingSlashes() {
        let dto = PokemonDTO(
            name: "many-slashes",
            url: "https://pokeapi.co/api/v2/pokemon/42////"
        )
        
        XCTAssertNoThrow(try PokemonDomain(from: dto))
        let domain = try? PokemonDomain(from: dto)
        XCTAssertEqual(domain?.id, 42)
    }
    
    func testNestedPathComponents() {
        let dto = PokemonDTO(
            name: "nested",
            url: "https://pokeapi.co/api/v2/foo/bar/pokemon/151"
        )
        
        XCTAssertNoThrow(try PokemonDomain(from: dto))
        let domain = try? PokemonDomain(from: dto)
        XCTAssertEqual(domain?.id, 151)
    }
}
