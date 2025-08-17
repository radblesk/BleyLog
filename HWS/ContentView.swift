//
//  ContentView.swift
//  HWS
//
//  Created by Radoslav Bley on 10/08/2025.
//

import SwiftData
import SwiftUI

struct ContentView: View {
    @State private var searchText: String = ""

    var body: some View {
        TabView {
            Tab("Courses", systemImage: "books.vertical") {
                HomeView()
                    .modelContainer(ModelData.shared.modelContainer)
            }

            Tab("For You", systemImage: "star") {
                ForYouView()
                    .modelContainer(ModelData.shared.modelContainer)
            }

            Tab("Settings", systemImage: "gear") {
                SettingsView()
                    .modelContainer(ModelData.shared.modelContainer)
            }

            Tab("Search", systemImage: "magnifyingglass", role: .search) {
                Text(searchText)
                    .searchable(text: $searchText)
            }
        }
    }
}

#Preview {
    ContentView()
        .modelContainer(ModelData.shared.modelContainer)
}
