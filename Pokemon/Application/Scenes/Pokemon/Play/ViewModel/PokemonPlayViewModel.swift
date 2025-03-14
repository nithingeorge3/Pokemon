//
//  PokemonPlayViewModel.swift
//  Pokemon
//
//  Created by Nitin George on 08/03/2025.
//

import Foundation
import PokemonNetworking
import Observation
import PokemonDataStore

private struct Scoring {
    static let basePoints: Int = 2
    static let maxPoints: Int = 10
    static let maxTime: Double = 30
    
    //Returns ratio of time remaining
    static func timeRatio(elapsed: Double) -> Double {
        guard maxTime > 0 else { return 0 }
        let normalized = min(max(elapsed / maxTime, 0), 1)
        return 1 - normalized
    }
}

@MainActor
protocol PokemonPlayViewModelType: AnyObject, Observable {
    var pokemon: Pokemon? { get set }
    var answerOptions: [Pokemon] { get set }
    var selectedAnswer: Pokemon? { get set }
    var showResult: Bool { get set }
    var isLoading: Bool { get set }
    var errorMessage: String? { get set }
    
    var currentScore: Int { get }
    var matchScore: Int { get }
    var showCelebration: Bool { get }
    var silhouetteMode: Bool { get }

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
    var errorMessage: String? = nil
    
    private var user: User?

    var currentScore: Int {
        user?.score ?? 0
    }
    
    var matchScore = Scoring.basePoints
    
    var showCelebration = false
    var silhouetteMode: Bool  = true
    
    private var pokemonID: Pokemon.ID
    private let service: PokemonSDServiceType
    private let userService: PokemonUserServiceType
    private let answerService: PokemonAnswerServiceType
    
    private var questionStartTime: Date?
    
    init(pokemonID: Pokemon.ID,
         service: PokemonSDServiceType,
         userService: PokemonUserServiceType,
         answerService: PokemonAnswerServiceType)
    {
        self.pokemonID = pokemonID
        self.service = service
        self.userService = userService
        self.answerService = answerService
    }
    
    func send(_ action: PokemonPlayActions) {
        switch action {
        case .load:
            Task { await fetchUserInfo() }
            Task { await loadPokemon() }
        case .selectAnswer(let pokemon):
            Task { try await handleSelection(pokemon) }
        case .refresh:
            Task { await refreshGame() }
        case .playlater:
            playlater()
        }
    }
    
    private func fetchUserInfo() async {
        Task {
            do {
                let userDomain = try await userService.getCurrentUser()
                user = User(from: userDomain)
                silhouetteMode = user?.preference.enableSilhouetteMode ?? true
            } catch {
                print("unable to find user")
            }
        }
    }
    
    private func loadPokemon() async {
        isLoading = true
        questionStartTime = Date()
        Task {
            do {
                async let current = service.fetchPokemon(for: pokemonID)
                async let options = answerService.fetchRandomOptions(excluding: pokemonID, count: 3)
                
                let (main, others) = await (try current, try options)
                let allOptions = [main] + others
                
                pokemon = Pokemon(from: main)
                                
                answerOptions = allOptions
                    .map { Pokemon(from: $0) }
                    .shuffled()
                
                self.isLoading = false
                
            } catch {
                print("Error laoding game: \(error)")
                self.isLoading = false
            }
        }
    }
    
    private func refreshGame() async {
        isLoading = true
        let previousPokemonID = pokemonID
        resetGame()
        
        Task {
            do {
                let newPokemon = try await service.fetchRandomUnplayedPokemon(excluding: previousPokemonID)
                let options = try await answerService.fetchRandomOptions(
                    excluding: newPokemon.id,
                    count: 3
                )

                let allOptions = [newPokemon] + options
                                
                pokemon = Pokemon(from: newPokemon)
                pokemonID = newPokemon.id
                                
                self.answerOptions = allOptions
                    .map { Pokemon(from: $0) }
                    .shuffled()
                
                isLoading = false
                
            } catch let error as SDError {
                handle(error)
            } catch {
                print("Error refreshing game: \(error)")
                isLoading = false
            }
        }
    }
    
    private func handleSelection(_ pokemon: Pokemon) async throws {
        guard !showResult else { return }
        selectedAnswer = pokemon
        showResult = true
        
        if pokemon.id == self.pokemon?.id {
            do {
                matchScore = calculateScore()
                
                showCelebration = user?.preference.showWinAnimation ?? false
                
                try await answerService.updateScore(matchScore)
                try await answerService.updatePlayedStatus(pokemonId: pokemon.id, outcome: .win)
                
                Task { await fetchUserInfo() }
            } catch {
                print("failed to update user score: \(error)")
            }

            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self.showCelebration = false
            }
        }
    }
    
    private func resetGame() {
        questionStartTime = Date()
        showResult = false
        selectedAnswer = nil
    }
    
    private func playlater() {
        //add logic later
    }
    
    private func handle(_ error: SDError) {
        isLoading = false
        switch error {
        case .noUnplayedPokemon:
            errorMessage = "No unplayed Pokemon found. Try again later."
        default:
            errorMessage = "An error occurred. Please try again. \(error)"
        }
    }
}

extension PokemonPlayViewModel {
    private func calculateScore() -> Int {
        guard let startTime = questionStartTime else { return Scoring.basePoints }
        
        let elapsedTime = abs(startTime.timeIntervalSinceNow)
        //calculate time ratio (0...1 where 1 = answered instantly)
        let ratio = Scoring.timeRatio(elapsed: elapsedTime)
        
        //convert to even integer score within base/max bounds
        let rawScore = Double(Scoring.maxPoints) * ratio
        let rounded = Int(rawScore.rounded(.toNearestOrEven))
        
        let evenScore = rounded.isMultiple(of: 2) ? rounded : rounded - 1
        return max(Scoring.basePoints, min(Scoring.maxPoints, evenScore))
    }
}
