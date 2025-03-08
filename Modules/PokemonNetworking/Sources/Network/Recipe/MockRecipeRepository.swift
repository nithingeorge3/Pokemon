//
//  MockRecipeRepository.swift
//  RecipeNetworking
//
//  Created by Nitin George on 06/03/2025.
//

import Foundation
import PokemonDomain

final class MockRecipeRepository: RecipeRepositoryType, @unchecked Sendable {
    private let fileName: String
    private let parser: ServiceParserType
    private var recipe: RecipeDomain?
    private var pagination: PaginationDomain
    
    init(
        fileName: String,
        parser: ServiceParserType = ServiceParser(),
        pagination: PaginationDomain = PaginationDomain(id: UUID(uuidString: "11111111-1111-1111-1111-111111111111")!, entityType: .recipe, totalCount: 0, currentPage: 0, lastUpdated: Date(timeIntervalSince1970: 0))
    ) {
        self.fileName = fileName
        self.parser = parser
        self.pagination = pagination
    }
    
    func fetchRecipes(endPoint: EndPoint) async throws -> [RecipeDomain] {
        guard let url = Bundle.module.url(forResource: self.fileName, withExtension: "json") else {
            throw NetworkError.responseError
        }
        
        do {
            let data = try Data(contentsOf: url)
            
            guard let mockResponse = HTTPURLResponse(
                url: url,
                statusCode: 200,
                httpVersion: nil,
                headerFields: nil
            ) else {
                throw NetworkError.responseError
            }
            
            let dtos = try await parser.parse(data: data, response: mockResponse, type: RecipeResponseDTO.self)
            let recipeDomains = dtos.results.map { RecipeDomain(from: $0) }
            recipe = recipeDomains.first
            pagination.totalCount = dtos.count
            pagination.currentPage = 1

            return recipeDomains
        }
        catch {
            throw NetworkError.failedToDecode
        }
    }
    
    func fetchRecipe(for recipeID: Int) async throws -> RecipeDomain {
        guard let recipe = recipe else {
            throw RecipeError.notFound(recipeID: recipeID)
        }
        return recipe
    }
    
    func fetchRecipes(page: Int, pageSize: Int) async throws -> [RecipeDomain] {
        return []
    }
    
    func updateFavouriteRecipe(_ recipeID: Int) async throws -> Bool {
        guard var recipe = recipe, recipe.id == recipeID else {
            return false
        }
        recipe.isFavorite.toggle()
        self.recipe = recipe
        return recipe.isFavorite
    }
    
    func fetchRecipePagination(_ entityType: EntityType) async throws -> PaginationDomain {
        pagination
    }
}
