//
//  MenuCoordinatorFactory.swift
//  Recipes
//
//  Created by Nitin George on 01/03/2025.
//

import Foundation

@MainActor
protocol MenuCoordinatorFactoryType {
    func makeMenuCoordinator() -> MenuCoordinator
}

final class MenuCoordinatorFactory: MenuCoordinatorFactoryType {
    private var menuViewFactory: MenuViewFactoryType
    
    init(menuViewFactory: MenuViewFactoryType) {
        self.menuViewFactory = menuViewFactory
    }
    
    func makeMenuCoordinator() -> MenuCoordinator {
        let tabItem = TabItem(title: "Menu", icon: "line.horizontal.3", badgeCount: nil, color: .black)
        return MenuCoordinator(menuViewFactory: menuViewFactory, tabItem: tabItem)
    }
}
