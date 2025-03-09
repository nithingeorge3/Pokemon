//
//  TabBarItemView.swift
//  Pokemon
//
//  Created by Nitin George on 08/03/2025.
//

import SwiftUI

struct TabBarItemView: View {
    @ObservedObject var tab: TabItem
    let isSelected: Bool
    
    var body: some View {
        VStack(spacing: 2) {
            ZStack {
                Image(systemName: tab.icon)
                    .font(.system(size: 18))
                    .foregroundColor(isSelected ? tab.color : .gray)
                
                if let badge = tab.badgeCount, badge > 0 {
                    Text("\(badge)")
                        .font(.caption2)
                        .foregroundColor(.white)
                        .padding(4)
                        .background(Color.red)
                        .clipShape(Circle())
                        .offset(x: 8, y: -8)
                }
            }
            Text(tab.title)
                .font(.caption2)
                .foregroundColor(isSelected ? tab.color : .gray)
        }
        .padding(.vertical, 4)
        .frame(maxWidth: .infinity)
    }
}
