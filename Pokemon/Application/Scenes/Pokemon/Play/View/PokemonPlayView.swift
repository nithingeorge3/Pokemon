//
//  PokemonPlayView.swift
//  Pokemon
//
//  Created by Nitin George on 08/03/2025.
//

import SwiftUI
import Kingfisher
import PokemonDomain
import PokemonNetworking

// MARK: - PokemonPlayView
struct PokemonPlayView<ViewModel: PokemonPlayViewModelType>: View {
    // MARK: - Properties
    @Bindable var viewModel: ViewModel
    @State private var rotationAngle: Double = 0
    
    // MARK: - Body
    var body: some View {
        VStack(spacing: 20) {
            if viewModel.isLoading {
                loadingView
            } else {
                gameContentView
            }
        }
        .onAppear(perform: handleOnAppear)
        .withCustomBackButton()
        .withCustomNavigationTitle(title: "Pokemon")
    }
}

// MARK: - View Components
extension PokemonPlayView {
    private var gameContentView: some View {
        Group {
            gameHeaderView
                .padding(.top, 8)
            ZStack {
                imageSection
                celebrationOverlay
            }
            answerGrid
                .padding(.bottom, 40)
        }
    }
    
    private var loadingView: some View {
        ProgressView()
            .progressViewStyle(.circular)
            .scaleEffect(1.5)
    }
    
    private var gameHeaderView: some View {
        HStack(alignment: .top, spacing: 8) {
            GameScoreView(score: viewModel.currentScore)
                .padding(.leading, 10)
            Spacer()
            RefreshButton {
                viewModel.send(.refresh)
            }
            Spacer().frame(width: 30)
        }
    }
    
    private var imageSection: some View {
        VStack {
            if let pokemon = viewModel.pokemon {
                PokemonImageView(
                    pokemonID: pokemon.id,
                    width: 150,
                    height: 150
                )
//                .silhouetteEffect(active: true)
                .blur(radius: viewModel.imageBlurRadius)//if zero will show correct image, no shadow. if 10 with shadow
                .animation(.easeInOut(duration: 0.3), value: viewModel.imageBlurRadius)
                
                //ToDo: this is without silhouetteMode toggle
//              .blur(radius: viewModel.showResult ? 0 : 10)
//              .animation(.easeInOut, value: viewModel.showResult)
            }
        }
    }
    
    private var answerGrid: some View {
        LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2)) {
            ForEach(viewModel.answerOptions) { pokemon in
                AnswerButton(
                    pokemon: pokemon,
                    isSelected: viewModel.selectedAnswer?.id == pokemon.id,
                    showResult: viewModel.showResult,
                    isCorrect: pokemon.id == viewModel.pokemon?.id
                ) {
                    viewModel.send(.selectAnswer(pokemon))
                }
            }
        }
        .padding(.horizontal)
    }
    
    private var celebrationOverlay: some View {
        Group {
            if viewModel.showCelebration {
                CelebrationView(
                    config: .points(
                        Constants.Pokemon.gamePoint,
                        color: .green
                    )
                )
                    .transition(.opacity)
                    .allowsHitTesting(false)
            }
        }
    }
}

// MARK: - Lifecycle & Actions
extension PokemonPlayView {
    private func handleOnAppear() {
        viewModel.send(.load)
    }
}

struct AnswerButton: View {
    let pokemon: Pokemon
    let isSelected: Bool
    let showResult: Bool
    let isCorrect: Bool
    let action: () -> Void
    
    var backgroundColor: Color {
        if showResult {
            return isCorrect ? .green : (isSelected ? .red : .gray)
        }
        return isSelected ? .blue : .gray
    }
    
    var body: some View {
        Button(action: action) {
            Text(pokemon.name.capitalized)
                .font(.headline)
                .padding()
                .frame(maxWidth: .infinity)
                .background(backgroundColor)
                .foregroundColor(.white)
                .cornerRadius(10)
                .scaleEffect(isSelected ? 1.05 : 1)
                .animation(.spring(), value: isSelected)
        }
        .disabled(showResult)
    }
}

// MARK: - Previews
#if DEBUG
#Preview("Initial Loading State") {
    PokemonPlayView(viewModel: PreviewPlayViewModel.loading)
}

#Preview("Game Ready State") {
    PokemonPlayView(viewModel: PreviewPlayViewModel.loaded)
}

#Preview("Silhouette Mode") {
    PokemonPlayView(viewModel: PreviewPlayViewModel.silhouette)
}

#Preview("Celebration Animation") {
    PokemonPlayView(viewModel: PreviewPlayViewModel.celebration)
}

#Preview("Correct Answer Selected") {
    PokemonPlayView(viewModel: PreviewPlayViewModel.correctAnswer)
}

#Preview("Wrong Answer Selected") {
    PokemonPlayView(viewModel: PreviewPlayViewModel.wrongAnswer)
}

// MARK: - Preview ViewModel
private class PreviewPlayViewModel: PokemonPlayViewModelType {
    var pokemon: Pokemon?
    var answerOptions: [Pokemon] = []
    var selectedAnswer: Pokemon?
    var showResult: Bool = false
    var isLoading: Bool = false
    var currentScore: Int = 0
    var showCelebration: Bool = false
    var silhouetteMode: Bool = false
    var imageBlurRadius: CGFloat = 0
    
    static let loading: PreviewPlayViewModel = {
        let vm = PreviewPlayViewModel()
        vm.isLoading = true
        return vm
    }()
    
    static let loaded: PreviewPlayViewModel = {
        let vm = PreviewPlayViewModel()
        vm.pokemon = .charmander
        vm.answerOptions = [.charmander, .squirtle, .bulbasaur, .pikachu]
        vm.currentScore = 1250
        return vm
    }()
    
    static let silhouette: PreviewPlayViewModel = {
        let vm = loaded
        vm.silhouetteMode = true
        vm.imageBlurRadius = 10
        return vm
    }()
    
    static let celebration: PreviewPlayViewModel = {
        let vm = loaded
        vm.showCelebration = true
        return vm
    }()
    
    static let correctAnswer: PreviewPlayViewModel = {
        let vm = loaded
        vm.selectedAnswer = .charmander
        vm.showResult = true
        return vm
    }()
    
    static let wrongAnswer: PreviewPlayViewModel = {
        let vm = loaded
        vm.selectedAnswer = .squirtle
        vm.showResult = true
        return vm
    }()
    
    // Protocol stubs
    func send(_ action: PokemonPlayActions) {}
}

// MARK: - Preview Data
extension Pokemon {
    static let charmander = Pokemon(
        id: 4,
        name: "charmander",
        url: URL(string: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/4.png")!,
        isFavorite: false
    )
    
    static let squirtle = Pokemon(
        id: 7,
        name: "squirtle",
        url: URL(string: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/7.png")!,
        isFavorite: false
    )
    
    static let bulbasaur = Pokemon(
        id: 1,
        name: "bulbasaur",
        url: URL(string: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/1.png")!,
        isFavorite: false
    )
    
    static let pikachu = Pokemon(
        id: 25,
        name: "pikachu",
        url: URL(string: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/25.png")!,
        isFavorite: false
    )
}
#endif
