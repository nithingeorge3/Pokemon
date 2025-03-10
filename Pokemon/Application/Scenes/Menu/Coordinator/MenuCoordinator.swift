//
//  MenuCoordinator.swift
//  Pokemon
//
//  Created by Nitin George on 08/03/2025.
//

import SwiftUI
import PokemonNetworking
import PokemonDomain

final class MenuCoordinator: Coordinator, TabItemProviderType {
    private var menuViewFactory: MenuViewFactoryType
    private let _tabItem: TabItem
    private let userService: PokemonUserServiceType
    private var userSDRepo: UserSDRepositoryType
    private var paginationSDRepo: PaginationSDRepositoryType
    private var pokemonSDRepo: PokemonSDRepositoryType
    
    var tabItem: TabItem {
        _tabItem
    }
    
    //When we use seperate repository for UserInteraction w ecan avoid to inject PaginationSDRepositoryType & PokemonSDRepositoryType
    init(menuViewFactory: MenuViewFactoryType, tabItem: TabItem, userSDRepo: UserSDRepositoryType, paginationSDRepo: PaginationSDRepositoryType, pokemonSDRepo: PokemonSDRepositoryType) {
        self.menuViewFactory = menuViewFactory
        _tabItem = tabItem
        self.userSDRepo = userSDRepo
        self.paginationSDRepo = paginationSDRepo
        self.pokemonSDRepo = pokemonSDRepo
        self.userService = PokemonUserServiceFactory.makePokemonUserService(userSDRepo: userSDRepo, pokemonSDRepo: pokemonSDRepo, paginationSDRepo: paginationSDRepo)
    }
    
    func start() -> some View {
        return menuViewFactory.makeMenuView(userService: userService)
    }
}
