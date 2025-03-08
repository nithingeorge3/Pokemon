//
//  AppTabViewFactory.swift
//  Recipes
//
//  Created by Nitin George on 01/03/2025.
//

import SwiftUI
import PokemonNetworking

@MainActor
protocol TabProvider {
    func view(for tabID: UUID) -> AnyView
}

@MainActor
protocol AppTabViewFactoryType {
    func makeAppTabView() -> AppTabView
}

final class AppTabViewFactory: AppTabViewFactoryType {
    private var coordinators: [any TabItemProviderType]
    
    init(coordinators: [any TabItemProviderType]) {
        self.coordinators = coordinators
    }
    
    var tabs: [TabItem] {
        coordinators.map { $0.tabItem }
    }
    
    func makeAppTabView() -> AppTabView {
        AppTabView(
            tabs: tabs,
            tabProvider: self
        )
    }
}

@MainActor
extension AppTabViewFactory: TabProvider {
    func view(for tabID: UUID) -> AnyView {
        // Find the coordinator whose `tabItem` matches the `tabID`
        guard let coordinator = coordinators.first(where: { $0.tabItem.id == tabID }) else {
            return AnyView(Text("Unknown Tab").foregroundColor(.black))
        }
        
        return coordinator.start() as! AnyView
    }
}
