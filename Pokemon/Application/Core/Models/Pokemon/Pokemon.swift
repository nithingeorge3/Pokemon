//
//  Pokemon.swift
//  Pokemon
//
//  Created by Nitin George on 08/03/2025.
//

import Foundation
import PokemonDomain

struct Pokemon: Identifiable, Hashable {
    let id: Int
    let name: String
    let url: URL
    var isFavorite: Bool
    
    init(id: Int, name: String, url: URL, isFavorite: Bool) {
        self.id = id
        self.name = name
        self.url = url
        self.isFavorite = isFavorite
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    public static func == (lhs: Pokemon, rhs: Pokemon) -> Bool {
        lhs.id == rhs.id
    }
}

extension Pokemon {
    init(from pokemonDomain: PokemonDomain) {
        self.id = pokemonDomain.id
        self.name = pokemonDomain.name
        self.url = pokemonDomain.url
        self.isFavorite = pokemonDomain.isFavorite
    }
}
