//
//  LessonsListView.swift
//  BleyLog
//
//  Created by Radoslav Bley on 28/08/2025.
//

import SwiftUI

struct LessonsListView: View {
    // MARK: Environments
    /// ViewModel
    @Environment(ViewModel.self) var viewModel

    // MARK: States
    /// Sheet
    @State private var isPresented = false
    /// Expanding
    @State private var showMore = false

    // MARK: - Main View
    var body: some View {
        /// Bindable variable for two-way data mutation
        @Bindable var viewModel = viewModel

        List(
            viewModel.courses(in: viewModel.selectedLanguage),
            selection: $viewModel.selectedLesson
        ) {
            course in
            Section(course.title) {
                if course.lessons.count > 0 {
                    ForEach(
                        viewModel.lessons(in: course, status: .started)
                    ) { lesson in
                        NavigationLink(value: lesson) {
                            LessonListRow(lesson: lesson)
                        }
                        .disabled(lesson.projects.count < 1)
                        .selectionDisabled(lesson.projects.count < 1)
                    }

                    if showMore {
                        ForEach(
                            viewModel
                                .lessons(in: course, status: .notStarted)
                        ) { lesson in
                            NavigationLink(value: lesson) {
                                LessonListRow(lesson: lesson)
                            }
                            .disabled(lesson.projects.count < 1)
                            .selectionDisabled(lesson.projects.count < 1)
                        }
                    }

                    Button(showMore ? "Show fewer" : "Show more") {
                        withAnimation { showMore.toggle() }
                    }
                } else {
                    Text("No lessons in this course.")
                        .foregroundStyle(.secondary)
                }
            }
        }
        .navigationTitle("Courses")
        .containerBackground(
            RadialGradient(
                colors: [
                    Color.accentColor,
                    .black,
                ],
                center: .bottom,
                startRadius: -200,
                endRadius: 400
            ),
            for: .navigation
        )
        .toolbar {
            ToolbarItemGroup(placement: .bottomBar) {
                Spacer()
                Button(
                    "Language",
                    systemImage: "line.3.horizontal.decrease"
                ) {
                    isPresented.toggle()
                }
            }

        }
        .sheet(isPresented: $isPresented) {
            Picker(
                "Language",
                selection: $viewModel.selectedLanguage
            ) {
                ForEach(viewModel.languages, id: \.self) {
                    language in
                    Text(language.title)
                        .tag(language)
                }
            }
        }
    }
}

// MARK: - Preview
#Preview {
    let viewModel = ViewModel()

    LessonsListView()
        .environment(viewModel)
}
