//
//  PreferencesView.swift
//  Pokemon
//
//  Created by Nitin George on 09/03/2025.
//

import SwiftUI

struct PreferencesView<ViewModel: PreferencesViewModelType>: View {
    @Bindable var viewModel: ViewModel
    
    private var showWinAnimationBinding: Binding<Bool> {
        Binding<Bool>(
            get: { viewModel.preference?.showWinAnimation ?? false },
            set: { newValue in
                viewModel.send(.winPreferenceUpdated(newValue))
            }
        )
    }

    
    var body: some View {
        Form {
            Section(header: Text("Game Preferences")) {
                Toggle("Enable Win Animation", isOn: showWinAnimationBinding)
                    .toggleStyle(SwitchToggleStyle())
                    .onChange(of: viewModel.enableGameWinAnimation) { _, newValue in
                        viewModel.send(.winPreferenceUpdated(newValue))
                    }
//                Toggle("Enable Silhouette Mode", isOn: showWinAnimationBinding)
//                    .toggleStyle(SwitchToggleStyle())
//                    .onChange(of: viewModel.enableGameWinAnimation) { _, newValue in
//                        viewModel.send(.winPreferenceUpdated(newValue))
//                    }
            }
        }
        .formStyle(.grouped)
        .withCustomBackButton()
        .withCustomNavigationTitle(title: "Preferences")
    }
}
