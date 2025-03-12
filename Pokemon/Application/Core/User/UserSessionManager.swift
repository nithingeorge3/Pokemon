//
//  UserSessionManager.swift
//  Pokemon
//
//  Created by Nitin George on 12/03/2025.
//

import Foundation

struct UserSessionManager {
    static func clearUserDataOnLogout() {
        let defaults = UserDefaults.standard
        
        let keysToRemove = [
            UserDefaultsKeys.hasCompletedOnboarding
        ]
        
        keysToRemove.forEach { defaults.removeObject(forKey: $0) }
        
        defaults.synchronize()
    }
}
