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
    var remotePagination: RemotePaginationHandlerType { get }
    var localPagination: LocalPaginationHandlerType { get }
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
    var remotePagination: RemotePaginationHandlerType
    var localPagination: LocalPaginationHandlerType
    
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
        remotePagination: RemotePaginationHandlerType,
        localPagination: LocalPaginationHandlerType
    ) {
        self.service = service
        self.userService = userService
        self.remotePagination = remotePagination
        self.localPagination = localPagination
        
        Task { try await updateLocalPagination() }
        Task { try await updateRemotePagination() }
    }
    
    func send(_ action: PokemonListAction) {
        switch action {
        case .refresh:
            Task { try await fetchUserInfo() }
            
            if localPagination.hasMoreData {
                Task { try await fetchLocalPokemon() }
            } else if remotePagination.hasMoreData {
                Task { try await fetchRemotePokemon() }
            }
        case .loadMore:
            Task {
                do {
                    if localPagination.hasMoreData {
                        try await fetchLocalPokemon()
                    } else if remotePagination.hasMoreData {
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
    
    private func updateRemotePagination() async throws {
        Task {
            do {
                let paginationDomain = try await service.fetchPokemonPagination(.pokemon)
                remotePagination.updateFromDomain(Pagination(from: paginationDomain))
            } catch {
                print("\(error)")
            }
        }
    }
    
    private func fetchLocalPokemon() async throws {
        Task {
            do {
                //do w eneed thsi code?
                let count = try await service.fetchPokemonCount()
                localPagination.updateTotalItems(count)
                
                let pokemonDomains = try await service.fetchPokemon(
                    offset: localPagination.currentOffset,
                    pageSize: localPagination.pageSize
                    )
                
                let storedPokemon = pokemonDomains.map { Pokemon(from: $0) }
                
                if storedPokemon.count > 0 {
                    pokemon.append(contentsOf: storedPokemon)
                    localPagination.incrementOffset()
                    state = .success
                }
            } catch {
                state = .failed(error: error)
            }
        }
    }
    
    private func updateLocalPagination() async throws {
        let count = try await service.fetchPokemonCount()
        localPagination.updateTotalItems(count)
    }
    
    private func fetchRemotePokemon() async throws {
        guard !remotePagination.isLoading else {
            return
        }
        
        remotePagination.isLoading = true
        
        Task {
            do {
                let pokemonDomains = try await service.fetchPokemon(
                    endPoint: .pokemon(
                        offset: remotePagination.currentPage,
                        limit: Constants.Pokemon.fetchLimit
                    )
                )
                
                let newPokemon = pokemonDomains.map { Pokemon(from: $0) }
                updatePokemon(with: newPokemon)
                
                try await updateRemotePagination()
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
    
    private func updateRemotePagination(_ pagination: Pagination) {
        remotePagination.updateFromDomain(pagination)
    }
    
    func isPlayed(pokemonID: Int) -> Bool {
        playedPokemonIDs.contains(pokemonID)
    }
}
