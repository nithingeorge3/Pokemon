import XCTest
@testable import PokemonDomain

final class RecipeDomainTests: XCTestCase {
    func testRecipeDomainFullInitialization() {
        let ratings = UserRatingsDomain(id: 1, countNegative: 5, countPositive: 95)
        let recipe = RecipeDomain(
            id: 123,
            name: "Chicken",
            description: "Yummy chicken",
            country: .us,
            thumbnailURL: "https://abc.com",
            originalVideoURL: "https://abc.com/video",
            yields: "4 servings",
            isFavorite: false,
            userRatings: ratings
        )
        
        XCTAssertEqual(recipe.id, 123)
        XCTAssertEqual(recipe.country, .us)
        XCTAssertEqual(recipe.description, "Yummy chicken")
        XCTAssertEqual(recipe.userRatings?.countPositive, 95)
    }
    
    func testRecipeDomainDefaults() {
        let recipe = RecipeDomain(id: 1, name: "Chicken")
        XCTAssertEqual(recipe.description, nil)
        XCTAssertEqual(recipe.country, .unknown)
        XCTAssertEqual(recipe.isFavorite, false)
    }
    
    func testPaginationDomainDefaults() {
        let pagination = PaginationDomain()
        XCTAssertEqual(pagination.entityType, .recipe)
        XCTAssertEqual(pagination.totalCount, 0)
        XCTAssertEqual(pagination.currentPage, 0)
    }
    
    func testCountryRawValues() {
        XCTAssertEqual(Country.us.rawValue, "US")
        XCTAssertEqual(Country.ind.rawValue, "IND")
        XCTAssertEqual(Country.unknown.rawValue, "unknown")
    }
}
