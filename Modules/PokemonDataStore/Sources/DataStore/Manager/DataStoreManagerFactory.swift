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
            return ModelContainer.makeTestContainer()
        } else {
            return ModelContainer.makeContainer(name: name)
        }
    }
}
