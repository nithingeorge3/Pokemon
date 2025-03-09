//
//  PokemonGridImageView.swift
//  Pokemon
//
//  Created by Nitin George on 08/03/2025.
//

import SwiftUI

struct PokemonGridImageView: View {
    let pokemon: Pokemon
    let width: CGFloat
    let height: CGFloat

    var body: some View {
        VStack {
            PokemonImageView(pokemonID: pokemon.id, width: width, height: height)
                    .cornerRadius(10)

            Text(pokemon.name)
                .font(.system(size: 14, weight: .semibold))
                .multilineTextAlignment(.center)
                .lineLimit(1)
        }
    }
}
