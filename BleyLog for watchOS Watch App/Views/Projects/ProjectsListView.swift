//
//  ProjectsListView.swift
//  BleyLog
//
//  Created by Radoslav Bley on 28/08/2025.
//

import SwiftUI

struct ProjectsListView: View {
    // MARK: Environments
    /// ViewModel
    @Environment(ViewModel.self) var viewModel
    /// Search dismiss action
    @Environment(\.dismissSearch) private var dismissSearch

    var body: some View {
        /// Bindable variable for two-way data mutation
        @Bindable var viewModel = viewModel

        NavigationStack {
            List(
                viewModel.projects(in: viewModel.selectedLesson),
                selection: $viewModel.selectedProject,
            ) {
                project in
                NavigationLink {
                    ProjectView(project: project)
                } label: {
                    ProjectListRow(project: project)
                }.tag(project)
            }
            .navigationTitle(viewModel.selectedLesson?.title ?? "")
            .containerBackground(
                RadialGradient(
                    colors: [
                        .teal.opacity(0.8),
                        .black,
                    ],
                    center: .bottom,
                    startRadius: -200,
                    endRadius: 400
                ),
                for: .navigation
            )
            .toolbarForegroundStyle(.teal, for: .automatic)
            .onAppear {
                dismissSearch()
            }
        }
    }
}

// MARK: - Preview
#Preview {
    struct PreviewWrapper: View {
        let viewModel = ViewModel()

        var body: some View {
            ProjectsListView()
                .environment(viewModel)
                .onAppear(perform: setLesson)
        }

        func setLesson() {
            let lesson = Lesson.hundreedDaysOfSwiftUILessons[2]

            viewModel.selectedLesson = lesson
        }
    }
    return PreviewWrapper()
}
