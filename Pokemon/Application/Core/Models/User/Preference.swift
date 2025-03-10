//
//  Preference.swift
//  Pokemon
//
//  Created by Nitin George on 10/03/2025.
//

import Foundation

import Foundation
import PokemonDomain

struct Preference: Identifiable, Hashable {
    let id: UUID
    let showWinAnimation: Bool
    let lastUpdated: Date
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    public static func == (lhs: Preference, rhs: Preference) -> Bool {
        lhs.id == rhs.id
    }
    
    init(
        id: UUID,
        showWinAnimation: Bool,
        lastUpdated: Date
    ) {
        self.id = id
        self.showWinAnimation = showWinAnimation
        self.lastUpdated = lastUpdated
    }
}

extension Preference {
    init(from preferenceDomain: PreferenceDomain) {
        self.id = preferenceDomain.id
        self.showWinAnimation = preferenceDomain.showWinAnimation
        self.lastUpdated = preferenceDomain.lastUpdated
    }
}
