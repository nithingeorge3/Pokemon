//
//  Tag.swift
//  Recipes
//
//  Created by Nitin George on 02/03/2025.
//

import Foundation
import PokemonDomain

struct Tag: Identifiable, Hashable {
    let id: Int
    var name: String
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    public static func == (lhs: Tag, rhs: Tag) -> Bool {
        lhs.id == rhs.id
    }
    
//    public init(id: String, name: String, cfaURL: String? = nil, vetstreetURL: String? = nil, vcahospitalsURL: String? = nil, temperament: String? = nil, origin: String? = nil, description: String? = nil, lifeSpan: String? = nil, wikipediaURL: String? = nil, hypoallergenic: Int? = nil, referenceImageID: String? = nil, isFavorite: Bool = false
//    ) {
//        (self.weight, self.id, self.name, self.cfaURL, self.vetstreetURL, self.vcahospitalsURL,self.temperament, self.origin, self.description, self.lifeSpan, self.wikipediaURL, self.hypoallergenic,self.referenceImageID, self.isFavorite, self.traitScores, self.image, self.otherImages
//        ) = (id, name, cfaURL, vetstreetURL, vcahospitalsURL, temperament, origin, description, lifeSpan, wikipediaURL, hypoallergenic, referenceImageID, isFavorite
//        )
//    }
}
