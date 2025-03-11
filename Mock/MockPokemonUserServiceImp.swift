//
//  MockPokemonUserServiceImp.swift
//  Pokemon
//
//  Created by Nitin George on 10/03/2025.
//

import Foundation
import PokemonNetworking
import PokemonDataStore
import PokemonDomain

final class MockPokemonUserServiceImp: PokemonUserServiceType, @unchecked Sendable {
    func getCurrentUser() async throws -> UserDomain {
        UserDomain(isGuest: true, lastActive: Date())
    }
    
    func updatePreferences(_ newPref: PreferenceDomain) async throws {
        
    }
    
    func getCurrentPreferences() async throws -> PreferenceDomain {
        PreferenceDomain()
    }
}
