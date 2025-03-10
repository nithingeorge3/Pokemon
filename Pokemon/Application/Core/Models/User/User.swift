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
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    public static func == (lhs: User, rhs: User) -> Bool {
        lhs.id == rhs.id
    }
    
    init(id: UUID, name: String, score: Int, email: String?, isGuest: Bool, lastActive: Date) {
        self.id = id
        self.name = name
        self.score = score
        self.email = email
        self.isGuest = isGuest
        self.lastActive = lastActive
    }
}

extension User {
    init(from userDomain: UserDomain) {
        self.id = userDomain.id
        self.name = userDomain.name
        self.score = userDomain.score
        self.email = userDomain.email
        self.isGuest = userDomain.isGuest
        self.lastActive = userDomain.lastActive
    }
}
