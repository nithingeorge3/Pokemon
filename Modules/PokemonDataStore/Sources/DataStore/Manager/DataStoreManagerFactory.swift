//
//  DataStoreManagerFactory.swift
//  RecipeDataStore
//
//  Created by Nitin George on 02/03/2025.
//

import Foundation
import SwiftData

public enum DataStoreManagerFactory {
    static var isTesting: Bool {
        ProcessInfo.processInfo.environment["XCTestConfigurationFilePath"] != nil
    }
    
    public static func makeSharedContainer(for name: String) -> ModelContainer {
        if isTesting {
            return makeTestContainer()
        } else {
            return makeContainer(name: name)
        }
    }
    
    private static func makeContainer(name: String) -> ModelContainer {
        do {
            let schema = Schema([
                SDRecipe.self,
                SDPagination.self
            ])
            
            let config = ModelConfiguration(
                url: .documentsDirectory.appendingPathComponent("\(name).sqlite"),
                cloudKitDatabase: .none
            )
            
            return try ModelContainer(for: schema, configurations: config)
        } catch {
            fatalError("Failed to create prod container: \(error)")
        }
    }
    
    private static func makeTestContainer() -> ModelContainer {
        let schema = Schema([
            SDRecipe.self,
            SDPagination.self
        ])
        
        let config = ModelConfiguration(
            isStoredInMemoryOnly: true,
            allowsSave: true
        )
        
        do {
            return try ModelContainer(for: schema, configurations: config)
        } catch {
            fatalError("Failed to create test container: \(error)")
        }
    }
}
