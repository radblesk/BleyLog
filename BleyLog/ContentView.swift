//
//  ContentView.swift
//  BleyLog
//
//  Created by Radoslav Bley on 10/08/2025.
//

import SwiftData
import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            Tab("Courses", systemImage: "books.vertical") {
                HomeView()
            }

            Tab("For You", systemImage: "star") {
                ForYouView()
            }

            Tab("Settings", systemImage: "gear") {
                SettingsView()
            }
        }
        .tabViewStyle(.tabBarOnly)
    }
}

#Preview {
    ContentView()
        .modelContainer(ModelData.shared.modelContainer)
}
