//
//  ProjectsList.swift
//  HWS
//
//  Created by Radoslav Bley on 10/08/2025.
//

import SwiftData
import SwiftUI

struct LessonsList: View {
    var courses: [Course]
    @Binding var selectedLesson: Lesson?

    var body: some View {

        NavigationStack {
            ZStack {
                Color(.systemGroupedBackground)
                    .ignoresSafeArea()
                VStack {
                    List(selection: $selectedLesson) {
                        ForEach(courses) { course in
                            if course.lessons.count > 0 {
                                LessonsListSection(
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
        }
    }
}
