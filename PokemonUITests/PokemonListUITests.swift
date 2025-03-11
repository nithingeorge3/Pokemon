//
//  PokemonListUITests.swift
//  PokemonUITests
//
//  Created by Nitin George on 10/03/2025.
//

import XCTest
import Foundation
import SwiftUI

@testable import Pokemon

final class PokemonListUITests: XCTestCase {
    let app = XCUIApplication()
    
    override func setUpWithError() throws {
        continueAfterFailure = false
        app.launchArguments = ["-ui-testing"]
        app.launch()
    }

}

extension XCUIElement {
    var isBlurred: Bool {
        return self.otherElements["BlurOverlay"].exists
    }
}
