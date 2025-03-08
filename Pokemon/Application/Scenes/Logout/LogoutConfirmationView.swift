//
//  LogoutConfirmationView.swift
//  Recipes
//
//  Created by Nitin George on 02/03/2025.
//

import SwiftUI

struct LogoutConfirmationView: View {
    var onConfirm: () -> Void
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Are you sure you want to logout?")
                .font(.headline)
            
            Button(role: .destructive) {
                onConfirm()
                dismiss()
            } label: {
                Label("Log Out", systemImage: "power")
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.borderedProminent)
            .controlSize(.large)
            .bold()
            .frame(height: 60)
            .clipShape(RoundedRectangle(cornerRadius: 8))
            
            Button(action: {
                dismiss()
            }) {
                Text("Cancel")
                    .bold()
                    .foregroundColor(.black)
                    .frame(maxWidth: .infinity, minHeight: 60)
                    .contentShape(Rectangle())
            }
            .buttonStyle(.plain)
            .background(
                RoundedRectangle(cornerRadius: 8)
                    .fill(Color.gray.opacity(0.2))
            )
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(Color.gray.opacity(0.5), lineWidth: 1)
            )
        }
        .padding()
        .presentationDragIndicator(.visible)
        .presentationDetents([.medium, .fraction(0.35)])
    }
}
