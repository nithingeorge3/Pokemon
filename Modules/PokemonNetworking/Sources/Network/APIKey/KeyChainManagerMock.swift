//
//  KeyChainManagerMock.swift
//  RecipeNetworking
//
//  Created by Nitin George on 02/03/2025.
//

import Foundation

final class KeyChainManagerMock: KeyChainManagerType, @unchecked Sendable {
    private var apiKey: String = ""
    private let lock = NSLock()
    
    func saveRecipeAPIKey(_ apiKey: String) {
        lock.lock()
        defer { lock.unlock() }
        self.apiKey = apiKey
    }
    
    func recipeAPIKey() -> String? {
        lock.lock()
        defer { lock.unlock() }
        return apiKey
    }
    
    func deleteRecipeAPIKey() -> Bool {
        lock.lock()
        defer { lock.unlock() }
        apiKey = ""
        return true
    }
}
