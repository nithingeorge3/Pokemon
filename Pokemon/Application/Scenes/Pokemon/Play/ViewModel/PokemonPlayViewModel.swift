//
//  PokemonPlayViewModel.swift
//  Pokemon
//
//  Created by Nitin George on 08/03/2025.
//

import Foundation
import PokemonNetworking
import Observation

@MainActor
protocol PokemonPlayViewModelType: AnyObject, Observable {
    var pokemon: Pokemon? { get set }
    
    func send(_ action: PokemonPlayActions)
}

@Observable
class PokemonPlayViewModel: PokemonPlayViewModelType {    
    var pokemon: Pokemon?
    private let pokemonID: Pokemon.ID
    private let service: PokemonSDServiceType
    
    init(pokemonID: Pokemon.ID, service: PokemonSDServiceType) {
        self.service = service
        self.pokemonID = pokemonID
        Task { await fetchPokemon() }
    }
    
    func send(_ action: PokemonPlayActions) {
        switch action {
        case .toggleFavorite:
            pokemon?.isFavorite.toggle()
            Task {
                do {
                    pokemon?.isFavorite = try await service.updateFavouritePokemon(pokemonID)
                } catch {
                    print("failed to upadte SwiftData: errro \(error)")
                }
            }
        case .load:
            Task { await fetchPokemon() }
        }
    }
    
    private func fetchPokemon() async {
        do {
            let pokemonDomain = try await service.fetchPokemon(for: pokemonID)
            self.pokemon = Pokemon(from: pokemonDomain)
        } catch {
            print("Error: \(error)")
        }
    }
}
