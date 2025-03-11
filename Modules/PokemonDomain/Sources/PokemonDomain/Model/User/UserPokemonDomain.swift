//
//  SDUserPokemon.swift
//  PokemonDomain
//
//  Created by Nitin George on 11/03/2025.
//

import Foundation

public enum GameOutcome: String, Codable, Sendable {
    case unplayed, win, fail
}

//public enum GameOutcome: Codable {
//    case unplayed
//    case win(score: Int)
//    case fail(reason: String)
//}

public struct GameSession: Codable {
    let date: Date
    let outcome: GameOutcome
    let options: GameOptions?
}

public struct GameOptions: Codable {
    let difficulty: String
    let itemsAllowed: Bool
    let timeLimit: Int
}

public struct UserPokemonDomain: Identifiable, @unchecked Sendable  {
    public var id: UUID
    public var lastPlayedDate: Date
    public var lastOutcome: GameOutcome
    public var isMarkedForPlayLater: Bool
    
    public var gameplayHistory: [GameSession]
    public var selectedOptions: GameOptions?

    public var user: UserDomain?
    public var pokemon: PokemonDomain?
    
    public init(id: UUID, lastPlayedDate: Date, lastOutcome: GameOutcome, isMarkedForPlayLater: Bool, gameplayHistory: [GameSession] = [], selectedOptions: GameOptions? = nil, user: UserDomain? = nil, pokemon: PokemonDomain? = nil) {
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
