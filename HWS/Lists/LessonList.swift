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
    @Binding var selectedLesson: Lesson?

    var body: some View {

        NavigationStack {
            ZStack {
                #if os(iOS)
                    Color(.systemGroupedBackground)
                        .ignoresSafeArea()
                #endif
                VStack {
                    List(selection: $selectedLesson) {
                        ForEach(courses) { course in
                            if course.lessons.count > 0 {
                                LessonListSection(
                                    lessons: course.lessons,
                                    course: course
                                )
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

                    Spacer()

                    Text(
                        "Developed by [Radoslav Bley](https://www.radobley.sk)"
                    )
                    .font(.caption)
                    .foregroundStyle(.secondary)

                    Text(
                        "v0.1.0 (2025.08.13)"
                    )
                    .font(.caption)
                    .foregroundStyle(.secondary)
                }
            }
            .toolbar {
                ToolbarItem {
                    Button("Reset", systemImage: "arrow.counterclockwise") {
                        try? context.delete(model: Course.self)
                    }
                }
            }
        }
    }
}

#Preview {
    LessonList(
        courses: Course.coursesData,
        selectedLesson: .constant(Lesson.hundreedDaysOfSwiftUILessons.first)
    )
}
