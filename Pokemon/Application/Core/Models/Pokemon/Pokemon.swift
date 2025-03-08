//
//  Recipe.swift
//  Recipes
//
//  Created by Nitin George on 02/03/2025.
//

import Foundation
import PokemonDomain

struct Pokemon: Identifiable, Hashable {
    let id: Int
    let name: String
    let url: String
    let isFavorite: Bool
    
    init(id: Int, name: String, url: String, isFavorite: Bool) {
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

struct Recipe: Identifiable, Hashable {
    let id: Int
    let name: String
    let country: Country
    let description: String?
    let thumbnailURL: String?
    let originalVideoURL: String?
    let createdAt, approvedAt: Int?
    let yields: String?
    var isFavorite: Bool = false
    let userRatings: UserRatings?

    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    public static func == (lhs: Recipe, rhs: Recipe) -> Bool {
        lhs.id == rhs.id
    }
    
    init(id: Int, name: String, description: String? = nil, country: Country = .unknown, thumbnailURL: String? = nil, originalVideoURL: String? = nil, createdAt: Int? = nil, approvedAt: Int? = nil, yields: String? = nil, isFavorite: Bool = false, userRatings: UserRatings? = nil) {
        self.id = id
        self.name = name
        self.description = description
        self.country = country
        self.thumbnailURL = thumbnailURL
        self.originalVideoURL = originalVideoURL
        self.createdAt = createdAt
        self.approvedAt = approvedAt
        self.yields = yields
        self.isFavorite = isFavorite
        self.userRatings = userRatings
    }
}

extension Recipe {
    init(from recipeDomain: RecipeDomain) {
        let userRatings = UserRatings(from: recipeDomain.userRatings)
        
        self.id = recipeDomain.id
        self.name = recipeDomain.name
        self.description = recipeDomain.description
        self.country = recipeDomain.country
        self.thumbnailURL = recipeDomain.thumbnailURL
        self.originalVideoURL = recipeDomain.originalVideoURL
        self.createdAt = recipeDomain.createdAt
        self.approvedAt = recipeDomain.approvedAt
        self.yields = recipeDomain.yields
        self.isFavorite = recipeDomain.isFavorite
        self.userRatings = userRatings
    }
}
