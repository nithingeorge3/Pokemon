//
//  PaginationDTO.swift
//  RecipeDomain
//
//  Created by Nitin George on 04/03/2025.
//

import Foundation

public enum EntityType: Int, Codable, Sendable {
    case pokemon = 101
}

public struct PaginationDomain: Identifiable, @unchecked Sendable {
    public let id: UUID
    public var entityType: EntityType
    public var totalCount: Int
    public var currentPage: Int
    public var lastUpdated: Date
    
    public init(id: UUID = UUID(), entityType: EntityType = .pokemon, totalCount: Int = 0, currentPage: Int = 0, lastUpdated: Date = Date()) {
        self.id = id
        self.entityType = entityType
        self.totalCount = totalCount
        self.currentPage = currentPage
        self.lastUpdated = lastUpdated
    }
}
