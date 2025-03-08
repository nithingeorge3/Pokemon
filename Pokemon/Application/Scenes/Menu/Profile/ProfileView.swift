//
//  MyProfileView.swift
//  Recipes
//
//  Created by Nitin George on 01/03/2025.
//

import SwiftUI

struct ProfileView: View {
    var body: some View {
        VStack {
            Text("Profile View")
                .font(.largeTitle)
                .foregroundColor(.gray)
        }
        .withCustomBackButton()
        .withCustomNavigationTitle(title: "Profile")
    }
}
