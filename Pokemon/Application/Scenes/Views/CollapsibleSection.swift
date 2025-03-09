//
//  CollapsibleSection.swift
//  Pokemon
//
//  Created by Nitin George on 08/03/2025.
//

import SwiftUI

struct CollapsibleSection<Content: View>: View {
    let title: String
    @Binding var isCollapsed: Bool
    
    @ViewBuilder let content: () -> Content
        
    var body: some View {
        Section {
            if !isCollapsed {
                content()
            }
        } header: {
            HStack {
                Text(title)
                    .font(.headline)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                Image(systemName: isCollapsed ? "chevron.down" : "chevron.up")
                    .onTapGesture {
                        withAnimation {
                            isCollapsed.toggle()
                        }
                    }
            }
            .padding(.vertical, 8)
            .background(Color(uiColor: .systemBackground))
        }
    }
}
