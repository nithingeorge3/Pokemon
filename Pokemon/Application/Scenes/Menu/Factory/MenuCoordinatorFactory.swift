//
//  MenuCoordinatorFactory.swift
//  Pokemon
//
//  Created by Nitin George on 08/03/2025.
//

import Foundation
import SwiftData
import PokemonDataStore

@MainActor
protocol MenuCoordinatorFactoryType {
    func makeMenuCoordinator(container: ModelContainer) -> MenuCoordinator
}

final class MenuCoordinatorFactory: MenuCoordinatorFactoryType {
    private var menuViewFactory: MenuViewFactoryType
    
    init(menuViewFactory: MenuViewFactoryType) {
        self.menuViewFactory = menuViewFactory
    }
    
    func makeMenuCoordinator(container: ModelContainer) -> MenuCoordinator {
        let tabItem = TabItem(title: "Menu", icon: "line.horizontal.3", badgeCount: nil, color: .black)
       
        let userSDRepo = UserSDRepository(container: container)
        let paginationSDRepo = PaginationSDRepository(container: container)
        let pokemonSDRepo = PokemonSDRepository(container: container)
        
        return MenuCoordinator(menuViewFactory: menuViewFactory, tabItem: tabItem, userSDRepo: userSDRepo, paginationSDRepo: paginationSDRepo, pokemonSDRepo: pokemonSDRepo)
    }
}
