//
//  OnboardingView.swift
//  Pokemon
//
//  Created by Nitin George on 11/03/2025.
//

import SwiftUI

// MARK: - Onboarding View
struct OnboardingView: View {
    let dismissAction: () -> Void
    @Environment(\.dismiss) private var dismiss
    
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
                    .padding(.top, 40)
                    
                    InstructionStep(
                        icon: "gamecontroller",
                        title: "Controls",
                        description: "add."
                    )
                    
                    InstructionStep(
                        icon: "target",
                        title: "dd",
                        description: "dd"
                    )
                    
                    InstructionStep(
                        icon: "trophy",
                        title: "Achievements",
                        description: "Complete challenges to earn rare items and Pokemon."
                    )
                    
                    HStack {
                        Spacer()
                        Button("Get Started") {
                            dismissAction()
                            dismiss()
                        }
                        .buttonStyle(.borderedProminent)
                        Spacer()
                    }
                    .padding(.top, 40)
                }
                .padding()
            }
            .navigationTitle("Welcome to Pokemon!")
            .navigationBarTitleDisplayMode(.inline)
            .interactiveDismissDisabled()
        }
        .presentationDetents([.large])
        .presentationDragIndicator(.visible)
    }
}


//            .toolbar {
//                ToolbarItem(placement: .confirmationAction) {
//                    Button("Get Started") {
//                        dismissAction()
//                        dismiss()
//                    }
//                    .buttonStyle(.borderedProminent)
//                }
//            }
