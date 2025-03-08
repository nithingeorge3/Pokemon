//
//  RecipeDTO.swift
//  RecipeNetworking
//
//  Created by Nitin George on 02/03/2025.
//

import Foundation

public struct PokemonDomain: Identifiable, @unchecked Sendable {
    public var id: Int
    public var name: String
    public var url: String
    public var isFavorite: Bool
    
    public init(id: Int, name: String, url: String, isFavorite: Bool = false) {
        self.id = id
        self.name = name
        self.url = url
        self.isFavorite = isFavorite
    }
}

public struct RecipeDomain: Identifiable, @unchecked Sendable {
    public var id: Int
    public var name: String
    public var country: Country
    public var description: String?
    public var thumbnailURL: String?
    public var originalVideoURL: String?
    public var createdAt, approvedAt: Int?
    public var yields: String?
    public var isFavorite: Bool
    public var userRatings: UserRatingsDomain?
    
    public init(id: Int, name: String, description: String? = nil, country: Country = .unknown, thumbnailURL: String? = nil, originalVideoURL: String? = nil, createdAt: Int? = nil, approvedAt: Int? = nil, yields: String? = nil, isFavorite: Bool = false, userRatings: UserRatingsDomain? = nil) {
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

public struct UserRatingsDomain: Codable {
    public let id: Int
    public var countNegative, countPositive: Int?
    public var score: Double?
    
    public init(id: Int, countNegative: Int?, countPositive: Int?, score: Double? = nil) {
        self.id = id
        self.countNegative = countNegative
        self.countPositive = countPositive
        self.score = score
    }
}
