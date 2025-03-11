//
//  SDUserPokemon.swift
//  PokemonDataStore
//
//  Created by Nitin George on 11/03/2025.
//

import Foundation
import SwiftData
import PokemonDomain

@Model
public final class SDUserPokemon {
    @Attribute(.unique) public var id: UUID
    public var lastPlayedDate: Date
    public var lastOutcome: GameOutcome
    public var isMarkedForPlayLater: Bool
    
    public var gameplayHistory: [GameSession]
    public var selectedOptions: GameOptions?

    public var user: SDUser
    public var pokemon: SDPokemon
    
    init(
        id: UUID = UUID(),
        user: SDUser,
        pokemon: SDPokemon,
        lastPlayedDate: Date = .now,
        lastOutcome: GameOutcome = .unplayed,
        isMarkedForPlayLater: Bool = false,
        gameplayHistory: [GameSession] = [],
        selectedOptions: GameOptions? = nil
    ) {
        self.id = id
        self.user = user
        self.pokemon = pokemon
        self.lastPlayedDate = lastPlayedDate
        self.lastOutcome = lastOutcome
        self.isMarkedForPlayLater = isMarkedForPlayLater
        self.gameplayHistory = gameplayHistory
        self.selectedOptions = selectedOptions
    }
}

extension SDUserPokemon {
    convenience init(from userPokeDomain: UserPokemonDomain) {
        let pokeUser = SDUser(from: userPokeDomain.user)
        let poke = SDPokemon(from: userPokeDomain.pokemon)
        
        self.init(
            id: userPokeDomain.id,
            user: pokeUser,
            pokemon: poke,
            lastPlayedDate: userPokeDomain.lastPlayedDate,
            lastOutcome: userPokeDomain.lastOutcome,
            isMarkedForPlayLater: userPokeDomain.isMarkedForPlayLater,
            gameplayHistory: userPokeDomain.gameplayHistory,
            selectedOptions: userPokeDomain.selectedOptions
        )
    }
}


extension UserPokemonDomain {
    init(from sdUserPokemon: SDUserPokemon) throws {
        let pokeUser = UserDomain(from: sdUserPokemon.user)
        let poke = try PokemonDomain(from: sdUserPokemon.pokemon)
                
        self.init(
            id: sdUserPokemon.id,
            lastPlayedDate: sdUserPokemon.lastPlayedDate,
            lastOutcome: sdUserPokemon.lastOutcome,
            isMarkedForPlayLater: sdUserPokemon.isMarkedForPlayLater,
            gameplayHistory: sdUserPokemon.gameplayHistory,
            selectedOptions: sdUserPokemon.selectedOptions,
            user: pokeUser,
            pokemon: poke
        )
    }
}
