//
//  InstructionStep.swift
//  Pokemon
//
//  Created by Nitin George on 11/03/2025.
//

import SwiftUI

struct InstructionStep: View {
    let bulletView: AnyView
    let title: String
    let description: String
    
    var body: some View {
        HStack(alignment: .top, spacing: 16) {
            bulletView

            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.headline)
                
                Text(description)
                    .foregroundStyle(.secondary)
                    .fixedSize(horizontal: false, vertical: true)
            }
        }
    }
}
