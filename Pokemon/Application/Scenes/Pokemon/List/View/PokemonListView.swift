//
//  PokemonListView.swift
//  Pokemon
//
//  Created by Nitin George on 08/03/2025.
//

import SwiftUI
import Combine

struct PokemonListView<ViewModel: PokemonListViewModelType>: View {
    @AppStorage(UserDefaultsKeys.hasCompletedOnboarding) private var hasCompletedOnboarding = false
    @State private var activeSheet: AppSheet?
    
    enum AppSheet: Identifiable {
        case onboarding
        var id: Int { hashValue }
    }
    
    @Bindable var viewModel: ViewModel
    
    private var isEmpty: Bool {
        viewModel.pokemon.isEmpty
    }
    
    var body: some View {
        VStack {
            switch viewModel.state {
                case .loading:
                    ProgressView()
                    .progressViewStyle(.circular)
                    .scaleEffect(1.5)
                case.failed(let error):
                    ErrorView(error: error) {
                        viewModel.send(.refresh)
                    }
                case .success:
                if isEmpty {
                    EmptyStateView(message: "No pokemon found. Please try again later.")
                } else {
                    PokemonGridView(silhouetteMode: $viewModel.silhouetteMode, playedPokemon: viewModel.playedPokemon, otherPokemon: viewModel.otherPokemon, hasMoreData: viewModel.remotePagination.hasMoreData) { pokemon in
                        viewModel.send(.selectPokemon(pokemon.id))
                    } onReachBottom: {
                        viewModel.send(.loadMore)
                    }
                }
            }
        }
        .onAppear {
            checkFirstLaunch()
            viewModel.send(.refresh)
        }
        .sheet(item: $activeSheet) { item in
            switch item {
            case .onboarding:
                OnboardingView(dismissAction: completeOnboarding)
            }
        }
        .withCustomNavigationTitle(title: "Pokemon")
        .withCustomNavigationScore(
            GameScoreView(score: viewModel.user?.score ?? 0, size: 12)
                .accessibilityIdentifier("ScoreLabel")
        )
    }
    
    private func checkFirstLaunch() {
        if !hasCompletedOnboarding {
            activeSheet = .onboarding
        }
    }
    
    private func completeOnboarding() {
        hasCompletedOnboarding = true
        activeSheet = nil
    }
}


// MARK: - Previews
#if DEBUG
#Preview("Loading State") {
    PokemonListView(viewModel: PreviewPokemonListViewModel(state: .loading))
}

#Preview("Success State with Pokemon") {
    PokemonListView(viewModel: PreviewPokemonListViewModel(state: .success))
}

#Preview("Empty State") {
    let vm = PreviewPokemonListViewModel(state: .success)
    vm.pokemon = []
    return PokemonListView(viewModel: vm)
}

#Preview("Error State") {
    PokemonListView(viewModel: PreviewPokemonListViewModel(
        state: .failed(error: NSError(domain: "Error", code: -1))
    ))
}

private class PreviewPokemonListViewModel: PokemonListViewModelType {
    var user: User?
    
    var pokemon: [Pokemon] = [
        Pokemon(id: 1, name: "ivysaur", url: URL(string: "https://pokeapi.co/api/v2/pokemon/2/")!),
        Pokemon(id: 2, name: "venusaur", url: URL(string: "https://pokeapi.co/api/v2/pokemon/2/")!),
        Pokemon(id: 3, name: "charmander", url: URL(string: "https://pokeapi.co/api/v2/pokemon/3/")!)
    ]
    
    var pagination: Pagination? = Pagination(entityType: .pokemon)
    var playedPokemon: [Pokemon] { [] }
    var silhouetteMode = true
    var otherPokemon: [Pokemon] { pokemon }
    var remotePagination: RemotePaginationHandlerType = PreviewRemotePaginationHandler()
    var localPagination: LocalPaginationHandlerType = PreviewLocalPaginationHandler()
    var pokemonListActionSubject = PassthroughSubject<PokemonListAction, Never>()
    var state: ResultState
    
    init(state: ResultState) {
        let id = UUID(uuidString: "11111111-1111-1111-1111-111111111111")!
        let date = Date()
        
        self.state = state
        self.user = User(id: id, name: "test", score: 10, email: "test@test.com", isGuest: true, lastActive: date, preference: Preference(id: id, showWinAnimation: false, enableSilhouetteMode: true, lastUpdated: date))
    }
    
    func send(_ action: PokemonListAction) {
    }
    
    func isPlayed(pokemonID: Int) -> Bool {
        false
    }
}

private class PreviewRemotePaginationHandler: RemotePaginationHandlerType {
    var currentPage: Int = 1
    var totalItems: Int = 10
    var hasMoreData: Bool = true
    var isLoading: Bool = false
    var lastUpdated: Date = Date()
    
    func reset() {
        currentPage = 0
        totalItems = 0
        isLoading = false
        lastUpdated = Date()
    }
    
    func validateLoadMore(index: Int) -> Bool {
        false
    }
    
    func updateFromDomain(_ pagination: Pagination) {
        totalItems = pagination.totalCount
        currentPage = pagination.currentPage
        lastUpdated = pagination.lastUpdated
    }
}

private class PreviewLocalPaginationHandler: LocalPaginationHandlerType {
    var currentOffset: Int = 0
    var pageSize: Int = 0
    var totalItems: Int = 10
    var isLoading: Bool = false
    var lastUpdated: Date = Date()

    var hasMoreData: Bool = false
    
    func reset() {
    }
    
    func incrementOffset() {
        currentOffset += pageSize
    }
    
    func updateTotalItems(_ newValue: Int) {
        totalItems = newValue
    }
}

#endif
