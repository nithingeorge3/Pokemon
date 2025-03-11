//
//  SDPokemon.swift
//  PokemonDataStore
//
//  Created by Nitin George on 02/03/2025.
//

import Foundation
import SwiftData
import PokemonDomain

@Model
public final class SDPokemon {
    @Attribute(.unique)
    public var id: Int
    public var name: String
    public var url: String
    
    init(
        id: Int,
        name: String,
        url: String
    ) {
        self.id = id
        self.name = name
        self.url = url
    }
}

extension SDPokemon {
    convenience init(from pokemon: PokemonDomain) {
        self.init(
            id: pokemon.id,
            name: pokemon.name,
            url: pokemon.url.absoluteString
            )
    }
    
    func update(from domain: PokemonDomain) {
        self.id = domain.id
        self.name = domain.name
        self.url = domain.url.absoluteString
    }
}

extension PokemonDomain {
    init(from sdPokemon: SDPokemon) throws {
        guard let url = URL(string: sdPokemon.url) else {
            throw PokemonError.invalidPokemonURL(url: sdPokemon.url)
        }
        
        self.init(
            id: sdPokemon.id,
            name: sdPokemon.name,
            url: url
        )
    }
}
