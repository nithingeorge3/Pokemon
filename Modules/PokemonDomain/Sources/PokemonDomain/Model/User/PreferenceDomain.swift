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
    public var lastUpdated: Date
    
    public init(
        id: UUID = UUID(),
        showWinAnimation: Bool = false,
        lastUpdated: Date = Date()
    ) {
        self.id = id
        self.showWinAnimation = showWinAnimation
        self.lastUpdated = lastUpdated
    }
}
