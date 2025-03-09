//
//  PokemonPlayViewFactoryType.swift
//  Pokemon
//
//  Created by Nitin George on 08/03/2025.
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
