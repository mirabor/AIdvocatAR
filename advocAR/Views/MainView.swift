//
//  MainView.swift

import SwiftUI

struct MainView: View {

    @State private var selectedTab = "Home"

    var body: some View {
        TabView {
            HomeScreen()
                .tabItem {
                    Label("Browse", systemImage: "house.fill")
                }
            EntryView()
                .tabItem {
                    Label("Post", systemImage: "plus.square.fill")
                }
            ARViewScreen()
                .tabItem {
                    Label("Reality", systemImage: "cube")
                }
            SettingsView()
                .tabItem {
                    Label("Settings", systemImage: "gear.circle.fill")
                }
        }
    }
    
}

