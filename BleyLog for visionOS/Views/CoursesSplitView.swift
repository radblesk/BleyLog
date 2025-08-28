//
//  CoursesSplitView.swift
//  BleyLog
//
//  Created by Radoslav Bley on 23/08/2025.
//

import SwiftData
import SwiftUI

struct CoursesSplitView: View {
    // MARK: Environments
    /// ViewModel
    @Environment(ViewModel.self) private var viewModel

    // States
    @State private var columnVisibility = NavigationSplitViewVisibility
        .doubleColumn
    @State private var preferredCompactColumn = NavigationSplitViewColumn
        .sidebar

    var body: some View {
        @Bindable var viewModel = viewModel
        NavigationSplitView {
            LessonList(
                languages: viewModel.languages,
                selectedLanguage: $viewModel.selectedLanguage,
                lesson: $viewModel.selectedLesson,
            )
            .toolbar {
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
                    .buttonStyle(.plain)
                }
            }

        } content: {
            ProjectList(lesson: viewModel.selectedLesson, project: $viewModel.selectedProject)
        } detail: {
            ProjectView(project: viewModel.selectedProject)
        }
        .onChange(of: viewModel.selectedLesson) {
            viewModel.selectedProject = nil
        }
    }
}

#Preview {
    let viewModel = ViewModel()

    CoursesSplitView()
        .environment(viewModel)
}
