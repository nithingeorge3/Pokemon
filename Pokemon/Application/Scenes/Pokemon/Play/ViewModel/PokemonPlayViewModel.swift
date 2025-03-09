//
//  PokemonPlayViewModel.swift
//  Pokemon
//
//  Created by Nitin George on 08/03/2025.
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
    private let pokemonID: Pokemon.ID
    
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
    
    private let service: PokemonSDServiceType
    
    init(pokemonID: Pokemon.ID, service: PokemonSDServiceType) {
        self.service = service
        self.pokemonID = pokemonID
        Task { await fetchPokemon() }
    }
    
    func send(_ action: RecipeDetailActions) {
        switch action {
        case .toggleFavorite:
            recipe?.isFavorite.toggle()
            Task {
                do {
                    recipe?.isFavorite = try await service.updateFavouritePokemon(pokemonID)
                } catch {
                    print("failed to upadte SwiftData: errro \(error)")
                }
            }
        case .load:
            Task { await fetchPokemon() }
        }
    }
    
    private func fetchPokemon() async {
//        do {
//            let recipeDomain = try await service.fetchPokemon(for: pokemonID)
//            self.recipe = Recipe(from: recipeDomain)
//        } catch {
//            print("Error: \(error)")
//        }
    }
}
