//
//  SwiftUI+Snapshot
//  Recipes
//
//  Created by Nitin George on 08/03/2025.
//

// SwiftUI+Snapshot.swift
import SwiftUI
import UIKit

extension SwiftUI.View {
    func toVC() -> UIViewController {
        UIHostingController(rootView: self)
    }
}

