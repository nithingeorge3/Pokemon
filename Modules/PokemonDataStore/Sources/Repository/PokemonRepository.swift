//
//  PokemonSDRepository.swift
//  PokemonDataStore
//
//  Created by Nitin George on 02/03/2025.
//

import Foundation
import PokemonDomain
import SwiftData

@frozen
public enum SDError: Error, Equatable {
    case modelNotFound
    case modelObjNotFound
    case invalidRequest(reason: String)
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
                sortBy: [SortDescriptor(\.id, order: .forward)]
            )
            descriptor.fetchLimit = pageSize
            descriptor.fetchOffset = offset

            return try context.fetch(descriptor).map(PokemonDomain.init)
        }
    }
    
    public func fetchPokemon_(for pokemonID: Int) async throws -> PokemonDomain {
        try await dataStore.performBackgroundTask { context in
            let predicate = #Predicate<SDPokemon> { $0.id == pokemonID }
            let descriptor = FetchDescriptor<SDPokemon>(predicate: predicate)

            guard let pokemon = try context.fetch(descriptor).first else {
                throw SDError.modelObjNotFound
            }
            return try PokemonDomain(from: pokemon)
        }
    }
    
    public func fetchRandomOptions(excluding id: Int, count: Int) async throws -> [PokemonDomain] {
        guard count > 0 else {
            throw SDError.invalidRequest(reason: "Count must be greater than zero")
        }
        
        return try await dataStore.performBackgroundTask { context in
            let predicate = #Predicate<SDPokemon> { $0.id != id }
            var descriptor = FetchDescriptor<SDPokemon>(predicate: predicate)
            descriptor.fetchLimit = count
            descriptor.sortBy = [.init(\.id, order: .reverse)]
            
            let pokemon = try context.fetch(descriptor)
            
            let pokemonDomains = try pokemon.map { pokemon in
                do {
                    return try PokemonDomain(from: pokemon)
                } catch let error as PokemonError {
                    throw error // handle error
                } catch {
                    throw SDError.modelNotFound
                }
            }
            
            return pokemonDomains
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

            guard let existingPokemon = try context.fetch(descriptor).first else {
                throw SDError.modelObjNotFound
            }

            existingPokemon.isFavorite.toggle()

            try context.save()

            return existingPokemon.isFavorite
        }
    }
    
    private func existingPokemon(ids: [Int], context: ModelContext) throws -> [Int: SDPokemon] {
        let predicate = #Predicate<SDPokemon> { ids.contains($0.id) }
        let descriptor = FetchDescriptor<SDPokemon>(predicate: predicate)
        return try context.fetch(descriptor).reduce(into: [:]) { $0[$1.id] = $1 }
    }
}

//ToDo ad dtest cases
extension PokemonSDRepository {
    public func fetchRandomUnplayedPokemon() async throws -> PokemonDomain {
        try await dataStore.performBackgroundTask { context in
            //add predicate later when we add user SwiftData
            var descriptor = FetchDescriptor<SDPokemon>()
            descriptor.fetchLimit = 50
            
            let pokemonList = try context.fetch(descriptor)
            
            guard let randomPokemon = pokemonList.randomElement() else {
                throw SDError.modelObjNotFound
            }
            return try PokemonDomain(from: randomPokemon)
        }
    }
}
