//
//  PokemonServiceFactory.swift
//  PokemonNetworking
//
//  Created by Nitin George on 08/03/2024.
//

import Foundation
import PokemonDomain

public protocol PokemonKeyServiceFactoryType {
    static func makeRecipeKeyService() -> RecipeKeyServiceType
}

public protocol PokemonServiceFactoryType {
    static func makePokemonService(recipeSDRepo: RecipeSDRepositoryType, paginationSDRepo: PaginationSDRepositoryType) -> PokemonServiceProvider
}

public final class PokemonServiceFactory: PokemonServiceFactoryType, PokemonKeyServiceFactoryType, @unchecked Sendable {
    private static let apiKeyProvider: APIKeyProviderType = APIKeyProvider(keyChainManager: KeyChainManager.shared)
    private static let serviceParser: ServiceParserType = ServiceParser()
    private static let requestBuilder: RequestBuilderType = RequestBuilder()
    
    public static func makePokemonService(recipeSDRepo: RecipeSDRepositoryType, paginationSDRepo: PaginationSDRepositoryType) -> PokemonServiceProvider {
        let pokemonRepository: PokemonRepositoryType = RecipeRepository(
            parser: serviceParser,
            requestBuilder: requestBuilder,
            apiKeyProvider: apiKeyProvider,
            recipeSDRepo: recipeSDRepo,
            paginationSDRepo: paginationSDRepo
        )
        return PokemonServiceImp(pokemonRepository: pokemonRepository)
    }
    
    public static func makeRecipeKeyService() -> any RecipeKeyServiceType {
        let recipeKeyRepo: RecipeKeyRepositoryType = RecipeKeyRepository(keyChainManager: KeyChainManager.shared)
        return RecipeKeyService(recipeKeyRepo: recipeKeyRepo)
    }
}

//just added for showing combine. In production I will only use Async/await or combine based on the decision
public protocol RecipeServiceListFactoryType {
    static func makeRecipeListService() -> RecipeListServiceType
}

public final class RecipeListServiceFactory: RecipeServiceListFactoryType {
    //Need to inject same as above function RecipeServiceFactory.makeRecipeService
    private static let serviceParser: ServiceParserType = ServiceParser()
    private static let requestBuilder: RequestBuilderType = RequestBuilder()
    
    public static func makeRecipeListService() -> RecipeListServiceType {
        let recipeRepository: RecipeListRepositoryType = RecipeListRepository(
            parser: serviceParser,
            requestBuilder: requestBuilder
        )
        return RecipeListServiceImp(recipeRepository: recipeRepository)
    }
}

//just added for dev purpose
public final class MockRecipeServiceFactory: PokemonServiceFactoryType, PokemonKeyServiceFactoryType, @unchecked Sendable {
    public static func makePokemonService(recipeSDRepo: RecipeSDRepositoryType, paginationSDRepo: PaginationSDRepositoryType) -> PokemonServiceProvider {
        
        let pagination: PaginationDomain = PaginationDomain(id: UUID(), entityType: .recipe, totalCount: 10, currentPage: 10, lastUpdated: Date(timeIntervalSince1970: 0))
                                                        
        let recipeRepository: PokemonRepositoryType = MockRecipeRepository(fileName: "pokemon_success", parser: ServiceParser(), pagination: pagination)
        
        return PokemonServiceImp(pokemonRepository: recipeRepository)
    }
    
    public static func makeRecipeKeyService() -> any RecipeKeyServiceType {
        let recipeKeyRepo: RecipeKeyRepositoryType = RecipeKeyRepository(keyChainManager: KeyChainManager.shared)
        return RecipeKeyService(recipeKeyRepo: recipeKeyRepo)
    }
}
