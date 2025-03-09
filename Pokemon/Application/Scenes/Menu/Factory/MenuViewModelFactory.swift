//
//  MenuViewModelFactory.swift
//  Recipes
//
//  Created by Nitin George on 01/03/2025.
//

import PokemonNetworking

protocol MenuViewModelFactoryType {
    func makeMenuViewModel(service: RecipeKeyServiceType) -> MenuViewModel
}

final class MenuViewModelFactory: MenuViewModelFactoryType {
    
    func makeMenuViewModel(service: RecipeKeyServiceType) -> MenuViewModel {
        let items = [
            SidebarItem(title: "Profile", type: .navigation),
            SidebarItem(title: "Pokemon List", type: .navigation),
            SidebarItem(title: "Logout", type: .action)
        ]
        return MenuViewModel(service: service, items: items)
    }
}
