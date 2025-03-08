//
//  RecipeDTO.swift
//  RecipeNetworking
//
//  Created by Nitin George on 01/03/2024.
//

import Foundation
import PokemonDomain

struct PokemonResponseDTO: Codable {
    let count: Int
    let next, previous: String
    let results: [PokemonDTO]
}

// MARK: - Result
struct PokemonDTO: Codable {
    let name: String
    let url: String
}


struct RecipeResponseDTO: Codable {
    let count: Int
    let results: [RecipeDTO]
}

struct RecipeDTO: Codable {
    let id: Int
    let name: String
    let country: CountryDTO?
    let description: String?
    let thumbnailURL: String?
    let originalVideoURL: String?
    let createdAt, approvedAt: Int?
    let yields: String?
    let userRatings: UserRatingsDTO? // I am not using this data(UI pending). In production I will not decode unwanted keys.
//    let sections: [SectionDTO] // pending

    enum CodingKeys: String, CodingKey {
        case id
        case name
        case country
        case description
        case thumbnailURL = "thumbnail_url"
        case originalVideoURL = "original_video_url"
        case createdAt = "created_at"
        case approvedAt = "approved_at"
        case yields
        case userRatings = "user_ratings"
//        case sections
    }
}

enum CountryDTO: String, Codable {
    case us = "US"
    case ind = "IND"
    case gb = "GB"
    case pl = "PL" //we can add more here
    case unknown
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let rawValue = try container.decode(String.self)
        self = CountryDTO(rawValue: rawValue) ?? .unknown
    }
}

/*
struct SectionDTO: Codable {
    let position: Int
    let components: [ComponentDTO]
    let name: String?
}

struct ComponentDTO: Codable {
    let rawText, extraComment: String
    let ingredient: IngredientDTO
    let id, position: Int

    enum CodingKeys: String, CodingKey {
        case rawText = "raw_text"
        case extraComment = "extra_comment"
        case ingredient, id, position
    }
}

struct IngredientDTO: Codable {
    let displayPlural: String
    let id: Int
    let displaySingular: String
    let updatedAt: Int
    let name: String
    let createdAt: Int

    enum CodingKeys: String, CodingKey {
        case displayPlural = "display_plural"
        case id
        case displaySingular = "display_singular"
        case updatedAt = "updated_at"
        case name
        case createdAt = "created_at"
    }
}
*/

struct UserRatingsDTO: Codable {
    let countNegative, countPositive: Int?
    let score: Double?

    enum CodingKeys: String, CodingKey {
        case countNegative = "count_negative"
        case countPositive = "count_positive"
        case score
    }
}
