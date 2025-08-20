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
    @Binding var selectedLanguage: Language?

    // Bindings
    @Binding var lesson: Lesson?

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
                                            LessonListRow(lesson: lesson)
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
            .navigationTitle(Text("Courses"))
            .searchable(text: $searchText)
            .toolbar {
                if #available(iOS 26, *) {
                    DefaultToolbarItem(kind: .search, placement: .bottomBar)
                    ToolbarSpacer(placement: .bottomBar)

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
                ToolbarItem(placement: .bottomBar) {
                    Menu {
                        Picker("Language", selection: $selectedLanguage) {
                            ForEach(languages, id: \.self) { language in
                                Button(language.title) {
                                    selectedLanguage = language
                                }
                                .tag(language)
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
