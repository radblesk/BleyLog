//
//  ProjectsList.swift
//  BleyLog
//
//  Created by Radoslav Bley on 19/08/2025.
//

import SwiftData
import SwiftUI

struct ProjectList: View {
    // DataModel
    var lesson: Lesson?

    // Bindings
    @Binding var project: Project?

    var body: some View {
        NavigationStack {
            if let lesson = lesson {
                if !lesson.projects.isEmpty {
                    List(
                        lesson.projects.sorted {
                            $0.date
                                < $1.date
                        },
                        selection: $project
                    ) { project in
                        NavigationLink(value: project) {
                            ProjectListRow(project: project)
                        }
                    }
                    .navigationTitle(lesson.title)
                    .containerBackground(
                        RadialGradient(
                            colors: [
                                .teal.opacity(0.8),
                                .black,
                            ],
                            center: .bottom,
                            startRadius: -200,
                            endRadius: 400
                        ),
                        for: .navigation
                    )
                    .listStyle(.carousel)
                    .toolbarForegroundStyle(.teal, for: .automatic)
                } else {
                    Text("No projects")
                        .navigationTitle(lesson.title)
                        .containerBackground(
                            .teal.gradient,
                            for: .navigation
                        )
                        .toolbarForegroundStyle(.teal, for: .automatic)
                }
            } else {
                Text("Select a lesson")
            }
        }
    }
}

#Preview {
    ProjectList(
        lesson: Lesson.hundreedDaysOfSwiftUILessons.first,
        project: .constant(nil)
    )
}
