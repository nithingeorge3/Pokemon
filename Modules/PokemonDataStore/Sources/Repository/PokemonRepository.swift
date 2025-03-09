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
    
    public func fetchPokemon(for pokemonID: Int) async throws -> PokemonDomain {
        try await dataStore.performBackgroundTask { context in
            let predicate = #Predicate<SDPokemon> { $0.id == pokemonID }
            let descriptor = FetchDescriptor<SDPokemon>(predicate: predicate)

            guard let pokemon = try context.fetch(descriptor).first else {
                throw SDError.modelObjNotFound
            }
            return try PokemonDomain(from: pokemon)
        }
    }
    
    public func fetchPokemon(offset: Int, pageSize: Int) async throws -> [PokemonDomain] {
        try await dataStore.performBackgroundTask { context in
            let offset = offset * pageSize
            
            var descriptor = FetchDescriptor<SDPokemon>(
                predicate: nil,
                sortBy: [SortDescriptor(\.id, order: .reverse)]
            )
            descriptor.fetchLimit = pageSize
            descriptor.fetchOffset = offset

            return try context.fetch(descriptor).map(PokemonDomain.init)
        }
    }
    
    public func savePokemon(_ pokemon: [PokemonDomain]) async throws {
        try await dataStore.performBackgroundTask { context in
            let existing = try self.existingPokemon(ids: pokemon.map(\.id), context: context)
            
            for poke in pokemon {
                if let existingPokemon = existing[poke.id] {
                    existingPokemon.update(from: poke)
                } else {
                    context.insert(SDPokemon(from: poke))
                }
            }
        }
    }
    
    public func updateFavouritePokemon(_ pokemonID: Int) async throws -> Bool {
        try await dataStore.performBackgroundTask { context in
            let predicate = #Predicate<SDPokemon> { $0.id == pokemonID }
            let descriptor = FetchDescriptor<SDPokemon>(predicate: predicate)

            guard let existingRecipe = try context.fetch(descriptor).first else {
                throw SDError.modelObjNotFound
            }

            existingRecipe.isFavorite.toggle()

            try context.save()

            return existingRecipe.isFavorite
        }
    }
    
    private func existingPokemon(ids: [Int], context: ModelContext) throws -> [Int: SDPokemon] {
        let predicate = #Predicate<SDPokemon> { ids.contains($0.id) }
        let descriptor = FetchDescriptor<SDPokemon>(predicate: predicate)
        return try context.fetch(descriptor).reduce(into: [:]) { $0[$1.id] = $1 }
    }
}
