//
//  PokemonListViewModel.swift
//  Pokemon
//
//  Created by Nitin George on 08/03/2025.
//

import Combine
import Foundation
import Observation
import PokemonNetworking
import PokemonDomain

@MainActor
protocol PokemonListViewModelType: AnyObject, Observable {
    var pokemon: [Pokemon] { get }
    var user: User? { get set }
    var playedPokemon: [Pokemon] { get }
    var otherPokemon: [Pokemon] { get }
    var paginationHandler: PaginationHandlerType { get }
    var pokemonListActionSubject: PassthroughSubject<PokemonListAction, Never> { get  set }
    var state: ResultState { get }
    
    func send(_ action: PokemonListAction)
}

@Observable
class PokemonListViewModel: PokemonListViewModelType {    
    var state: ResultState = .loading
    var user: User?
    var pokemon: [Pokemon] = []
    let service: PokemonServiceProvider
    let userService: PokemonUserServiceType
    var paginationHandler: PaginationHandlerType
    var pokemonListActionSubject = PassthroughSubject<PokemonListAction, Never>()
    
    private var updateTask: Task<Void, Never>?
    
    var playedPokemon: [Pokemon] {
        []
    }
    
    var otherPokemon: [Pokemon] {
        pokemon
    }
    
    init(
        service: PokemonServiceProvider,
        userService: PokemonUserServiceType,
        paginationHandler: PaginationHandlerType
    ) {
        self.service = service
        self.userService = userService
        self.paginationHandler = paginationHandler
        Task { try await fetchPokemonPagination() }
        Task { try await fetchLocalPokemon() }
    }
    
    func send(_ action: PokemonListAction) {
        switch action {
        case .refresh:
            Task { try await currentUser() }
            Task { try await fetchRemotePokemon() }
        case .loadMore:
            guard paginationHandler.hasMoreData else { return }
            Task { try await fetchRemotePokemon() }
        case .selectPokemon(let pokemonID):
            pokemonListActionSubject.send(PokemonListAction.selectPokemon(pokemonID))
        }
    }
    
    private func currentUser() async throws {
        Task {
            do {
                let userDomain = try await userService.getCurrentUser()
                user = User(from: userDomain)
                _ = user?.playedPokemons.map { poke in
                    print("***** user played Pokemon: \(poke))")
                }
                
            } catch {
                print("unable to find user")
            }
        }
    }
    
    private func fetchPokemonPagination() async throws {
        Task {
            do {
                let paginationDomain = try await service.fetchPokemonPagination(.pokemon)
                updatePagination(Pagination(from: paginationDomain))
            } catch {
                print("\(error)")
            }
        }
    }
    
    private func fetchLocalPokemon() async throws {
        Task {
            do {
                let pokemonDomains = try await service.fetchPokemon(
                        offset: 0,
                        pageSize: Constants.Pokemon.fetchLimit
                    )
                
                let storedPokemon = pokemonDomains.map { Pokemon(from: $0) }
                
                if storedPokemon.count > 0 {
                    pokemon = storedPokemon
                    state = .success
                }
            } catch {
                state = .failed(error: error)
            }
        }
    }
    
    private func fetchRemotePokemon() async throws {
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
                
                try await fetchPokemonPagination()
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
    
    private func updatePokemonPlayLaterStatus(pokemonID: Int) {
        //add logic later
    }
}
