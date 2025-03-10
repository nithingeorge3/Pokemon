//
//  ScoreView.swift
//  Pokemon
//
//  Created by Nitin George on 09/03/2025.
//

import SwiftUI

struct GameScoreView: View {
    var score: Int
//    @Binding var score: Int
    var size: CGFloat = 24
    
    var body: some View {
        HStack {
            Text("Score: \(score)")
                .font(.system(size: size, weight: .bold, design: .rounded))
                .foregroundColor(.white)
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .background(
                    Capsule()
                        .fill(Color.blue.gradient)
                        .shadow(color: .black.opacity(0.3), radius: 5, x: 2, y: 2)
                )
                .overlay(
                    Capsule()
                        .stroke(Color.white.opacity(0.8), lineWidth: 2)
                )
        }
        .accessibilityElement(children: .ignore)
        .accessibilityLabel("Current score")
        .accessibilityValue("\(score)")
    }
}
