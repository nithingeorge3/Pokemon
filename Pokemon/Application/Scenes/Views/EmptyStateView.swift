//
//  EmptyStateView.swift
//  Recipes
//
//  Created by Nitin George on 02/03/2025.
//

import SwiftUI

struct EmptyStateView: View {
    let message: String
    
    var body: some View {
        Text(message)
            .multilineTextAlignment(.center)
            .font(.largeTitle)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .foregroundColor(.primary)
            .padding()
    }
}
