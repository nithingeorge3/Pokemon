//
//  RecipeDetailViewModelFactory.swift
//  Recipes
//
//  Created by Nitin George on 01/03/2025.
//

import PokemonNetworking

protocol PokemonPlayViewModelFactoryType {
    @MainActor func makePokemonPlayViewModel(recipeID: Recipe.ID, service: RecipeSDServiceType) -> PokemonPlayViewModel
}

final class PokemonPlayViewModelFactory: PokemonPlayViewModelFactoryType {
    @MainActor func makePokemonPlayViewModel(recipeID: Recipe.ID, service: RecipeSDServiceType) -> PokemonPlayViewModel {
        PokemonPlayViewModel(recipeID: recipeID, service: service)
    }
}
