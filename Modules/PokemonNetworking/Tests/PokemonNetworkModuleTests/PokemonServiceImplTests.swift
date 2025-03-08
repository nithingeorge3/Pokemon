import XCTest

@testable import PokemonNetworking

class PokemonServiceImplTests: XCTestCase {
    
    private var pokemonRepository: PokemonRepositoryType!
    private var pokemonServiceImpl: PokemonServiceType!
    
    override func setUp() {
    }
    
    override func tearDown() {
        pokemonRepository = nil
        pokemonServiceImpl = nil
    }
        
    func testFetchRecipes_SuccessResponse_ReturnRecipe() async throws {
        pokemonRepository = MockRecipeRepository(fileName: "pokemon_success", parser: ServiceParser())
        pokemonServiceImpl = PokemonServiceImp(pokemonRepository: pokemonRepository)
        
        let expectation = XCTestExpectation(description: "Recipe should be fetched successfully with one recipe")
        
        do {
            let dtos = try await pokemonRepository.fetchPokemon(endPoint: .pokemon(offset: 0, limit: 40))
            XCTAssertEqual(dtos.first?.name, "Low-Carb Avocado Chicken Salad")
            XCTAssertEqual(dtos.count, 10)
            expectation.fulfill()
        } catch {
            XCTFail("Unexpected error happened: \(error)")
        }
        
        await fulfillment(of: [expectation], timeout: 1.0)
    }
    
    func testFetchRecipes__SuccessResponse_ReturnEmptyRecipe() async throws {
        pokemonRepository = MockRecipeRepository(fileName: "pokemon_empty", parser: ServiceParser())
        pokemonServiceImpl = PokemonServiceImp(pokemonRepository: pokemonRepository)
        
        let expectation = XCTestExpectation(description: "Recipe fetch should return an empty list when no recipes are available")
        
        do {
            let dtos = try await pokemonRepository.fetchPokemon(endPoint: .pokemon(offset: 0, limit: 40))
            XCTAssertEqual(dtos.count, 0)
            expectation.fulfill()
        } catch {
            XCTFail("Unexpected error happened: \(error)")
        }
        
        await fulfillment(of: [expectation], timeout: 1.0)
    }

    func testFetchRecipes_FailureResponse_ReturnError() async throws {
        pokemonRepository = MockRecipeRepository(fileName: "pokemon_error", parser: ServiceParser())
        pokemonServiceImpl = PokemonServiceImp(pokemonRepository: pokemonRepository)
        
        let expectation = XCTestExpectation(description: "Recipe fetch should fail and return an appropriate error")
        
        do {
            _ = try await pokemonRepository.fetchPokemon(endPoint: .pokemon(offset: 0, limit: 40))
            XCTFail("Expected an error but received data instead")
        } catch {
            XCTAssertFalse(false, "expected error happened \(error)")
            expectation.fulfill()
        }
        
        await fulfillment(of: [expectation], timeout: 1.0)
    }
    
    func testUpdateFavouriteRecipe() async throws {
        pokemonRepository = MockRecipeRepository(fileName: "pokemon_success", parser: ServiceParser())
        pokemonServiceImpl = PokemonServiceImp(pokemonRepository: pokemonRepository)
        
        let expectation = XCTestExpectation(description: "Recipe's isFavorite status should update successfully")
        
        do {
            let dtos = try await pokemonRepository.fetchPokemon(endPoint: .pokemon(offset: 0, limit: 40))
            let firstToggle = try await pokemonRepository.updateFavouriteRecipe(dtos.first?.id ?? 0)
            XCTAssertTrue(firstToggle, "updated should be true")
            let secondToggle = try await pokemonRepository.updateFavouriteRecipe(dtos.first?.id ?? 0)
            XCTAssertFalse(secondToggle, "updated should be false")
            expectation.fulfill()
        } catch {
            XCTFail("Unexpected error happened: \(error)")
        }
        
        await fulfillment(of: [expectation], timeout: 1.0)
    }
    
    func testFetchRecipe() async throws {
        pokemonRepository = MockRecipeRepository(fileName: "pokemon_success", parser: ServiceParser())
        pokemonServiceImpl = PokemonServiceImp(pokemonRepository: pokemonRepository)
        
        let expectation = XCTestExpectation(description: "Recipe should be fetched successfully with one recipe")
        
        do {
            let dtos = try await pokemonRepository.fetchPokemon(endPoint: .pokemon(offset: 0, limit: 40))
            XCTAssertEqual(dtos.first?.name, "Low-Carb Avocado Chicken Salad")
            XCTAssertEqual(dtos.count, 10)
            expectation.fulfill()
        } catch {
            XCTFail("Unexpected error happened: \(error)")
        }
        
        await fulfillment(of: [expectation], timeout: 1.0)
    }
    
    func testRecipePagination() async throws {
        pokemonRepository = MockRecipeRepository(fileName: "pokemon_success", parser: ServiceParser())
        pokemonServiceImpl = PokemonServiceImp(pokemonRepository: pokemonRepository)
        
        let expectation = XCTestExpectation(description: "Recipe pagination data should be fetched successfully with expected values")
        
        do {
            _ = try await pokemonRepository.fetchPokemon(endPoint: .pokemon(offset: 0, limit: 40))
            let pagination = try await pokemonRepository.fetchRecipePagination(.recipe)
            XCTAssertEqual(pagination.totalCount, 10)
            XCTAssertEqual(pagination.currentPage, 1)
            XCTAssertEqual(pagination.id, UUID(uuidString: "11111111-1111-1111-1111-111111111111")!)
            XCTAssertEqual(pagination.lastUpdated, Date(timeIntervalSince1970: 0))
            expectation.fulfill()
        } catch {
            XCTFail("Unexpected error happened: \(error)")
        }
        
        await fulfillment(of: [expectation], timeout: 1.0)
    }
}
