//
//  ProjectsList.swift
//  BleyLog
//
//  Created by Radoslav Bley on 10/08/2025.
//

import SwiftData
import SwiftUI

struct LessonList: View {
    // DataModel
    @Environment(\.modelContext) private var context
    var languages: [Language]

    // States
    @State private var searchText: String = ""
    @State private var expanded: Set<String> = ["100 days of SwiftUI"]
    @State private var isPresented = false
    @State private var settingsPresented = false
    @Binding var selectedLanguage: Language?

    // Bindings
    @Binding var lesson: Lesson?

    // OS Specifics
    private var buttonPlacement: ToolbarItemPlacement {
        #if os(iOS)
            .bottomBar
        #else
            .automatic
        #endif
    }

    var body: some View {
        NavigationStack {
            VStack {
                if let selectedLanguage {
                    if !selectedLanguage.courses.isEmpty {
                        let sortedCourses = selectedLanguage
                            .courses
                            .sorted {
                                $0.lessons
                                    .count > $1.lessons.count
                            }
                        List(
                            sortedCourses,
                            selection: $lesson
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
                                if !course.lessons.isEmpty {
                                    let searchResults = course.lessons.filter {
                                        $0.title.lowercased().contains(
                                            searchText.lowercased()
                                        )
                                    }

                                    let sortedLessons = course.lessons.sorted {
                                        $0.firstDay
                                            < $1.firstDay
                                    }
                                    ForEach(
                                        searchText.isEmpty
                                            ? sortedLessons : searchResults,
                                        id: \.self
                                    ) { lesson in
                                        NavigationLink(value: lesson) {
                                            HStack(spacing: 20) {
                                                if lesson.inProgress {
                                                    Image(systemName: "target")
                                                        .symbolEffect(
                                                            .variableColor
                                                                .iterative
                                                                .dimInactiveLayers
                                                                .nonReversing,
                                                            options: .repeat(
                                                                .periodic(
                                                                    delay: 1.0
                                                                )
                                                            )
                                                        )
                                                        .foregroundStyle(.blue)
                                                } else {
                                                    Image(
                                                        systemName: lesson
                                                            .finished
                                                            ? "checkmark"
                                                            : "book.pages"
                                                    )
                                                    .imageScale(.medium)
                                                    .foregroundStyle(
                                                        lesson.finished
                                                            ? .green
                                                            : .orange
                                                    )
                                                }
                                                VStack(alignment: .leading) {
                                                    Text(lesson.title)
                                                        .font(.headline)
                                                    Text(
                                                        "Days \(lesson.firstDay)-\(lesson.lastDay)"
                                                    )
                                                    .font(.caption)
                                                    .foregroundStyle(
                                                        .secondary
                                                    )
                                                }
                                                Spacer()
                                                Text("\(lesson.projects.count)")
                                                    .foregroundStyle(.secondary)
                                            }
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
                                } else {
                                    Text("Course not started...")
                                        .foregroundStyle(.secondary)
                                }
                            }
                        }
                        .headerProminence(.increased)
                        .refreshable {
                            insertModelData()
                        }
                    } else {
                        Text("No courses")
                    }
                } else {
                    Text("Select a language")
                }
            }
            .onAppear {
                if selectedLanguage == nil {
                    selectedLanguage = languages.first { $0.title == "Swift" }
                }
            }
            .navigationTitle("Courses")
            .toolbarTitleDisplayMode(.inlineLarge)
            .searchable(text: $searchText)
            .toolbar {
                ToolbarItem(placement: .automatic) {
                    Button("Settings", systemImage: "ellipsis") {
                        settingsPresented = true
                    }
                }
                if #available(iOS 26, *) {
                    DefaultToolbarItem(kind: .search, placement: .bottomBar)

                    ToolbarItem(placement: .largeSubtitle) {
                        if let selectedLanguage {
                            HStack {
                                Text(
                                    "\(selectedLanguage.courses.count) \(selectedLanguage.title) courses"
                                )
                                .font(.caption)
                                .foregroundStyle(.secondary)
                                Spacer()
                            }
                        }
                    }
                    ToolbarItem(placement: .subtitle) {
                        if let selectedLanguage {
                            HStack {
                                Text(
                                    "\(selectedLanguage.courses.count) \(selectedLanguage.title) courses"
                                )
                                .font(.caption)
                                .foregroundStyle(.secondary)
                                Spacer()
                            }
                        }
                    }
                } else {
                    ToolbarItem(placement: .status) {
                        if let selectedLanguage {
                            HStack {
                                Text(
                                    "\(selectedLanguage.courses.count) \(selectedLanguage.title) courses"
                                )
                                .font(.caption)
                                .foregroundStyle(.secondary)
                                Spacer()
                            }
                        }
                    }
                }
                ToolbarItem(placement: buttonPlacement) {
                    Button(
                        "Language",
                        systemImage: "line.3.horizontal.decrease"
                    ) {
                        isPresented = true
                    }
                }
                if #available(iOS 26, *) {
                    ToolbarSpacer(placement: .bottomBar)
                }

            }
            .sheet(isPresented: $isPresented) {
                VStack {
                    Picker("Language", selection: $selectedLanguage) {
                        ForEach(languages, id: \.self) { language in
                            Text(language.title)
                                .tag(language)
                        }
                    }
                    #if os(iOS)
                        .pickerStyle(.wheel)
                    #endif
                }
                .padding()
                .presentationDetents([.height(200), .medium])
                .presentationDragIndicator(.visible)
            }
            .sheet(isPresented: $settingsPresented) {
                SettingsView(presented: $settingsPresented)
                    .presentationDetents([.medium, .large])
            }
        }
    }
    private func insertModelData() {
        let descriptor = FetchDescriptor<Language>()

        guard let languages = try? context.fetch(descriptor) else { return }

        if languages.isEmpty {
            for language in Language.languages {
                context.insert(language)
            }
        }
    }
}

#Preview {
    LessonList(
        languages: Language.languages,
        selectedLanguage: .constant(Language.languages.first),
        lesson: .constant(nil)
    )
}
