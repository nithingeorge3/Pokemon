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

struct PokemonPlayView<ViewModel: PokemonPlayViewModelType>: View {
    @Bindable var viewModel: ViewModel
    @State private var selectedIndex: Int = 0
   
    var body: some View {
        Group {
            if let recipe = viewModel.recipe {
                content(for: recipe)
            } else {
                ProgressView()
                    .progressViewStyle(.circular)
                    .scaleEffect(1.5)
            }
        }
        .onAppear {
            viewModel.send(.load)
        }
        .withCustomBackButton()
        .withCustomNavigationTitle(title: viewModel.recipe?.name ?? "Recipe Details")
    }
    
    @ViewBuilder
    private func content(for recipe: Recipe) -> some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                RecipeImageCarousel(
                    mediaItems: viewModel.mediaItems,
                    selectedIndex: $selectedIndex
                )
                .frame(height: 400)
                .padding(.bottom, 4)
                
                nameCountrySection(for: recipe)
                detailSection(for: recipe)
            }
        }
    }
    
    @ViewBuilder
    private func nameCountrySection(for recipe: Recipe) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack(alignment: .top) {
                Text(recipe.name)
                    .font(.largeTitle.weight(.bold))
                    .foregroundColor(.primary)
                
                Spacer()
                
                VStack(alignment: .center) {
                    Spacer().frame(height: 10.0)
                    Button(action: {
                        viewModel.send(.toggleFavorite)
                    }) {
                        Image(systemName: recipe.isFavorite ? "heart.fill" : "heart")
                            .font(.system(size: 28))
                            .foregroundColor(recipe.isFavorite ? .red : .gray)
                            .symbolEffect(.bounce, value: recipe.isFavorite)
                    }
                    Spacer()
                }
                
                Spacer().frame(width: 30)
            }
            
            HStack(spacing: 4) {
                Image(systemName: "mappin.and.ellipse")
                Text(recipe.country.displayName)
            }
            .font(.title3)
            .foregroundColor(.secondary)
        }
        .padding(.horizontal, 8)
    }
    
    @ViewBuilder
    private func detailSection(for recipe: Recipe) -> some View {
        Group {
            SubTitleView(title: "Description")

            DescriptionText(description: recipe.description)
        }
        .padding(.horizontal, 8)
    }
    
    private struct DescriptionText: View {
        let description: String?
        
        var body: some View {
            Group {
                if let description = description, !description.isEmpty {
                    Text(description)
                        .descriptionStyle()
                } else {
                    DescriptionEmptyState()
                }
            }
            .transition(.opacity)
        }
    }
    
    private struct DescriptionEmptyState: View {
        var body: some View {
            HStack(spacing: 8) {
                Image(systemName: "text.bubble")
                    .foregroundColor(.secondary)
                
                Text("Description unavailable")
                    .foregroundColor(.secondary.opacity(0.8))
            }
            .font(.subheadline)
            .accessibilityElement(children: .combine)
        }
    }
}

private extension Text {
    func descriptionStyle() -> some View {
        self
            .font(.body)
            .lineSpacing(6)
            .foregroundColor(.primary.opacity(0.9))
            .fixedSize(horizontal: false, vertical: true)
            .lineLimit(nil)
    }
}

struct SubTitleView: View {
    let title: String
    
    var body: some View {
        Text(title)
            .font(.title2)
            .fontWeight(.semibold)
    }
}

// MARK: - Previews
#if DEBUG
#Preview("Default Detail") {
    PokemonPlayView(viewModel: PreviewPlayViewModel.fullRecipe)
}

#Preview("No Image") {
    PokemonPlayView(viewModel: PreviewPlayViewModel.noImageRecipe)
}

#Preview("No Description") {
    PokemonPlayView(viewModel: PreviewPlayViewModel.noDescriptionRecipe)
}

#Preview("Favorite State") {
    let vm = PreviewPlayViewModel.fullRecipe
    vm.recipe?.isFavorite.toggle()
    return PokemonPlayView(viewModel: vm)
}

