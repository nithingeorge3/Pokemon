//
//  AppTabCoordinator.swift
//  Pokemon
//
//  Created by Nitin George on 08/03/2025.
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
