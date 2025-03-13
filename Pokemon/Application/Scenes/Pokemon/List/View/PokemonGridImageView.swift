//
//  PokemonGridImageView.swift
//  Pokemon
//
//  Created by Nitin George on 08/03/2025.
//

import SwiftUI

struct PokemonGridImageView: View {
    @Binding var silhouetteMode: Bool
    let pokemon: Pokemon
    let width: CGFloat
    let height: CGFloat

    var body: some View {
        VStack {
            let imageView = PokemonImageView(pokemonID: pokemon.id, width: width, height: height)
                    .cornerRadius(10)

            Group {
                if silhouetteMode {
                    imageView
                        .silhouetteEffect(active: silhouetteMode)
                        .cornerRadius(10)
                } else {
                    imageView
                }
            }
        }
    }
}
