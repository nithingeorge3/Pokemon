//
//  RecipeKeyService.swift
//  RecipeNetworking
//
//  Created by Nitin George on 01/03/2024.
//

import Foundation

//Later all API key service to here and keep generic name for class
final class RecipeKeyService: RecipeKeyServiceType {
    private let recipeKeyRepo: RecipeKeyRepositoryType

    init(recipeKeyRepo: RecipeKeyRepositoryType) {
        self.recipeKeyRepo = recipeKeyRepo
    }
    
    func deleteRecipeAPIkey() -> Bool {
        return recipeKeyRepo.deleteRecipeAPIkey()
    }
}
