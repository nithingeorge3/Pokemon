//
//  MenuView.swift
//  Pokemon
//
//  Created by Nitin George on 08/03/2025.
//

import SwiftUI
import PokemonNetworking

//ToDo: Later use DI principle and use Observable and Bindable
struct MenuView: View {
    @Bindable var viewModel: MenuViewModel
    @State private var selectedItem: SidebarItem?
    @State private var showAuthConfirmation = false
    @State private var authActionType: AuthActionType?
    
    init(viewModel: MenuViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        NavigationSplitView {
            List(viewModel.filteredItems ?? [],
                selection: $selectedItem
            ) { item in
                switch item.type {
                case .navigation:
                    NavigationLink(item.title, value: item)
                        .font(.headline)
                        .padding(.vertical, 8)
                case .action:
                    SideBarActionButton(
                        title: item.title,
                        isDestructive: item.isDestructive
                    ) {
                        handleAction(for: item)
                    }
                }
            }
            .navigationTitle("More")
            .listStyle(.sidebar)
            .navigationSplitViewColumnWidth(200)
        } detail: {
            detailContent
        }
        .sheet(item: $authActionType) { actionType in
            AuthConfirmationView(
                actionType: actionType,
                onConfirm: handleAuthConfirmation
            )
        }
    }
    
    private var detailContent: some View {
        Group {
            if let selectedItem {
                destinationView(for: selectedItem)
            } else {
                EmptyStateView(
                    icon: "arrow.left.circle",
                    message: "Select a menu item to begin"
                )
            }
        }
    }
    
    private struct SideBarActionButton: View {
        let title: String
        let isDestructive: Bool
        let action: () -> Void
        
        var body: some View {
            Button(action: action) {
                HStack {
                    Text(title)
                        .font(.headline)
                    Spacer()
                    Image(systemName: authButtonIcon)
                }
                .padding(.vertical, 8)
                .contentShape(Rectangle())
            }
            .buttonStyle(.plain)
            .foregroundColor(buttonColor)
        }
        
        private var buttonColor: Color {
            isDestructive ? .red : .primary
        }
        
        private var authButtonIcon: String {
            switch title {
            case "Login": return "person.crop.circle.fill.badge.checkmark"
            case "Logout": return "power"
            default: return ""
            }
        }
    }
    
    private struct EmptyStateView: View {
        let icon: String
        let message: String
        
        var body: some View {
            VStack(spacing: 20) {
                Image(systemName: icon)
                    .font(.system(size: 40))
                    .foregroundStyle(.secondary)
                Text(message)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
    }
    
    private func handleAction(for item: SidebarItem) {
        switch item.authAction {
        case .login:
            authActionType = .login
        case .logout:
            authActionType = .logout
        case .none:
            break
        }
    }
    
    private func handleAuthConfirmation() {
        switch authActionType {
        case .login:
            viewModel.handleLogin()
        case .logout:
            viewModel.handleLogout()
        case .none:
            break
        }
        authActionType = nil
    }
    
    @ViewBuilder
    private func destinationView(for item: SidebarItem) -> some View {
        switch item.title {
        case "Settings":
            SettingsView()
        case "Preferences":
            makePreferencesView()
        default:
            EmptyStateView(
                icon: "exclamationmark.triangle",
                message: "Feature in development"
            )
        }
    }
    
    private func makePreferencesView() -> some View {
        let viewModel = PreferencesViewModel(userService: viewModel.userService)
        return PreferencesView(viewModel: viewModel)
    }
}
