//
//  RecipeImageCarousel.swift
//  Recipes
//
//  Created by Nitin George on 01/03/2025.
//

import SwiftUI
import Kingfisher

struct RecipeImageCarousel: View {
    let mediaItems: [PresentedMedia]
    @Binding var selectedIndex: Int
    @State private var presentedMedia: PresentedMedia?
    
    private enum CarouselConstants {
        static let cornerRadius: CGFloat = 12
        static let spacing: CGFloat = 12
        static let placeholderIconScale: CGFloat = 0.4
        static let horizontalPadding: CGFloat = 4
    }
    
    var body: some View {
        GeometryReader { geometry in
            Group {
                if mediaItems.isEmpty {
                    placeholderView(size: geometry.size)
                } else {
                    carouselContent(size: geometry.size)
                }
            }
        }
        .sheet(item: $presentedMedia) { media in
            FullScreenMediaView(media: media)
        }
    }
    
    @ViewBuilder
    private func carouselContent(size: CGSize) -> some View {
        ScrollViewReader { proxy in
            ScrollView(.horizontal) {
                LazyHStack(spacing: CarouselConstants.spacing) {
                    ForEach(Array(mediaItems.enumerated()), id: \.element.id) { index, mediaItem in
                        MediaThumbnailView(
                            mediaItem: mediaItem,
                            width: calculatedWidth(for: mediaItems.count, size: size),
                            height: calculatedHeight(size: size)
                        )
                        .id(index)
                        .padding(.leading, index == 0 ? CarouselConstants.horizontalPadding : 0)
                        .onTapGesture { handleMediaSelection(index, mediaItem) }
                    }
                }
                .padding(.trailing, 24)
            }
            .scrollDisabled(mediaItems.count == 1)
            .contentMargins(.leading, CarouselConstants.horizontalPadding)
            .contentMargins(.trailing, 24)
            .scrollTargetBehavior(.paging)
            .onChange(of: selectedIndex) {
                withAnimation { proxy.scrollTo(selectedIndex, anchor: .center) }
            }
        }
    }
    
    private func placeholderView(size: CGSize) -> some View {
        ZStack {
            RoundedRectangle(cornerRadius: CarouselConstants.cornerRadius)
                .fill(Color(.systemGray6))
            
            Image(Constants.Pokemon.placeholderImage)
                .resizable()
                .scaledToFit()
                .frame(
                    width: calculatedWidth(for: 1, size: size) * CarouselConstants.placeholderIconScale,
                    height: calculatedHeight(size: size) * CarouselConstants.placeholderIconScale
                )
                .foregroundColor(.gray.opacity(0.4))
        }
        .frame(
            width: calculatedWidth(for: 1, size: size),
            height: calculatedHeight(size: size)
        )
        .padding(.horizontal, CarouselConstants.horizontalPadding)
        .accessibilityElement(children: .ignore)
    }
    
    // MARK: - Dimension Calculations
    private func calculatedWidth(for itemCount: Int, size: CGSize) -> CGFloat {
        size.width - (itemCount == 1 ? 16 : 44)
    }
    
    private func calculatedHeight(size: CGSize) -> CGFloat {
        size.width - 30
    }
    
    // MARK: - Action Handling
    private func handleMediaSelection(_ index: Int, _ media: PresentedMedia) {
        presentedMedia = media
        selectedIndex = index
        UIImpactFeedbackGenerator(style: .medium).impactOccurred()
    }
}

struct MediaThumbnailView: View {
    let mediaItem: PresentedMedia
    let width: CGFloat
    let height: CGFloat

    var body: some View {
        ZStack {
            Group {
                switch mediaItem {
                case .image(let url):
                    KFImage(url)
                        .resizable()
                        .scaledToFill()
                case .video(_):
                    //I used placeholder image instead video image
                    Image(Constants.Pokemon.placeholderImage)
                        .resizable()
                        .scaledToFill()
                }
            }
            .frame(width: width, height: height)
            .clipped()
            
            if case .video = mediaItem {
                Image(systemName: "play.circle.fill")
                    .resizable()
                    .frame(width: 50, height: 50)
                    .foregroundColor(.black.opacity(0.5))
            }
        }
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .shadow(radius: 4)
    }
}
