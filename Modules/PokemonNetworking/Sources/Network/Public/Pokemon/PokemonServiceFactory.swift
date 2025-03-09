//
//  PokemonServiceFactory.swift
//  PokemonNetworking
//
//  Created by Nitin George on 08/03/2024.
//

import Foundation
import PokemonDomain

public protocol PokemonServiceFactoryType {
    static func makePokemonService(pokemonSDRepo: PokemonSDRepositoryType, paginationSDRepo: PaginationSDRepositoryType) -> PokemonServiceProvider
}

public final class PokemonServiceFactory: PokemonServiceFactoryType, @unchecked Sendable {
    private static let serviceParser: ServiceParserType = ServiceParser()
    private static let requestBuilder: RequestBuilderType = RequestBuilder()
    
    public static func makePokemonService(pokemonSDRepo: PokemonSDRepositoryType, paginationSDRepo: PaginationSDRepositoryType) -> PokemonServiceProvider {
        let pokemonRepository: PokemonRepositoryType = PokemonRepository(
            parser: serviceParser,
            requestBuilder: requestBuilder,
            pokemonSDRepo: pokemonSDRepo,
            paginationSDRepo: paginationSDRepo
        )
        return PokemonServiceImp(pokemonRepository: pokemonRepository)
    }
}

/*
//just added for showing combine. In production I will only use Async/await or combine based on the decision
public protocol PokemonServiceListFactoryType {
    static func makePokemonListService() -> PokemonListServiceType
}

public final class PokemonListServiceFactory: PokemonServiceListFactoryType {
    //Need to inject same as above function PokemonServiceFactory.makePokemonService
    private static let serviceParser: ServiceParserType = ServiceParser()
    private static let requestBuilder: RequestBuilderType = RequestBuilder()
    
    public static func makePokemonListService() -> PokemonListServiceType {
        let pokemonRepository: PokemonListRepositoryType = PokemonListRepository(
            parser: serviceParser,
            requestBuilder: requestBuilder
        )
        return PokemonListServiceImp(pokemonRepository: pokemonRepository)
    }
}
*/
