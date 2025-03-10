//
//  SDUser.swift
//  PokemonDataStore
//
//  Created by Nitin George on 09/03/2025.
//

import Foundation
import SwiftData
import PokemonDomain

@Model
public final class SDUser {
    @Attribute(.unique)
    public var id: UUID
    public var name: String
    public var score: Int
    public var email: String?
    public var isGuest: Bool
    public var lastActive: Date
    
    @Relationship(deleteRule: .cascade)
    public var preference: SDPreference?
    
    init(
        id: UUID,
        name: String = "Guest",
        score: Int,
        email: String?,
        isGuest: Bool,
        lastActive: Date,
        preference: SDPreference? = nil
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

extension SDUser {
    convenience init(from user: UserDomain) {
        let preference = SDPreference(from: user.preference)
        
        self.init(
            id: user.id,
            name: user.name,
            score: user.score,
            email: user.email,
            isGuest: user.isGuest,
            lastActive: user.lastActive,
            preference: preference
            )
    }
    
    func update(from domain: UserDomain) {
        self.id = domain.id
        self.name = domain.name
        self.score = domain.score
        self.email = domain.email
        self.isGuest = domain.isGuest
        self.lastActive = domain.lastActive
    }
}

extension UserDomain {
    init(from sdUser: SDUser) {
        let preferance = PreferenceDomain(from: sdUser.preference ?? SDPreference(lastUpdated: Date()))
       
        self.init(
            id: sdUser.id,
            name: sdUser.name,
            score: sdUser.score,
            email: sdUser.email,
            isGuest: sdUser.isGuest,
            lastActive: sdUser.lastActive,
            preference: preferance
        )
    }
}
