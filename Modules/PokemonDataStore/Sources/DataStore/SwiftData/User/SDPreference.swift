//
//  SDPreference.swift
//  PokemonDataStore
//
//  Created by Nitin George on 10/03/2025.
//

import Foundation
import SwiftData
import PokemonDomain

@Model
public final class SDPreference {
    @Attribute(.unique)
    public var id: UUID
    public var showWinAnimation: Bool
    public var enableSilhouetteMode: Bool
    public var lastUpdated: Date
    
    @Relationship(inverse: \SDUser.preference)
    public var user: SDUser?
    
    init(
        id: UUID = UUID(),
        showWinAnimation: Bool = false,
        enableSilhouetteMode: Bool = true,
        lastUpdated: Date
    ) {
        self.id = id
        self.showWinAnimation = showWinAnimation
        self.enableSilhouetteMode = enableSilhouetteMode
        self.lastUpdated = lastUpdated
    }
}

extension SDPreference {
    convenience init(from preference: PreferenceDomain) {
        self.init(
            id: preference.id,
            showWinAnimation: preference.showWinAnimation,
            enableSilhouetteMode: preference.enableSilhouetteMode,
            lastUpdated: preference.lastUpdated
            )
    }
    
    func update(from preference: PreferenceDomain) {
        self.id = preference.id
        self.showWinAnimation = preference.showWinAnimation
        self.enableSilhouetteMode = preference.enableSilhouetteMode
        self.lastUpdated = preference.lastUpdated
    }
}

extension PreferenceDomain {
    init(from sdPreference: SDPreference) {
        self.init(
            id: sdPreference.id,
            showWinAnimation: sdPreference.showWinAnimation,
            enableSilhouetteMode: sdPreference.enableSilhouetteMode,
            lastUpdated: sdPreference.lastUpdated
        )
    }
}
