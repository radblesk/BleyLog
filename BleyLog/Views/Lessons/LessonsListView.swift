//
//  LessonsListView.swift
//  BleyLog
//
//  Created by Radoslav Bley on 27/08/2025.
//

import SwiftUI

struct LessonsListView: View {
    // MARK: Environments
    /// ViewModel
    @Environment(ViewModel.self) var viewModel

    // MARK: States
    /// Expanded State
    @State private var expanded: Set<String> = [
        "100 days of SwiftUI", "100 days of Swift",
    ]
    @State private var showMore = false

    var body: some View {
        /// Bindable variable for two-way data mutation
        @Bindable var viewModel = viewModel

        List(
            viewModel.courses(in: viewModel.selectedLanguage),
            selection: $viewModel.selectedLesson
        ) {
            course in
            Section(
                course.title,
                isExpanded: Binding<Bool>(
                    get: {
                        expanded.contains(course.title)
                    },
                    set: { isExpanding in
                        if isExpanding {
                            expanded.insert(
                                course.title
                            )
                        } else {
                            expanded.remove(
                                course.title
                            )
                        }
                    }
                )
            ) {
                if !viewModel.lessons(in: course).isEmpty {
                    ForEach(
                        viewModel.lessons(in: course, status: .started),
                        id: \.self
                    ) { lesson in
                        LessonsListRow(lesson: lesson)
                            .disabled(
                                lesson.projects.count == 0
                                    && !lesson.inProgress
                            )
                            .selectionDisabled(
                                lesson.projects.count == 0
                                    && !lesson.inProgress
                            )
                    }

                    if showMore {
                        ForEach(
                            viewModel.lessons(
                                in: course,
                                status: .notStarted
                            ),
                            id: \.self
                        ) { lesson in
                            NavigationLink(value: lesson) {
                                Label {
                                    Text(lesson.title)
                                } icon: {
                                    if lesson.inProgress {
                                        Image(
                                            systemName: "target"
                                        )
                                        .foregroundStyle(.blue)
                                        .symbolEffect(
                                            .variableColor.cumulative
                                                .dimInactiveLayers
                                                .nonReversing,
                                            options: .repeat(
                                                .periodic(delay: 1.0)
                                            )
                                        )
                                    } else {
                                        Image(
                                            systemName: lesson.finished
                                                ? "checkmark.circle"
                                                : "book"
                                        ).foregroundStyle(
                                            lesson.finished
                                                ? .green
                                                : Color.accentColor
                                        )
                                    }
                                }
                                .badge(lesson.projects.count)
                            }
                            .disabled(
                                lesson.projects.count == 0
                                    && !lesson.inProgress
                            )
                            .selectionDisabled(
                                lesson.projects.count == 0
                                    && !lesson.inProgress
                            )
                        }
                    }

                    Button(showMore ? "Show fewer" : "Show more") {
                        withAnimation {
                            showMore.toggle()
                        }
                    }
                    .padding(.horizontal)
                    .foregroundStyle(.blue)
                    .font(.subheadline)
                } else {
                    Text("No lessons in this course.")
                        .foregroundStyle(.secondary)
                }
            }
            .headerProminence(.increased)
        }
        .navigationTitle("Courses")
        .apply {
            if #available(iOS 26, *) {
                if let language = viewModel.selectedLanguage {
                    $0.navigationSubtitle(
                        "for \(language.title)"
                    )
                }
            } else {
                $0.disabled(false)
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
