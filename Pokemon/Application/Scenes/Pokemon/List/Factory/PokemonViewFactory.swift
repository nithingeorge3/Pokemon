//
//  PokemonViewFactoryType.swift
//  Pokemon
//
//  Created by Nitin George on 08/03/2025.
//

import Foundation

protocol PokemonViewFactoryType {
    @MainActor func makePokemonGridView<ViewModel: PokemonListViewModelType>(
        viewModel: ViewModel
    ) -> PokemonListView<ViewModel>
    
//    @MainActor func makePokemonListView<ViewModel: RecipesViewModelType>(
//        viewModel: ViewModel
//    ) -> RecipesView<ViewModel>
}

final class PokemonViewFactory: PokemonViewFactoryType {
    @MainActor func makePokemonGridView<ViewModel: PokemonListViewModelType>(
        viewModel: ViewModel
    ) -> PokemonListView<ViewModel> {
        PokemonListView(viewModel: viewModel)
    }
    
//    @MainActor func makePokemonListView<ViewModel: RecipesViewModelType>(
//        viewModel: ViewModel
//    ) -> RecipesView<ViewModel> {
//        RecipesView(viewModel: viewModel)
//    }
}
