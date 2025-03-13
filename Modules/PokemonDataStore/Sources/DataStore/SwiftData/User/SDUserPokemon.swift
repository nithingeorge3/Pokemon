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
    
    public var lastOutcomeRaw: String
    public var isMarkedForPlayLater: Bool

    //@Relationship(inverse: \SDUser.preference)
    public var user: SDUser?
    public var pokemon: SDPokemon?
    
    public var lastOutcomeType: GameOutcome {
        get { GameOutcome(rawValue: lastOutcomeRaw) ?? .fail }
        set { lastOutcomeRaw = newValue.rawValue }
    }
    
    init(
        id: UUID = UUID(),
        user: SDUser? = nil,
        pokemon: SDPokemon? = nil,
        lastPlayedDate: Date = .now,
        lastOutcome: GameOutcome = .unplayed,
        isMarkedForPlayLater: Bool = false
    ) {
        self.id = id
        self.user = user
        self.pokemon = pokemon
        self.lastPlayedDate = lastPlayedDate
        self.lastOutcomeRaw = lastOutcome.rawValue
        self.isMarkedForPlayLater = isMarkedForPlayLater
    }
}

extension SDUserPokemon {
    convenience init(from userPokeDomain: UserPokemonDomain) {        
        self.init(
            id: userPokeDomain.id,
            lastPlayedDate: userPokeDomain.lastPlayedDate,
            lastOutcome: userPokeDomain.lastOutcome,
            isMarkedForPlayLater: userPokeDomain.isMarkedForPlayLater
        )
    }
}

extension UserPokemonDomain {
    init(from sdUserPokemon: SDUserPokemon) throws {
        var pokeDomain: PokemonDomain?
        
        if let sdPokemon = sdUserPokemon.pokemon {
            pokeDomain = try PokemonDomain(from: sdPokemon)
        }
                
        self.init(
            id: sdUserPokemon.id,
            lastPlayedDate: sdUserPokemon.lastPlayedDate,
            lastOutcome: sdUserPokemon.lastOutcomeType,
            isMarkedForPlayLater: sdUserPokemon.isMarkedForPlayLater,
            pokemon: pokeDomain
        )
    }
}
