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

    /// Expanded State
    @State private var expanded: Set<String> = [
        "100 days of SwiftUI", "100 days of Swift",
    ]
    @State private var showMore = false

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
            Picker<
                Text, Language?,
                ForEach<[Language], PersistentIdentifier, some View>
            >
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

    // MARK: - Lessons list
    fileprivate func lessonsList() -> some View {
        return NavigationStack {
            @Bindable var viewModel = viewModel
            VStack {
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
                                NavigationLink(value: lesson) {
                                    Label {
                                        Text(lesson.title)
                                    } icon: {
                                        if lesson.inProgress {
                                            Image(
                                                systemName: "target"
                                            )
                                            .foregroundStyle(.primary)
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

    // MARK: - Projects list
    fileprivate func projectsList() -> NavigationStack<
        NavigationPath, some View
    > {
        return NavigationStack {
            @Bindable var viewModel = viewModel
            if viewModel.selectedLesson != nil {
                List(
                    viewModel.projects(in: viewModel.selectedLesson),
                    id: \.self,
                    selection: $viewModel.selectedProject
                ) {
                    project in
                    NavigationLink {
                        ProjectView(project: project)
                    } label: {
                        VStack(alignment: .leading, spacing: 16) {
                            HStack(spacing: 14) {
                                if let icon = project.icon {
                                    Image(icon)
                                        .resizable()
                                        .frame(width: 60, height: 60)
                                        .clipShape(.rect(cornerRadius: 16))
                                        .overlay {
                                            RoundedRectangle(cornerRadius: 16)
                                                .stroke(
                                                    .secondary.opacity(0.4),
                                                    style: StrokeStyle(
                                                        lineWidth: 0.2
                                                    )
                                                )
                                        }
                                        .apply {
                                            if #available(iOS 26.0, *) {
                                                $0.glassEffect(
                                                    in: .rect(cornerRadius: 16)
                                                )
                                            } else {
                                                $0.disabled(false)
                                            }
                                        }
                                } else {
                                    Image("empty-icon")
                                        .resizable()
                                        .frame(width: 60, height: 60)
                                        .clipShape(.rect(cornerRadius: 16))
                                        .overlay {
                                            RoundedRectangle(cornerRadius: 16)
                                                .stroke(
                                                    .secondary.opacity(0.4),
                                                    style: StrokeStyle(
                                                        lineWidth: 0.2
                                                    )
                                                )
                                        }
                                        .apply {
                                            if #available(iOS 26.0, *) {
                                                $0.glassEffect(
                                                    in: .rect(cornerRadius: 16)
                                                )
                                            } else {
                                                // Fallback
                                            }
                                        }
                                }

                                VStack(alignment: .leading, spacing: 4) {

                                    Text(project.title)
                                        .font(.title3)
                                        .truncationMode(.tail)

                                    let date = project.date
                                    let currentDate =
                                        date
                                        == Calendar.current.startOfDay(
                                            for: Date()
                                        )
                                    let lessThanThreeDaysAgo =
                                        Calendar.current.date(
                                            byAdding: .dayOfYear,
                                            value: -3,
                                            to: Date()
                                        )! < date

                                    if currentDate {
                                        Text(
                                            "Today"
                                        )
                                        .font(.caption)
                                        .foregroundStyle(.secondary)
                                    } else if lessThanThreeDaysAgo {
                                        Text(
                                            "\(project.date.formatted(.dateTime.weekday(.wide)))"
                                        )
                                        .font(.caption)
                                        .foregroundStyle(.secondary)
                                    } else {
                                        Text(
                                            "\(project.date.formatted(date: .abbreviated, time: .omitted))"
                                        )
                                        .font(.caption)
                                        .foregroundStyle(.secondary)
                                    }
                                }
                            }

                            Text(project.desc)
                                .font(.subheadline)
                                .lineLimit(2)
                                .truncationMode(.tail)
                        }
                    }
                }
                .navigationTitle(viewModel.selectedLesson?.title ?? "")
                .apply {
                    if #available(iOS 26, *) {
                        if let lesson = viewModel.selectedLesson {
                            let oneDay =
                                lesson.firstDay
                                == lesson.lastDay
                            $0
                                .navigationSubtitle(
                                    oneDay
                                        ? "Day \(lesson.firstDay) in \(lesson.course!.title)"
                                        : "Days \(lesson.firstDay) - \(lesson.lastDay) in \(lesson.course!.title)"
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

    // MARK: - Main View
    var body: some View {
        NavigationSplitView(
            columnVisibility: $columnVisibility,
            preferredCompactColumn: $preferredCompactColumn,
            sidebar: {
                lessonsList()
                    .toolbar {
                        if !iPad {
                            languageSelector()
                        }
                    }
            },
            detail: {
                projectsList()
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
