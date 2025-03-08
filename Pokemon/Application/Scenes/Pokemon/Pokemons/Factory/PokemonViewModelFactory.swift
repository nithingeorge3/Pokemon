//
//  PokemonViewModelFactoryType.swift
//  Recipes
//
//  Created by Nitin George on 01/03/2025.
//

import PokemonNetworking

protocol PokemonViewModelFactoryType {
    @MainActor func makePokemonListViewModel(service: RecipeServiceProvider, paginationHandler: PaginationHandlerType) async -> PokemonListViewModel
}

final class RecipesViewModelFactory: PokemonViewModelFactoryType {
    func makePokemonListViewModel(service: RecipeServiceProvider, paginationHandler: PaginationHandlerType) async -> PokemonListViewModel {
        PokemonListViewModel(service: service, paginationHandler: paginationHandler)
    }
}
