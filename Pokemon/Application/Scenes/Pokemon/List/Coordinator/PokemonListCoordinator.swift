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
    private let userService: PokemonUserServiceType
    private var cancellables: [AnyCancellable] = []
    
    private var paginationSDRepo: PaginationSDRepositoryType
    private var pokemonSDRepo: PokemonSDRepositoryType
    private var userSDRepo: UserSDRepositoryType
    
    @Published var navigationPath = NavigationPath()
    
    var tabItem: TabItem {
        _tabItem
    }
    
    init(
        tabItem: TabItem,
        viewFactory: PokemonViewFactoryType,
        modelFactory: PokemonViewModelFactoryType,
        userSDRepo: UserSDRepositoryType,
        paginationSDRepo: PaginationSDRepositoryType,
        pokemonSDRepo: PokemonSDRepositoryType
    ) async {
        _tabItem = tabItem
        self.viewFactory = viewFactory
        self.modelFactory = modelFactory
        self.userSDRepo = userSDRepo
        self.paginationSDRepo = paginationSDRepo
        self.pokemonSDRepo = pokemonSDRepo
        
        //I need to create a seperate repository for user interaction. so that that we can avoid unwanted injection
        self.service = PokemonServiceFactory.makePokemonService(userSDRepo: userSDRepo, pokemonSDRepo: pokemonSDRepo, paginationSDRepo: paginationSDRepo)
        
        self.userService = PokemonUserServiceFactory.makePokemonUserService(userSDRepo: userSDRepo, pokemonSDRepo: pokemonSDRepo, paginationSDRepo: paginationSDRepo)
        
        let paginationHandler: PaginationHandlerType = PaginationHandler()
        
        let vm = await modelFactory.makePokemonListViewModel(
            service: service,
            userService: userService,
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
        let answerService: PokemonAnswerServiceType = PokemonAnswerServiceFactory.makePokemonAnswerService(userSDRepo: userSDRepo, pokemonSDRepo: pokemonSDRepo, paginationSDRepo: paginationSDRepo)
        
        let playCoordinator = PokemonPlayCoordinatorFactory().makePokemonPlayCoordinator(pokemonID: pokemonID, service: service, answerService: answerService)
        return playCoordinator.start()
    }
}
