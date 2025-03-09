import XCTest

@testable import PokemonNetworking

class PokemonServiceImplTests: XCTestCase {
    
    private var pokemonRepository: PokemonRepositoryType!
    private var pokemonServiceImpl: PokemonServiceType!
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
        pokemonRepository = nil
        pokemonServiceImpl = nil
    }
        
    func testFetchPokemon_SuccessResponse_ReturnPokemon() async throws {
        pokemonRepository = MockPokemonRepository(fileName: "pokemon_success", parser: ServiceParser())
        pokemonServiceImpl = PokemonServiceImp(pokemonRepository: pokemonRepository)
        
        let expectation = XCTestExpectation(description: "Pokemon should be fetched successfully with one pokemon")
        
        do {
            let dtos = try await pokemonRepository.fetchPokemon(endPoint: .pokemon(offset: 0, limit: 40))
            XCTAssertEqual(dtos.first?.name, "ivysaur")
            XCTAssertEqual(dtos.count, 3)
            expectation.fulfill()
        } catch {
            XCTFail("Unexpected error happened: \(error)")
        }
        
        await fulfillment(of: [expectation], timeout: 1.0)
    }
    
    func testFetchPokemon_SuccessResponse_ReturnEmptyPokemon() async throws {
        pokemonRepository = MockPokemonRepository(fileName: "pokemon_empty", parser: ServiceParser())
        pokemonServiceImpl = PokemonServiceImp(pokemonRepository: pokemonRepository)
        
        let expectation = XCTestExpectation(description: "Pokemon fetch should return an empty list when no pokemon are available")
        
        do {
            let dtos = try await pokemonRepository.fetchPokemon(endPoint: .pokemon(offset: 0, limit: 40))
            XCTAssertEqual(dtos.count, 0)
            expectation.fulfill()
        } catch {
            XCTFail("Unexpected error happened: \(error)")
        }
        
        await fulfillment(of: [expectation], timeout: 1.0)
    }

    func testFetchPokemon_FailureResponse_ReturnError() async throws {
        pokemonRepository = MockPokemonRepository(fileName: "pokemon_error", parser: ServiceParser())
        pokemonServiceImpl = PokemonServiceImp(pokemonRepository: pokemonRepository)
        
        let expectation = XCTestExpectation(description: "Pokemon fetch should fail and return an appropriate error")
        
        do {
            _ = try await pokemonRepository.fetchPokemon(endPoint: .pokemon(offset: 0, limit: 40))
            XCTFail("Expected an error but received data instead")
        } catch {
            XCTAssertFalse(false, "expected error happened \(error)")
            expectation.fulfill()
        }
        
        await fulfillment(of: [expectation], timeout: 1.0)
    }
    
    func testUpdateFavouritePokemon() async throws {
        pokemonRepository = MockPokemonRepository(fileName: "pokemon_success", parser: ServiceParser())
        pokemonServiceImpl = PokemonServiceImp(pokemonRepository: pokemonRepository)
        
        let expectation = XCTestExpectation(description: "Pokemon's isFavorite status should update successfully")
        
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
    
    func testFetchPokemon() async throws {
        pokemonRepository = MockPokemonRepository(fileName: "pokemon_success", parser: ServiceParser())
        pokemonServiceImpl = PokemonServiceImp(pokemonRepository: pokemonRepository)
        
        let expectation = XCTestExpectation(description: "Pokemon should be fetched successfully with one pokemon")
        
        do {
            let dtos = try await pokemonRepository.fetchPokemon(endPoint: .pokemon(offset: 0, limit: 40))
            XCTAssertEqual(dtos.first?.name, "ivysaur")
            XCTAssertEqual(dtos.count, 3)
            expectation.fulfill()
        } catch {
            XCTFail("Unexpected error happened: \(error)")
        }
        
        await fulfillment(of: [expectation], timeout: 1.0)
    }
    
    func testPokemonPagination() async throws {
        pokemonRepository = MockPokemonRepository(fileName: "pokemon_success", parser: ServiceParser())
        pokemonServiceImpl = PokemonServiceImp(pokemonRepository: pokemonRepository)
        
        let expectation = XCTestExpectation(description: "Pokemon pagination data should be fetched successfully with expected values")
        
        do {
            _ = try await pokemonRepository.fetchPokemon(endPoint: .pokemon(offset: 0, limit: 40))
            let pagination = try await pokemonRepository.fetchRecipePagination(.pokemon)
            XCTAssertEqual(pagination.totalCount, 1304)
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
