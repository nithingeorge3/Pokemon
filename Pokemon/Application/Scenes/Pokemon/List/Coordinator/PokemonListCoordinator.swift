//
//  PokemonListCoordinator.swift
//  Pokemon
//
//  Created by Nitin George on 08/03/2025.
//

import Combine
import PokemonNetworking
import PokemonDataStore
import SwiftData
import SwiftUI
import PokemonDomain

enum PokemonListAction: Hashable {
    case refresh
    case loadMore
    case selectPokemon(Pokemon.ID)
}

@MainActor
final class PokemonListCoordinator: ObservableObject, Coordinator, TabItemProviderType {
    let viewFactory: PokemonViewFactoryType
    private let modelFactory: PokemonViewModelFactoryType
    var viewModel: PokemonListViewModel
    private let _tabItem: TabItem
    private let service: PokemonServiceProvider
    private var cancellables: [AnyCancellable] = []
    
    @Published var navigationPath = NavigationPath()
    
    var tabItem: TabItem {
        _tabItem
    }
    
    init(
        tabItem: TabItem,
        viewFactory: PokemonViewFactoryType,
        modelFactory: PokemonViewModelFactoryType,
        paginationSDRepo: PaginationSDRepositoryType,
        pokemonSDRepo: PokemonSDRepositoryType
    ) async {
        _tabItem = tabItem
        self.viewFactory = viewFactory
        self.modelFactory = modelFactory
        self.service = PokemonServiceFactory.makePokemonService(pokemonSDRepo: pokemonSDRepo, paginationSDRepo: paginationSDRepo)
        
        let paginationHandler: PaginationHandlerType = PaginationHandler()
        
        let vm = await modelFactory.makePokemonListViewModel(
            service: service,
            paginationHandler: paginationHandler
        )

        self.viewModel = vm
        addSubscriptions()
    }
    
    func start() -> some View {
        PokemonListCoordinatorView(coordinator: self)
    }
    
    func addSubscriptions() {
        viewModel.pokemonListActionSubject
            .sink { [weak self] action in
                guard let self = self else { return }
                switch action {
                case .selectPokemon(let pokemonID):
                    self.navigationPath.append(PokemonListAction.selectPokemon(pokemonID))
                default:
                    break
                }
            }
            .store(in: &cancellables)
    }
}

extension PokemonListCoordinator {
    func navigateToPokemonPlay(for pokemonID: Pokemon.ID) -> some View {
        let playCoordinator = PokemonPlayCoordinatorFactory().makePokemonPlayCoordinator(pokemonID: pokemonID, service: service)
        return playCoordinator.start()
    }
}
