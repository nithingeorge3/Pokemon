//
//  RecipeServiceImp.swift
//  RecipeNetworking
//
//  Created by Nitin George on 01/03/2024.
//

import Combine
import Foundation
import PokemonDomain

final class RecipeServiceImp: RecipeServiceProvider {
    private let recipeRepository: RecipeRepositoryType
    private let (favoritesDidChangeStream, favoritesDidChangeContinuation) = AsyncStream.makeStream(of: Int.self)
            
    init(recipeRepository: RecipeRepositoryType) {
        self.recipeRepository = recipeRepository
    }

    func fetchRecipes(endPoint: EndPoint) async throws(NetworkError) -> [RecipeDomain] {
        do {
            return try await recipeRepository.fetchRecipes(endPoint: endPoint)
            //add business logic
        } catch {
            throw NetworkError.failedToDecode
        }
    }
}

//SwiftData
extension RecipeServiceImp {        
    var favoritesDidChange: AsyncStream<Int> { favoritesDidChangeStream }
    
    func fetchRecipe(for recipeID: Int) async throws -> RecipeDomain {
        try await recipeRepository.fetchRecipe(for: recipeID)
    }
    
    func fetchRecipes(page: Int = 0, pageSize: Int = 40) async throws -> [RecipeDomain] {
        try await recipeRepository.fetchRecipes(page: page, pageSize: pageSize)
    }
    
    func updateFavouriteRecipe(_ recipeID: Int) async throws -> Bool {
        let isUpdated = try await recipeRepository.updateFavouriteRecipe(recipeID)
        favoritesDidChangeContinuation.yield(recipeID)
        return isUpdated
    }
    
    func fetchRecipePagination(_ entityType: EntityType) async throws -> PaginationDomain {
        return try await recipeRepository.fetchRecipePagination(entityType)
    }
}


//just added for showing combine
final class RecipeListServiceImp: RecipeListServiceType {
    private let recipeRepository: RecipeListRepositoryType
    private var cancellables: Set<AnyCancellable> = []

            
    init(recipeRepository: RecipeListRepositoryType) {
        self.recipeRepository = recipeRepository
    }
    
    func fetchRecipes(endPoint: EndPoint) -> Future<[RecipeDomain], Error> {
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
