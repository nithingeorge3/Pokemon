//
//  MenuViewFactory.swift
//  Recipes
//
//  Created by Nitin George on 01/03/2025.
//

import Foundation
import PokemonNetworking

@MainActor
protocol MenuViewFactoryType {
    func makeMenuView(service: RecipeKeyServiceType) -> MenuView
}

final class MenuViewFactory: MenuViewFactoryType {
    private var menuViewModelFactory: MenuViewModelFactoryType
    
    init(menuViewModelFactory: MenuViewModelFactoryType) {
        self.menuViewModelFactory = menuViewModelFactory
    }
    
    func makeMenuView(service: RecipeKeyServiceType) -> MenuView {
        MenuView(viewModel: menuViewModelFactory.makeMenuViewModel(service: service))
    }
}
