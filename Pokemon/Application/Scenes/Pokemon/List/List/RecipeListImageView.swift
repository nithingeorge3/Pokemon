//
//  PokemonListImageView.swift
//  Pokemon
//
//  Created by Nitin George on 08/03/2025.
//

/*
import SwiftUI

//just added for listing with combine.
struct RecipeListImageView: View {
    let recipe: Recipe
    let gridSize: CGFloat
    
    var body: some View {
        HStack(alignment: .top, spacing: 16) {
            Group {
                if let url = recipe.thumbnailURL.validatedURL {
                    RecipeImageView(imageURL: url, height: gridSize)
                        .cornerRadius(10)
                } else {
                    Image(Constants.Pokemon.placeholderImage)
                        .resizable()
                        .scaledToFill()
                        .frame(width: gridSize, height: gridSize)
                        .cornerRadius(10)
                }
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(recipe.name)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.primary)
                    .lineSpacing(4)
                    .multilineTextAlignment(.leading)
                    .fixedSize(horizontal: false, vertical: true)
                
                if let description = recipe.description?.trimmingCharacters(in: .whitespacesAndNewlines), !description.isEmpty {
                    Text(description)
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .lineLimit(6)
                        .padding(.top, 4)
                }

            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding(.vertical, 2)
    }
}

*/
