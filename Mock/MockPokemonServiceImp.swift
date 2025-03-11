//
//  MockPokemonServiceImp.swift
//  Pokemon
//
//  Created by Nitin George on 10/03/2025.
//

import Foundation
import PokemonNetworking
import PokemonDataStore
import PokemonDomain

final class MockPokemonServiceImp: @unchecked Sendable {
    var resultsJSON: String
    var stubbedPokemon: [PokemonDomain] = []
    var shouldThrowError: Bool = false
    
    private let (stream, continuation) = AsyncStream.makeStream(of: Int.self)
    
    init(mockJSON: String = JSONData.pokemonValidJSON) {
        self.resultsJSON = mockJSON
    }
}

extension MockPokemonServiceImp: PokemonServiceProvider {
    func fetchPokemon(for pokemonID: Int) async throws -> PokemonDomain {
        if stubbedPokemon.count > 0 {
            return stubbedPokemon[0]
        } else {
            return PokemonDomain(id: 1, name: "ivysaur1", url: URL(string: "https://pokeapi.co/api/v2/pokemon/1/")!)
        }
    }
    
    func fetchRandomUnplayedPokemon() async throws -> PokemonDomain {
        if stubbedPokemon.count > 0 {
            return stubbedPokemon[1]
        } else {
            return PokemonDomain(id: 2, name: "ivysaur2", url: URL(string: "https://pokeapi.co/api/v2/pokemon/2/")!)
        }
    }
    
    func fetchPokemon(offset: Int, pageSize: Int) async throws -> [PokemonDomain] {
        stubbedPokemon
    }
    
    func fetchPokemonPagination(_ type: EntityType) async throws -> PaginationDomain {
        PaginationDomain()
    }
    
    func fetchPokemon(endPoint: EndPoint) async throws -> [PokemonDomain] {
        do {
            if let data = resultsJSON.data(using: .utf8) {
                let decoder = JSONDecoder()
                let dtos = try decoder.decode(MockPokemonResponseDTO.self, from: data)
                
                let pokemonDomains = dtos.results.map { PokemonDomain(from: $0) }
                stubbedPokemon = pokemonDomains
                return stubbedPokemon
            }
        } catch {
            throw NetworkError.failedToDecode
        }
        
        return stubbedPokemon
    }
}

struct MockPokemonResponseDTO: Codable {
    let count: Int
    let next, previous: String?
    let results: [MockPokemonDTO]
}

struct MockPokemonDTO: Codable {
    let name: String
    let url: String
}

extension PokemonDomain {
    init(from dto: MockPokemonDTO) {
        let pokemonID = PokemonDomain.extractPokemonID(from: dto.url)
        
        self.init(
            id: pokemonID,
            name: dto.name,
            url: URL(string: dto.url)!
        )
    }
    
    private static func extractPokemonID(from urlString: String) -> Int {
        let trimmedURLString = urlString.trimmingCharacters(in: ["/"])
        
        if let trimmedURL = URL(string: trimmedURLString) {
            let components = trimmedURL.pathComponents.filter { !$0.isEmpty }
            
            if let lastComponent = components.last, let id = Int(lastComponent) {
                return id
            }
        }
        return -1
    }
}
