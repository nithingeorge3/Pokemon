//
//  RecipeDetailViewFactory.swift
//  Recipes
//
//  Created by Nitin George on 01/03/2025.
//

protocol PokemonPlayViewFactoryType {
    @MainActor func makePokemonPlayView<ViewModel: PokemonPlayViewModelType>(
        viewModel: ViewModel
    ) -> PokemonPlayView<ViewModel>
}

final class PokemonPlayViewFactory: PokemonPlayViewFactoryType {
    @MainActor func makePokemonPlayView<ViewModel: PokemonPlayViewModelType>(
        viewModel: ViewModel
    ) -> PokemonPlayView<ViewModel> {
        PokemonPlayView(viewModel: viewModel)
    }
}
