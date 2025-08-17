//
//  ContentView.swift
//  HWS
//
//  Created by Radoslav Bley on 10/08/2025.
//

import SwiftData
import SwiftUI

struct ContentView: View {

    var body: some View {
        TabView {
            Tab("Home", systemImage: "house") {
                HomeView()
                    .modelContainer(ModelData.shared.modelContainer)
            }

            Tab("Settings", systemImage: "gear") {
                SettingsView()
                    .modelContainer(ModelData.shared.modelContainer)
            }
        }
    }
}

#Preview {
    ContentView()
        .modelContainer(ModelData.shared.modelContainer)
}
