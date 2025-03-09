//
//  PreferencesView.swift
//  Pokemon
//
//  Created by Nitin George on 09/03/2025.
//

import SwiftUI

struct PreferencesView<ViewModel: PreferencesViewModelType>: View {
    @Bindable var viewModel: ViewModel
    
    var body: some View {
        Form {
            Section(header: Text("Game Preferences")) {
                Toggle("Enable Win Animation", isOn: $viewModel.enableGameWinAnimation)
                    .toggleStyle(SwitchToggleStyle())
                    .onChange(of: viewModel.enableGameWinAnimation) {
                        viewModel.send(.winPreferenceUpdated)
                    }
            }
        }
        .formStyle(.grouped)
        .withCustomBackButton()
        .withCustomNavigationTitle(title: "Preferences")
    }
}
