//
//  RecipeImageView.swift
//  Recipes
//
//  Created by Nitin George on 02/03/2025.
//

import SwiftUI
import Kingfisher

//ToDo: need to revisit
struct RecipeImageView: View {
    let imageURL: URL
    let height: CGFloat
    var kingfisherManager: KingfisherManager = .shared
    
    @State private var retryAttempts = 0
    @State private var maxRetryAttempts = 3
    @State private var isLoadingSuccessful = false
    @State private var currentImageURL: URL

    init(imageURL: URL,
         height: CGFloat,
         kingfisherManager: KingfisherManager = .shared)
    {
        self.imageURL = imageURL
        self.height = height
        self.kingfisherManager = kingfisherManager
        _currentImageURL = State(initialValue: imageURL)
    }

    var body: some View {
        KFImage(currentImageURL)
            .placeholder {
                ProgressView("Loading...")
            }
            .onSuccess { result in
                isLoadingSuccessful = true
            }
            .onFailure { _ in
                if retryAttempts < maxRetryAttempts {
                    retryAttempts += 1
                    reloadImage()
                }
            }
            .resizable()
            .scaledToFill()
            .frame(width: height ,height: height)
    }

    private func reloadImage() {
        kingfisherManager.cache.removeImage(forKey: imageURL.absoluteString)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            currentImageURL = imageURL
        }
    }
}

