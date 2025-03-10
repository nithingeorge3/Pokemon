//
//  SwiftUI+Snapshot
//  Pokemon
//
//  Created by Nitin George on 08/03/2025.
//

import SwiftUI
import UIKit

extension SwiftUI.View {
    func toVC() -> UIViewController {
        UIHostingController(rootView: self)
    }
}

