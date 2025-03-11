//
//  User.swift
//  Pokemon
//
//  Created by Nitin George on 09/03/2025.
//

import Foundation
import PokemonDomain

struct User: Identifiable, Hashable {
    let id: UUID
    let name: String
    let score: Int
    let email: String?
    let isGuest: Bool
    let lastActive: Date
    let preference: Preference
    let playedPokemons: [UserPokemon]

    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    public static func == (lhs: User, rhs: User) -> Bool {
        lhs.id == rhs.id
    }
    
    init(id: UUID, name: String, score: Int, email: String?, isGuest: Bool, lastActive: Date, preference: Preference, playedPokemons: [UserPokemon] = []) {
        self.id = id
        self.name = name
        self.score = score
        self.email = email
        self.isGuest = isGuest
        self.lastActive = lastActive
        self.preference = preference
        self.playedPokemons = playedPokemons
    }
}

extension User {
    init(from userDomain: UserDomain) {
        let preference = Preference(from: userDomain.preference)
        let userPoke = userDomain.playedPokemons.map {
            UserPokemon(from: $0)
        }
        
        self.id = userDomain.id
        self.name = userDomain.name
        self.score = userDomain.score
        self.email = userDomain.email
        self.isGuest = userDomain.isGuest
        self.lastActive = userDomain.lastActive
        self.preference = preference
        self.playedPokemons = userPoke
    }
}
