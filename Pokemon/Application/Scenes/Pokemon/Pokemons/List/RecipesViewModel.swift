
//
//  RecipesViewModel.swift
//  Recipes
//
//  Created by Nitin George on 06/03/2025.
//

import Combine
import Foundation
import Observation
import PokemonNetworking
import PokemonDomain

@MainActor
protocol RecipesViewModelType: AnyObject, Observable {
    var recipes: [Recipe] { get }
    var state: ResultState { get }
    
    func send(_ action: RecipeListAction)
}

//Actually we need only one viewmodel, as i am just showing listing with combine i used seperate viewmodel
@Observable
class RecipesViewModel: RecipesViewModelType {
    var state: ResultState = .loading
    var recipes: [Recipe] = []
    let service: RecipeListServiceType
    var cancellables: Set<AnyCancellable> = []
    
    init(service: RecipeListServiceType) {
        self.service = service
    }
    
    func send(_ action: RecipeListAction) {
        switch action {
        case .refresh:
            Task { try await fetchRemoteRecipes() }
        default: break
        }
    }
    
    private func fetchRemoteRecipes() async throws {
        service.fetchRecipes(endPoint: .recipes(page: 0, limit: 5))//Just hardcoded for listing
            .sink { [weak self] completion in
                guard let self = self else { return }
                switch completion {
                case .finished:
                    self.state = .success
                case .failure(let error):
                    self.state = .failed(error: error)
                }
            }
        receiveValue: { [weak self] response in
            self?.recipes.removeAll()
            self?.recipes = response.map { Recipe(from: $0) }
        }
        .store(in: &cancellables)
    }
    
    private func updateRecipes(with fetchedRecipes: [Recipe]) {
        if fetchedRecipes.count > 0 {
            recipes.append(contentsOf: fetchedRecipes)
        }
        
        state = .success
    }
}
