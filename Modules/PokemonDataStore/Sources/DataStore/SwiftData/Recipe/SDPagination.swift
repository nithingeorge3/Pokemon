//
//  SDPagination.swift
//  RecipeDataStore
//
//  Created by Nitin George on 04/03/2025.
//

import Foundation
import SwiftData
import PokemonDomain

@Model
public class SDPagination {
    @Attribute(.unique)
    public var id: UUID
    public var entityTypeRaw: Int
    public var totalCount: Int
    public var currentPage: Int
    public var lastUpdated: Date
    
    public var entityType: EntityType {
        get { EntityType(rawValue: entityTypeRaw) ?? .recipe }
        set { entityTypeRaw = newValue.rawValue }
    }
    
    init(id: UUID = UUID(), type: EntityType, total: Int, page: Int, lastUpdated: Date = Date()) {
        self.id = id
        self.entityTypeRaw = type.rawValue
        self.totalCount = total
        self.currentPage = page
        self.lastUpdated = lastUpdated
    }
}

extension PaginationDomain {
    init(from sdPagination: SDPagination) {
        self.init(
            entityType: sdPagination.entityType,
            totalCount: sdPagination.totalCount,
            currentPage: sdPagination.currentPage,
            lastUpdated: sdPagination.lastUpdated
        )
    }
}
