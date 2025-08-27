//
//  ContentView.swift
//  BleyLog
//
//  Created by Radoslav Bley on 10/08/2025.
//

import SwiftUI

struct ContentView: View {
    // MARK: Environments
    /// ViewModel
    @Environment(ViewModel.self) var viewModel

    var body: some View {
        /// Bindable variable for two-way data mutation
        @Bindable var viewModel = viewModel

        /// Main app navigation with TabView
        TabView {
            Tab("Courses", systemImage: "books.vertical.fill") {
                CoursesSplitView()
            }

//            Tab("Recents", systemImage: "clock.fill") {
//                RecentsView()
//            }

            Tab("Search", systemImage: "magnifyingglass", role: .search) {
                NavigationStack {
                    SearchView()
                }
                .searchable(text: $viewModel.search)
            }
        }
    }
}

// MARK: - Preview

#Preview {
    let viewModel = ViewModel()
    ContentView()
        .environment(viewModel)
}
