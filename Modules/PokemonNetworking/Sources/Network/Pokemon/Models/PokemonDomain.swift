//
//  PokemonDTO.swift
//  PokemonNetworking
//
//  Created by Nitin George on 08/03/2024.
//

import Foundation
import PokemonDomain

extension PokemonDomain {
    init(from dto: PokemonDTO) throws {
        guard let url = URL(string: dto.url) else {
            throw PokemonError.invalidPokemonURL(url: dto.url)
        }
        let id = try Self.extractPokemonID(from: url)
        self.init(id: id, name: dto.name, url: url)
    }
    
    private static func extractPokemonID(from url: URL) throws -> Int {
        let trimmedURLString = url.absoluteString.trimmingCharacters(in: ["/"])
        guard let trimmedURL = URL(string: trimmedURLString) else {
            throw PokemonError.invalidPokemonURL(url: url.absoluteString)
        }
        
        let components = trimmedURL.pathComponents.filter { !$0.isEmpty }
        guard !components.isEmpty else {
            throw PokemonError.emptyPathComponents(url: url.absoluteString)
        }
        
        guard let lastComponent = components.last,
              let id = Int(lastComponent) else {
            throw PokemonError.invalidIDFormat(url: url.absoluteString)
        }
        
        return id
    }
}
