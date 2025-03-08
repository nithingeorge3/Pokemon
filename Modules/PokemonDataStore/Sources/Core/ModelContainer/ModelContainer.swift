//
//  Extension.swift
//  RecipeDataStore
//
//  Created by Nitin George on 02/03/2025.
//

import Foundation
import SwiftData

extension ModelContainer {
    static func buildShared(_ name: String) throws -> ModelContainer {
        let schema = Schema([
            SDRecipe.self,
            SDPagination.self
        ])
        
        let config = ModelConfiguration(
            url: .documentsDirectory.appendingPathComponent("\(name).sqlite"),
            cloudKitDatabase: .none
        )
        
        return try ModelContainer(for: schema, configurations: config)
    }
    
    static func makeInMemoryContext() -> ModelContainer {
        let schema = Schema([
            SDRecipe.self,
            SDPagination.self
        ])
        
        let config = ModelConfiguration(
            isStoredInMemoryOnly: true
        )
        //ToDo: avoid force unwrapping later
        return try! ModelContainer(for: schema, configurations: config)
    }
}
