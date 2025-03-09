//
//  PokemonRepository.swift
//  PokemonNetworking
//
//  Created by Nitin George on 08/03/2024.
//

import Combine
import Foundation
import PokemonDomain

//we can split protocol. backend and SwiftData fetch
public protocol PokemonRepositoryType: Sendable {
    func fetchPokemon(endPoint: EndPoint) async throws -> [PokemonDomain]
    func fetchPokemon(for pokemonID: Int) async throws -> PokemonDomain
    func fetchPokemon(offset: Int, pageSize: Int) async throws -> [PokemonDomain]
    func updateFavouritePokemon(_ pokemonID: Int) async throws -> Bool
    func fetchPokemonPagination(_ entityType: EntityType) async throws -> PaginationDomain
}

final class PokemonRepository: PokemonRepositoryType {
    private let parser: ServiceParserType
    private let requestBuilder: RequestBuilderType
    private let pokemonSDRepo: PokemonSDRepositoryType
    private let paginationSDRepo: PaginationSDRepositoryType
    
    init(
        parser: ServiceParserType,
        requestBuilder: RequestBuilderType,
        pokemonSDRepo: PokemonSDRepositoryType,
        paginationSDRepo: PaginationSDRepositoryType
    ) {
        self.parser = parser
        self.requestBuilder = requestBuilder
        self.pokemonSDRepo = pokemonSDRepo
        self.paginationSDRepo = paginationSDRepo
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
//            return pokemonDomains
            
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
    
    func updateFavouritePokemon(_ pokemonID: Int) async throws -> Bool {
        try await pokemonSDRepo.updateFavouritePokemon(pokemonID)
    }
    
    func fetchPokemonPagination(_ entityType: EntityType) async throws -> PaginationDomain {
        try await paginationSDRepo.fetchPokemonPagination(entityType)
    }
}


//RecipeListRepository added for combine based operation. We can add combine with PokemonRepositoryType.
public protocol RecipeListRepositoryType {
    func fetchRecipes(endPoint: EndPoint) -> Future<[RecipeDomain], Error>
}

final class RecipeListRepository: RecipeListRepositoryType {
    private let parser: ServiceParserType
    private let requestBuilder: RequestBuilderType
    private var cancellables: Set<AnyCancellable> = []
    
    init(
        parser: ServiceParserType,
        requestBuilder: RequestBuilderType
    ) {
        self.parser = parser
        self.requestBuilder = requestBuilder
    }
    
    func fetchRecipes(endPoint: EndPoint) -> Future<[RecipeDomain], Error> {
        Future<[RecipeDomain], Error> { [weak self] promise in
            guard let self = self else {
                return promise(.failure(NetworkError.contextDeallocated))
            }
            
            do {
                let url = try endPoint.url()
                URLSession.shared.dataTaskPublisher(for: requestBuilder.buildRequest(url: url))
                    .mapError { error -> Error in
                        return NetworkError.responseError
                    }
                    .flatMap { [weak self] output -> AnyPublisher<RecipeResponseDTO, Error> in
                        guard let self = self else {
                            return Fail(error: NetworkError.contextDeallocated)
                                .eraseToAnyPublisher()
                        }
                        let parseResult = self.parser.parse(data: output.data, response: output.response, type: RecipeResponseDTO.self)
                        return parseResult
                    }
                    .sink(receiveCompletion: { completion in
                        if case .failure(let error) = completion { promise(.failure(error))
                        }
                    }, receiveValue:  { decodedData in
                        let domains = decodedData.results.map { RecipeDomain(from: $0) }
                        promise(.success(domains))
                    })
                    .store(in: &self.cancellables)
            } catch  {
                return promise(.failure(NetworkError.unKnown))
            }
        }
    }
}
