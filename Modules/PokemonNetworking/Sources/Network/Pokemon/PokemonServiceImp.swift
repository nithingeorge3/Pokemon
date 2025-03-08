//
//  RecipeServiceImp.swift
//  RecipeNetworking
//
//  Created by Nitin George on 01/03/2024.
//

import Combine
import Foundation
import PokemonDomain

final class PokemonServiceImp: PokemonServiceProvider {
    private let pokemonRepository: PokemonRepositoryType
    private let (favoritesDidChangeStream, favoritesDidChangeContinuation) = AsyncStream.makeStream(of: Int.self)
            
    init(pokemonRepository: PokemonRepositoryType) {
        self.pokemonRepository = pokemonRepository
    }

    func fetchPokemon(endPoint: EndPoint) async throws(NetworkError) -> [PokemonDomain] {
        do {
            return try await pokemonRepository.fetchPokemon(endPoint: endPoint)
            //add business logic
        } catch {
            throw NetworkError.failedToDecode
        }
    }
}

//SwiftData
extension PokemonServiceImp {        
    var favoritesDidChange: AsyncStream<Int> { favoritesDidChangeStream }
    
    func fetchRecipe(for recipeID: Int) async throws -> RecipeDomain {
        try await pokemonRepository.fetchRecipe(for: recipeID)
    }
    
    func fetchRecipes(page: Int = 0, pageSize: Int = 40) async throws -> [RecipeDomain] {
        try await pokemonRepository.fetchRecipes(page: page, pageSize: pageSize)
    }
    
    func updateFavouriteRecipe(_ recipeID: Int) async throws -> Bool {
        let isUpdated = try await pokemonRepository.updateFavouriteRecipe(recipeID)
        favoritesDidChangeContinuation.yield(recipeID)
        return isUpdated
    }
    
    func fetchRecipePagination(_ entityType: EntityType) async throws -> PaginationDomain {
        return try await pokemonRepository.fetchRecipePagination(entityType)
    }
}


//just added for showing combine
final class RecipeListServiceImp: RecipeListServiceType {
    private let recipeRepository: RecipeListRepositoryType
    private var cancellables: Set<AnyCancellable> = []

            
    init(recipeRepository: RecipeListRepositoryType) {
        self.recipeRepository = recipeRepository
    }
    
    func fetchPokemon(endPoint: EndPoint) -> Future<[RecipeDomain], Error> {
        return Future<[RecipeDomain], Error> { [weak self] promise in
            guard let self = self else {
                return promise(.failure(NetworkError.contextDeallocated))
            }
            recipeRepository.fetchRecipes(endPoint: endPoint)
                .receive(on: RunLoop.main)
                .sink { completion in
                    if case .failure(let error) = completion {
                        promise(.failure(error))
                    }
                } receiveValue: { recipes in
                    promise(.success(recipes))
                }
                .store(in: &cancellables)
        }
    }
}
