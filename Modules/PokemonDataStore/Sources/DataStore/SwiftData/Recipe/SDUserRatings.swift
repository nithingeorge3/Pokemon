//
//  SDUserRatings.swift
//  RecipeDataStore
//
//  Created by Nitin George on 02/03/2025.
//

import Foundation
import SwiftData
import PokemonDomain

@Model
public class SDUserRatings {
    @Attribute(.unique) public var id: Int?
    public var countNegative: Int?
    public var countPositive: Int?
    public var score: Double?
    public var recipe: SDRecipe?
    
    init(
        id: Int?,
        countNegative: Int? = nil,
        countPositive: Int? = nil,
        score: Double? = nil,
        recipe: SDRecipe? = nil
    ) {
        self.id = id
        self.countNegative = countNegative
        self.countPositive = countPositive
        self.score = score
        self.recipe = recipe
    }
}

extension SDUserRatings {
    convenience init(from ratings: UserRatingsDomain?) {
        self.init(
            id: ratings?.id,
            countNegative: ratings?.countNegative,
            countPositive: ratings?.countPositive,
            score: ratings?.score
        )
    }
}
