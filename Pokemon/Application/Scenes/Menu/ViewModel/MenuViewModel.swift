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
    
    init(items: [SidebarItem]) {
        self.items = items
    }
    
     func performLogOut() {
    }
}
