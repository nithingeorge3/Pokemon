//
//  BulletPointView.swift
//  Pokemon
//
//  Created by Nitin George on 11/03/2025.
//

import SwiftUI

struct BulletPointView: View {
    let icon: String
    let color: Color
    let size: CGFloat
    let animationState: Bool
        
    var body: some View {
        Image(systemName: icon)
            .symbolRenderingMode(.hierarchical)
            .foregroundStyle(.white)
            .frame(width: size, height: size)
            .background(Circle().fill(color.gradient))
            .opacity(animationState ? 1 : 0)
            .offset(x: animationState ? 0 : -20)
            .animation(.easeInOut(duration: 0.4), value: animationState)
    }
}

// MARK: - Previews
#if DEBUG
#Preview("Bullet Point View") {
    VStack(spacing: 40) {
        BulletPointView(icon: "circle.fill", color: .blue, size: 44, animationState: true)
        BulletPointView(icon: "target", color: .red, size: 44, animationState: true)
        BulletPointView(icon: "trophy.fill", color: .green, size: 44, animationState: true)
    }
    .padding()
}
#endif
