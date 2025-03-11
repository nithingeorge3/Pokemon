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

    public var user: SDUser
    public var pokemon: SDPokemon
    
    init(
        id: UUID = UUID(),
        user: SDUser,
        pokemon: SDPokemon,
        lastPlayedDate: Date = .now,
        lastOutcome: GameOutcome = .unplayed,
        isMarkedForPlayLater: Bool = false
    ) {
        self.id = id
        self.user = user
        self.pokemon = pokemon
        self.lastPlayedDate = lastPlayedDate
        self.lastOutcome = lastOutcome
        self.isMarkedForPlayLater = isMarkedForPlayLater
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
            isMarkedForPlayLater: userPokeDomain.isMarkedForPlayLater
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
            user: pokeUser,
            pokemon: poke
        )
    }
}
