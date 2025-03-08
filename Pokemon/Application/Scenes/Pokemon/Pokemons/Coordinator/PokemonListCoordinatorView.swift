//
//  PokemonListCoordinatorView.swift
//  Recipe
//
//  Created by Nitin George on 01/03/2025.
//

import SwiftUI

struct PokemonListCoordinatorView: View {
    @ObservedObject var coordinator: PokemonListCoordinator
    
    var body: some View {
        NavigationStack(path: $coordinator.navigationPath) {
                coordinator.viewFactory.makePokemonGridView(viewModel: coordinator.viewModel)
                .navigationDestination(for: RecipeListAction.self) { action in
                    switch action {
                    case .userSelectedRecipe(let recipeID):
                        coordinator.navigateToPokemonPlay(for: recipeID)
                    default: EmptyView()
                    }
                }
            }
            .navigationBarTitle("Recipe")
        }
}
