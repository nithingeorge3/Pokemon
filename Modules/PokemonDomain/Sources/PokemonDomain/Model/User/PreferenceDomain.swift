//
//  PreferenceDomain.swift
//  PokemonDomain
//
//  Created by Nitin George on 10/03/2025.
//

import Foundation

public struct PreferenceDomain: Identifiable, @unchecked Sendable  {
    public var id: UUID
    public var showWinAnimation: Bool
    public var enableSilhouetteMode: Bool
    public var lastUpdated: Date
    
    public init(
        id: UUID = UUID(),
        showWinAnimation: Bool = true,
        enableSilhouetteMode: Bool = true,
        lastUpdated: Date = Date()
    ) {
        self.id = id
        self.showWinAnimation = showWinAnimation
        self.enableSilhouetteMode = enableSilhouetteMode
        self.lastUpdated = lastUpdated
    }
}
