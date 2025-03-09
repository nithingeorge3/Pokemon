//
//  TabItem.swift
//  Pokemon
//
//  Created by Nitin George on 08/03/2025.
//

import SwiftUI

protocol TabItemProviderType: Coordinator {
    var tabItem: TabItem { get }
}

class TabItem: Identifiable, ObservableObject {
    let id = UUID()
    let title: String
    let icon: String
    let color: Color
    @Published var badgeCount: Int?
    
    init(title: String, icon: String, badgeCount: Int?, color: Color) {
        self.title = title
        self.icon = icon
        self.badgeCount = badgeCount
        self.color = color
    }
}
