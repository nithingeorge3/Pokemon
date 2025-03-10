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
                Toggle("Enable Win Animation", isOn: showWinAnimationBinding)
                    .toggleStyle(SwitchToggleStyle())
                Toggle("Enable Silhouette Mode", isOn: showEnableSilhouetteModeBinding)
                    .toggleStyle(SwitchToggleStyle())
            }
        }
        .formStyle(.grouped)
        .withCustomBackButton()
        .withCustomNavigationTitle(title: "Preferences")
    }
    
    private var showWinAnimationBinding: Binding<Bool> {
        Binding<Bool>(
            get: { viewModel.preference?.showWinAnimation ?? false },
            set: { newValue in
                viewModel.send(.winPreferenceUpdated(newValue))
            }
        )
    }

    private var showEnableSilhouetteModeBinding: Binding<Bool> {
        Binding<Bool>(
            get: { viewModel.preference?.enableSilhouetteMode ?? false },
            set: { newValue in
                viewModel.send(.silhouetteModeUpdated(newValue))
            }
        )
    }
}
