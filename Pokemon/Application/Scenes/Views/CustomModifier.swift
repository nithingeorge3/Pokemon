
//
//  CustomBackButtonModifier.swift
//  Pokemon
//
//  Created by Nitin George on 08/03/2025.
//

import SwiftUI

struct CustomBackButtonModifier: ViewModifier {
    @Environment(\.dismiss) private var dismiss
    let action: (() -> Void)?
    
    func body(content: Content) -> some View {
        content
            .navigationBarBackButtonHidden(true)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        action?() ?? dismiss()
                    } label: {
                        Image(systemName: "chevron.left")
                            .foregroundColor(.black)
                    }
                }
            }
    }
}

struct CustomNavigationTitle: ViewModifier {
    @State var title: String = "Pokemon"
    func body(content: Content) -> some View {
        content
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text(title)
                        .foregroundColor(.primary)
                        .fontWeight(.semibold)
                }
            }
    }
}

struct CustomNavigationScoreView<ScoreContent: View>: ViewModifier {
    let scoreContent: ScoreContent

    func body(content: Content) -> some View {
        content
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    scoreContent
                }
            }
    }
}

extension View {
    func withCustomBackButton(action: (() -> Void)? = nil) -> some View {
        modifier(CustomBackButtonModifier(action: action))
    }
    
    func withCustomNavigationTitle(title: String) -> some View {
        modifier(CustomNavigationTitle(title: title))
    }
    
    func withCustomNavigationScore<Content: View>(_ view: Content) -> some View {
        self.modifier(CustomNavigationScoreView(scoreContent: view))
    }
}
