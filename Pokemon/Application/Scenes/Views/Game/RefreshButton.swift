//
//  RefreshButton.swift
//  Pokemon
//
//  Created by Nitin George on 09/03/2025.
//

import SwiftUI

struct RefreshButton: View {
    let onRefresh: () -> Void
    @State private var rotationAngle: Double = 0
    
    var body: some View {
        Button(action: {
            UIImpactFeedbackGenerator(style: .medium).impactOccurred()
            
            withAnimation(.easeInOut(duration: 0.6)) {
                rotationAngle += 360
            }
            
            onRefresh()
        }) {
            Image(systemName: "arrow.clockwise")
                .font(.title)
                .foregroundColor(.blue)
                .rotationEffect(.degrees(rotationAngle))
        }
        .accessibilityLabel("Refresh")
    }
}

#if DEBUG
#Preview("Default") {
    RefreshButton {
        print("Refresh tapped!")
    }
    .padding()
}
#endif
