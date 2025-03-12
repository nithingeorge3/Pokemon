//
//  PokemonServiceFactory.swift
//  PokemonNetworking
//
//  Created by Nitin George on 08/03/2024.
//

import Foundation
import PokemonDomain

public protocol PokemonServiceFactoryType {
    static func makePokemonService(userSDRepo: UserSDRepositoryType, pokemonSDRepo: PokemonSDRepositoryType, paginationSDRepo: PaginationSDRepositoryType) -> PokemonServiceProvider
}

//Later remove inject PaginationSDRepositoryType when we sepearte Repository
public protocol PokemonAnswerServiceFactoryType {
    static func makePokemonAnswerService(userSDRepo: UserSDRepositoryType, pokemonSDRepo: PokemonSDRepositoryType, paginationSDRepo: PaginationSDRepositoryType) -> PokemonAnswerServiceType
}

public protocol PokemonUserServiceFactoryType {
    static func makePokemonUserService(userSDRepo: UserSDRepositoryType, pokemonSDRepo: PokemonSDRepositoryType, paginationSDRepo: PaginationSDRepositoryType) -> PokemonUserServiceType
}

public final class PokemonServiceFactory: PokemonServiceFactoryType, @unchecked Sendable {
    private static let serviceParser: ServiceParserType = ServiceParser()
    private static let requestBuilder: RequestBuilderType = RequestBuilder()
    
    public static func makePokemonService(userSDRepo: UserSDRepositoryType, pokemonSDRepo: PokemonSDRepositoryType, paginationSDRepo: PaginationSDRepositoryType) -> PokemonServiceProvider {
        let pokemonRepository: PokemonRepositoryType = PokemonRepository(
            parser: serviceParser,
            requestBuilder: requestBuilder,
            pokemonSDRepo: pokemonSDRepo,
            paginationSDRepo: paginationSDRepo,
            userSDRepo: userSDRepo
        )
        return PokemonServiceImp(pokemonRepository: pokemonRepository)
    }
}

public final class PokemonAnswerServiceFactory: PokemonAnswerServiceFactoryType, @unchecked Sendable {
    private static let serviceParser: ServiceParserType = ServiceParser()
    private static let requestBuilder: RequestBuilderType = RequestBuilder()
    
    public static func makePokemonAnswerService(userSDRepo: UserSDRepositoryType, pokemonSDRepo: PokemonSDRepositoryType, paginationSDRepo: PaginationSDRepositoryType) -> PokemonAnswerServiceType {
        let pokemonRepository: PokemonRepositoryType = PokemonRepository(
            parser: serviceParser,
            requestBuilder: requestBuilder,
            pokemonSDRepo: pokemonSDRepo,
            paginationSDRepo: paginationSDRepo,
            userSDRepo: userSDRepo
            
        )
        return PokemonAnswerServiceImp(pokemonRepository: pokemonRepository)
    }
}

public final class PokemonUserServiceFactory: PokemonUserServiceFactoryType, @unchecked Sendable {
    private static let serviceParser: ServiceParserType = ServiceParser()
    private static let requestBuilder: RequestBuilderType = RequestBuilder()
    
    public static func makePokemonUserService(userSDRepo: UserSDRepositoryType, pokemonSDRepo: PokemonSDRepositoryType, paginationSDRepo: PaginationSDRepositoryType) -> PokemonUserServiceType {
        
        let pokemonRepository: PokemonRepositoryType = PokemonRepository(
            parser: serviceParser,
            requestBuilder: requestBuilder,
            pokemonSDRepo: pokemonSDRepo,
            paginationSDRepo: paginationSDRepo,
            userSDRepo: userSDRepo
        )
        return PokemonUserServiceImp(pokemonRepository: pokemonRepository)
    }
}
