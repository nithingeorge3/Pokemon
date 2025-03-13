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
    var silhouetteMode: Bool { get set }
    
    func send(_ action: PokemonListAction)
    func isPlayed(pokemonID: Int) -> Bool
}

@Observable
class PokemonListViewModel: PokemonListViewModelType {    
    var state: ResultState = .loading
    var user: User?
    var pokemon: [Pokemon] = []
    var silhouetteMode: Bool = true
    
    let service: PokemonServiceProvider
    let userService: PokemonUserServiceType
    var paginationHandler: PaginationHandlerType
    
    var pokemonListActionSubject = PassthroughSubject<PokemonListAction, Never>()
    
    private var playedPokemonIDs: Set<Int> = []
    private var localOffset = 0
    
    var playedPokemon: [Pokemon] {
        pokemon
            .lazy
            .filter { [playedPokemonIDs] in playedPokemonIDs.contains($0.id) }
            .prefix(20)
            .map { $0 }
    }
    
    var otherPokemon: [Pokemon] {
        pokemon.filter { !playedPokemonIDs.contains($0.id) }
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
            Task { try await fetchUserInfo() }
            guard paginationHandler.hasMoreData else { return }
            Task { try await fetchRemotePokemon() }
        case .loadMore:
            Task {
                do {
                    let pokeSDCount = try await service.fetchPokemonCount()
                    
                    //If we still have fewer than 150 in local DB, fetch from local
                    if pokemon.count < pokeSDCount {
                        localOffset += Constants.Pokemon.fetchLimit
                        try await fetchLocalPokemon()
                    }
                    // Otherwise, check the remote pagination
                    else if paginationHandler.hasMoreData {
                        try await fetchRemotePokemon()
                    }
                } catch {
                    print("error: \(error)")
                }
            }
        case .selectPokemon(let pokemonID):
            if isPlayed(pokemonID: pokemonID) { return }
            pokemonListActionSubject.send(PokemonListAction.selectPokemon(pokemonID))
        }
    }
    
    private func fetchUserInfo() async throws {
        Task {
            do {
                let userDomain = try await userService.getCurrentUser()
                user = User(from: userDomain)
                
                silhouetteMode = user?.preference.enableSilhouetteMode ?? true
                
                let playedIDs = userDomain.playedPokemons
                                    .compactMap { $0.pokemon?.id }
                
                playedPokemonIDs = Set(playedIDs)
                
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
                        offset: localOffset,
                        pageSize: Constants.Pokemon.fetchLimit
                    )
                
                let storedPokemon = pokemonDomains.map { Pokemon(from: $0) }
                
                if storedPokemon.count > 0 {
                    pokemon.append(contentsOf: storedPokemon)
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
    
    func isPlayed(pokemonID: Int) -> Bool {
        playedPokemonIDs.contains(pokemonID)
    }
}
