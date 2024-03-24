//
//  MainView.swift

import SwiftUI

struct MainView: View {

    @State private var selectedTab = "Home"
    @StateObject private var viewModel = EntryViewModel()

    var body: some View {
        TabView {
            HomeScreen()
                .tabItem {
                    Label("Browse", systemImage: "house.fill")
                }
            EntryView()
                .tabItem {
                    Label("Generate", systemImage: "plus.square.fill")
                }
            ARViewScreen()
                .tabItem {
                    Label("Reality", systemImage: "cube")
                }
        //        .environmentObject(viewModel)
            SettingsView()
                .tabItem {
                    Label("Settings", systemImage: "gear.circle.fill")
                }
        }
        .environmentObject(viewModel)
    }
    
}

