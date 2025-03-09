//
//  PokemonPlayViewModelFactoryType.swift
//  Pokemon
//
//  Created by Nitin George on 08/03/2025.
//

import PokemonNetworking

protocol PokemonPlayViewModelFactoryType {
    @MainActor func makePokemonPlayViewModel(pokemonID: Pokemon.ID, service: PokemonSDServiceType) -> PokemonPlayViewModel
}

final class PokemonPlayViewModelFactory: PokemonPlayViewModelFactoryType {
    @MainActor func makePokemonPlayViewModel(pokemonID: Pokemon.ID, service: PokemonSDServiceType) -> PokemonPlayViewModel {
        PokemonPlayViewModel(pokemonID: pokemonID, service: service)
    }
}
