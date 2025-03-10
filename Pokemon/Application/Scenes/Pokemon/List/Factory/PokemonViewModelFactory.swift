//
//  PokemonViewModelFactory.swift
//  Pokemon
//
//  Created by Nitin George on 08/03/2025.
//

import PokemonNetworking

protocol PokemonViewModelFactoryType {
    @MainActor func makePokemonListViewModel(service: PokemonServiceProvider, userService: PokemonUserServiceType, paginationHandler: PaginationHandlerType) async -> PokemonListViewModel
}

final class PokemonViewModelFactory: PokemonViewModelFactoryType {
    func makePokemonListViewModel(service: PokemonServiceProvider, userService: PokemonUserServiceType, paginationHandler: PaginationHandlerType) async -> PokemonListViewModel {
        PokemonListViewModel(service: service, userService: userService, paginationHandler: paginationHandler)
    }
}
