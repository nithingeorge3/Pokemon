//
//  MenuViewModel.swift
//  Recipes
//
//  Created by Nitin George on 01/03/2025.
//

import Foundation
import PokemonNetworking
import PokemonDataStore
import SwiftData

class MenuViewModel: ObservableObject {
    private let service: RecipeKeyServiceType
    let items: [SidebarItem]
    
    init(service: RecipeKeyServiceType, items: [SidebarItem]) {
        self.service = service
        self.items = items
    }
    
     func performLogOut() {
         service.deleteRecipeAPIkey()
         //clearing API on logout. I just added this code.
    }
}
