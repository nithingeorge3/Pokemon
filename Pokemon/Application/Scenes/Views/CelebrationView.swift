//
//  ParticleConfig.swift
//  Pokemon
//
//  Created by Nitin George on 09/03/2025.
//

import SwiftUI

struct Particle: Identifiable {
    let id = UUID()
    let offset: CGSize
    let size: CGFloat
}

struct ParticleConfig {
    let color: Color
    let count: Int
    let spread: CGFloat
    let minSize: CGFloat
    let maxSize: CGFloat
    
    static let confetti = ParticleConfig(
        color: .blue,
        count: 50,
        spread: 200,
        minSize: 4,
        maxSize: 12
    )
}

struct CelebrationView: View {
    @State private var animate = false
    
    var body: some View {
        ZStack {
            // Ribbon Effect
            ForEach(0..<20) { index in
                Image(systemName: "bandage.fill")
                    .foregroundColor(.green)
                    .rotationEffect(.degrees(Double.random(in: 0...360)))
                    .offset(
                        x: animate ? CGFloat.random(in: -200...200) : 0,
                        y: animate ? CGFloat.random(in: -200...200) : 0
                    )
                    .opacity(animate ? 0 : 1)
                    .animation(
                        .easeOut(duration: 1.5).delay(Double.random(in: 0...0.5)),
                        value: animate
                    )
            }
            
            // Confetti Particles with proper configuration
            ParticleView(config: .confetti)
        }
        .onAppear { animate = true }
    }
}

struct ParticleView: View {
    let config: ParticleConfig
    @State private var particles: [Particle] = []
    
    var body: some View {
        ZStack {
            ForEach(particles) { particle in
                Circle()
                    .fill(config.color)
                    .frame(width: particle.size, height: particle.size)
                    .offset(particle.offset)
            }
        }
        .onAppear(perform: emitParticles)
    }
    
    private func emitParticles() {
        particles = (0..<config.count).map { _ in
            Particle(
                offset: CGSize(
                    width: CGFloat.random(in: -config.spread...config.spread),
                    height: CGFloat.random(in: -config.spread...config.spread)
                ),
                size: CGFloat.random(in: config.minSize...config.maxSize)
            )
        }
    }
}
