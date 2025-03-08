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
    func fetchPokemon(endPoint: EndPoint) async throws -> [RecipeDomain]
    func fetchRecipe(for recipeID: Int) async throws -> RecipeDomain
    func fetchRecipes(page: Int, pageSize: Int) async throws -> [RecipeDomain]
    func updateFavouriteRecipe(_ recipeID: Int) async throws -> Bool
    func fetchRecipePagination(_ entityType: EntityType) async throws -> PaginationDomain
}

final class RecipeRepository: PokemonRepositoryType {
    private let parser: ServiceParserType
    private let requestBuilder: RequestBuilderType
    private let apiKeyProvider: APIKeyProviderType
    private let recipeSDRepo: RecipeSDRepositoryType
    private let paginationSDRepo: PaginationSDRepositoryType
    
    init(
        parser: ServiceParserType,
        requestBuilder: RequestBuilderType,
        apiKeyProvider: APIKeyProviderType,
        recipeSDRepo: RecipeSDRepositoryType,
        paginationSDRepo: PaginationSDRepositoryType
    ) {
        self.parser = parser
        self.requestBuilder = requestBuilder
        self.apiKeyProvider = apiKeyProvider
        self.recipeSDRepo = recipeSDRepo
        self.paginationSDRepo = paginationSDRepo
    }
    
    func fetchPokemon(endPoint: EndPoint) async throws -> [RecipeDomain] {
        do {
            let apiKey = try await apiKeyProvider.getRecipeAPIKey()
            
            let (data, response) = try await URLSession.shared.data(for: requestBuilder.buildRequest(url: endPoint.url(), apiKey: apiKey))
            
            let dtos = try await parser.parse(
                data: data,
                response: response,
                type: RecipeResponseDTO.self
            )
            
            let recipeDomains = dtos.results.map { RecipeDomain(from: $0) }

            return recipeDomains
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
            
            let pageSize = endPoint.recipeFetchInfo.1
            let page = endPoint.recipeFetchInfo.0

            let batchRecipes = try await fetchRecipes(page: page, pageSize: pageSize)
                        
            return batchRecipes
            */
        } catch {
            throw NetworkError.noNetworkAndNoCache(context: error)
        }
    }
}

extension RecipeRepository {
    func fetchRecipe(for recipeID: Int) async throws -> RecipeDomain {
        try await recipeSDRepo.fetchRecipe(for: recipeID)
    }
    
    func fetchRecipes(page: Int, pageSize: Int) async throws -> [RecipeDomain] {
        try await recipeSDRepo.fetchRecipes(page: page, pageSize: pageSize)
    }
    
    func updateFavouriteRecipe(_ recipeID: Int) async throws -> Bool {
        try await recipeSDRepo.updateFavouriteRecipe(recipeID)
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
                //We ned to save this in keychain. same as Async/await impliemntataion
                let apiKey = "c36446da42msh685aa9134d41e0ep10f9cdjsnaa15ec2198b5"
                let url = try endPoint.url()
                URLSession.shared.dataTaskPublisher(for: requestBuilder.buildRequest(url: url, apiKey: apiKey))
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
