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

@MainActor
protocol MenuViewModelType: AnyObject, Observable {
    var isLoggedIn: Bool { get }
    var items: [SidebarItem] { set get }
    var filteredItems: [SidebarItem]? { set get }
}

@Observable
class MenuViewModel: MenuViewModelType {
    var isLoggedIn = false
    var items: [SidebarItem]
    var filteredItems: [SidebarItem]?
    
    let userService: PokemonUserServiceType
    
    init(items: [SidebarItem], userService: PokemonUserServiceType) {
        self.items = items
        self.userService = userService
        
        filteredItems(includeLogin: true)
    }
    
    private func filteredItems(includeLogin: Bool) {
        filteredItems = items.filter { item in
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
        filteredItems(includeLogin: !isLoggedIn)
    }
    
    
    func handleLogout() {
        UserSessionManager.clearUserDataOnLogout()
        isLoggedIn = false
        filteredItems(includeLogin: !isLoggedIn)
    }
}
