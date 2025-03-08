//
//  RecipeDetailViewModel.swift
//  Recipes
//
//  Created by Nitin George on 01/03/2025.
//

import Foundation
import PokemonNetworking
import Observation

enum PresentedMedia: Identifiable {
    case image(URL)
    case video(URL)
    
    var id: String {
        switch self {
        case .image(let url): return "\(url.absoluteString)"
        case .video(let url): return "\(url.absoluteString)"
        }
    }
}

@MainActor
protocol PokemonPlayViewModelType: AnyObject, Observable {
    var recipe: Recipe? { get set }
    var mediaItems: [PresentedMedia] { get }
    
    func send(_ action: RecipeDetailActions)
}

@Observable
class PokemonPlayViewModel: PokemonPlayViewModelType {    
    var recipe: Recipe?
    private let recipeID: Recipe.ID
    
    var mediaItems: [PresentedMedia] {
        var result: [PresentedMedia] = []
        
        if let imageURL = recipe?.thumbnailURL.validatedURL {
            result.append(.image(imageURL))
        }
        
        if let videoURL = recipe?.originalVideoURL.validatedURL {
            result.append(.video(videoURL))
        }
        
        return result
    }
    
    private let service: RecipeSDServiceType
    
    init(recipeID: Recipe.ID, service: RecipeSDServiceType) {
        self.service = service
        self.recipeID = recipeID
        Task { await fetchRecipe() }
    }
    
    func send(_ action: RecipeDetailActions) {
        switch action {
        case .toggleFavorite:
            recipe?.isFavorite.toggle()
            Task {
                do {
                    recipe?.isFavorite = try await service.updateFavouriteRecipe(recipeID)
                } catch {
                    print("failed to upadte SwiftData: errro \(error)")
                }
            }
        case .load:
            Task { await fetchRecipe() }
        }
    }
    
    private func fetchRecipe() async {
        do {
            let recipeDomain = try await service.fetchRecipe(for: recipeID)
            self.recipe = Recipe(from: recipeDomain)
        } catch {
            print("Error: \(error)")
        }
    }
}
