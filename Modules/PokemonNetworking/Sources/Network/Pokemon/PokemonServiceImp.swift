//
//  PokemonServiceImp.swift
//  PokemonNetworking
//
//  Created by Nitin George on 08/03/2024.
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

    func fetchPokemon(for pokemonID: Int) async throws -> PokemonDomain {
        try await pokemonRepository.fetchPokemon(for: pokemonID)
    }
    
    func fetchPokemon(offset: Int = 0, pageSize: Int = 40) async throws -> [PokemonDomain] {
        try await pokemonRepository.fetchPokemon(offset: offset, pageSize: pageSize)
    }
    
    func updateFavouritePokemon(_ pokemonID: Int) async throws -> Bool {
        let isUpdated = try await pokemonRepository.updateFavouritePokemon(pokemonID)
        favoritesDidChangeContinuation.yield(pokemonID)
        return isUpdated
    }
    
    func fetchPokemonPagination(_ entityType: EntityType) async throws -> PaginationDomain {
        return try await pokemonRepository.fetchPokemonPagination(entityType)
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
