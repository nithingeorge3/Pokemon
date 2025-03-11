//
//  Extension.swift
//  PokemonDataStore
//
//  Created by Nitin George on 02/03/2025.
//

import Foundation
import SwiftData

extension ModelContainer {
    static func makeContainer(name: String) -> ModelContainer {
        do {
            let schema = Schema([
                SDUser.self,
                SDUserPokemon.self,
                SDPreference.self,
                SDPokemon.self,
                SDPagination.self
            ])
            
            let config = ModelConfiguration(
                url: .documentsDirectory.appendingPathComponent("\(name).sqlite"),
                cloudKitDatabase: .none
            )
            
            return try ModelContainer(for: schema, configurations: config)
        } catch {
            fatalError("Failed to create prod container: \(error)")
        }
    }
    
    static func makeTestContainer() -> ModelContainer {
        let schema = Schema([
            SDUser.self,
            SDUserPokemon.self,
            SDPreference.self,
            SDPokemon.self,
            SDPagination.self
        ])
        
        let config = ModelConfiguration(
            isStoredInMemoryOnly: true,
            allowsSave: true
        )
        
        do {
            return try ModelContainer(for: schema, configurations: config)
        } catch {
            fatalError("Failed to create test container: \(error)")
        }
    }
}
