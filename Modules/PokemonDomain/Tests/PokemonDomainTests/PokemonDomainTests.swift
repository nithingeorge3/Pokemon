import XCTest
@testable import PokemonDomain

final class PokemonDomainTests: XCTestCase {
    func testWithAllParameters() {
        let url = URL(string: "https://pokeapi.co/pokemon/1")!
        let pokemon = PokemonDomain(
            id: 1,
            name: "Bulbasaur",
            url: url
        )
        
        XCTAssertEqual(pokemon.id, 1)
        XCTAssertEqual(pokemon.name, "Bulbasaur")
        XCTAssertEqual(pokemon.url, url)
    }
    
    func test_valueSemantics() {
        let url = URL(string: "https://pokeapi.co/pokemon/3")!
        let pokemon1 = PokemonDomain(
            id: 3,
            name: "Bulbasaur",
            url: url
        )
        let pokemon2 = pokemon1
        
        XCTAssertEqual(pokemon1.id, pokemon2.id)
    }
}
