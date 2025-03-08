//
//  Country.swift
//  Pokemon
//
//  Created by Nitin George on 03/03/2025.
//

import PokemonDomain

extension Country {
    var displayName: String {
        switch self {
        case .us:
            return "United State"
        case .gb:
            return "United Kingdom"
        case .ind:
            return "India"
        case .pl:
            return "Poland"
        case .unknown:
            return "Unknown"
        }
    }
}
