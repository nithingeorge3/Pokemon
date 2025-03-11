//
//  MockPaginationHandler.swift
//  Pokemon
//
//  Created by Nitin George on 10/03/2025.
//

import XCTest
@testable import Pokemon

final class MockPaginationHandler: PaginationHandlerType {
    var currentPage: Int = 0
    var totalItems: Int = 0
    var isLoading: Bool = false
    var lastUpdated: Date = Date()
    
    var hasMoreData: Bool = true
    
    func reset() { }
    func validateLoadMore(index: Int) -> Bool { false }
    func updateFromDomain(_ pagination: Pagination) {
        totalItems = pagination.totalCount
        currentPage = pagination.currentPage
        lastUpdated = pagination.lastUpdated
        isLoading = false
    }
}
