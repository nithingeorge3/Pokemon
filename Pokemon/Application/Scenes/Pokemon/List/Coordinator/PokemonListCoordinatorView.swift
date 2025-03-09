//
//  PokemonListCoordinatorView.swift
//  Pokemon
//
//  Created by Nitin George on 08/03/2025.
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
                        coordinator.navigateToPokemonPlay(for: pokemonID)
                    default: EmptyView()
                    }
                }
            }
            .navigationBarTitle("Recipe")
        }
}
