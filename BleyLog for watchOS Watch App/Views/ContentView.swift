//
//  ContentView.swift
//  BleyLog
//
//  Created by Radoslav Bley on 19/08/2025.
//

import SwiftUI

struct ContentView: View {
    // MARK: Environments
    /// ViewModel
    @Environment(ViewModel.self) var viewModel

    // MARK: - States
    /// PathStore
    @State private var pathStore = PathStore()

    var body: some View {
        NavigationSplitView {
            LessonsListView()
        } detail: {
            NavigationStack(path: $pathStore.path) {
                ProjectsListView()
                    .navigationDestination(for: Project.self) { project in
                        ProjectView(project: project)
                    }
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
