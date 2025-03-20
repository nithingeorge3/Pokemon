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
        
        self.service = PokemonServiceFactory.makePokemonService(
            userSDRepo: userSDRepo,
            pokemonSDRepo: pokemonSDRepo,
            paginationSDRepo: paginationSDRepo,
            maxPokemonCount: Constants.Pokemon.maximumPokemonCount
        )
        
        //I need to create a seperate repository for user interaction. so that that we can avoid unwanted injection
        self.userService = PokemonUserServiceFactory.makePokemonUserService(
            userSDRepo: userSDRepo,
            pokemonSDRepo: pokemonSDRepo,
            paginationSDRepo: paginationSDRepo
        )
        
        if ProcessInfo.processInfo.arguments.contains("-ui-testing") {
            let service: PokemonServiceProvider = MockPokemonServiceImp()
            let userService: PokemonUserServiceType = MockPokemonUserServiceImp()
            let remotePagination: RemotePaginationHandlerType = MockRemotePaginationHandler()
            let localPagination: LocalPaginationHandlerType = MockLocalPaginationHandler()
            
            let vm = await modelFactory.makePokemonListViewModel(
                service: service,
                userService: userService,
                remotePagination: remotePagination,
                localPagination: localPagination
            )

            self.viewModel = vm
            
        } else {
            let remotePagination: RemotePaginationHandlerType = RemotePaginationHandler()
            let localPagination: LocalPaginationHandlerType = LocalPaginationHandler()
            
            let vm = await modelFactory.makePokemonListViewModel(
                service: service,
                userService: userService,
                remotePagination: remotePagination,
                localPagination: localPagination
            )

            self.viewModel = vm
        }
        
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
        
        if ProcessInfo.processInfo.arguments.contains("-ui-testing") {
            let service: PokemonServiceProvider = MockPokemonServiceImp()
            let userService: PokemonUserServiceType = MockPokemonUserServiceImp()
            let answerService: PokemonAnswerServiceType = MockPokemonAnswerServiceImp()
            
            let playCoordinator = PokemonPlayCoordinatorFactory().makePokemonPlayCoordinator(pokemonID: pokemonID, service: service, userService: userService, answerService: answerService)
            return playCoordinator.start()
            
        } else {
            let answerService: PokemonAnswerServiceType = PokemonAnswerServiceFactory.makePokemonAnswerService(userSDRepo: userSDRepo, pokemonSDRepo: pokemonSDRepo, paginationSDRepo: paginationSDRepo)
            
            let playCoordinator = PokemonPlayCoordinatorFactory().makePokemonPlayCoordinator(pokemonID: pokemonID, service: service, userService: userService, answerService: answerService)
            return playCoordinator.start()
        }
    }
}
