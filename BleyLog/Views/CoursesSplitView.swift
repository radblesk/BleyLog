//
//  CoursesSplitView.swift
//  BleyLog
//
//  Created by Radoslav Bley on 23/08/2025.
//

import SwiftData
import SwiftUI

struct CoursesSplitView: View {
    // MARK: - ViewModel
    /// Environment
    @Environment(ViewModel.self) var viewModel

    // MARK: - States
    /// NavigationSplitView
    @State private var columnVisibility = NavigationSplitViewVisibility
        .doubleColumn
    @State private var preferredCompactColumn = NavigationSplitViewColumn
        .sidebar

    // MARK: - Helpers
    /// Determine wheter user is on iPhone or iPad
    let iPad = UIDevice.current.userInterfaceIdiom == .pad

    /// Determine wheter device orientation is portrait or landscape
    var placement: ToolbarItemPlacement {
        if iPad {
            .automatic
        } else {
            .topBarTrailing
        }
    }

    // MARK: - Language selector
    fileprivate func languageSelector() -> ToolbarItem<
        (),
        Menu<
            Button<Label<Text, Image>>,
            Picker<Text, Language?, ForEach<[Language], PersistentIdentifier, some View>>
        >
    > {
        return ToolbarItem(placement: placement) {
            @Bindable var viewModel = viewModel
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

    // MARK: - Main View
    var body: some View {
        NavigationSplitView(
            columnVisibility: $columnVisibility,
            preferredCompactColumn: $preferredCompactColumn,
            sidebar: {
                LessonsListView()
                    .toolbar {
                        if !iPad {
                            languageSelector()
                        }
                    }
            },
            detail: {
                ProjectsListView()
                    .toolbar {
                        if iPad {
                            languageSelector()
                        }
                    }
            }
        )
        .navigationSplitViewStyle(.balanced)
        .onChange(of: viewModel.selectedLesson) {
            columnVisibility = .doubleColumn
        }
    }
}

// MARK: - Preview
#Preview {
    let viewModel = ViewModel()

    CoursesSplitView()
        .environment(viewModel)
}
