//
//  PokemonDetailCoordinatorFactory.swift
//  Recipes
//
//  Created by Nitin George on 01/03/2025.
//

import Foundation
import PokemonNetworking

protocol PokemonPlayCoordinatorFactoryType {
    @MainActor func makePokemonPlayCoordinator(recipeID: Recipe.ID, service: RecipeSDServiceType) -> PokemonPlayCoordinator
}

final class PokemonPlayCoordinatorFactory: PokemonPlayCoordinatorFactoryType {
    func makePokemonPlayCoordinator(recipeID: Recipe.ID, service: RecipeSDServiceType) -> PokemonPlayCoordinator {
        let viewModelFactory: PokemonPlayViewModelFactoryType = PokemonPlayViewModelFactory()
        let viewFactory: PokemonPlayViewFactoryType = PokemonPlayViewFactory()
        return PokemonPlayCoordinator(
            viewModelFactory: viewModelFactory,
            viewFactory: viewFactory,
            recipeID: recipeID,
            service: service
        )
    }
}
