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
    @ObservedObject var viewModel: MenuViewModel
    @State private var selectedItem: SidebarItem?
    @State private var showLogoutConfirmation = false
    
    init(viewModel: MenuViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        NavigationSplitView {
            List(viewModel.items, selection: $selectedItem) { item in
                switch item.type {
                case .navigation:
                    NavigationLink(item.title, value: item)
                        .font(.headline)
                        .padding(.vertical, 8)
                case .action:
                    SideBarActionButton(title: item.title) {
                        handleAction(for: item)
                    }
                }
            }
            .navigationTitle("More")
            .listStyle(.sidebar)
            .navigationSplitViewColumnWidth(200)
        } detail: {
            if let selectedItem {
                destinationView(for: selectedItem)
            } else {
                Text("Select an item")
                    .foregroundStyle(.secondary)
            }
        }
        .sheet(isPresented: $showLogoutConfirmation) {
            LogoutConfirmationView {
                viewModel.performLogOut()
            }
        }
    }
    
    private struct SideBarActionButton: View {
        let title: String
        let action: () -> Void
        
        var body: some View {
            Button {
                action()
            } label: {
                Text(title)
                    .font(.headline)
                    .padding(.vertical, 8)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .contentShape(Rectangle())
            }
            .buttonStyle(.plain)
            .frame(maxWidth: .infinity, alignment:  .leading)
            .foregroundColor(title == "Logout" ? .red : .primary)
        }
    }
    
    private func handleAction(for item: SidebarItem) {
        switch item.title {
        case "Logout":
            showLogoutConfirmation = true
        default:
            break
        }
    }
    
    @ViewBuilder
    private func destinationView(for item: SidebarItem) -> some View {
        switch item.title {
        case "Profile":
            SettingsView()
        case "Preferences":
            makePreferencesView()
        case "Pokemon List":
            EmptyView() //pokemonListView()
        default:
            EmptyView()
        }
    }
    
//    private func pokemonListView() -> some View {
//        let service = PokemonListServiceFactory.makePokemonListService()
//        let viewModel = PokemonViewModel(service: service)
//        return PokemonViewFactory().makePokemonListView(viewModel: viewModel)
//    }
    
    private func makePreferencesView() -> some View {
        let viewModel = PreferencesViewModel(userService: viewModel.userService)
        return PreferencesView(viewModel: viewModel)
    }
}
