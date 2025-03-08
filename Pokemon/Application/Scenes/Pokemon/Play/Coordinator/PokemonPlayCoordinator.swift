//
//  PokemonPlayCoordinator.swift
//  Recipes
//
//  Created by Nitin George on 01/03/2025.
//

import SwiftUI
import PokemonNetworking
import PokemonDataStore
import SwiftData
import PokemonDomain

enum RecipeDetailActions {
    case toggleFavorite
    case load
}

final class PokemonPlayCoordinator: Coordinator {
    private let viewModelFactory: PokemonPlayViewModelFactoryType
    private let viewFactory: PokemonPlayViewFactoryType
    private var viewModel: PokemonPlayViewModel
    private let recipeID: Recipe.ID
    private let service: RecipeSDServiceType
    
    init(
        viewModelFactory: PokemonPlayViewModelFactoryType,
        viewFactory: PokemonPlayViewFactoryType,
        recipeID: Recipe.ID,
        service: RecipeSDServiceType
    ) {
        self.viewModelFactory = viewModelFactory
        self.viewFactory = viewFactory
        self.recipeID = recipeID
        self.service = service
        self.viewModel = viewModelFactory.makePokemonPlayViewModel(recipeID: recipeID, service: service)
    }
    
    func start() -> some View {
        viewFactory.makePokemonPlayView(viewModel: viewModel)
    }
}
