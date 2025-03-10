//
//  MockPokemonServiceImp.swift
//  Pokemon
//
//  Created by Nitin George on 10/03/2025.
//

import XCTest
import Foundation
import PokemonNetworking
import PokemonDataStore
import PokemonDomain

@testable import Pokemon

final class MockPokemonServiceImp: @unchecked Sendable {
    
    var resultsJSON: String
    
    var stubbedPokemon: [PokemonDomain] = []
    
    var shouldThrowError: Bool = false
    
    private var isFavorite: Bool = false
    
    private let (stream, continuation) = AsyncStream.makeStream(of: Int.self)
    
    init(mockJSON: String = JSONData.pokemonValidJSON) {
        self.resultsJSON = mockJSON
    }
}

extension MockPokemonServiceImp: PokemonServiceProvider {
    
    var favoritesDidChange: AsyncStream<Int> { stream }
    
    func fetchPokemon(for pokemonID: Int) async throws -> PokemonDomain {
        stubbedPokemon[0]
    }
    
    func fetchRandomUnplayedPokemon() async throws -> PokemonDomain {
        stubbedPokemon[2]
    }
    
    func fetchPokemon(offset: Int, pageSize: Int) async throws -> [PokemonDomain] {
        stubbedPokemon
    }
    
    func updateFavouritePokemon(_ pokemonID: Int) async throws -> Bool {
        false
    }
    
    func fetchPokemonPagination(_ type: EntityType) async throws -> PaginationDomain {
        PaginationDomain()
    }
    
    func fetchPokemon(endPoint: PokemonNetworking.EndPoint) async throws -> [PokemonDomain] {
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


extension MockPokemonServiceImp: PokemonUserServiceType {
    func getCurrentUser() async throws -> UserDomain {
        UserDomain(isGuest: true, lastActive: Date())
    }
    
    func updatePreferences(_ newPref: PreferenceDomain) async throws {
        
    }
    
    func getCurrentPreferences() async throws -> PreferenceDomain {
        PreferenceDomain()
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
            url: URL(string: dto.url)!,
            isFavorite: false
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
