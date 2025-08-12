//
//  ProjectsList.swift
//  HWS
//
//  Created by Radoslav Bley on 10/08/2025.
//

import SwiftData
import SwiftUI

struct DaysList: View {
    @Query(sort: \Days.firstDay) private var days: [Days]
    @Query(sort: \Courses.title) private var courses: [Courses]
    @Environment(\.modelContext) private var context

    @Binding var selectedDays: Int?

    var body: some View {

        NavigationStack {
            ZStack {
                Color(.systemGroupedBackground)
                    .ignoresSafeArea()
                VStack {
                    List(selection: $selectedDays) {
                        ForEach(courses) { course in
                            let groupedDays = days.filter {
                                $0.courseName == course.title
                            }

                            if groupedDays.count > 0 {
                                DaysListSection(
                                    groupedDays: groupedDays,
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
                        "v0.1.0 (2025.08.12)"
                    )
                    .font(.caption)
                    .foregroundStyle(.secondary)
                }
            }
        }
    }
}

#Preview {
    DaysList(selectedDays: .constant(16))
        .modelContainer(ProjectsData.shared.modelContainer)
}
