//
//  PokemonViewModelFactory.swift
//  Pokemon
//
//  Created by Nitin George on 08/03/2025.
//

import PokemonNetworking

protocol PokemonViewModelFactoryType {
    @MainActor func makePokemonListViewModel(service: PokemonServiceProvider, userService: PokemonUserServiceType, remotePagination: RemotePaginationHandlerType, localPagination: LocalPaginationHandlerType) async -> PokemonListViewModel
}

final class PokemonViewModelFactory: PokemonViewModelFactoryType {
    func makePokemonListViewModel(service: PokemonServiceProvider, userService: PokemonUserServiceType, remotePagination: RemotePaginationHandlerType, localPagination: LocalPaginationHandlerType) async -> PokemonListViewModel {
        PokemonListViewModel(service: service, userService: userService, remotePagination: remotePagination, localPagination: localPagination)
    }
}
