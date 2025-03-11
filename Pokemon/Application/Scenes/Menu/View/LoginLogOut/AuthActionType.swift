//
//  AuthActionType.swift
//  Pokemon
//
//  Created by Nitin George on 11/03/2025.
//

import Foundation

enum AuthActionType: Identifiable {
    case login
    case logout
    
    var id: Int {
         switch self {
         case .login: return 101
         case .logout: return 102
         }
     }
}
