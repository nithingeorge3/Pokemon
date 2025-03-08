//
//  AppTabView.swift
//  Recipes
//
//  Created by Nitin George on 01/03/2025.
//

import SwiftUI
import PokemonNetworking

struct AppTabView: View {
    @State private var selectedTab: UUID
    private let tabProvider: TabProvider
    let tabs: [TabItem]

    init(tabs: [TabItem], tabProvider: TabProvider) {
        self.tabs = tabs
        self.tabProvider = tabProvider
        _selectedTab = State(initialValue: tabs.first!.id)
    }

    var body: some View {
        VStack(spacing: 0) {
            ZStack {
                tabProvider.view(for: selectedTab)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.white)

            CustomTabBar(selectedTab: $selectedTab, tabs: tabs)
        }
        .edgesIgnoringSafeArea(.bottom)
    }
}
