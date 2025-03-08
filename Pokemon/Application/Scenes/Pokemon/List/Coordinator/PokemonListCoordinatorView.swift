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
                .navigationDestination(for: PokemonListAction.self) { action in
                    switch action {
                    case .selectPokemon(let pokemonID):
                        EmptyView()
//                        coordinator.navigateToPokemonPlay(for: recipeID)
                    default: EmptyView()
                    }
                }
            }
            .navigationBarTitle("Recipe")
        }
}
