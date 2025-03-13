//
//  SilhouetteEffect.swift
//  Pokemon
//
//  Created by Nitin George on 10/03/2025.
//

import SwiftUI

struct SilhouetteModifier: ViewModifier {
    let isActive: Bool
    let darkness: Double
    let sharpness: Double
    let animation: Animation?
    
    func body(content: Content) -> some View {
        content
            //Base effect controls
            .saturation(isActive ? 0 : 1)
            .brightness(isActive ? -darkness : 0)
            .contrast(isActive ? 1 + sharpness : 1)
            //Edge detection overlay
            .overlay(
                LinearGradient(
                    gradient: Gradient(colors: [
                        .clear,
                        .black.opacity(isActive ? darkness * 0.5 : 0)
                    ]),
                    startPoint: .top,
                    endPoint: .bottom
                )
                .blendMode(.softLight)
            )
            // Outline effect
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(.white.opacity(isActive ? 0.2 : 0), lineWidth: 2)
                    .blendMode(.overlay)
            )
            .animation(animation, value: isActive)
    }
}

extension View {
    func silhouetteEffect(
        active: Bool = true,
        darkness: Double = 0.4,
        sharpness: Double = 0.3,
        animation: Animation? = .easeInOut(duration: 0.8)
    ) -> some View {
        self.modifier(SilhouetteModifier(
            isActive: active,
            darkness: darkness,
            sharpness: sharpness,
            animation: animation
        ))
    }
}
