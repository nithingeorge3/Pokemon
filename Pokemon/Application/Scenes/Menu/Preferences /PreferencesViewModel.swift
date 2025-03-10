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
            Task { try await updatePreference(isUpdated) }
        case .silhouetteModeUpdated(let isUpdated): break
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

    private func updatePreference(_ isUpdated: Bool) async throws {
        do {
            preference?.showWinAnimation = isUpdated
            if let preference =  preference {
                try await userService.updatePreferences(preference.asDomain)
            }
            
        } catch {
            print("error: \(error)")
        }
    }
}
