//
//  PokemonDTO.swift
//  PokemonNetworking
//
//  Created by Nitin George on 08/03/2025.
//

struct PokemonResponseDTO: Codable {
    let count: Int
    let next, previous: String
    let results: [PokemonDTO]
}

struct PokemonDTO: Codable {
    let name: String
    let url: String
}
