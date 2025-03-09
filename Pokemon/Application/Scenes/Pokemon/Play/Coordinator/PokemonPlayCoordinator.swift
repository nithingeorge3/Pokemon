//
//  PokemonPlayCoordinator.swift
//  Pokemon
//
//  Created by Nitin George on 08/03/2025.
//

import SwiftUI
import PokemonNetworking
import PokemonDataStore
import SwiftData
import PokemonDomain

enum PokemonPlayActions {
    case load
    case selectAnswer(Pokemon)
    case refresh
    case toggleFavorite
}


final class PokemonPlayCoordinator: Coordinator {
    private let viewModelFactory: PokemonPlayViewModelFactoryType
    private let viewFactory: PokemonPlayViewFactoryType
    private var viewModel: PokemonPlayViewModel
    private let pokemonID: Pokemon.ID
    private let service: PokemonSDServiceType
    
    init(
        viewModelFactory: PokemonPlayViewModelFactoryType,
        viewFactory: PokemonPlayViewFactoryType,
        pokemonID: Pokemon.ID,
        service: PokemonSDServiceType,
        answerService: PokemonAnswerServiceType
    ) {
        self.viewModelFactory = viewModelFactory
        self.viewFactory = viewFactory
        self.pokemonID = pokemonID
        self.service = service
        self.viewModel = viewModelFactory.makePokemonPlayViewModel(pokemonID: pokemonID, service: service, answerService: answerService)
    }
    
    func start() -> some View {
        viewFactory.makePokemonPlayView(viewModel: viewModel)
    }
}
