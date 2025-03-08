//
//  Instruction.swift
//  Recipes
//
//  Created by Nitin George on 02/03/2025.
//

import Foundation
import PokemonDomain

struct Instruction: Identifiable, Hashable {
    let id: Int
    var position: Int
    var description: String?
    var startTime: Int
    var endTime: Int
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    public static func == (lhs: Instruction, rhs: Instruction) -> Bool {
        lhs.id == rhs.id
    }
}
