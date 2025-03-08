//
//  Country.swift
//  RecipeNetworking
//
//  Created by Nitin George on 04/03/2025.
//

import Foundation
import PokemonDomain

extension Country {
    init(from dto: CountryDTO) {
        self = Country(rawValue: dto.rawValue) ?? .unknown
    }
}
