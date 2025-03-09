//
//  MenuViewModelFactory.swift
//  Recipes
//
//  Created by Nitin George on 01/03/2025.
//

import PokemonNetworking

protocol MenuViewModelFactoryType {
    func makeMenuViewModel() -> MenuViewModel
}

final class MenuViewModelFactory: MenuViewModelFactoryType {
    
    func makeMenuViewModel() -> MenuViewModel {
        let items = [
            SidebarItem(title: "Profile", type: .navigation),
            SidebarItem(title: "Pokemon List", type: .navigation),
            SidebarItem(title: "Logout", type: .action)
        ]
        return MenuViewModel(items: items)
    }
}
