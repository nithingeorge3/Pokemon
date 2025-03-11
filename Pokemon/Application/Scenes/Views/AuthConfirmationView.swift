//
//  AuthConfirmationView.swift
//  Pokemon
//
//  Created by Nitin George on 11/03/2025.
//

import SwiftUI

struct AuthConfirmationView: View {
    let actionType: AuthActionType
    let onConfirm: () -> Void
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        VStack(spacing: 24) {
            Text(actionTitle)
                .font(.title3.weight(.semibold))
                .multilineTextAlignment(.center)
            
            VStack(spacing: 12) {
                Button(role: actionRole) {
                    onConfirm()
                    dismiss()
                } label: {
                    Label(actionButtonTitle, systemImage: actionButtonIcon)
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.borderedProminent)
                .controlSize(.large)
                
                Button("Cancel", role: .cancel) {
                    dismiss()
                }
                .buttonStyle(.plain)
                .foregroundStyle(.secondary)
            }
        }
        .padding()
        .presentationDetents([.height(280)])
        .presentationDragIndicator(.visible)
    }
    
    private var actionTitle: String {
        switch actionType {
        case .login: return "Sign in to play and unlock more features"
        case .logout: return "Are you sure you want to sign out?"
        }
    }

    private var iconColor: Color {
        switch actionType {
        case .login: return .gray
        case .logout: return .red
        }
    }
    
    private var actionRole: ButtonRole? {
        switch actionType {
        case .login: return nil
        case .logout: return .destructive
        }
    }
    
    private var actionButtonTitle: String {
        switch actionType {
        case .login: return "Login"
        case .logout: return "Sign Out"
        }
    }
    
    private var actionButtonIcon: String {
        switch actionType {
        case .login: return ""
        case .logout: return "power"
        }
    }
}
