//
//  RecipeDTO.swift
//  RecipeNetworking
//
//  Created by Nitin George on 01/03/2024.
//

import Foundation
import PokemonDomain

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
