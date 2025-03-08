//
//  AppTabCoordinator.swift
//  Recipes
//
//  Created by Nitin George on 01/03/2025.
//

import SwiftUI

final class AppTabCoordinator: Coordinator {
    let appTabViewFactory: AppTabViewFactory
        
    init(appTabViewFactory: AppTabViewFactory) {
        self.appTabViewFactory = appTabViewFactory
    }
    
    func start() -> some View {
        appTabViewFactory.makeAppTabView()
    }
}
