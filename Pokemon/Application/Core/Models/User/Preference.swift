//
//  Preference.swift
//  Pokemon
//
//  Created by Nitin George on 10/03/2025.
//

import Foundation
import PokemonDomain

struct Preference: Identifiable, Hashable {
    let id: UUID
    var showWinAnimation: Bool
    var enableSilhouetteMode: Bool
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
        enableSilhouetteMode: Bool,
        lastUpdated: Date
    ) {
        self.id = id
        self.showWinAnimation = showWinAnimation
        self.enableSilhouetteMode = enableSilhouetteMode
        self.lastUpdated = lastUpdated
    }
}

extension Preference {
    init(from preferenceDomain: PreferenceDomain) {
        self.id = preferenceDomain.id
        self.showWinAnimation = preferenceDomain.showWinAnimation
        self.enableSilhouetteMode = preferenceDomain.enableSilhouetteMode
        self.lastUpdated = preferenceDomain.lastUpdated
    }
}

extension Preference {
    var asDomain: PreferenceDomain {
        PreferenceDomain(
            id: self.id,
            showWinAnimation: self.showWinAnimation,
            enableSilhouetteMode: self.enableSilhouetteMode,
            lastUpdated: self.lastUpdated
        )
    }
}
