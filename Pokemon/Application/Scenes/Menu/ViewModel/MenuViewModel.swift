//
//  MenuViewModel.swift
//  Pokemon
//
//  Created by Nitin George on 08/03/2025.
//

import Foundation
import PokemonNetworking
import PokemonDataStore
import SwiftData

@Observable
class MenuViewModel {
    var isLoggedIn = false
    let items: [SidebarItem]
    let userService: PokemonUserServiceType
    
    init(items: [SidebarItem], userService: PokemonUserServiceType) {
        self.items = items
        self.userService = userService
    }
    
    @discardableResult
    func filteredItems(includeLogin: Bool) -> [SidebarItem] {
        items.filter { item in
            switch item.authAction {
            case .login:
                return includeLogin
            case .logout:
                return !includeLogin
            case .none:
                return true
            }
        }
    }
    
    func handleLogin() {
        isLoggedIn = true
    }
    
    
    func handleLogout() {
        isLoggedIn = false
    }
}
