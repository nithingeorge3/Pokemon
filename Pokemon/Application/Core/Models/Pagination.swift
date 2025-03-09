//
//  PaginationInfo.swift
//  Pokemon
//
//  Created by Nitin George on 08/03/2025.
//
import Foundation
import PokemonDomain

struct Pagination: Identifiable, Hashable {
    let id: UUID
    let entityType: EntityType
    let totalCount: Int
    var currentPage: Int
    let lastUpdated: Date
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    public static func == (lhs: Pagination, rhs: Pagination) -> Bool {
        lhs.id == rhs.id
    }
    
    init(id: UUID = UUID(), entityType: EntityType, totalCount: Int = 10, currentPage: Int = 10, lastUpdated: Date = Date()) {
        self.id = id
        self.entityType = entityType
        self.totalCount = totalCount
        self.currentPage = currentPage
        self.lastUpdated = lastUpdated
    }
    
    var shouldFetch: Bool {
        currentPage == totalCount - 1 ? false : true
    }
}

extension Pagination {
    init(from paginationDomain: PaginationDomain) {
        self.id = paginationDomain.id
        self.entityType = paginationDomain.entityType
        self.totalCount = paginationDomain.totalCount
        self.currentPage = paginationDomain.currentPage
        self.lastUpdated = paginationDomain.lastUpdated
    }
}
