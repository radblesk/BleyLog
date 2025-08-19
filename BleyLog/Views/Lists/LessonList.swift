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
                                                                .reversing,
                                                            options: .repeat(
                                                                .continuous
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
                                                    .imageScale(.large)
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
                                                    .font(.subheadline)
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
                        .searchable(text: $searchText)
                    } else {
                        Text("No courses")
                    }
                } else {
                    Text("Select a language")
                }
            }
            //            .navigationTitle("Courses")
            //            .toolbarTitleDisplayMode(.inlineLarge)
            .onAppear {
                if selectedLanguage == nil {
                    selectedLanguage = languages.first { $0.title == "Swift" }
                }
            }
            .navigationTitle("Courses")
            .toolbarTitleDisplayMode(.inlineLarge)
            .toolbar {
                ToolbarItem(placement: .status) {
                    if let selectedLanguage {
                        Text(
                            "\(selectedLanguage.courses.count) \(selectedLanguage.title) courses"
                        )
                        .font(.caption)
                        .foregroundStyle(.secondary)
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
                ToolbarItem(placement: buttonPlacement) {
                    NavigationLink {
                        SettingsView()
                    } label: {
                        Label("Settings", systemImage: "gear")
                    }
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
