//
//  ContentView.swift
//  BleyLog
//
//  Created by Radoslav Bley on 10/08/2025.
//

import SwiftUI

struct ContentView: View {
    // MARK: - ViewModel
    /// Environment
    @Environment(ViewModel.self) var viewModel

    // MARK: - States
    /// NavigationSplitView
    @State private var pathStore = PathStore()

    // MARK: - Helpers
    /// Determine wheter user is on iPhone or iPad
    let iPad = UIDevice.current.userInterfaceIdiom == .pad

    /// Determine wheter device orientation is portrait or landscape
    var placement: ToolbarItemPlacement {
        if iPad {
            .automatic
        } else {
            if #available(iOS 26, *) {
                .bottomBar
            } else {
                .topBarTrailing
            }
        }
    }

    // MARK: - Main View

    var body: some View {
        @Bindable var viewModel = viewModel

        NavigationSplitView {
            LessonsListView()
                .toolbar {
                    if !iPad {
                        if #available(iOS 26, *) {
                            ToolbarSpacer(.flexible, placement: .bottomBar)
                        }
                        ToolbarItem(placement: placement) {
                            Menu {
                                Picker("Language", selection: $viewModel.selectedLanguage) {
                                    ForEach(viewModel.languages) { language in
                                        Text(language.title).tag(language)
                                    }
                                }
                            } label: {
                                Button(
                                    "Language",
                                    systemImage: "line.3.horizontal.decrease"
                                ) {}
                            }
                        }
                    }
                }
        } detail: {
            NavigationStack(path: $pathStore.path) {
                ProjectsListView()
                    .toolbar {
                        if iPad {
                            if #available(iOS 26, *) {
                                ToolbarSpacer(.flexible, placement: .bottomBar)
                            }
                            ToolbarItem(placement: placement) {
                                Menu {
                                    Picker("Language", selection: $viewModel.selectedLanguage) {
                                        ForEach(viewModel.languages) { language in
                                            Text(language.title).tag(language)
                                        }
                                    }
                                } label: {
                                    Button(
                                        "Language",
                                        systemImage: "line.3.horizontal.decrease"
                                    ) {}
                                }
                            }
                        }
                    }
                    .navigationDestination(for: Project.self) { project in
                        ProjectView(project: project)
                    }
            }
        }
    }
}

// MARK: - Preview
#Preview {
    ContentView()
        .environment(ViewModel())
}
