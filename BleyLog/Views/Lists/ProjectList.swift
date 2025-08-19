//
//  ProjectsList.swift
//  BleyLog
//
//  Created by Radoslav Bley on 10/08/2025.
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
                    #if os(watchOS)
                        .containerBackground(
                            .teal.gradient.opacity(0.5),
                            for: .navigation
                        )
                        .listStyle(.carousel)
                        .toolbarForegroundStyle(.mint, for: .automatic)
                    #endif
                } else {
                    Text("No projects")
                        .navigationTitle(lesson.title)
                        #if os(watchOS)
                            .containerBackground(
                                .mint.gradient,
                                for: .navigation
                            )
                        #endif
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
