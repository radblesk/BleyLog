//
//  ProjectsList.swift
//  HWS
//
//  Created by Radoslav Bley on 10/08/2025.
//

import SwiftData
import SwiftUI

struct LessonList: View {

    @Environment(\.modelContext) private var context

    var courses: [Course]

    var body: some View {

        VStack {
            List {
                ForEach(courses) { course in
                    if course.lessons.count > 0 {
                        Section(course.title) {
                            ForEach(
                                course.lessons.sorted {
                                    $0.firstDay < $1.firstDay
                                }
                            ) { lesson in
                                NavigationLink {
                                    ProjectList(lesson: lesson)
                                } label: {
                                    if lesson.inProgress {
                                        ProgressView()
                                            .tint(.orange)
                                    } else if lesson.finished {
                                        Image(systemName: "checkmark")
                                            .foregroundStyle(.green)
                                    }
                                    Text(
                                        "Days \(lesson.firstDay)-\(lesson.lastDay): \(lesson.title)"
                                    )
                                }
                                .swipeActions(edge: .leading) {
                                    Button(
                                        "Mark as done",
                                        systemImage: lesson.finished
                                            ? "xmark" : "checkmark"
                                    ) {
                                        if lesson.inProgress {
                                            lesson.inProgress.toggle()
                                        }

                                        lesson.finished.toggle()

                                        do {
                                            try context.save()
                                        } catch {
                                            print(error)
                                        }
                                    }
                                    .tint(.green)
                                    Button(
                                        "Mark as in progress",
                                        systemImage:
                                            "arrow.triangle.2.circlepath"
                                    ) {
                                        if lesson.finished {
                                            lesson.finished.toggle()
                                        }
                                        lesson.inProgress.toggle()

                                        do {
                                            try context.save()
                                        } catch {
                                            print(error)
                                        }
                                    }
                                    .tint(.orange)
                                }
                                .tag(lesson)
                            }
                        }
                    } else {
                        Section(course.title) {
                            Text("Course not started yet...")
                                .foregroundStyle(.secondary)
                        }
                    }
                }
            }
            .listStyle(.sidebar)
            .navigationTitle("Swift Courses")
        }
        #if os(iOS)
            .toolbar {
                ToolbarItem {
                    EditButton()
                }
            }
        #endif
    }
}

#Preview {
    LessonList(
        courses: Course.coursesData,
    )
}
