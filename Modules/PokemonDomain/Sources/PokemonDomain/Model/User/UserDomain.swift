//
//  UserDomain.swift
//  PokemonDomain
//
//  Created by Nitin George on 09/03/2025.
//

import Foundation

public struct UserDomain: Identifiable, @unchecked Sendable  {
    public var id: UUID
    public var name: String
    public var score: Int
    public var email: String?
    public var isGuest: Bool
    public var lastActive: Date
    public var preference: PreferenceDomain
    
    public init(
        id: UUID = UUID(),
        name: String = "Guest",
        score: Int = 0,
        email: String? = "guest@pokemon.com",
        isGuest: Bool,
        lastActive: Date,
        preference: PreferenceDomain = PreferenceDomain()
    ) {
        self.id = id
        self.name = name
        self.score = score
        self.email = email
        self.isGuest = isGuest
        self.lastActive = lastActive
        self.preference = preference
    }
}
