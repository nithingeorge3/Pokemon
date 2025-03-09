//
//  PokemonViewModelFactory.swift
//  Pokemon
//
//  Created by Nitin George on 08/03/2025.
//

import PokemonNetworking

protocol PokemonViewModelFactoryType {
    @MainActor func makePokemonListViewModel(service: PokemonServiceProvider, paginationHandler: PaginationHandlerType) async -> PokemonListViewModel
}

final class PokemonViewModelFactory: PokemonViewModelFactoryType {
    func makePokemonListViewModel(service: PokemonServiceProvider, paginationHandler: PaginationHandlerType) async -> PokemonListViewModel {
        PokemonListViewModel(service: service, paginationHandler: paginationHandler)
    }
}
