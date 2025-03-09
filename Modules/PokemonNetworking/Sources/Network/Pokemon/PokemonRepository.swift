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
    func fetchPokemon(for pokemonID: Int) async throws -> RecipeDomain
    func fetchRecipes(page: Int, pageSize: Int) async throws -> [RecipeDomain]
    func updateFavouriteRecipe(_ recipeID: Int) async throws -> Bool
    func fetchRecipePagination(_ entityType: EntityType) async throws -> PaginationDomain
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
            
            try await pokemonSDRepo.savePokemon(pokemonDomains)
            return pokemonDomains
            
            //handle errro late
//            let pokemonDomains = try dtos.results.map { try PokemonDomain(from: $0) }

//            return pokemonDomains // [PokemonDomain(id: 1, name: "bulbasaur", url: "https://pokeapi.co/api/v2/pokemon/1/")]
            /*
            //Reach the page end or no data
            if recipeDomains.count == 0 {
                return recipeDomains
            }
            
//            try await recipeSDRepo.saveRecipes(recipeDomains)
            
            var pagination = try await paginationSDRepo.fetchRecipePagination(.recipe)
            pagination.totalCount = dtos.count
            pagination.currentPage += 1
            pagination.lastUpdated = Date()
            
            //updating Pagination
            try await paginationSDRepo.updateRecipePagination(pagination)
            
            let pageSize = endPoint.pokemonFetchInfo.1
            let page = endPoint.pokemonFetchInfo.0

            let batchRecipes = try await fetchRecipes(page: page, pageSize: pageSize)
                        
            return batchRecipes
            */
        } catch {
            throw NetworkError.noNetworkAndNoCache(context: error)
        }
    }
}

/*
 class PokemonRepository {
     func fetchPokemon() async -> Result<[PokemonDomain], Error> {
         do {
             let dtos = try await apiService.fetchPokemon()
             let domains = try dtos.map { try PokemonDomain(from: $0) }
             return .success(domains)
         } catch let error as NetworkError {
             return .failure(error) // Network issues
         } catch let error as PokemonError {
             return .failure(error) // Domain validation issues
         } catch {
             return .failure(NetworkError.unknown(error))
         }
     }
 }
 */

/*
 switch error {
 case .invalidPokemonURL:
     showAlert("Invalid Pokémon data. Please try again.")
 case .noNetworkConnectivity:
     showAlert("No internet connection.")
 // ...
 }
 */

extension PokemonRepository {
    func fetchPokemon(for pokemonID: Int) async throws -> RecipeDomain {
        try await pokemonSDRepo.fetchPokemon(for: pokemonID)
    }
    
    func fetchRecipes(page: Int, pageSize: Int) async throws -> [RecipeDomain] {
        try await pokemonSDRepo.fetchRecipes(page: page, pageSize: pageSize)
    }
    
    func updateFavouriteRecipe(_ recipeID: Int) async throws -> Bool {
        try await pokemonSDRepo.updateFavouriteRecipe(recipeID)
    }
    
    func fetchRecipePagination(_ entityType: EntityType) async throws -> PaginationDomain {
        try await paginationSDRepo.fetchRecipePagination(entityType)
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
