//
//  keyChainManager.swift
//  RecipeNetworking
//
//  Created by Nitin George on 02/03/2025.
//

protocol KeyChainManagerType: Sendable {
    func saveRecipeAPIKey(_ apiKey: String)
    func recipeAPIKey() -> String?
    func deleteRecipeAPIKey() -> Bool
}

final class KeyChainManager: KeyChainManagerType {
    static let shared = KeyChainManager()
    
    private let recipeKey = "com.recipe.recipeAPIKey"
    
    private init() { }
    
    func saveRecipeAPIKey(_ apiKey: String) {
        KeychainWrapper().save(value: apiKey, for: recipeKey)
    }
    
    func recipeAPIKey() -> String? {
        return KeychainWrapper().retrieveValue(for: recipeKey)
    }
    
    func deleteRecipeAPIKey() -> Bool {
        KeychainWrapper().deleteValue(for: recipeKey)
    }
}
