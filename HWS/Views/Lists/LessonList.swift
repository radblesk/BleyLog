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
        NavigationStack {
            VStack {
                List {
                    ForEach(courses, id: \.self) { course in
                        if course.lessons.count > 0 {
                            Section(course.title) {
                                ForEach(
                                    course.lessons.sorted {
                                        $0.firstDay < $1.firstDay
                                    },
                                    id: \.self
                                ) { lesson in
                                    NavigationLink {
                                        ProjectList(lesson: lesson)
                                    } label: {
                                        Label(
                                            "Days \(lesson.firstDay)-\(lesson.lastDay): \(lesson.title)",
                                            systemImage: lesson.finished
                                                ? "checkmark"
                                                : lesson.inProgress
                                                    ? "circle.dotted"
                                                    : "book.pages.fill"
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
                                                "circle.dotted"
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

        }
    }
}

#Preview {
    LessonList(
        courses: Course.coursesData
    )
}
