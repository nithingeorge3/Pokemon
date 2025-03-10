//
//  MenuViewModelFactory.swift
//  Pokemon
//
//  Created by Nitin George on 08/03/2025.
//

import PokemonNetworking

protocol MenuViewModelFactoryType {
    func makeMenuViewModel(userService: PokemonUserServiceType) -> MenuViewModel
}

final class MenuViewModelFactory: MenuViewModelFactoryType {
    
    func makeMenuViewModel(userService: PokemonUserServiceType) -> MenuViewModel {
        let items = [
            SidebarItem(title: "Settings", type: .navigation),
            SidebarItem(title: "Preferences", type: .navigation),
            SidebarItem(title: "Logout", type: .action)
        ]
        return MenuViewModel(items: items, userService: userService)
    }
}
