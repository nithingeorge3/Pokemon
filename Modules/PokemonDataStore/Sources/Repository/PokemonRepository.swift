//
//  PokemonSDRepository.swift
//  RecipeDataStore
//
//  Created by Nitin George on 02/03/2025.
//

import Foundation
import PokemonDomain
import SwiftData

@frozen
public enum SDError: Error {
    case modelNotFound
    case modelObjNotFound
}

public final class PokemonSDRepository: PokemonSDRepositoryType {
    private let container: ModelContainer
    
    public init(container: ModelContainer) {
        self.container = container
    }
    
    @MainActor
    private var dataStore: DataStoreManager {
        DataStoreManager(container: self.container)
    }
    
    public func fetchPokemon(for pokemonID: Int) async throws -> RecipeDomain {
        try await dataStore.performBackgroundTask { context in
            let predicate = #Predicate<SDRecipe> { $0.id == pokemonID }
            let descriptor = FetchDescriptor<SDRecipe>(predicate: predicate)

            guard let recipe = try context.fetch(descriptor).first else {
                throw SDError.modelObjNotFound
            }
            return RecipeDomain(from: recipe)
        }
    }
    
    public func fetchRecipes(page: Int = 0, pageSize: Int = 40) async throws -> [RecipeDomain] {
        try await dataStore.performBackgroundTask { context in
            let offset = page * pageSize
            
            var descriptor = FetchDescriptor<SDRecipe>(
                predicate: nil,
                sortBy: [SortDescriptor(\.createdAt, order: .reverse)]
            )
            descriptor.fetchLimit = pageSize
            descriptor.fetchOffset = offset

            return try context.fetch(descriptor).map(RecipeDomain.init)
        }
    }
    
    public func savePokemon(_ pokemon: [PokemonDomain]) async throws {
        try await dataStore.performBackgroundTask { context in
            let existing = try self.existingRecipes(ids: pokemon.map(\.id), context: context)
            
            for poke in pokemon {
                if let existingPokemon = existing[poke.id] {
                    existingPokemon.update(from: poke)
                } else {
                    context.insert(SDPokemon(from: poke))
                }
            }
        }
    }
    
    public func updateFavouriteRecipe(_ recipeID: Int) async throws -> Bool {
        try await dataStore.performBackgroundTask { context in
            let predicate = #Predicate<SDRecipe> { $0.id == recipeID }
            let descriptor = FetchDescriptor<SDRecipe>(predicate: predicate)

            guard let existingRecipe = try context.fetch(descriptor).first else {
                throw SDError.modelObjNotFound
            }

            existingRecipe.isFavorite.toggle()

            try context.save()

            return existingRecipe.isFavorite
        }
    }
    
    private func existingRecipes(ids: [Int], context: ModelContext) throws -> [Int: SDPokemon] {
        let predicate = #Predicate<SDPokemon> { ids.contains($0.id) }
        let descriptor = FetchDescriptor<SDPokemon>(predicate: predicate)
        return try context.fetch(descriptor).reduce(into: [:]) { $0[$1.id] = $1 }
    }
}
