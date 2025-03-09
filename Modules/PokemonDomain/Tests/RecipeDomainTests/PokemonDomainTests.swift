import XCTest
@testable import PokemonDomain

final class PokemonDomainTests: XCTestCase {
    func testWithAllParameters() {
        let url = URL(string: "https://pokeapi.co/pokemon/1")!
        let pokemon = PokemonDomain(
            id: 1,
            name: "Bulbasaur",
            url: url,
            isFavorite: true
        )
        
        XCTAssertEqual(pokemon.id, 1)
        XCTAssertEqual(pokemon.name, "Bulbasaur")
        XCTAssertEqual(pokemon.url, url)
        XCTAssertTrue(pokemon.isFavorite)
    }
    
    func testWithDefaultFavorite() {
        let pokemon = PokemonDomain(
            id: 2,
            name: "Bulbasaur",
            url: URL(string: "https://pokeapi.co/pokemon/2")!
        )
        
        XCTAssertFalse(pokemon.isFavorite)
    }
    
    func test_valueSemantics() {
        let url = URL(string: "https://pokeapi.co/pokemon/3")!
        let pokemon1 = PokemonDomain(
            id: 3,
            name: "Bulbasaur",
            url: url
        )
        var pokemon2 = pokemon1
        
        pokemon2.isFavorite = true
        
        XCTAssertEqual(pokemon1.id, pokemon2.id)
        XCTAssertNotEqual(pokemon1.isFavorite, pokemon2.isFavorite)
    }
}
