//
//  PokemonRepository.swift
//  PokemonNetworking
//
//  Created by Nitin George on 08/03/2024.
//

import Combine
import Foundation
import PokemonDomain

//we need to split PokemonRepositoryType protocol. backend, SwiftData and gaming fetch
public protocol PokemonRepositoryType: Sendable {
    func fetchPokemon(endPoint: EndPoint) async throws -> [PokemonDomain]
    func fetchPokemon(for pokemonID: Int) async throws -> PokemonDomain
    func fetchPokemon(offset: Int, pageSize: Int) async throws -> [PokemonDomain]
//    func updateFavouritePokemon(_ pokemonID: Int) async throws -> Bool
    func fetchPokemonPagination(_ entityType: EntityType) async throws -> PaginationDomain
    
    //gaming
    func fetchRandomOptions(excluding id: Int, count: Int) async throws -> [PokemonDomain]
    func fetchRandomUnplayedPokemon() async throws -> PokemonDomain
    func updateScore(_ points: Int) async throws
    func updatePlayedStatus(pokemonId: Int, outcome: GameOutcome) async throws
    
    //user
    func getOrCreateGuest() async throws -> UserDomain
    func updatePreferences(_ newPref: PreferenceDomain) async throws
    func getCurrentPreferences() async throws -> PreferenceDomain
}

final class PokemonRepository: PokemonRepositoryType {
    private let parser: ServiceParserType
    private let requestBuilder: RequestBuilderType
    private let pokemonSDRepo: PokemonSDRepositoryType
    private let paginationSDRepo: PaginationSDRepositoryType
    private let userSDRepo: UserSDRepositoryType
    
    init(
        parser: ServiceParserType,
        requestBuilder: RequestBuilderType,
        pokemonSDRepo: PokemonSDRepositoryType,
        paginationSDRepo: PaginationSDRepositoryType,
        userSDRepo: UserSDRepositoryType
    ) {
        self.parser = parser
        self.requestBuilder = requestBuilder
        self.pokemonSDRepo = pokemonSDRepo
        self.paginationSDRepo = paginationSDRepo
        self.userSDRepo =  userSDRepo
    }
    
    func fetchPokemon(endPoint: EndPoint) async throws -> [PokemonDomain] {
        do {
            let (data, response) = try await URLSession.shared.data(for: requestBuilder.buildRequest(url: endPoint.url()))
            
            let responseDTO = try await parser.parse(
                data: data,
                response: response,
                type: PokemonResponseDTO.self
            )
            
            let pokemonDomains = try responseDTO.results.map { dto in
                do {
                    return try PokemonDomain(from: dto)
                } catch let error as PokemonError {
                    throw error // handle error
                } catch {
                    throw NetworkError.failedToDecode
                }
            }
            
            if pokemonDomains.count == 0 {
                return pokemonDomains
            }
            
            try await pokemonSDRepo.savePokemon(pokemonDomains)
            
            var pagination = try await paginationSDRepo.fetchPokemonPagination(.pokemon)
            pagination.totalCount = responseDTO.count
            pagination.currentPage += 1
            pagination.lastUpdated = Date()
            
            //updating Pagination
            try await paginationSDRepo.updatePokemonPagination(pagination)
            
            
            let pageSize = endPoint.pokemonFetchInfo.1
            let offset = endPoint.pokemonFetchInfo.0

            let batchPokemon = try await fetchPokemon(offset: offset, pageSize: pageSize)
                        
            return batchPokemon
            
        } catch {
            throw NetworkError.noNetworkAndNoCache(context: error)
        }
    }
}

extension PokemonRepository {
    func fetchPokemon(for pokemonID: Int) async throws -> PokemonDomain {
        try await pokemonSDRepo.fetchPokemon(for: pokemonID)
    }
    
    func fetchPokemon(offset: Int, pageSize: Int) async throws -> [PokemonDomain] {
        try await pokemonSDRepo.fetchPokemon(offset: offset, pageSize: pageSize)
    }
    
    func fetchPokemonPagination(_ entityType: EntityType) async throws -> PaginationDomain {
        try await paginationSDRepo.fetchPokemonPagination(entityType)
    }
}

//Gaming specific. later creata a sperate Repo for gaming
extension PokemonRepository {
    func fetchRandomOptions(excluding id: Int, count: Int) async throws -> [PokemonDomain] {
        try await pokemonSDRepo.fetchRandomOptions(excluding: id, count: count)
    }
    
    func fetchRandomUnplayedPokemon() async throws -> PokemonDomain {
        try await pokemonSDRepo.fetchRandomUnplayedPokemon()
    }
    
    func updateScore(_ points: Int) async throws {
        try await userSDRepo.updateScore(points)
    }
    
    func updatePlayedStatus(pokemonId: Int, outcome: GameOutcome) async throws {
        try await userSDRepo.updatePlayedStatus(pokemonId: pokemonId, outcome: outcome)
    }
}

//User specific
extension PokemonRepository {
    func getOrCreateGuest() async throws -> UserDomain {
        try await userSDRepo.getOrCreateGuest()
    }
    
    func updatePreferences(_ newPref: PreferenceDomain) async throws {
        try await userSDRepo.updatePreferences(newPref)
    }
    
    func getCurrentPreferences() async throws -> PreferenceDomain {
        try await userSDRepo.getCurrentPreferences()
    }
}
