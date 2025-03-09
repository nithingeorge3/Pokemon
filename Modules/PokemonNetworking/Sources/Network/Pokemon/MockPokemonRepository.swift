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
    
    func fetchRecipe(for recipeID: Int) async throws -> RecipeDomain {
        guard let pokemon = pokemon else {
            throw RecipeError.notFound(recipeID: recipeID)
        }
        return RecipeDomain(id: 1, name: "")
    }
    
    func fetchRecipes(page: Int, pageSize: Int) async throws -> [RecipeDomain] {
        return []
    }
    
    func updateFavouriteRecipe(_ recipeID: Int) async throws -> Bool {
        guard var pokemon = pokemon, pokemon.id == recipeID else {
            return false
        }
        pokemon.isFavorite.toggle()
        self.pokemon = pokemon
        return pokemon.isFavorite
    }
    
    func fetchRecipePagination(_ entityType: EntityType) async throws -> PaginationDomain {
        pagination
    }
}
