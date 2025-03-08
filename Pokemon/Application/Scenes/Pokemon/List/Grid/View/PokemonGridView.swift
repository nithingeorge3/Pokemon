//
//  RecipeGridView.swift
//  Recipes
//
//  Created by Nitin George on 01/03/2025.
//

import SwiftUI

struct PokemonGridView: View {
    var favorites: [Pokemon]
    var others: [Pokemon]
    var hasMoreData: Bool
    var onPokemonTap: (Pokemon) -> Void
    var onReachBottom: () -> Void
    
    @State private var isFavoritesCollapsed: Bool = false
    @State private var isOtherCollapsed: Bool = false
    @State private var showProgress: Bool = false
    
    var body: some View {
        return GeometryReader { geometry in
            let totalWidth = geometry.size.width
            let spacing: CGFloat = Constants.Pokemon.listSpacing
            let minColumnWidth = Constants.Pokemon.listItemSize
            let columns = calculateColumns(totalWidth: totalWidth, spacing: spacing, minColumnWidth: minColumnWidth)
            let coulmnsCount = max(columns.count, 1)
            let padding = Constants.Pokemon.listSpacing * CGFloat(coulmnsCount - 1) / 2.0 + 32.0
            let gridSize = max((totalWidth - padding)/CGFloat(coulmnsCount), Constants.Pokemon.listItemSize)

            ScrollView {
                LazyVGrid(columns: columns) {
                    if !favorites.isEmpty {
                        CollapsibleSection(title: "Favourites", isCollapsed: $isFavoritesCollapsed) {
                            pokemonGrid(for: favorites, size: gridSize)
                        }
                    }

                    if !favorites.isEmpty {
                        CollapsibleSection(title: "Other Pokemon", isCollapsed: $isOtherCollapsed) {
                            pokemonGrid(for: others, size: gridSize)
                        }
                    } else {
                        pokemonGrid(for: others, size: gridSize)
                    }

                    if !others.isEmpty && hasMoreData {
                        ProgressView()
                            .opacity(showProgress ? 1 : 0)
                            .frame(height: 50, alignment: .center)
                            .onAppear {
                                showProgress = !isOtherCollapsed
                                onReachBottom()
                            }
                            .onDisappear {
                                showProgress = false
                            }
                    }
                }
                .padding(.horizontal, 8)
            }
        }
    }
    
    @ViewBuilder
    private func pokemonGrid(for pokemon: [Pokemon], size: CGFloat) -> some View {
        ForEach(pokemon) { pokemon in
            PokemonGridImageView(pokemon: pokemon, width: size, height: size)
                .onTapGesture {
                    onPokemonTap(pokemon)
                }
        }
    }
}

extension PokemonGridView {
    func calculateColumns(totalWidth: CGFloat, spacing: CGFloat, minColumnWidth: CGFloat) -> [GridItem] {
        let availableWidth = totalWidth - spacing * 2
        let columnsCount = max(availableWidth/(minColumnWidth + spacing), 1)
        return Array(repeating: GridItem(.flexible(), spacing: spacing), count: Int(columnsCount))
    }
}
