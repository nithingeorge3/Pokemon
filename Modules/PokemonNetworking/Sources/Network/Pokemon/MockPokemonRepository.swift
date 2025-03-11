//
//  MockPokemonRepository.swift
//  PokemonNetworking
//
//  Created by Nitin George on 08/03/2025.
//

import Foundation
import PokemonDomain

final class MockPokemonRepository: PokemonRepositoryType, @unchecked Sendable {
    private let fileName: String
    private let parser: ServiceParserType
    private var pokemon: PokemonDomain?
    private var pagination: PaginationDomain
    
    init(
        fileName: String,
        parser: ServiceParserType = ServiceParser(),
        pagination: PaginationDomain = PaginationDomain(id: UUID(uuidString: "11111111-1111-1111-1111-111111111111")!, entityType: .pokemon, totalCount: 0, currentPage: 0, lastUpdated: Date(timeIntervalSince1970: 0))
    ) {
        self.fileName = fileName
        self.parser = parser
        self.pagination = pagination
    }
    
    func fetchPokemon(endPoint: EndPoint) async throws -> [PokemonDomain] {
        guard let url = Bundle.module.url(forResource: self.fileName, withExtension: "json") else {
            throw NetworkError.responseError
        }
        
        do {
            let data = try Data(contentsOf: url)
            
            guard let mockResponse = HTTPURLResponse(
                url: url,
                statusCode: 200,
                httpVersion: nil,
                headerFields: nil
            ) else {
                throw NetworkError.responseError
            }
            
            let responseDTO = try await parser.parse(data: data, response: mockResponse, type: PokemonResponseDTO.self)
            
            do {
                let pokemonDomains = try responseDTO.results.map { dto in
                    do {
                        return try PokemonDomain(from: dto)
                    } catch let error as PokemonError {
                        throw error // handle error
                    } catch {
                        throw NetworkError.failedToDecode
                    }
                }
                
                pokemon = pokemonDomains.first
                pagination.totalCount = responseDTO.count
                pagination.currentPage = 1
                
                return pokemonDomains
            }
        }
        catch {
            throw NetworkError.failedToDecode
        }
    }
    
    func fetchPokemon(for pokemonID: Int) async throws -> PokemonDomain {
        guard let pokemon = pokemon else {
            throw PokemonError.notFound(pokemonID: pokemonID)
        }
        return pokemon
    }
    
    func fetchRandomUnplayedPokemon() async throws -> PokemonDomain {
        let id = randomNumber()
        
        return PokemonDomain(id: id, name: "bulbasaur", url: URL(string: "https://pokeapi.co/api/v2/pokemon/\(id)/")!)
    }
    
    func fetchPokemon(offset: Int = 0, pageSize: Int = 40) async throws -> [PokemonDomain] {
        return []
    }
    
    func fetchPokemonPagination(_ entityType: EntityType) async throws -> PaginationDomain {
        pagination
    }
    
    private func randomNumber() -> Int {
        Int.random(in: 1...50)
    }
}

//Gaming
extension MockPokemonRepository {
    func fetchRandomOptions(excluding id: Int, count: Int) async throws -> [PokemonDomain] {
        return [PokemonDomain(id: 1, name: "bulbasaur", url: URL(string: "https://pokeapi.co/api/v2/pokemon/1/")!)]
    }
    
    func updateScore(_ points: Int) async throws {
        
    }
    
    func updatePlayedStatus(pokemonId: Int, outcome: GameOutcome) async throws {
        
    }
}

//User
extension MockPokemonRepository {
    func getOrCreateGuest() async throws -> UserDomain {
        UserDomain(isGuest: true, lastActive: Date(timeIntervalSince1970: 0))
    }
    
    
    func updatePreferences(_ newPref: PreferenceDomain) async throws {
        
    }
    
    func getCurrentPreferences() async throws -> PreferenceDomain {
        PreferenceDomain()
    }
}
