//
//  OnboardingView.swift
//  Pokemon
//
//  Created by Nitin George on 11/03/2025.
//

import SwiftUI

struct OnboardingView: View {
    let dismissAction: () -> Void
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    HStack {
                        Spacer()
                        Image("pokemonPlaceholder")
                            .resizable()
                            .scaledToFit()
                            .frame(height: 60)
                        Spacer()
                    }
                    .padding(.top, 8)
                    
                    Text("Pokemon App Features")
                        .font(.title2)
                        .bold()
                        .padding(.top, 10)
                    
                    //app features
                    InstructionStep(
                        bulletView: AnyView(BulletPointView(icon: "list.bullet.circle.fill", color: .blue, size: 44, animationState: true)),
                        title: "Home Screen",
                        description: "User can see a list of Pokemon in the Home tab with the latest score."
                    )
                    
                    InstructionStep(
                        bulletView: AnyView(BulletPointView(icon: "gamecontroller.fill", color: .red, size: 44, animationState: true)),
                        title: "Play Pokemon",
                        description: "User can choose any Pokemon and play the game."
                    )
                    
                    //game view
                    Text("GameView Features")
                        .font(.title2)
                        .bold()
                        .padding(.top, 10)
                    
                    InstructionStep(
                        bulletView: AnyView(BulletPointView(icon: "rectangle.grid.2x2.fill", color: .blue, size: 44, animationState: true)),
                        title: "PlayView",
                        description: "User will see four options. Choosing the correct answer will score points."
                    )
                    
                    InstructionStep(
                        bulletView: AnyView(BulletPointView(icon: "arrow.triangle.2.circlepath", color: .purple, size: 44, animationState: true)),
                        title: "Random Pokemon",
                        description: "User can refresh the Pokemon to choose a random Pokemon to play."
                    )
                    
                    InstructionStep(
                        bulletView: AnyView(BulletPointView(icon: "chart.bar.fill", color: .green, size: 44, animationState: true)),
                        title: "Live Score Updates",
                        description: "User can see the updated score instantly."
                    )
                    
                    //menu view
                    Text("MenuView Features")
                        .font(.title2)
                        .bold()
                        .padding(.top, 10)
                    
                    InstructionStep(
                        bulletView: AnyView(BulletPointView(icon: "gearshape.fill", color: .gray, size: 44, animationState: true)),
                        title: "Preferences",
                        description: "From the Menu Preference view, the user can configure preferences."
                    )
                    
                    InstructionStep(
                        bulletView: AnyView(BulletPointView(icon: "sparkles", color: .orange, size: 44, animationState: true)),
                        title: "Win Animation",
                        description: "Users can enable or disable the Win Animation."
                    )
                    
                    InstructionStep(
                        bulletView: AnyView(BulletPointView(icon: "eye.slash.fill", color: .pink, size: 44, animationState: true)),
                        title: "Silhouette Effect",
                        description: "Users can enable or disable the Pokemon Silhouette Effect for the initial stage."
                    )
                    
                    //score & play tracking
                    Text("Score & Play Tracking")
                        .font(.title2)
                        .bold()
                        .padding(.top, 10)
                    
                    InstructionStep(
                        bulletView: AnyView(BulletPointView(icon: "archivebox.fill", color: .teal, size: 44, animationState: true)),
                        title: "Local Storage",
                        description: "Score and play status will be stored locally for tracking progress."
                    )
                    
                    HStack {
                        Spacer()
                        Button("Get Started") {
                            dismissAction()
                        }
                        .buttonStyle(.borderedProminent)
                        Spacer()
                    }
                    .padding(.top, 40)
                }
                .padding()
            }
            .navigationTitle("Welcome to Pokemon")
            .navigationBarTitleDisplayMode(.inline)
            .interactiveDismissDisabled()
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Skip") {
                        dismissAction()
                    }
                    .buttonStyle(.borderedProminent)
                }
            }
        }
        .presentationDetents([.large])
        .presentationDragIndicator(.visible)
    }
}