// MARK: - Preview ViewModel
public class PreviewPlayViewModel: PokemonPlayViewModelType {
    var recipe: Recipe?
    private let recipeID: Recipe.ID
    private let service: PokemonSDServiceType
    
    var mediaItems: [PresentedMedia] {
        var result: [PresentedMedia] = []
        if let imageURL = recipe?.thumbnailURL.validatedURL {
            result.append(.image(imageURL))
        }
        if let videoURL = recipe?.originalVideoURL.validatedURL {
            result.append(.video(videoURL))
        }
        
        return result
    }
    
    @MainActor
    init(recipe: Recipe) {
        self.recipe = recipe
        self.recipeID = recipe.id
        self.service = MockPreviewService()
    }
    
    @MainActor
    init(recipeID: Recipe.ID, service: PokemonSDServiceType = MockPreviewService()) {
        self.recipeID = recipeID
        self.service = service
    }
    
    func send(_ action: RecipeDetailActions) {
        switch action {
        case .toggleFavorite:
            recipe?.isFavorite.toggle()
            Task { try? await service.updateFavouriteRecipe(recipeID) }
        case .load:
            break
        }
    }
}

extension PreviewPlayViewModel {
    static var fullRecipe: PreviewPlayViewModel {
        PreviewPlayViewModel(
            recipe: Recipe(
                id: 1,
                name: "Indian Chicken Curry",
                description: "Indian Chicken Curry is a rich, flavorful dish made with tender chicken simmered in a spiced tomato and onion gravy. It’s infused with aromatic Indian spices, garlic, ginger, and creamy textures, making it perfect to pair with rice or naan bread.",
                country: .ind,
                thumbnailURL: "https://img.buzzfeed.com/thumbnailer-prod-us-east-1/45b4efeb5d2c4d29970344ae165615ab/FixedFBFinal.jpg",
                originalVideoURL: "https://s3.amazonaws.com/video-api-prod/assets/a0e1b07dc71c4ac6b378f24493ae2d85/FixedFBFinal.mp4",
                isFavorite: false
            )
        )
    }
    
    static var noImageRecipe: PreviewPlayViewModel {
        PreviewPlayViewModel(recipe: Recipe(
            id: 2,
            name: "Kerala Chicken Biriyani (CB)",
            description: "A flavorful one-pot dish made with fragrant basmati rice, marinated chicken, and aromatic Kerala spices, layered and cooked to perfection. Side dish: Fresh yummy salad",
            country: .ind,
            thumbnailURL: nil
        ))
    }
    
    static var noDescriptionRecipe: PreviewPlayViewModel {
        PreviewPlayViewModel(recipe: Recipe(
            id: 3,
            name: "Kerala Chicken Curry",
            description: "",
            country: .ind,
            thumbnailURL: "https://img.buzzfeed.com/thumbnailer-prod-us-east-1/45b4efeb5d2c4d29970344ae165615ab/FixedFBFinal.jpg"
        ))
    }
}

// MARK: - Mock Service
private class MockPreviewService: PokemonSDServiceType, @unchecked Sendable {
    var favoritesDidChange: AsyncStream<Int> {
        AsyncStream { _ in }
    }
    
    func fetchPokemon(for pokemonID: Int) async throws -> RecipeDomain {
        RecipeDomain(id: 999, name: "Mock Recipe")
    }
    
    func fetchRecipes(page: Int, pageSize: Int) async throws -> [RecipeDomain] {
        []
    }
    
    func fetchRecipePagination(_ type: EntityType) async throws -> PaginationDomain {
        PaginationDomain(entityType: .pokemon, totalCount: 10, currentPage: 10)
    }
    
    func fetchRecipe(id: Recipe.ID) async throws -> Recipe {
        Recipe(id: 999, name: "Mock Recipe")
    }
    
    func updateFavouriteRecipe(_ id: Int) async throws -> Bool {
        true
    }
}
#endif
