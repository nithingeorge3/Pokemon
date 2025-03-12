//
//  UserSDRepositoryTests.swift
//  PokemonDataSource
//
//  Created by Nitin George on 10/03/2025.
//

import XCTest
import SwiftData
import PokemonDomain

@testable import PokemonDataStore

final class UserSDRepositoryTests: XCTestCase {
    private var pokeRepository: PokemonSDRepositoryType!
    private var repository: UserSDRepositoryType!
    private var container: ModelContainer!
    private let testPokemonId = 25
    private let testPokemonName = "Pikachu"
    
    override func setUp() async throws {
        container = DataStoreManagerFactory.makeSharedContainer(for: "TestContainer")
        repository = UserSDRepository(container: container)
        pokeRepository = PokemonSDRepository(container: container)
        
        let pokemon = [
            PokemonDomain(id: testPokemonId, name: testPokemonName, url: URL(string: "https://pokeapi.co/api/v2/pokemon/1/")!)
        ]
                
        try await pokeRepository.savePokemon(pokemon)
    }
    
    @MainActor
    override func tearDown() async throws {
        try await clearData()
        container = nil
        repository = nil
        pokeRepository = nil
    }
    
    @MainActor
    private func clearData() async throws {
        let context = ModelContext(container)
        try context.delete(model: SDUser.self)
        try context.save()
    }
}

extension UserSDRepositoryTests {
    func testGetOrCreateGuest_CreatesNewUser_WhenNoExistingGuest() async throws {
        let user = try await repository.getOrCreateGuest()
        
        XCTAssertTrue(user.isGuest)
        XCTAssertEqual(user.score, 0)
        XCTAssertEqual(try countUsers(), 1)
    }
    
    func testGetOrCreateGuest_ReturnsExistingGuest_WithMostRecentLastActive() async throws {
        let oldUser = SDUser(id: UUID(uuidString: "11111111-1111-1111-1111-111111111111")!, score: 10, email: "test1@gmail.com", isGuest: true, lastActive: .distantPast)
        let newUser = SDUser(id: UUID(uuidString: "11111111-1111-1111-1111-111111111111")!, score: 10, email: "test1@gmail.com", isGuest: true, lastActive: .now)
        
        try await saveUsers([oldUser, newUser])
        
        let result = try await repository.getOrCreateGuest()
        
        XCTAssertEqual(result.id, newUser.id)
    }
    
    func testGetOrCreateGuest_IsSame() async throws {
        let user1 = try await repository.getOrCreateGuest()
        let user2 = try await repository.getOrCreateGuest()
        
        XCTAssertEqual(user1.id, user2.id)
        XCTAssertEqual(try countUsers(), 1)
    }
        
    func testUpdateScore_IncrementsScoreAndUpdatesTimestamp() async throws {
        let initialUser = try await repository.getOrCreateGuest()
        
        try await repository.updateScore(25)
        let updatedUser = try await repository.getCurrentUser()
        
        XCTAssertEqual(updatedUser.score, initialUser.score + 25)
        XCTAssert(updatedUser.lastActive > initialUser.lastActive)
    }
    
    func testUpdateScore_HandlesNegativeValues() async throws {
        _ = try await repository.getOrCreateGuest()
        try await repository.updateScore(30)
        
        try await repository.updateScore(-15)
        let user = try await repository.getCurrentUser()
        
        XCTAssertEqual(user.score, 15)
    }

    func testGetCurrentUser_AlwaysReturnsGuestInCurrentImplementation() async throws {
        let user = try await repository.getCurrentUser()
        
        XCTAssertTrue(user.isGuest)
    }
    
    func testGetCurrentUser_ReflectsScoreChanges() async throws {
        _ = try await repository.getOrCreateGuest()
        try await repository.updateScore(50)
        
        let user = try await repository.getCurrentUser()
        
        XCTAssertEqual(user.score, 50)
    }

    func testIsolationBetweenModelContexts() async throws {
        let user1 = try await repository.getOrCreateGuest()
        
        try await repository.updateScore(10)
        
        let context = ModelContext(container)
        let descriptor = FetchDescriptor<SDUser>()
        let storedUser = try context.fetch(descriptor).first
        
        XCTAssertEqual(storedUser?.score, user1.score + 10)
    }
}

extension UserSDRepositoryTests {
    private func countUsers() throws -> Int {
        let context = ModelContext(container)
        let descriptor = FetchDescriptor<SDUser>()
        return try context.fetchCount(descriptor)
    }
    
    private func saveUsers(_ users: [SDUser]) async throws {
        let context = ModelContext(container)
        users.forEach { context.insert($0) }
        try context.save()
    }
}

// MARK: - Gameplay
extension UserSDRepositoryTests {
    func testCreateNewEntryWhenNoneExists() async throws {
        
        let newUser = SDUser(id: UUID(uuidString: "11111111-1111-1111-1111-111111111111")!, score: 10, email: "test1@gmail.com", isGuest: true, lastActive: .distantPast)
        try await saveUser(newUser)
        
        try await repository.updatePlayedStatus(pokemonId: testPokemonId, outcome: .win)
        
        let user = try await repository.getCurrentUser()
        let entries = user.playedPokemons
        
        XCTAssertEqual(entries.count, 1, "Should create one new entry")
        XCTAssertEqual(entries.first?.pokemon?.id, testPokemonId)
        XCTAssertEqual(entries.first?.lastOutcome, .win)
    }
    
    private func saveUser(_ users: SDUser) async throws {
        let context = ModelContext(container)
        context.insert(users)
        try context.save()
    }
}
