//
//  PokemonListView.swift
//  Pokemon
//
//  Created by Nitin George on 08/03/2025.
//

import SwiftUI
import Combine

struct PokemonListView<ViewModel: PokemonListViewModelType>: View {
    @Bindable var viewModel: ViewModel
    @State private var score: Int = 10
    
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
                    EmptyView()
                    PokemonGridView(favorites: viewModel.favoritePokemon, others: viewModel.otherPokemon, hasMoreData: viewModel.paginationHandler.hasMoreData) { pokemon in
                        viewModel.send(.selectPokemon(pokemon.id))
                    } onReachBottom: {
                        viewModel.send(.loadMore)
                    }
                }
            }
        }.onAppear {
            viewModel.send(.refresh)
        }
        .withCustomNavigationTitle(title: "Pokemon")
        .withCustomNavigationScore(GameScoreView(score: viewModel.user?.score ?? 0, size: 12))
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
        Pokemon(id: 1, name: "ivysaur", url: URL(string: "https://pokeapi.co/api/v2/pokemon/2/")!, isFavorite: false),
        Pokemon(id: 2, name: "venusaur", url: URL(string: "https://pokeapi.co/api/v2/pokemon/2/")!, isFavorite: true),
        Pokemon(id: 3, name: "charmander", url: URL(string: "https://pokeapi.co/api/v2/pokemon/3/")!, isFavorite: false)
    ]
    
    var pagination: Pagination? = Pagination(entityType: .pokemon)
    var favoritePokemon: [Pokemon] { pokemon.filter { $0.isFavorite } }
    var otherPokemon: [Pokemon] { pokemon.filter { !$0.isFavorite } }
    var paginationHandler: PaginationHandlerType = PreviewPaginationHandler()
    var pokemonListActionSubject = PassthroughSubject<PokemonListAction, Never>()
    var state: ResultState
    
    init(state: ResultState) {
        self.state = state
        self.user = User(id: UUID(uuidString: "11111111-1111-1111-1111-111111111111")!, name: "test", score: 10, email: "test@test.com", isGuest: true, lastActive: Date())
    }
    
    func send(_ action: PokemonListAction) {
    }
}

private class PreviewPaginationHandler: PaginationHandlerType {
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
#endif
