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

class MenuViewModel: ObservableObject {
    let items: [SidebarItem]
    let userService: PokemonUserServiceType
    
    init(items: [SidebarItem], userService: PokemonUserServiceType) {
        self.items = items
        self.userService = userService
    }
    
     func performLogOut() {
    }
}
