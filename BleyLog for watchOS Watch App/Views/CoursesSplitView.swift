//
//  CoursesSplitView.swift
//  BleyLog
//
//  Created by Radoslav Bley on 25/08/2025.
//

import SwiftUI

struct CoursesSplitView: View {
    // MARK: Environments
    /// ViewModel
    @Environment(ViewModel.self) private var viewModel
    /// Search dismiss action
    @Environment(\.dismissSearch) private var dismissSearch

    // MARK: States
    /// Sheet
    @State private var isPresented = false
    /// Expanding
    @State private var showMore = false

    // MARK: - Lessons list
    fileprivate func lessonsList() -> NavigationStack<NavigationPath, some View>
    {
        return NavigationStack {
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

    // MARK: - Projects list
    fileprivate func projectsList() -> NavigationStack<
        NavigationPath, some View
    > {
        return NavigationStack {
            /// Bindable variable for two-way data mutation
            @Bindable var viewModel = viewModel

            List(
                viewModel.projects(in: viewModel.selectedLesson),
                selection: $viewModel.selectedProject,
            ) {
                project in
                NavigationLink {
                    NavigationStack {
                        Group {
                            switch viewModel.selectedProject?.title {
                            case "WeSplit":
                                WeSplit()
                            case "TempConvert":
                                TempConvert()
                            case "GuessTheFlag":
                                GuessTheFlag()
                            case "RockPaperScissors":
                                RockPaperScissors()
                            case "BetterRest":
                                BetterRest()
                            default:
                                Text("Select a project")
                            }
                        }
                    }
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
        }
    }

    // MARK: - Main View
    var body: some View {
        NavigationSplitView(
            sidebar: {
                lessonsList()
            },
            detail: {
                projectsList()
            }
        )
        .onAppear {
            dismissSearch()
        }
    }
}

#Preview {
    let viewModel = ViewModel()
    CoursesSplitView()
        .environment(viewModel)
}
