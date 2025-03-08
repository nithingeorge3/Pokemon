//
//  RecipeKeyRepository.swift
//  RecipeNetworking
//
//  Created by Nitin George on 01/03/2024.
//

import Foundation

public protocol RecipeKeyRepositoryType {
    func deleteRecipeAPIkey() -> Bool
}

final class RecipeKeyRepository: RecipeKeyRepositoryType {
    private let keyChainManager: KeyChainManagerType
    
    init(keyChainManager: KeyChainManagerType) {
        self.keyChainManager = keyChainManager
    }
    
    func deleteRecipeAPIkey() -> Bool {
        keyChainManager.deleteRecipeAPIKey()
    }
}
