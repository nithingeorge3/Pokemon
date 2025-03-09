//
//  MenuCoordinator.swift
//  Pokemon
//
//  Created by Nitin George on 08/03/2025.
//

import SwiftUI
import PokemonNetworking

final class MenuCoordinator: Coordinator, TabItemProviderType {
    private var menuViewFactory: MenuViewFactoryType
    private let _tabItem: TabItem
    
    var tabItem: TabItem {
        _tabItem
    }
    
    init(menuViewFactory: MenuViewFactoryType, tabItem: TabItem) {
        self.menuViewFactory = menuViewFactory
        _tabItem = tabItem
    }
    
    func start() -> some View {
        return menuViewFactory.makeMenuView()
    }
}
