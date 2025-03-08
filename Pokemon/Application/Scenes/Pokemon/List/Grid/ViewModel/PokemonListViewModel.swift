//
//  RecipeListViewModel.swift
//  Recipes
//
//  Created by Nitin George on 01/03/2025.
//

import Combine
import Foundation
import Observation
import PokemonNetworking
import PokemonDomain

@MainActor
protocol PokemonListViewModelType: AnyObject, Observable {
    var pokemon: [Pokemon] { get }
    var playlaterPokemon: [Pokemon] { get }
    var otherPokemon: [Pokemon] { get }
    var paginationHandler: PaginationHandlerType { get }
    var pokemonListActionSubject: PassthroughSubject<PokemonListAction, Never> { get  set }
    var state: ResultState { get }
    
    func send(_ action: PokemonListAction)
}

@Observable
class PokemonListViewModel: PokemonListViewModelType {    
    var state: ResultState = .loading
    var pokemon: [Pokemon] = []
    let service: PokemonServiceProvider
    var paginationHandler: PaginationHandlerType
    var pokemonListActionSubject = PassthroughSubject<PokemonListAction, Never>()
    
    private var updateTask: Task<Void, Never>?
    
    var playlaterPokemon: [Pokemon] {
        pokemon//.filter { $0.isFavorite }
    }
    
    var otherPokemon: [Pokemon] {
        pokemon//.filter { !$0.isFavorite }
    }
    
    init(
        service: PokemonServiceProvider,
        paginationHandler: PaginationHandlerType
    ) {
        self.service = service
        self.paginationHandler = paginationHandler
//        Task { try await loadMore() }
//        Task { try await fetchLocalPokemon() }
//        listeningFavoritesChanges()
        
        //temp code
        Task { try await fetchRemoteRecipes() }
    }
    
    func send(_ action: PokemonListAction) {
        switch action {
        case .refresh:
            Task { try await fetchRemoteRecipes() }
        case .loadMore:
            guard paginationHandler.hasMoreData else { return }
            Task { try await fetchRemoteRecipes() }
        case .selectPokemon( let recipeID):
            pokemonListActionSubject.send(PokemonListAction.selectPokemon(recipeID))
        }
    }
    
    private func loadMore() async throws {
        Task {
            do {
                let paginationDomain = try await service.fetchRecipePagination(.recipe)
                updatePagination(Pagination(from: paginationDomain))
            } catch {
                print("\(error)")
            }
        }
    }
    
    private func fetchLocalPokemon() async throws {
//        Task {
//            do {
//                let recipeDomains = try await service.fetchRecipes(
//                        page: 0,
//                        pageSize: Constants.Pokemon.fetchLimit
//                    )
//                
//                let storedRecipes = recipeDomains.map { Recipe(from: $0) }
//                
//                if storedRecipes.count > 0 {
//                    recipes = storedRecipes
//                    state = .success
//                }
//            } catch {
//                state = .failed(error: error)
//            }
//        }
    }
    
    private func fetchRemoteRecipes() async throws {
        guard !paginationHandler.isLoading else {
            return
        }
        paginationHandler.isLoading = true
        Task {
            do {
                let pokemonDomains = try await service.fetchPokemon(
                    endPoint: .pokemon(
                        offset: paginationHandler.currentPage,
                        limit: Constants.Pokemon.fetchLimit
                    )
                )
                let newPokemon = pokemonDomains.map { Pokemon(from: $0) }
                updatePokemon(with: newPokemon)
                try await loadMore()
            } catch {
                if pokemon.count == 0 {
                    state = .failed(error: error)
                }
            }
        }
    }
    
    private func updatePokemon(with fetchedPokemon: [Pokemon]) {
        if fetchedPokemon.count > 0 {
            pokemon.append(contentsOf: fetchedPokemon)
        }
        
        state = .success
    }
    
    private func updatePagination(_ pagination: Pagination) {
        paginationHandler.updateFromDomain(pagination)
    }
    
//    private func listeningFavoritesChanges() {
//        updateTask = Task { [weak self] in
//            guard let self = self else { return }
//            for await recipeID in self.service.favoritesDidChange {
//                self.updatePokemonFavoritesStatus(recipeID: recipeID)
//            }
//        }
//    }
    
//    private func updatePokemonFavoritesStatus(recipeID: Int) {
//        guard let index = recipes.firstIndex(where: { $0.id == recipeID }) else { return }
//        if recipes.count > index - 1 {
//            recipes[index].isFavorite.toggle()
//        }
//    }
}
