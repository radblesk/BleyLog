//
//  ProjectsListView.swift
//  BleyLog
//
//  Created by Radoslav Bley on 27/08/2025.
//

import SwiftUI

struct ProjectsListView: View {
    // MARK: Environments
    /// ViewModel
    @Environment(ViewModel.self) var viewModel

    var body: some View {
        /// Bindable variable for two-way data mutation
        @Bindable var viewModel = viewModel

        if viewModel.selectedLesson != nil {
            List(viewModel.projects(in: viewModel.selectedLesson), id: \.self) { project in
                NavigationLink(value: project) {
                    ProjectsListRow(project: project)
                }
            }
            .navigationTitle(viewModel.selectedLesson?.title ?? "")
            .apply {
                if #available(iOS 26, *) {
                    if let lesson = viewModel.selectedLesson {
                        let oneDay =
                            lesson.firstDay
                            == lesson.lastDay
                        $0.navigationSubtitle(
                            oneDay
                                ? "Day \(lesson.firstDay)"
                                : "Days \(lesson.firstDay)"
                        )
                    }
                } else {
                    $0.disabled(false)
                }
            }
        } else {
            Text("Select a lesson")
        }
    }
}

// MARK: - Preview
#Preview {
    struct PreviewWrapper: View {
        let viewModel = ViewModel()

        var body: some View {
            @Bindable var viewModel = viewModel

            ProjectsListView()
                .environment(viewModel)
                .onAppear(perform: setLesson)
        }

        func setLesson() {
            let lesson = Lesson.hundreedDaysOfSwiftUILessons[4]

            viewModel.selectedLesson = lesson
        }
    }
    return PreviewWrapper()
}
