//
//  MyProfileView.swift
//  Pokemon
//
//  Created by Nitin George on 08/03/2025.
//

import SwiftUI

struct SettingsView: View {
    var body: some View {
        VStack {
            Text("Settings View")
                .font(.largeTitle)
                .foregroundColor(.gray)
        }
        .withCustomBackButton()
        .withCustomNavigationTitle(title: "Settings")
    }
}
