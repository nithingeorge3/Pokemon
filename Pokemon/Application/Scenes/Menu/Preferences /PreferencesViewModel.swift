//
//  PreferencesViewModel.swift
//  Pokemon
//
//  Created by Nitin George on 09/03/2025.
//

import Foundation
import PokemonNetworking
import Observation

enum PreferenceActions {
    case winPreferenceUpdated(Bool)
    case silhouetteModeUpdated(Bool)
}

@MainActor
protocol PreferencesViewModelType: AnyObject, Observable {
    var enableGameWinAnimation: Bool { get set }
    var preference: Preference? { get }
    func send(_ action: PreferenceActions)
}

@MainActor
@Observable
final class PreferencesViewModel: PreferencesViewModelType {
    var enableGameWinAnimation: Bool = false
    var preference: Preference?
    private let userService: PokemonUserServiceType
    
    init(userService: PokemonUserServiceType) {
        self.userService = userService
        Task { try await loadPreferences() }
    }

    func send(_ action: PreferenceActions) {
        switch action {
        case .winPreferenceUpdated(let isUpdated):
            preference?.showWinAnimation = isUpdated
            Task { try await updatePreference() }
        case .silhouetteModeUpdated(let isUpdated):
            preference?.enableSilhouetteMode = isUpdated
            Task { try await updatePreference() }
        }
    }

    private func loadPreferences() async throws {
        do {
            let domianPreference = try await userService.getCurrentPreferences()
            preference = Preference(from: domianPreference)
            
        } catch {
            print("error: \(error)")
        }
    }

    private func updatePreference() async throws {
        do {
            if let preference =  preference {
                try await userService.updatePreferences(preference.asDomain)
            }
            
        } catch {
            print("error: \(error)")
        }
    }
}
