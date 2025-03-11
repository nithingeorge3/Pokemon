//
//  AuthSidebarItem.swift
//  Pokemon
//
//  Created by Nitin George on 11/03/2025.
//

import Foundation

extension SidebarItem {
    enum AuthAction {
        case login
        case logout
        case none
    }
    
    var authAction: AuthAction {
        switch title {
        case "Login": return .login
        case "Logout": return .logout
        default: return .none
        }
    }
    
    var isDestructive: Bool {
        authAction == .logout
    }
}
