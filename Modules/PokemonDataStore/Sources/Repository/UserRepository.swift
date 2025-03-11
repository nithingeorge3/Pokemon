//
//  UserRepository.swift
//  PokemonDataStore
//
//  Created by Nitin George on 09/03/2025.
//

import Foundation
import PokemonDomain
import SwiftData

public final class UserSDRepository: UserSDRepositoryType {
    private let container: ModelContainer
    
    public init(container: ModelContainer) {
        self.container = container
    }
    
    @MainActor
    private var dataStore: DataStoreManager {
        DataStoreManager(container: self.container)
    }
    
    public func getOrCreateGuest() async throws -> UserDomain {
        try await dataStore.performBackgroundTask { context in
            let predicate = #Predicate<SDUser> { $0.isGuest }
            let descriptor = FetchDescriptor<SDUser>(
                predicate: predicate,
                sortBy: [SortDescriptor(\.lastActive, order: .reverse)]
            )
            
            let existing = try context.fetch(descriptor)
            if let guest = existing.first {
                return UserDomain(from: guest)
            }

            let id = UUID()
            let date = Date()
            let newUser = SDUser(id: id, score: 0, email: "guest@pokemon.com", isGuest: true, lastActive: date)
            newUser.preference = SDPreference(id: id, lastUpdated: date)
            context.insert(newUser)
            try context.save()
            return UserDomain(from: newUser)
        }
    }
    
    public func updatePreferences(_ newPref: PreferenceDomain) async throws {
        try await dataStore.performBackgroundTask { context in
            let predicate = #Predicate<SDUser> { $0.isGuest }
            let descriptor = FetchDescriptor<SDUser>(
                predicate: predicate,
                sortBy: [SortDescriptor(\.lastActive, order: .reverse)]
            )
            
            let existing = try context.fetch(descriptor)
            
            guard let guest = existing.first, let preference = guest.preference else {
                throw SDError.modelObjNotFound
            }
            
            preference.showWinAnimation = newPref.showWinAnimation
            preference.enableSilhouetteMode = newPref.enableSilhouetteMode
            
            preference.lastUpdated = Date()
            
            try context.save()
        }
    }
    
    public func getCurrentPreferences() async throws -> PreferenceDomain {
        try await dataStore.performBackgroundTask { context in
            let predicate = #Predicate<SDUser> { $0.isGuest }
            let descriptor = FetchDescriptor<SDUser>(
                predicate: predicate,
                sortBy: [SortDescriptor(\.lastActive, order: .reverse)]
            )
            
            let existing = try context.fetch(descriptor)
            
            if let preference = existing.first?.preference {
                return PreferenceDomain(from: preference)
            }
       
            let id = UUID()
            let date = Date()
            let newUser = SDUser(id: id, score: 0, email: "guest@pokemon.com", isGuest: true, lastActive: date)
            let sdPreference = SDPreference(id: id, lastUpdated: date)
            newUser.preference = sdPreference
            context.insert(newUser)
            try context.save()
            return PreferenceDomain(from: sdPreference)
            
        }
    }
    
    public func updateScore(_ points: Int) async throws {
        try await dataStore.performBackgroundTask { context in
            let predicate = #Predicate<SDUser> { $0.isGuest }
            let descriptor = FetchDescriptor<SDUser>(
                predicate: predicate,
                sortBy: [SortDescriptor(\.lastActive, order: .reverse)]
            )
            
            guard let user = try context.fetch(descriptor).first else {
                throw NSError(domain: "UserNotFound", code: 404)
            }
            
            user.score += points
            user.lastActive = Date()
            try context.save()
        }
    }
    
    public func getCurrentUser() async throws -> UserDomain {
        // For future multi-user: Check auth state
        return try await getOrCreateGuest()
    }
}

// MARK: - Game update
extension UserSDRepository {
    public func updatePlayedStatus(pokemonId: Int, outcome: GameOutcome) async throws {
        try await dataStore.performBackgroundTask { context in
            //Get current guest user
            let userPredicate = #Predicate<SDUser> { $0.isGuest }
            let userDescriptor = FetchDescriptor<SDUser>(predicate: userPredicate)
            guard let user = try context.fetch(userDescriptor).first else {
                throw SDError.userNotFound
            }
            
            //Find Pokemon
            let pokemonPredicate = #Predicate<SDPokemon> { $0.id == pokemonId }
            let pokemonDescriptor = FetchDescriptor<SDPokemon>(predicate: pokemonPredicate)
            guard let pokemon = try context.fetch(pokemonDescriptor).first else {
                throw SDError.pokemonNotFound
            }
            
            //Find existing entry or create new
            let existingEntry = user.playedPokemons.first { $0.pokemon?.id == pokemonId }
            
            if let entry = existingEntry {
                entry.lastOutcomeRaw = outcome.rawValue
                entry.lastPlayedDate = Date()
            } else {
                let newEntry = SDUserPokemon(
                    user: user,
                    pokemon: pokemon,
                    lastOutcome: outcome
                )
                user.playedPokemons.append(newEntry)
            }
            
            user.lastActive = Date()
            
            try context.save()
        }
    }
}
