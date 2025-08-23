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
    @State private var expanded: Set<String> = ["100 days of SwiftUI"]

    // Bindings
    @Binding var selectedLanguage: Language?
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

                                    let sortedLessons = course.lessons.sorted {
                                        $0.firstDay
                                            < $1.firstDay
                                    }
                                    ForEach(
                                        sortedLessons,
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
