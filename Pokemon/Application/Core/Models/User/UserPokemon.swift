//
//  UserPokemon.swift
//  Pokemon
//
//  Created by Nitin George on 11/03/2025.
//

import Foundation
import PokemonDomain

struct UserPokemon: Identifiable, Hashable {
    let id: UUID
    let lastPlayedDate: Date
    let lastOutcome: GameOutcome
    let isMarkedForPlayLater: Bool
    
    let gameplayHistory: [GameSession]
    
    let selectedOptions: GameOptions?

    let user: User
    let pokemon: Pokemon
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    public static func == (lhs: UserPokemon, rhs: UserPokemon) -> Bool {
        lhs.id == rhs.id
    }
    
    init(id: UUID, lastPlayedDate: Date, lastOutcome: GameOutcome, isMarkedForPlayLater: Bool, gameplayHistory: [GameSession] = [], selectedOptions: GameOptions? = nil, user: User, pokemon: Pokemon) {
        self.id = id
        self.lastPlayedDate = lastPlayedDate
        self.lastOutcome = lastOutcome
        self.isMarkedForPlayLater = isMarkedForPlayLater
        self.gameplayHistory = gameplayHistory
        self.selectedOptions = selectedOptions
        self.user = user
        self.pokemon = pokemon
    }
}

extension UserPokemon {
    init(from userPokeDomain: UserPokemonDomain) {
        let pokeUser = User(from: userPokeDomain.user)
        let poke = Pokemon(from: userPokeDomain.pokemon)
        
        self.id = userPokeDomain.id
        self.lastPlayedDate = userPokeDomain.lastPlayedDate
        self.lastOutcome = userPokeDomain.lastOutcome
        self.isMarkedForPlayLater = userPokeDomain.isMarkedForPlayLater
        self.gameplayHistory = userPokeDomain.gameplayHistory
        self.selectedOptions = userPokeDomain.selectedOptions
        self.user = pokeUser
        self.pokemon = poke
    }
}
