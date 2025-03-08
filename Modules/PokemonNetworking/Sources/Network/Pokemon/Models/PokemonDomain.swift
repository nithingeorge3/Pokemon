//
//  RecipeDTO.swift
//  RecipeNetworking
//
//  Created by Nitin George on 01/03/2024.
//

import Foundation
import PokemonDomain

extension PokemonDomain {
    init(from dto: PokemonDTO) throws {
        guard let id = Self.extractPokemonID(from: dto.url) else {
            throw PokemonError.invalidURL(url: dto.url)
        }
        self.init(
            id: id,
            name: dto.name,
            url: dto.url
        )
    }

    private static func extractPokemonID(from urlString: String) -> Int? {
        let components = urlString.split(separator: "/").filter { !$0.isEmpty }
        return components.last.flatMap { Int($0) }
    }
}

extension RecipeDomain {
    init(from dto: RecipeDTO) {
        let country = Country(from: dto.country ?? .unknown)
        let rating = UserRatingsDomain(id: dto.id, countNegative: dto.userRatings?.countNegative, countPositive: dto.userRatings?.countPositive, score: dto.userRatings?.score)
        
        self.init(
            id: dto.id,
            name: dto.name,
            description: dto.description,
            country: country,
            thumbnailURL: dto.thumbnailURL,
            originalVideoURL: dto.originalVideoURL,
            createdAt: dto.createdAt,
            approvedAt: dto.approvedAt,
            yields: dto.yields,
            userRatings: rating
        )
    }
}
