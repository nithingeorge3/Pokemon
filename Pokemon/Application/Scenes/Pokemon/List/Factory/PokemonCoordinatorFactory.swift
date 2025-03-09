//
//  PokemonListCoordinatorFactory.swift
//  Pokemon
//
//  Created by Nitin George on 08/03/2025.
//

import Foundation
import SwiftData
import PokemonDataStore
import PokemonDataStore

protocol PokemonListCoordinatorFactoryType {
    @MainActor func makePokemonListCoordinator(container: ModelContainer) async -> PokemonListCoordinator
}

final class PokemonListCoordinatorFactory: PokemonListCoordinatorFactoryType {
    func makePokemonListCoordinator(container: ModelContainer) async -> PokemonListCoordinator {
        let tabItem = TabItem(title: "Pokemon", icon: "house.fill", badgeCount: 0, color: .black)
        let modelFactory = PokemonViewModelFactory()
        let viewFactory = PokemonViewFactory()
        
        let paginationSDRepo = PaginationSDRepository(container: container)
        let pokemonSDRepo = PokemonSDRepository(container: container)
        
        return await PokemonListCoordinator(
            tabItem: tabItem,
            viewFactory: viewFactory,
            modelFactory: modelFactory,
            paginationSDRepo: paginationSDRepo,
            pokemonSDRepo: pokemonSDRepo
        )
    }
}
