//
//  PokemonImageView.swift
//  Recipes
//
//  Created by Nitin George on 02/03/2025.
//

import SwiftUI
import Kingfisher

private enum PokemonImageURLBuilder {
    static func url(forID id: Int) -> URL? {
        URL(string: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/\(id).png")
    }
}

struct PokemonImageView: View {
    let pokemonID: Int
    let width: CGFloat
    let height: CGFloat
    var kingfisherManager: KingfisherManager = .shared
    
    @State private var retryAttempts = 0
    @State private var maxRetryAttempts = 3
    @State private var isLoadingSuccessful = false
//    @State private var currentImageURL: URL

    init(pokemonID: Int,
         width: CGFloat,
         height: CGFloat,
         kingfisherManager: KingfisherManager = .shared)
    {
        self.pokemonID = pokemonID
        self.width = width
        self.height = height
        self.kingfisherManager = kingfisherManager
//        _currentImageURL = State(initialValue: imageURL)
    }

    var body: some View {
        if let url = PokemonImageURLBuilder.url(forID: pokemonID) {
            KFImage(url)
                .placeholder { loadingPlaceholder }
                .onSuccess { _ in isLoadingSuccessful = true }
                .onFailure { _ in handleRetry() }
                .resizable()
                .scaledToFill()
        } else {
            placeholderImage
//            Image(Constants.Pokemon.placeholderImage)
//                .resizable()
//                .scaledToFill()
//                .frame(width: width, height: height)
//                .cornerRadius(10)
        }
    }
    
    private var loadingPlaceholder: some View {
        ProgressView() //handle later
    }
    
    private var placeholderImage: some View {
        Image(Constants.Pokemon.placeholderImage)
            .resizable()
            .scaledToFill()
    }
    
    /// Handles image retry logic
    private func handleRetry() {
        if retryAttempts < maxRetryAttempts {
            retryAttempts += 1
            // reloadImage() // Uncomment if reload functionality is required
        }
    }

//    private func reloadImage() {
//        kingfisherManager.cache.removeImage(forKey: imageURL.absoluteString)
//        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
//            currentImageURL = imageURL
//        }
//    }
}

