//
//  PokemonDomain.swift
//  PokemonDomain
//
//  Created by Nitin George on 08/03/2025.
//

import Foundation

public struct PokemonDomain: Identifiable, @unchecked Sendable {
    public var id: Int
    public var name: String
    public var url: URL
    
    public init(id: Int, name: String, url: URL) {
        self.id = id
        self.name = name
        self.url = url
    }
}
