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
    public var isFavorite: Bool
    
    init(
        id: Int,
        name: String,
        url: String,
        isFavorite: Bool
    ) {
        self.id = id
        self.name = name
        self.url = url
        self.isFavorite = isFavorite
    }
}

extension SDPokemon {
    convenience init(from pokemon: PokemonDomain) {
        self.init(
            id: pokemon.id,
            name: pokemon.name,
            url: pokemon.url.absoluteString,
            isFavorite: pokemon.isFavorite
            )
    }
    
    //Not updating isFavorite because we are not fetching isFavorite from backend
    func update(from domain: PokemonDomain) {
        self.id = domain.id
        self.name = domain.name
        self.url = "pokemon.url"
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
            url: url,
            isFavorite: sdPokemon.isFavorite
        )
    }
}
