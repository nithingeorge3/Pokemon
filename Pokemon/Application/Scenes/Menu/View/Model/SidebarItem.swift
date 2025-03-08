//
//  SidebarItem.swift
//  Recipes
//
//  Created by Nitin George on 01/03/2025.
//

import Foundation

enum ItemType {
    case navigation
    case action
}

struct SidebarItem: Identifiable, Hashable {
    let id = UUID()
    let title: String
    let type: ItemType
}
