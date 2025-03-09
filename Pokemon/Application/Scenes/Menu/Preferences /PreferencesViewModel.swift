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
    case winPreferenceUpdated
}

@MainActor
protocol PreferencesViewModelType: AnyObject, Observable {
    var enableGameWinAnimation: Bool { get set }
    func send(_ action: PreferenceActions)
}

@MainActor
@Observable
final class PreferencesViewModel: PreferencesViewModelType {
    var enableGameWinAnimation: Bool = false

    init() {
    }

    func send(_ action: PreferenceActions) {
        switch action {
        case .winPreferenceUpdated:
            saveToSwiftData()
        }
    }

    private func loadPreferences() {
        enableGameWinAnimation = true
    }

    private func saveToSwiftData() {
    }
}
