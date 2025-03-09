//
//  PokemonView.swift
//  Pokemon
//
//  Created by Nitin George on 08/03/2025.
//

/*
import SwiftUI

//Actually we need only one viewmodel, as i am just showing listing with combine i used seperate viewmodel
struct RecipesView<ViewModel: RecipesViewModelType>: View {
    @Bindable var viewModel: ViewModel
   
    private var isEmpty: Bool {
        viewModel.recipes.isEmpty
    }
    
    var body: some View {
        Group {
            switch viewModel.state {
            case .loading:
                ProgressView()
                    .progressViewStyle(.circular)
                    .scaleEffect(1.5)
            case .failed(let error):
                ErrorView(error: error) {
                    viewModel.send(.refresh)
                }
            case .success:
                if isEmpty {
                    EmptyStateView(message: "No recipes found. Please try again later.")
                } else {
                    List {
                        ForEach(viewModel.recipes) { recipes in
                            Button(action: {
                                print("list tapped")
                            }) {
                                RecipeListImageView(recipe: recipes, gridSize: 150)
                                    .padding(.horizontal, 8)
                            }
                        }
                    }
                    .listStyle(.plain)
                }
            }
        }
        .onAppear {
            viewModel.send(.refresh)
        }
        .withCustomBackButton()
        .withCustomNavigationTitle(title: "Recipes List")
    }
}


// MARK: - Previews
#if DEBUG
#Preview("Loading State") {
    RecipesView(viewModel: PreviewRecipesViewModel(state: .loading))
}

#Preview("Success State with Recipes") {
    RecipesView(viewModel: PreviewRecipesViewModel(state: .success))
}

#Preview("Empty State") {
    let vm = PreviewRecipesViewModel(state: .success)
    vm.recipes = []
    return RecipesView(viewModel: vm)
}

#Preview("Error State") {
    RecipesView(viewModel: PreviewRecipesViewModel(
        state: .failed(error: NSError(domain: "Error", code: -1))
    ))
}

private class PreviewRecipesViewModel: RecipesViewModelType {
    var recipes: [Recipe] = [
        Recipe(id: 1, name: "Kerala Chicken", description: "Whether you’re trying to be healthy, pulling an all-nighter, or just trying to get through the day, protein-packed snacks are your best friends", thumbnailURL: "https://img.buzzfeed.com/thumbnailer-prod-us-east-1/45b4efeb5d2c4d29970344ae165615ab/FixedFBFinal.jpg" ,isFavorite: true),
        Recipe(id: 2, name: "Kerala Dosha", description: "Whether you’re trying to be healthy, pulling an all-nighter, or just trying to get through the day, protein-packed snacks are your best friends", thumbnailURL: "https://img.buzzfeed.com/thumbnailer-prod-us-east-1/video-api/assets/314886.jpg", isFavorite: false),
        Recipe(id: 3, name: "Kerala CB", description: "Whether you’re trying to be healthy, pulling an all-nighter, or just trying to get through the day, protein-packed snacks are your best friends", thumbnailURL: "https://s3.amazonaws.com/video-api-prod/assets/654d0916588d46c5835b7a5f547a090e/BestPastaFB.jpg", isFavorite: true)
    ]
    var state: ResultState
    
    init(state: ResultState) {
        self.state = state
    }
    
    func send(_ action: RecipeListAction) {
    }
}
#endif

*/
