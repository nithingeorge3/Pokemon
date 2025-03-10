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
    
    init(
        id: UUID,
        name: String = "Guest",
        score: Int,
        email: String?,
        isGuest: Bool,
        lastActive: Date
    ) {
        self.id = id
        self.name = name
        self.score = score
        self.email = email
        self.isGuest = isGuest
        self.lastActive = lastActive
    }
}

extension SDUser {
    convenience init(from user: UserDomain) {
        self.init(
            id: user.id,
            name: user.name,
            score: user.score,
            email: user.email,
            isGuest: user.isGuest,
            lastActive: user.lastActive
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
        self.init(
            id: sdUser.id,
            name: sdUser.name,
            score: sdUser.score,
            email: sdUser.email,
            isGuest: sdUser.isGuest,
            lastActive: sdUser.lastActive
        )
    }
}
