//
//  PaginationTests.swift
//  Recipes
//
//  Created by Nitin George on 05/03/2025.
//

import Testing
import XCTest
import RecipeDomain

@testable import Recipes

class PaginationTests: XCTestCase {

    func test_recipe_shouldFetch_returnsFalseWhenOnLastPage() {
        let pagination = Pagination(entityType: .recipe, totalCount: 10, currentPage: 9)
        XCTAssertFalse(pagination.shouldFetch)
    }

    func test_recipe_shouldFetch_returnsTrueWhenNotOnLastPage() {
        let pagination = Pagination(entityType: .recipe, totalCount: 10, currentPage: 5)
        XCTAssertTrue(pagination.shouldFetch)
    }
    
    func test_recipe_initFromDomain_mapsPropertiesCorrectly() {
        let domain = PaginationDomain(
            id: UUID(uuidString: "11111111-1111-1111-1111-111111111111")!,
            entityType: .recipe,
            totalCount: 20,
            currentPage: 5,
            lastUpdated: Date(timeIntervalSince1970: 0)
        )
        
        let pagination = Pagination(from: domain)
        
        XCTAssertEqual(pagination.id, domain.id)
        XCTAssertEqual(pagination.entityType, .recipe)
        XCTAssertEqual(pagination.totalCount, 20)
        XCTAssertEqual(pagination.currentPage, 5)
        XCTAssertEqual(pagination.lastUpdated, Date(timeIntervalSince1970: 0))
    }

    func test_recipe_equality_usesID() {
        let pagination1 = Pagination(id: UUID(), entityType: .recipe, totalCount: 10, currentPage: 1)
        let pagination2 = Pagination(id: pagination1.id, entityType: .recipe, totalCount: 990, currentPage: 90)
        
        XCTAssertEqual(pagination1, pagination2)
    }
    
    func test_hash_usesID_equal() {
        let id = UUID(uuidString: "11111111-1111-1111-1111-111111111111")!
        let pagination1 = Pagination(id: id, entityType: .recipe)
        var hasher1 = Hasher()
        pagination1.hash(into: &hasher1)
        
        let pagination2 = Pagination(id: id, entityType: .recipe)
        var hasher2 = Hasher()
        pagination2.hash(into: &hasher2)
        
        XCTAssertEqual(hasher1.finalize(), hasher2.finalize())
    }
    
    func test_hash_usesID_notEqual() {
        let id1 = UUID(uuidString: "11111111-1111-1111-1111-111111111111")!
        let id2 = UUID(uuidString: "11111111-1111-1111-1111-111111111110")!
        let pagination1 = Pagination(id: id1, entityType: .recipe)
        var hasher1 = Hasher()
        pagination1.hash(into: &hasher1)
        
        let pagination2 = Pagination(id: id2, entityType: .recipe)
        var hasher2 = Hasher()
        pagination2.hash(into: &hasher2)
    
        XCTAssertNotEqual(hasher1.finalize(), hasher2.finalize())
    }
}
