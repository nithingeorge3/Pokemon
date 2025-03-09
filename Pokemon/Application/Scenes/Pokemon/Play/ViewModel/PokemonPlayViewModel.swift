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
    var answerOptions: [Pokemon] { get set }
    var selectedAnswer: Pokemon? { get set }
    var showResult: Bool { get set }
    var isLoading: Bool { get set }
    var showCelebration: Bool { get }
    
    func send(_ action: PokemonPlayActions)
}

@MainActor
@Observable
final class PokemonPlayViewModel: PokemonPlayViewModelType {
    var pokemon: Pokemon?
    var answerOptions: [Pokemon] = []
    var selectedAnswer: Pokemon?
    var showResult: Bool = false
    var isLoading: Bool = false
    var showCelebration: Bool = false
    
    private var pokemonID: Pokemon.ID
    private let service: PokemonSDServiceType
    private let answerService: PokemonAnswerServiceType
    
    init(pokemonID: Pokemon.ID,
         service: PokemonSDServiceType,
         answerService: PokemonAnswerServiceType) {
        self.pokemonID = pokemonID
        self.service = service
        self.answerService = answerService
    }
    
    func send(_ action: PokemonPlayActions) {
        switch action {
        case .load:
            loadPokemon()
        case .selectAnswer(let pokemon):
            handleSelection(pokemon)
        case .refresh:
            refreshGame()
        case .toggleFavorite:
            toggleFavorite()
        }
    }
    
    private func loadPokemon() {
        isLoading = true
        Task {
            do {
                async let current = service.fetchPokemon(for: pokemonID)
                async let options = answerService.fetchRandomOptions(excluding: pokemonID, count: 3)
                
                let (main, others) = await (try current, try options)
                let allOptions = [main] + others
                
                self.pokemon = Pokemon(from: main)
                self.answerOptions = allOptions.map {
                    Pokemon(from: $0)
                }.shuffled()
                
                for pok in answerOptions {
                    print("**** \(pok.name)")
                }
                
                self.isLoading = false
                
            } catch {
                print("error")
            }
        }
    }
    
    private func refreshGame() {
        isLoading = true
        Task {
            do {
                async let newPokemon = service.fetchRandomUnplayedPokemon()
                async let options = answerService.fetchRandomOptions(excluding: pokemonID, count: 3)
                
                let (main, others) = await (try newPokemon, try options)
                let allOptions = [main] + others
                
                self.pokemon = Pokemon(from: main)

                guard let id = self.pokemon?.id else {
                    return
                }
                pokemonID = id
                
                self.answerOptions = allOptions.map {
                    Pokemon(from: $0)
                }.shuffled()
                
                for pok in answerOptions {
                    print("**** \(pok.name)")
                }
                
                self.isLoading = false
                
            } catch {
                print("error")
            }
        }
    }
    
    
    private func handleSelection(_ pokemon: Pokemon) {
        guard !showResult else { return }
        selectedAnswer = pokemon
        showResult = true
        
        if pokemon.id == self.pokemon?.id {
            showCelebration = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self.showCelebration = false
            }
        }
    }
    
    private func reloadGame() {
        showResult = false
        selectedAnswer = nil
        loadPokemon()
    }
    
    private func toggleFavorite() {
        guard var pokemon = pokemon else { return }
        pokemon.isFavorite.toggle()
        Task {
            do {
                self.pokemon?.isFavorite = try await service.updateFavouritePokemon(pokemon.id)
            } catch {
                print("Favorite update failed: \(error)")
            }
        }
    }
}
//
//@Observable
//class PokemonPlayViewModel_: PokemonPlayViewModelType {
//    var pokemon: Pokemon?
//    private let pokemonID: Pokemon.ID
//    private let service: PokemonSDServiceType
//    private let answerService: PokemonAnswerServiceType
//    
//    init(pokemonID: Pokemon.ID, service: PokemonSDServiceType, answerService: PokemonAnswerServiceType) {
//        self.service = service
//        self.answerService = answerService
//        self.pokemonID = pokemonID
//        Task { await fetchPokemon() }
//    }
//    
//    func send(_ action: PokemonPlayActions) {
//        switch action {
//        case .toggleFavorite:
//            pokemon?.isFavorite.toggle()
//            Task {
//                do {
//                    pokemon?.isFavorite = try await service.updateFavouritePokemon(pokemonID)
//                } catch {
//                    print("failed to upadte SwiftData: errro \(error)")
//                }
//            }
//        case .load:
//            Task { await fetchPokemon() }
//        default: break
//        }
//    }
//    
//    private func fetchPokemon() async {
//        do {
//            let pokemonDomain = try await service.fetchPokemon(for: pokemonID)
//            self.pokemon = Pokemon(from: pokemonDomain)
//        } catch {
//            print("Error: \(error)")
//        }
//    }
//}
