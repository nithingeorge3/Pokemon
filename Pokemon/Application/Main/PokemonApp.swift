//
//  RecipesApp.swift
//  Pokemon
//
//  Created by Nitin George on 08/03/2025.
//

import SwiftUI
import PokemonDataStore
import SwiftData

@main
struct PokemonApp: App {
    @StateObject private var appCoordinator = AppCoordinator()
    
    var body: some Scene {
        WindowGroup {
            Group {
                switch appCoordinator.state {
                case .loading:
                    ProgressView()
                case .ready(let coordinator):
                    coordinator.start()
                }
            }
            .task {
                await appCoordinator.initialize()
            }
        }
    }
}

@MainActor
class AppCoordinator: ObservableObject {
    enum State {
        case loading
        case ready(AppTabCoordinator)
    }
    
    @Published var state: State = .loading
    
    private let containerName: String
    
    init(containerName: String = "Pokemon") {
        self.containerName = containerName
    }
    
    func initialize() async {
        let container = DataStoreManagerFactory.makeSharedContainer(for: containerName)
        let coordinator = await AppTabCoordinatorFactory().makeAppTabCoordinator(container: container)
        state = .ready(coordinator)
    }
}
