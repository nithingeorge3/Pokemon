//
//  LocalPaginationHandler.swift
//  Pokemon
//
//  Created by Nitin George on 18/03/2025.
//

import Foundation
import Observation

@MainActor
protocol LocalPaginationHandlerType: AnyObject {
    var currentOffset: Int { get set }
    var pageSize: Int { get set }
    var totalItems: Int { get set }
    var isLoading: Bool { get set }
    var lastUpdated: Date { get set }
    
    var hasMoreData: Bool { get }
    
    func reset()
    func incrementOffset()
    func updateTotalItems(_ newValue: Int)
}

@Observable
final class LocalPaginationHandler: LocalPaginationHandlerType {
    var currentOffset: Int = 0
    var pageSize: Int = Constants.Pokemon.fetchLimit
    var totalItems: Int = 0
    var isLoading: Bool = false
    var lastUpdated: Date = Date()
    
    var hasMoreData: Bool {
        return currentOffset < totalItems
    }
    
    func reset() {
        currentOffset = 0
        isLoading = false
        lastUpdated = Date()
    }
    
    func incrementOffset() {
        currentOffset += pageSize
    }
    
    func updateTotalItems(_ newValue: Int) {
        totalItems = newValue
    }
}
