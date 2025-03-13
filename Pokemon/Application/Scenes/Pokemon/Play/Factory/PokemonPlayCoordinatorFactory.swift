//
//  PokemonPlayCoordinatorFactoryType.swift
//  Pokemon
//
//  Created by Nitin George on 08/03/2025.
//

import Foundation
import PokemonNetworking

protocol PokemonPlayCoordinatorFactoryType {
    @MainActor func makePokemonPlayCoordinator(pokemonID: Pokemon.ID, service: PokemonSDServiceType, userService: PokemonUserServiceType, answerService: PokemonAnswerServiceType) -> PokemonPlayCoordinator
}

final class PokemonPlayCoordinatorFactory: PokemonPlayCoordinatorFactoryType {
    func makePokemonPlayCoordinator(pokemonID: Pokemon.ID, service: PokemonSDServiceType, userService: PokemonUserServiceType, answerService: PokemonAnswerServiceType) -> PokemonPlayCoordinator {
        let viewModelFactory: PokemonPlayViewModelFactoryType = PokemonPlayViewModelFactory()
        let viewFactory: PokemonPlayViewFactoryType = PokemonPlayViewFactory()
        return PokemonPlayCoordinator(
            viewModelFactory: viewModelFactory,
            viewFactory: viewFactory,
            pokemonID: pokemonID,
            service: service,
            userService: userService,
            answerService: answerService
        )
    }
}
