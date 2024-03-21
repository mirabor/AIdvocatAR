//
//  MainView.swift

import SwiftUI

struct MainView: View {

    @State private var selectedTab = "Home"

    var body: some View {
        TabView {
            HomeScreen()
                .tabItem {
                    Label("Home", systemImage: "house.fill")
                }
            NewPostView()
                .tabItem {
                    Label("Post", systemImage: "plus.square.fill")
                }
            ARViewScreen()
                .tabItem {
                    Label("Your World", systemImage: "cube")
                }
            AboutUsView()
                .tabItem {
                    Label("Settings", systemImage: "gear.circle.fill")
                }
        }
    }
    
}

